all: ED2.m5 ED2.k5

../tools/k7mofs:
	make -C ../tools k7mofs

ED2K7M5.BIN: ED2K7M5.asm
	../tools/lwasm --6809 -lED2K7M5.txt -f decb -o $@ ED2K7M5.asm

INTRO.BIN: INTRO.asm
	make -C ../tools
	make -C ../res
	../tools/lwasm --6809 -lINTRO.txt -f raw -o $@ INTRO.asm
	../tools/exoraw -b $@ -o $@.exo2

OUTRO.BIN: OUTRO.asm
	make -C ../tools
	make -C ../res
	../tools/lwasm --6809 -lOUTRO.txt -f raw -o $@ OUTRO.asm

INIT.BIN: INIT.asm
	make -C ../tools
	make -C ../res
	../tools/lwasm --6809 -lINIT.txt -f raw -o $@ INIT.asm

ED2.BIN: ED2.asm
	../tools/lwasm --6809 -lED2.txt -f raw -o $@ ED2.asm -DINIT=1 -DPACKE=1 -DPACKM=1
	dd if=ED2.BIN of=INIT1.DAT bs=256 count=1
	dd if=ED2.BIN of=PACK1.DAT bs=256 count=25 skip=97
	../tools/exoraw -b PACK1.DAT -o PACK1.DAT.exo2
	../tools/lwasm --6809 -lED2P2.txt -f raw -o ED2P2.BIN ED2.asm -DINIT=2 -DPACKE=2 -DPACKM=2
	dd if=ED2P2.BIN of=INIT2.DAT bs=256 count=1
	dd if=ED2P2.BIN of=PACK2.DAT bs=256 count=25 skip=97
	../tools/exoraw -b PACK2.DAT -o PACK2.DAT.exo2
	../tools/lwasm --6809 -lED2P3.txt -f raw -o ED2P3.BIN ED2.asm -DINIT=3 -DPACKE=3 -DPACKM=3
	dd if=ED2P3.BIN of=INIT3.DAT bs=256 count=1
	dd if=ED2P3.BIN of=PACK3.DAT bs=256 count=25 skip=97
	../tools/exoraw -b PACK3.DAT -o PACK3.DAT.exo2
	dd if=ED2.BIN of=ED2Part1.DAT bs=256 skip=1 count=24
	dd if=ED2.BIN of=ED2Part2.DAT bs=256 skip=25 count=70
	dd if=ED2.BIN of=ED2Part3.DAT bs=256 skip=95 count=2
	../tools/exoraw -b ED2Part1.DAT -o ED2Part1.DAT.exo2
	../tools/exoraw -b ED2Part2.DAT -o ED2Part2.DAT.exo2
	../tools/exoraw -b ED2Part3.DAT -o ED2Part3.DAT.exo2

ED2.m5: INTRO.BIN INIT.asm OUTRO.asm ED2.BIN ED2ROM0.asm ED2ROM1.asm ED2ROM2.asm ED2ROM3.asm
	../tools/lwasm --6809 -lED2ROM0.txt -f raw -o ED2ROM0.BIN ED2ROM0.asm
	../tools/lwasm --6809 -lED2ROM1.txt -f raw -o ED2ROM1.BIN ED2ROM1.asm
	../tools/lwasm --6809 -lED2ROM2.txt -f raw -o ED2ROM2.BIN ED2ROM2.asm
	../tools/lwasm --6809 -lED2ROM3.txt -f raw -o ED2ROM3.BIN ED2ROM3.asm
	cat ED2ROM0.BIN ED2ROM1.BIN ED2ROM2.BIN ED2ROM3.BIN > $@

ED2.k5: ../tools/k7mofs ED2K7M5.BIN ED2.m5
	../tools/k7mofs -add $@ ED2.BAS ED2K7M5.BIN ED2ROM0.BIN ED2ROM1.BIN ED2ROM2.BIN ED2ROM3.BIN

clean:
	-rm *.txt *.BIN *.DAT *.exo2 *.m5 *.k5

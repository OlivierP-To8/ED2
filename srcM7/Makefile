all: ED2.m7

../tools/k7mofs:
	make -C ../tools k7mofs

INTRO.BIN: INTRO.asm
	make -C ../tools
	../tools/lwasm --6809 -lINTRO.txt -f raw -o $@ INTRO.asm
	../tools/exoraw -b $@ -o $@.exo2

OUTRO.BIN: OUTRO.asm
	make -C ../tools
	../tools/lwasm --6809 -lOUTRO.txt -f raw -o $@ OUTRO.asm

INIT.BIN: INIT.asm
	make -C ../tools
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

ED2.m7: INTRO.BIN INIT.asm OUTRO.asm ED2.BIN ED2ROM0.asm ED2ROM1.asm ED2ROM2.asm ED2ROM3.asm
	dd if=ED2.BIN of=ED2Part.DAT bs=256 skip=1 count=96
	../tools/exoraw -b ED2Part.DAT -o ED2Part.DAT.exo2
	../tools/lwasm --6809 -lED2ROM0.txt -f raw -o ED2ROM0.BIN ED2ROM0.asm -DMEGAROM=0
	../tools/lwasm --6809 -lED2ROM1.txt -f raw -o ED2ROM1.BIN ED2ROM1.asm
	../tools/lwasm --6809 -lED2ROM2.txt -f raw -o ED2ROM2.BIN ED2ROM2.asm
	../tools/lwasm --6809 -lED2ROM3.txt -f raw -o ED2ROM3.BIN ED2ROM3.asm
	cat ED2ROM0.BIN ED2ROM1.BIN ED2ROM2.BIN ED2ROM3.BIN > $@

ED2MegaromT2.fd: ../tools/fdfs ED2ROM0.asm ED2MegaromT2.asm
	../tools/lwasm --6809 -lED2ROM0MR.txt -f raw -o ED2ROM0MR.BIN ED2ROM0.asm -DMEGAROM=1
	cat ED2ROM0MR.BIN ED2ROM1.BIN ED2ROM2.BIN ED2ROM3.BIN > ED2MRT2.m7
	../tools/lwasm --6809 -lED2MegaromT2.txt -f decb -o ED2MRT2.BIN ED2MegaromT2.asm
	../tools/fdfs -M7 ED2MegaromT2.fd ED2MRT2.m7 ED2MRT2.BIN
	# réserve les pistes 1 à 16 pour la sauvegarde de la Mégarom
	dd if=ED2MegaromT2.fd of=reserved.DAT bs=1 count=32 skip=82225
	dd if=reserved.DAT of=ED2MegaromT2.fd bs=1 count=32 seek=82179 conv=notrunc
	# test de la MEMO7 dans la disquette
	dd if=ED2MegaromT2.fd of=test.m7 bs=4096 skip=24 count=16
	md5sum ED2MRT2.m7 test.m7

clean:
	-rm *.txt *.BIN *.DAT *.exo2 *.m7 *.fd

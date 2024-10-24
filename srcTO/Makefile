all: ED2TO.fd

../tools/fdfs:
	make -C ../tools fdfs

BOOTMOTO.BIN: BootMOTO.asm
	../tools/lwasm --6809 -lBootMOTO.txt -f decb -o $@ BootMOTO.asm

INTRO.BIN: INTRO.asm
	make -C ../tools
	../tools/lwasm --6809 -lINTRO.txt -f raw -o $@ INTRO.asm

INIT4.DAT: INIT4.asm
	make -C ../tools
	../tools/lwasm --6809 -lINIT4.txt -f raw -o $@ INIT4.asm

OUTRO.DAT: OUTRO.asm
	make -C ../tools
	../tools/lwasm --6809 -lOUTRO.txt -f raw -o $@ OUTRO.asm

INIT.BIN: INIT.asm
	make -C ../tools
	../tools/lwasm --6809 -lINIT.txt -f raw -o $@ INIT.asm

ED2.BIN: ED2.asm
	../tools/lwasm --6809 -lED2.txt -f raw -o $@ ED2.asm -DINIT=1 -DPACKE=1 -DPACKM=1
	dd if=ED2.BIN of=INIT1.DAT bs=256 count=1
	dd if=ED2.BIN of=PACK1.DAT bs=256 count=25 skip=97

	../tools/lwasm --6809 -lED2P2.txt -f raw -o ED2P2.BIN ED2.asm -DINIT=2 -DPACKE=2 -DPACKM=2
	dd if=ED2P2.BIN of=INIT2.DAT bs=256 count=1
	dd if=ED2P2.BIN of=PACK2.DAT bs=256 count=25 skip=97

	dd if=../src/PACKM3.bin of=PACKM3TO.bin
	dd if=../src/PACKM3.bin of=PACKM3MOcols.bin bs=1 skip=400 count=52
	../tools/colMO2TO PACKM3MOcols.bin PACKM3TOcols.bin
	dd if=PACKM3TOcols.bin of=PACKM3TO.bin bs=1 count=52 seek=400 conv=notrunc
	../tools/lwasm --6809 -lED2P3.txt -f raw -o ED2P3.BIN ED2.asm -DINIT=3 -DPACKE=3 -DPACKM=3
	dd if=ED2P3.BIN of=INIT3.DAT bs=256 count=1
	dd if=ED2P3.BIN of=PACK3.DAT bs=256 count=25 skip=97

ED2TO.fd: ../tools/fdfs BOOTMOTO.BIN INTRO.BIN INIT.BIN ED2.BIN INIT4.DAT OUTRO.DAT
	../tools/fdfs -ED2 ED2TO.fd BOOTMOTO.BIN INTRO.BIN@6600@6752 INIT.BIN@A000@A156 ED2.BIN@6600 INIT1.DAT PACK1.DAT INIT2.DAT PACK2.DAT INIT3.DAT PACK3.DAT INIT4.DAT OUTRO.DAT

clean:
	-rm *.DAT *.BIN *.bin *.txt *.fd

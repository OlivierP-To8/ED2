all: ED2MO.fd

../tools/fdfs:
	make -C ../tools fdfs

BOOTMO.BIN: BootMO.asm
	../tools/lwasm --6809 -lBootMO.txt -f decb -o $@ BootMO.asm

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
	../tools/lwasm --6809 -lED2P3.txt -f raw -o ED2P3.BIN ED2.asm -DINIT=3 -DPACKE=3 -DPACKM=3
	dd if=ED2P3.BIN of=INIT3.DAT bs=256 count=1
	dd if=ED2P3.BIN of=PACK3.DAT bs=256 count=25 skip=97

ED2MO.fd: ../tools/fdfs BOOTMO.BIN INTRO.BIN INIT.BIN ED2.BIN INIT4.DAT OUTRO.DAT
	../tools/fdfs -ED2 ED2MO.fd BOOTMO.BIN INTRO.BIN@2600@2752 INIT.BIN@6000@6156 ED2.BIN@2600 INIT1.DAT PACK1.DAT INIT2.DAT PACK2.DAT INIT3.DAT PACK3.DAT INIT4.DAT OUTRO.DAT

clean:
	-rm *.DAT *.BIN *.txt *.fd

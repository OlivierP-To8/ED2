all: tools ED2.fd

.PHONY: tools ED2MO.fd ED2TO.fd

clean:
	-rm *.fd
	make -C tools clean
	make -C src clean
	make -C srcTO clean

tools:
	make -C tools

ED2MO.fd:
	make -C src ED2MO.fd

ED2TO.fd:
	make -C srcTO ED2TO.fd

ED2.fd: ED2TO.fd ED2MO.fd
	cat srcTO/ED2TO.fd src/ED2MO.fd > $@

source:
	-rm ED2src.zip
	zip -r -x \*.o \*.BIN -o ED2src.zip src/PACKMAPS.xlsm srcTO/colMO2TO.asm \
	src*/BootMO*.asm src*/INTRO.asm src*/OUTRO.asm src*/INIT*.asm src*/PACK*.asm src/PACK*.bin src*/ED2.asm \
	res/ed2*.forme.exo2 res/ed2titre.fond*.exo2 res/interface.*.exo2 res/ed2*.png res/*.asm res/evil-snd.* res/credits.txt \
	tools/*.exe tools/*.c tools/*.h tools/exomizer2 tools/lwtools-4.22 \
	*/Makefile Makefile make.bat \
	Docs Conception


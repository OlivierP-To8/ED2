all: tools ED2.fd ED2.m5 ED2.k5 ED2.m7 ED2MegaromT2.fd

.PHONY: tools ED2MO.fd ED2TO.fd ED2.m5 ED2.k5 ED2.m7 ED2MegaromT2.fd

clean:
	-rm *.fd *.sd *.hfe *.m5 *.k5 *.m7
	make -C tools clean
	make -C src clean
	make -C srcTO clean
	make -C srcM5 clean
	make -C srcM7 clean

tools:
	make -C tools

ED2MO.fd:
	make -C src ED2MO.fd

ED2TO.fd:
	make -C srcTO ED2TO.fd

ED2.fd: ED2TO.fd ED2MO.fd
	cat srcTO/ED2TO.fd src/ED2MO.fd > $@
	tools/fdtosd -conv $@ ED2.sd
	tools/fdtohfe -conv $@ ED2.hfe 2

ED2.m5: ED2MO.fd
	make -C srcM5 $@
	cat srcM5/$@ > $@

ED2.k5: ED2.m5
	make -C srcM5 $@
	cat srcM5/$@ > $@

ED2.m7: ED2TO.fd
	make -C srcM7 $@
	cat srcM7/$@ > $@

ED2MegaromT2.fd: ED2.m7
	make -C srcM7 $@
	cat srcM7/$@ > $@
	tools/fdtosd -conv $@ ED2MegaromT2.sd
	tools/fdtohfe -conv $@ ED2MegaromT2.hfe 2

source:
	-rm ED2src.zip
	zip -r -x \*.o \*.BIN -o ED2src.zip src/PACKMAPS.xlsm srcTO/colMO2TO.asm \
	src*/BootMO*.asm src*/INTRO.asm src*/OUTRO.asm src*/INIT*.asm src*/PACK*.asm src/PACK*.bin src*/ED2*.asm \
	res/ed2*.forme.exo2 res/ed2titre.fond*.exo2 res/interface.*.exo2 res/ed2*.png res/*.asm res/evil-snd.* res/credits.txt \
	tools/*.exe tools/*.c tools/*.h tools/exomizer2 tools/lwtools-4.22 \
	*/Makefile Makefile make.bat \
	.gitignore LICENSE *.md ED2*.pdf Docs Conception


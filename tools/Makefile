all: fdfs fdfs.exe k7mofs k7mofs.exe png2fofd colMO2TO colMO2TO.exe snd6bit exoraw lwasm

.PHONY: lwasm exoraw

fdfs: fdfs.c
	gcc -o $@ $@.c

fdfs.exe: fdfs.c
	i686-w64-mingw32-gcc -o $@ fdfs.c

k7mofs: k7mofs.c
	gcc -o $@ $@.c

k7mofs.exe: k7mofs.c
	i686-w64-mingw32-gcc -o $@ k7mofs.c

png2fofd: png2fofd.c upng.c upng.h
	gcc -o $@ $@.c upng.c

colMO2TO: colMO2TO.c
	gcc -o $@ $@.c

colMO2TO.exe: colMO2TO.c
	i686-w64-mingw32-gcc -o $@ colMO2TO.c

snd6bit: snd6bit.c
	gcc -o $@ $@.c

exoraw:
	make -C exomizer2
	cp -p exomizer2/exoraw .

lwasm:
	make -C lwtools-4.22 lwasm
	cp -p lwtools-4.22/lwasm/lwasm .

clean:
	-rm fdfs png2fofd colMO2TO snd6bit exoraw lwasm
	make -C exomizer2 clean
	make -C lwtools-4.22 clean


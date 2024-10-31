cd src
..\tools\lwasm.exe --6809 -lBootMO.txt -f decb -o BOOTMO.BIN BootMO.asm
..\tools\lwasm.exe --6809 -lINTRO.txt -f raw -o INTRO.BIN INTRO.asm
..\tools\lwasm.exe --6809 -lINIT4.txt -f raw -o INIT4.DAT INIT4.asm
..\tools\lwasm.exe --6809 -lOUTRO.txt -f raw -o OUTRO.DAT OUTRO.asm
..\tools\lwasm.exe --6809 -lINIT.txt -f raw -o INIT.BIN INIT.asm
..\tools\lwasm.exe --6809 -lED2.txt -f raw -o ED2.BIN ED2.asm -DINIT=1 -DPACKE=1 -DPACKM=1
..\tools\dd.exe if=ED2.BIN of=INIT1.DAT bs=256 count=1
..\tools\dd.exe if=ED2.BIN of=PACK1.DAT bs=256 count=25 skip=97
..\tools\lwasm.exe --6809 -lED2P2.txt -f raw -o ED2P2.BIN ED2.asm -DINIT=2 -DPACKE=2 -DPACKM=2
..\tools\dd.exe if=ED2P2.BIN of=INIT2.DAT bs=256 count=1
..\tools\dd.exe if=ED2P2.BIN of=PACK2.DAT bs=256 count=25 skip=97
..\tools\lwasm.exe --6809 -lED2P3.txt -f raw -o ED2P3.BIN ED2.asm -DINIT=3 -DPACKE=3 -DPACKM=3
..\tools\dd.exe if=ED2P3.BIN of=INIT3.DAT bs=256 count=1
..\tools\dd.exe if=ED2P3.BIN of=PACK3.DAT bs=256 count=25 skip=97
..\tools\fdfs.exe -ED2 ED2MO.fd BOOTMO.BIN INTRO.BIN@2600@2752 INIT.BIN@6000@6156 ED2.BIN@2600 INIT1.DAT PACK1.DAT INIT2.DAT PACK2.DAT INIT3.DAT PACK3.DAT INIT4.DAT OUTRO.DAT
pause
cd ..\srcM5
..\tools\lwasm.exe --6809 -lED2K7M5.txt -f decb -o ED2K7M5.BIN ED2K7M5.asm
..\tools\lwasm.exe --6809 -lINTRO.txt -f raw -o INTRO.BIN INTRO.asm
..\tools\exoraw.exe -b INTRO.BIN -o INTRO.BIN.exo2
..\tools\lwasm.exe --6809 -lED2.txt -f raw -o ED2.BIN ED2.asm -DINIT=1 -DPACKE=1 -DPACKM=1
..\tools\dd.exe if=ED2.BIN of=INIT1.DAT bs=256 count=1
..\tools\dd.exe if=ED2.BIN of=PACK1.DAT bs=256 count=25 skip=97
..\tools\exoraw.exe -b PACK1.DAT -o PACK1.DAT.exo2
..\tools\lwasm.exe --6809 -lED2P2.txt -f raw -o ED2P2.BIN ED2.asm -DINIT=2 -DPACKE=2 -DPACKM=2
..\tools\dd.exe if=ED2P2.BIN of=INIT2.DAT bs=256 count=1
..\tools\dd.exe if=ED2P2.BIN of=PACK2.DAT bs=256 count=25 skip=97
..\tools\exoraw.exe -b PACK2.DAT -o PACK2.DAT.exo2
..\tools\lwasm.exe --6809 -lED2P3.txt -f raw -o ED2P3.BIN ED2.asm -DINIT=3 -DPACKE=3 -DPACKM=3
..\tools\dd.exe if=ED2P3.BIN of=INIT3.DAT bs=256 count=1
..\tools\dd.exe if=ED2P3.BIN of=PACK3.DAT bs=256 count=25 skip=97
..\tools\exoraw.exe -b PACK3.DAT -o PACK3.DAT.exo2
..\tools\dd.exe if=ED2.BIN of=ED2Part1.DAT bs=256 skip=1 count=24
..\tools\dd.exe if=ED2.BIN of=ED2Part2.DAT bs=256 skip=25 count=70
..\tools\dd.exe if=ED2.BIN of=ED2Part3.DAT bs=256 skip=95 count=2
..\tools\exoraw.exe -b ED2Part1.DAT -o ED2Part1.DAT.exo2
..\tools\exoraw.exe -b ED2Part2.DAT -o ED2Part2.DAT.exo2
..\tools\exoraw.exe -b ED2Part3.DAT -o ED2Part3.DAT.exo2
..\tools\lwasm.exe --6809 -lED2ROM0.txt -f raw -o ED2ROM0.BIN ED2ROM0.asm
..\tools\lwasm.exe --6809 -lED2ROM1.txt -f raw -o ED2ROM1.BIN ED2ROM1.asm
..\tools\lwasm.exe --6809 -lED2ROM2.txt -f raw -o ED2ROM2.BIN ED2ROM2.asm
..\tools\lwasm.exe --6809 -lED2ROM3.txt -f raw -o ED2ROM3.BIN ED2ROM3.asm
..\tools\k7mofs.exe -add ED2.k5 ED2.BAS ED2K7M5.BIN ED2ROM0.BIN ED2ROM1.BIN ED2ROM2.BIN ED2ROM3.BIN
move /Y ED2.k5 ..
copy /B ED2ROM0.BIN + ED2ROM1.BIN + ED2ROM2.BIN + ED2ROM3.BIN ..\ED2.m5
pause
cd ..\srcTO
..\tools\lwasm.exe --6809 -lBootMOTO.txt -f decb -o BOOTMOTO.BIN BootMOTO.asm
..\tools\lwasm.exe --6809 -lINTRO.txt -f raw -o INTRO.BIN INTRO.asm
..\tools\lwasm.exe --6809 -lINIT4.txt -f raw -o INIT4.DAT INIT4.asm
..\tools\lwasm.exe --6809 -lOUTRO.txt -f raw -o OUTRO.DAT OUTRO.asm
..\tools\lwasm.exe --6809 -lINIT.txt -f raw -o INIT.BIN INIT.asm
..\tools\lwasm.exe --6809 -lED2.txt -f raw -o ED2.BIN ED2.asm -DINIT=1 -DPACKE=1 -DPACKM=1
..\tools\dd.exe if=ED2.BIN of=INIT1.DAT bs=256 count=1
..\tools\dd.exe if=ED2.BIN of=PACK1.DAT bs=256 count=25 skip=97
..\tools\lwasm.exe --6809 -lED2P2.txt -f raw -o ED2P2.BIN ED2.asm -DINIT=2 -DPACKE=2 -DPACKM=2
..\tools\dd.exe if=ED2P2.BIN of=INIT2.DAT bs=256 count=1
..\tools\dd.exe if=ED2P2.BIN of=PACK2.DAT bs=256 count=25 skip=97
..\tools\dd if=..\src\PACKM3.bin of=PACKM3TO.bin
..\tools\dd if=..\src\PACKM3.bin of=PACKM3MOcols.bin bs=1 skip=400 count=52
..\tools\colMO2TO.exe PACKM3MOcols.bin PACKM3TOcols.bin
..\tools\dd if=PACKM3TOcols.bin of=PACKM3TO.bin bs=1 count=52 seek=400 conv=notrunc
..\tools\lwasm.exe --6809 -lED2P3.txt -f raw -o ED2P3.BIN ED2.asm -DINIT=3 -DPACKE=3 -DPACKM=3
..\tools\dd.exe if=ED2P3.BIN of=INIT3.DAT bs=256 count=1
..\tools\dd.exe if=ED2P3.BIN of=PACK3.DAT bs=256 count=25 skip=97
..\tools\fdfs.exe -ED2 ED2TO.fd BOOTMOTO.BIN INTRO.BIN@6600@6752 INIT.BIN@A000@A156 ED2.BIN@6600 INIT1.DAT PACK1.DAT INIT2.DAT PACK2.DAT INIT3.DAT PACK3.DAT INIT4.DAT OUTRO.DAT
cd ..
copy /B srcTO\ED2TO.fd + src\ED2MO.fd ED2.fd
pause

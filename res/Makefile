all: evil-snd.bin ed2debut1.forme.exo2 ed2debut2.forme.exo2 ed2menu.forme.exo2 interface.forme.exo2

ed2intro.forme: ed2intro.png
	../tools/png2fofd ed2intro.png ed2intro.forme ed2intro.fond

ed2intro.forme.exo2: ed2intro.forme
	../tools/exoraw -b -o ed2intro.forme.exo2 ed2intro.forme
	../tools/exoraw -b -o ed2intro.fond.exo2 ed2intro.fond

evil-snd.bin: evil-snd.wav
	../tools/snd6bit evil-snd.wav evil-snd.bin

ed2titre.forme: ed2titre.png
	../tools/png2fofd ed2titre.png ed2titre.forme ed2titre.fond
	xxd -i -c 40 ed2titre.fond > ed2titre.fond.txt
	xxd -i -c 40 ed2titre.forme > ed2titre.forme.txt

ed2titre.fondTO: ed2titre.fond
	../tools/colMO2TO ed2titre.fond ed2titre.fondTO
	xxd -i -c 40 ed2titre.fondTO > ed2titre.fondTO.txt

ed2titre.forme.exo2: ed2titre.forme ed2titre.fondTO
	../tools/exoraw -b -o ed2titre.forme.exo2 ed2titre.forme
	../tools/exoraw -b -o ed2titre.fond.exo2 ed2titre.fond
	../tools/exoraw -b -o ed2titre.fondTO.exo2 ed2titre.fondTO

ed2debut1.forme: ed2debut1.png
	../tools/png2fofd ed2debut1.png ed2debut1.forme ed2debut1.fond
	xxd -i -c 40 ed2debut1.fond > ed2debut1.fond.txt
	xxd -i -c 40 ed2debut1.forme > ed2debut1.forme.txt

ed2debut1.forme.exo2: ed2debut1.forme
	../tools/exoraw -b -o ed2debut1.forme.exo2 ed2debut1.forme
	../tools/exoraw -b -o ed2debut1.fond.exo2 ed2debut1.fond

ed2debut2.forme: ed2debut2.png
	../tools/png2fofd ed2debut2.png ed2debut2.forme ed2debut2.fond
	xxd -i -c 40 ed2debut2.fond > ed2debut2.fond.txt
	xxd -i -c 40 ed2debut2.forme > ed2debut2.forme.txt

ed2debut2.forme.exo2: ed2debut2.forme
	../tools/exoraw -b -o ed2debut2.forme.exo2 ed2debut2.forme
	../tools/exoraw -b -o ed2debut2.fond.exo2 ed2debut2.fond

ed2menu.forme: ed2menu.png
	../tools/png2fofd ed2menu.png ed2menu.forme ed2menu.fond
	xxd -i -c 40 ed2menu.fond > ed2menu.fond.txt
	xxd -i -c 40 ed2menu.forme > ed2menu.forme.txt

ed2menu.forme.exo2: ed2menu.forme
	../tools/exoraw -b -o ed2menu.forme.exo2 ed2menu.forme
	../tools/exoraw -b -o ed2menu.fond.exo2 ed2menu.fond

interface.forme.exo2: interface.forme
	../tools/exoraw -b -o interface.forme.exo2 interface.forme
	../tools/exoraw -b -o interface.fond.exo2 interface.fond
	../tools/exoraw -b -o interface.fondTO.exo2 interface.fondTO

unexo2:
	../tools/exoraw -b -d -o ed2debut1.forme ed2debut1.forme.exo2
	../tools/exoraw -b -d -o ed2debut2.forme ed2debut2.forme.exo2
	../tools/exoraw -b -d -o ed2menu.forme ed2menu.forme.exo2
	../tools/exoraw -b -d -o ed2titre.forme ed2titre.forme.exo2
	../tools/exoraw -b -d -o ed2titre.fond ed2titre.fond.exo2
	../tools/exoraw -b -d -o ed2titre.fondTO ed2titre.fondTO.exo2
	../tools/exoraw -b -d -o ed2intro.forme ed2intro.forme.exo2
	../tools/exoraw -b -d -o interface.forme interface.forme.exo2
	../tools/exoraw -b -d -o interface.fond interface.fond.exo2

clean:
	rm ed2*.forme ed2*.fond evil-snd.bin


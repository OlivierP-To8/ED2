/*******************************************************************************
 * Rapide programme pour mettre des fichiers dans une image disquette bootable
 * Auteur : OlivierP-To8
 * Avril 2024
 * Basé sur https://github.com/OlivierP-To8/InufutoPorts/blob/main/Thomson/fdfs.c
 *******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <memory.h>
#include <string.h>
#include <time.h>
#include <ctype.h>

#define sectorSize 256 // 256 octets par secteur (255 octets utiles)
#define trackSize 16*sectorSize // 16 secteurs par piste (numérotés à partir de 1)
#define diskSize  80*trackSize // 80 pistes (numérotées à partir de 0)
#define blockSize 8*sectorSize // 8 secteurs par bloc

#define FAT 20*trackSize+sectorSize+1 // Le secteur 2 de la piste 20 contient la table d'allocation mémoire
#define REP 20*trackSize+2*sectorSize // Le secteur 3 de la piste 20 contient le répertoire

#define sectorBytes 255 // 256 octets par secteur (255 octets utiles)
#define blockBytes 8*sectorBytes // 8 secteurs par bloc

#define freeBlock 0xff
#define reservedBlock 0xfe

#define byte unsigned char

typedef enum
{
	BASIC_PRG = 0,
	BASIC_DAT = 1,
	ASM_PRG = 2,
	TEXT = 3
} ThomsonFileType;

byte *floppyDisk = NULL;

void formatDisk(char *diskname)
{
	byte filler = 0xe5;

	for (int i=0; i<diskSize; i++)
	{
		floppyDisk[i] = filler;
	}
	// Annexe 1 du guide du TO8, TO8D ou MO6
	/* Le secteur 2 de la piste 20 contient la table d'allocation mémoire,
	c'est à dire des informations sur les blocs de la disquette.
	Chaque fichier ne se compte pas en secteurs mais en blocs de 8 secteurs (2 Ko).
	Dans la table, chaque bloc est représenté par un octet. Attention, le 1er octet du secteur n'est pas utilisé.
	Le 1er bloc est représenté pas le 2e octet, le 2e bloc par le 3e octet, etc.
	La valeur de l'octet donne des indications sur l'occupation de bloc correspondant:
		entre 0 et 4B : Le bloc fait partie d'un fichier, l'octet contient le numéro du prochain bloc du même fichier.
		entre C1 et C8 : Le bloc est le dernier d'un fichier, l'octet contient le nombre de secteurs du bloc occupés par le fichier auquel est ajouté la constante C0.
		FE : Le bloc est réservé et ne peut pas être utilisé pour un fichier.
		FF : Le bloc est libre
	*/
	for (int i=20*trackSize; i<21*trackSize; i++)
	{
		floppyDisk[i] = freeBlock;
	}
	// Nom de la disquette sur les 8 premiers octets
	if (diskname != NULL)
	{
		char basename[10] = {0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x00};
		char *folder = strrchr(diskname,'/');
		char *point = strrchr(diskname,'.');
		int start = (folder==NULL) ? 0 : 1 + folder - diskname;
		int end = (point==NULL) ? strlen(diskname) : point - diskname;
		if ((end - start) > 8)
		{
			end = start + 8;
		}
		memcpy(basename, &diskname[start], end - start);
		memcpy(&floppyDisk[20*trackSize], basename, 8);
	}
	// Le 1er octet du secteur n'est pas utilisé
	floppyDisk[FAT-1] = 0x00;
	// La piste 20 est réservée (2 blocs de 8 secteurs par piste)
	floppyDisk[FAT+2*20] = reservedBlock;
	floppyDisk[FAT+2*20+1] = reservedBlock;
	// Les pistes 80 et suivantes ne sont pas utilisées
	for (int i=FAT+80*2; i<REP; i++)
	{
		floppyDisk[i] = 0x00;
	}
}

int contains(byte value, byte *data, int size)
{
	for (int i=0; i<size; i++)
	{
		if (data[i] == value)
		{
			return 1;
		}
	}
	return 0;
}

byte findFreeBlock(byte *blocks, int blocksnb)
{
	// Le répertoire est situé sur la piste 20 de la disquette.
	// Le répertoire commence au secteur 3 et occupe une place de 14 secteurs.
	// on récupére les 1er blocs utilisés par les fichiers
	byte inuse[112];
	int inusenb=0;
	for (int entry=13; entry<14*sectorSize; entry+=32)
	{
		byte block = floppyDisk[REP+entry];
		if (block != freeBlock)
		{
			inuse[inusenb++] = block;
		}
	}
	// Chaque fichier ne se compte pas en secteurs mais en blocs de 8 secteurs (2 Ko).
	// on commence de la piste 39 vers 0
	// on évite de prendre les blocks qui sont en train d'être réservés (passés en paramètre)
	for (byte i=79; i>=0; i--)
	{
		if ((floppyDisk[FAT+i] == freeBlock) && (!contains(i, inuse, inusenb)) && (!contains(i, blocks, blocksnb)))
			return i;
	}
	// puis de la piste 40 vers 79
	for (byte i=80; i<2*80; i++)
	{
		if ((floppyDisk[FAT+i] == freeBlock) && (!contains(i, inuse, inusenb)) && (!contains(i, blocks, blocksnb)))
			return i;
	}

	return 0xff;
}

int findFreeEntry()
{
	// Le répertoire est situé sur la piste 20 de la disquette.
	// Le répertoire commence au secteur 3 et occupe une place de 14 secteurs.
	for (int i=0; i<14*sectorSize; i+=32)
	{
		if (floppyDisk[REP+i] == freeBlock)
			return i;
	}

	return -1;
}

int addFileEntry(char *filename, byte block, int sizeLeft)
{
	/* Le répertoire est situé sur la piste 20 de la disquette.
	Le répertoire commence au secteur 3 et occupe une place de 14 secteurs.
	Chaque fichier inscrit au répertoire à une zone réservée fixe de 32 octets :*/
	int entry = REP + findFreeEntry();

	/*  8: Nom du fichier, cadré à gauche, complété au besoin par des blanc à droite.
			Si le fichier a été supprimé par KILL, le premier octet contient 0.
			Si la zone du répertoire n'a pas encore été utilisée, le premier octet contient FF.*/
	char basename[10];
	sscanf(filename,"%[^.]",basename);
	for (int i=0; i<strlen(basename); i++)
	{
		floppyDisk[entry+i] = (byte)basename[i];
	}
	for (int i=strlen(basename); i<8; i++)
	{
		floppyDisk[entry+i] = 0x20;
	}

	//  3: Suffixe du nom de fichier (BAS,DAT,BIN,...) cadré à gauche, complété par des blanc à droite si nécessaire.
	char *extension = strrchr(filename,'.');
	for (int i=1; i<strlen(extension); i++)
	{
		floppyDisk[entry+7+i] = (byte)extension[i];
	}
	for (int i=strlen(extension); i<4; i++)
	{
		floppyDisk[entry+7+i] = 0x20;
	}

	/*  1: Type du fichier
			0: programme BASIC
			1: fichier de données BASIC
			2: programme en langage machine
			3: fichier de texte*/
	ThomsonFileType fileType = BASIC_PRG;
	if ((strcmp(extension, ".BIN") == 0) ||
		(strcmp(extension, ".CHG") == 0) ||
		(strcmp(extension, ".DAT") == 0) ||
		(strcmp(extension, ".MAP") == 0))
	{
		fileType = ASM_PRG;
	}
	floppyDisk[entry+11] = (byte)fileType;

	/*  1: Type des données
			0: les octets contiennent du binaire
			FF: les octets contiennent des caractères codés en ASCII*/
	floppyDisk[entry+12] = 0; // les octets contiennent du binaire

	//  1: Le numéro du premier bloc attribué au fichier (à partir de 0)
	floppyDisk[entry+13] = block;

	//  2: Le nombre d'octets occupés dans le dernier secteur du fichier
	floppyDisk[entry+14] = (byte)(sizeLeft >> 8);
	floppyDisk[entry+15] = (byte)(sizeLeft & 0xff);

	//  8: Commentaire associé au fichier (lors du SAVE, COPY, NAME)
	floppyDisk[entry+16] = 0x00;
	for (int i=1; i<8; i++)
	{
		floppyDisk[entry+16+i] = 0x20;
	}

	//  8: Inutilisés
	time_t t = time(NULL);
	struct tm *tm = localtime(&t);
	floppyDisk[entry+24] = (byte)(tm->tm_mday);
	floppyDisk[entry+25] = (byte)(tm->tm_mon+1);
	floppyDisk[entry+26] = (byte)(tm->tm_year-100);
	for (int i=3; i<8; i++)
	{
		floppyDisk[entry+24+i] = 0x00;
	}

	return entry;
}

void addFileBlock(byte block, byte *bytes, int size, int offset, int sectorLength)
{
	for (int b=0; b<8; b++)
	{
		int src = offset+b*sectorLength;
		int dst = block*blockSize+b*sectorSize;
		int nb = sectorLength;
		if (src+sectorLength > size)
		{
			nb = size - src;
		}
		if (nb > 0)
		{
			memcpy(&floppyDisk[dst], &bytes[src], nb);
			for (int j=nb; j<sectorSize; j++)
			{
				floppyDisk[dst+j] = 0x00;
			}
		}
	}
}

void addFileContent(char *filename, byte *bytes, int size)
{
	byte blocks[112];
	int blocksnb=0;
	int offset = 0;
	int sizeLeft = size;
	memset(blocks, 0, sizeof(blocks));
	while (sizeLeft > 0)
	{
		byte block = findFreeBlock(blocks, blocksnb);
		addFileBlock(block, bytes, size, offset, sectorBytes);
		offset += blockBytes;
		if (blocksnb > 0)
		{
			floppyDisk[FAT+blocks[blocksnb-1]] = block;
		}
		blocks[blocksnb++] = block;
		if (sizeLeft < blockBytes)
		{
			byte nbSectors = 0xc0;
			while (sizeLeft > 0)
			{
				nbSectors++;
				sizeLeft -= sectorBytes;
			}
			floppyDisk[FAT+blocks[blocksnb-1]] = nbSectors;
			int entry = addFileEntry(filename, blocks[0], sizeLeft+sectorBytes);
			if (strcmp(strrchr(filename,'.'), ".CHG") == 0)
			{
				for (int i=0; i<size; i+=16384)
				{
					floppyDisk[entry+30]++; // number of 16K banks
				}
				printf("\t%d banques de 16K\n", floppyDisk[entry+30]);
				byte checksum = 0;
				for (int i=0; i<8; i++)
				{
					checksum += floppyDisk[entry+i];
				}
				floppyDisk[entry+31] = checksum;
			}
		}
		sizeLeft -= blockBytes;
	}
}

void addBootLoader(char *bootsector, int nbf)
{
	FILE *fi=fopen(bootsector, "rb");
	if (fi==NULL)
	{
		printf("impossible d'ouvrir %s\n", bootsector);
		exit(1);
	}
	else
	{
		fseek(fi, 0, SEEK_END);
		int size = ftell(fi);
		byte *fileData = malloc(size);
		memset(fileData, 0, size);
		fseek(fi, 0, SEEK_SET);

		int nbr = fread(fileData, 1, size, fi);
		fclose(fi);
		printf("lecture du secteur de boot %s (%d octets) %s\n", bootsector, size, size==nbr?"OK":"KO");

		// test du binaire
		if (size > 130)
		{
			printf("erreur, le boot secteur doit faire un maximum de 120 octets\n");
		}
		else if ((fileData[0] != 0x00) || ((fileData[3] != 0x62) && (fileData[3] != 0x22)) || (fileData[4] != 0x00))
		{
			printf("erreur, le boot secteur doit commencer à l'adresse $6200 ou $2200\n");
		}
		else
		{
			memset(floppyDisk, 0, sectorSize);
			byte checksum = 0x55;
			for (int i=0; i<size-10; i++)
			{
				floppyDisk[i] = 256 - fileData[i+5];
				checksum += fileData[i+5];
			}
			memcpy(&floppyDisk[120], "BASIC2", 6);
			checksum += 0x6c;
			floppyDisk[127] = checksum;
			floppyDisk[FAT] = reservedBlock;
		}

		int n = 12; // position où écrire dans le secteur
		for (int entry=0; entry<32*nbf; entry+=32)
		{
			printf("addBootLoader %.11s\n", &floppyDisk[REP + entry]);
			if (strncmp(&floppyDisk[REP + entry + 8], "BIN", 3) == 0)
			{
				byte block = floppyDisk[REP+entry+13];
				byte header[5];
				memcpy(header, &floppyDisk[block*blockSize], 5);
				unsigned int fileAddr, fileSize, fileEnd, fileExec;

				fileSize = header[1];
				fileSize = (fileSize << 8) + header[2];
				fileAddr = header[3];
				fileAddr = (fileAddr << 8) + header[4];
				fileEnd = fileAddr + fileSize;

				printf("\theader: [%04X-%04X] (%d octets)\n", fileAddr, fileEnd, fileSize);
				// printf("ajout @load %04x\n", fileAddr);
				// les infos permettant de lire le(s) bootfile(s) sont placées sur le secteur 20 piste 1
				floppyDisk[20*trackSize+n++] = (byte)(fileAddr >> 8);
				floppyDisk[20*trackSize+n++] = (byte)(fileAddr & 0xff);

				do
				{
					byte nextb = floppyDisk[FAT+block];
					int nbs = 8;
					if (nextb > 0xc0)
					{
						nbs = nextb - 0xc0;
						nextb = freeBlock;
						int nbBytes = (floppyDisk[REP+entry+14] << 8) | floppyDisk[REP+entry+15];
						int src = block*blockSize+(nbs-1)*sectorSize+nbBytes;
						if (nbBytes < 2)
						{	// l'adresse est coupée entre 2 secteurs, il faut tenir compte du 256e octet non géré par le basic
							fileExec = floppyDisk[src-3];
						}
						else
						{
							fileExec = floppyDisk[src-2];
						}
						fileExec = (fileExec << 8) + floppyDisk[src-1];
					}
					byte track = (block >> 1);
					byte sector = (block & 0x01) ? 9 : 1;
					floppyDisk[20*trackSize+n++] = track;
					floppyDisk[20*trackSize+n++] = sector;
					floppyDisk[20*trackSize+n++] = sector+nbs-1;
					printf("\tajout bloc 2K BOOT : piste %02d secteur %02d-%02d\n", track, sector, sector + nbs - 1);
					block = nextb;
				} while (block != freeBlock);
				floppyDisk[20*trackSize+n++] = freeBlock;
				printf("\tajout @exec %04x\n", fileExec);
				floppyDisk[20*trackSize+n++] = (byte)(fileExec >> 8);
				floppyDisk[20*trackSize+n++] = (byte)(fileExec & 0xff);
			}
		}
	}
}

void addED2Pack(char *initfile, char *packfile)
{
	// Ajout des INIT/PACK pour les tours de ED2.
	// Les pistes et secteurs sont ajoutées à ED2.asm, en reportant les pistes/secteur affichés

	// Le contenu des fichiers est ajouté, avec les blocs réservés (piste 20 secteur 2)
	// pour éviter qu’ils soient écrasés par d’autres fichiers, mais
	// ils ne sont pas ajoutés dans le catalogue (piste 20 secteurs 3 à 16).
	// Les INIT/PACK ne sont donc pas visibles dans le BASIC (commande DIR),
	// de toute façon ils ne seraient pas gérables par le BASIC, car
	// pour simplifier mon code ils occupent 256 octets par secteur et
	// le BASIC ne gère que 255 octets par secteur.

	printf("addED2Pack %s %s\n", initfile, (packfile!=NULL)?packfile:"");
	FILE *finit = fopen(initfile, "rb");
	FILE *fpack = fopen(packfile, "rb");
	if (finit == NULL)
	{
		printf("impossible d'ouvrir %s\n", initfile);
		exit(1);
	}
	else
	{
		fseek(finit, 0, SEEK_END);
		int initfilesize = ftell(finit);
		fseek(finit, 0, SEEK_SET);

		int packfilesize = 0;
		if (fpack != NULL)
		{
			fseek(fpack, 0, SEEK_END);
			packfilesize = ftell(fpack);
			fseek(fpack, 0, SEEK_SET);
		}

		int size = initfilesize + packfilesize;
		byte *bytes = malloc(size);
		memset(bytes, 0, size);

		int nbinit = fread(bytes, 1, initfilesize, finit);
		printf("\tlecture de %s (%d octets) %s\n", initfile, initfilesize, initfilesize == nbinit?"OK":"KO");
		fclose(finit);
		if (fpack != NULL)
		{
			int nbpack = fread(&bytes[initfilesize], 1, packfilesize, fpack);
			fclose(fpack);
			printf("\tlecture de %s (%d octets) %s\n", packfile, packfilesize, packfilesize == nbpack?"OK":"KO");
		}

		byte blocks[112];
		int blocksnb = 0;
		int offset = 0;
		int sizeLeft = size;
		memset(blocks, 0, sizeof(blocks));
		while (sizeLeft > 0)
		{
			byte block = findFreeBlock(blocks, blocksnb);
			addFileBlock(block, bytes, size, offset, sectorSize);
			offset += blockSize;
			if (blocksnb > 0)
			{
				floppyDisk[FAT+blocks[blocksnb-1]] = block;
			}
			blocks[blocksnb++] = block;
			int nbs = 8;
			if (sizeLeft < blockSize)
			{
				byte nbSectors = 0xc0;
				while (sizeLeft > 0)
				{
					nbSectors++;
					sizeLeft -= sectorSize;
				}
				floppyDisk[FAT+blocks[blocksnb-1]] = nbSectors;
				nbs = nbSectors - 0xc0;
			}
			byte track = (block >> 1);
			byte sector = (block & 0x01) ? 9 : 1;
			printf("\tajout bloc 2K ED2 : piste %02d secteur %02d-%02d\n", track, sector, sector + nbs - 1);
			sizeLeft -= blockSize;
		}
	}
}

void addContBloc(char *file)
{
	// Ajout d'un fichier en bloc continu.
	// Le contenu du fichier est ajouté, avec les blocs réservés (piste 20 secteur 2)
	// pour éviter qu’il soit écrasé par d’autres fichiers, mais
	// il n'est pas ajouté dans le catalogue (piste 20 secteurs 3 à 16).

	printf("addContBloc %s\n", file);
	FILE *f = fopen(file, "rb");
	{
		fseek(f, 0, SEEK_END);
		int filesize = ftell(f);
		fseek(f, 0, SEEK_SET);

		byte *bytes = malloc(filesize);
		memset(bytes, 0, filesize);

		int nb = fread(bytes, 1, filesize, f);
		printf("\tlecture de %s (%d octets) %s\n", file, filesize, filesize == nb?"OK":"KO");
		fclose(f);

		byte blocks[112];
		int blocksnb = 0;
		int offset = filesize-blockSize;
		int sizeLeft = filesize;
		memset(blocks, 0, sizeof(blocks));
		while (sizeLeft > 0)
		{
			byte block = findFreeBlock(blocks, blocksnb);
			addFileBlock(block, bytes, filesize, offset, sectorSize);
			if (blocksnb > 0)
			{
				floppyDisk[FAT+blocks[blocksnb-1]] = reservedBlock;
			}
			blocks[blocksnb++] = block;
			int nbs = 8;
			if (sizeLeft <= blockSize)
			{
				byte nbSectors = 0;
				while (sizeLeft > 0)
				{
					nbSectors++;
					sizeLeft -= sectorSize;
				}
				floppyDisk[FAT+blocks[blocksnb-1]] = reservedBlock;
				nbs = nbSectors;
			}
			byte track = (block >> 1);
			byte sector = (block & 0x01) ? 9 : 1;
			printf("\tajout bloc 2K offset %04x : piste %02d secteur %02d-%02d\n", offset, track, sector, sector + nbs - 1);
			offset -= blockSize;
			sizeLeft -= blockSize;
		}
	}
}

void extFile(char *filename, FILE *f)
{
	char basename[13];
	sscanf(filename,"%[^.]",basename);
	for (int i=strlen(basename); i<8; i++)
	{
		basename[i] = 0x20;
	}
	char *extension = strrchr(filename,'.');
	for (int i=1; i<strlen(extension); i++)
	{
		basename[7+i] = (byte)extension[i];
	}
	for (int i=strlen(extension); i<4; i++)
	{
		basename[7+i] = 0x20;
	}

	// Le répertoire est situé sur la piste 20 de la disquette.
	// Le répertoire commence au secteur 3 et occupe une place de 14 secteurs.
	for (int entry=0; entry<14*sectorSize; entry+=32)
	{
		if (strncmp(basename, (char *)(&floppyDisk[REP+entry]), 11) == 0)
		{
			byte block = floppyDisk[REP+entry+13];
			printf("extraction de %s\n", filename);
			while (block != freeBlock)
			{
				int nbBytes = sectorBytes;
				byte nextBlock = floppyDisk[FAT+block];
				int nbSectors = 8;
				if (nextBlock > 0xc0)
				{
					nbSectors = nextBlock - 0xc0;
					nextBlock = freeBlock;
				}
				for (int b=0; b<nbSectors; b++)
				{
					int src = block*blockSize+b*sectorSize;
					if ((nextBlock == freeBlock) && (b+1==nbSectors))
					{
						nbBytes = (floppyDisk[REP+entry+14] << 8) | floppyDisk[REP+entry+15];
					}
					//printf("ext block %x depuis [%x-%x]\n", block, src, src+nbBytes);
					fwrite(&floppyDisk[src], 1, nbBytes, f);
				}
				block = nextBlock;
			}
			break;
		}
	}
}

void list(FILE *f)
{
	// Le répertoire est situé sur la piste 20 de la disquette.
	// Le répertoire commence au secteur 3 et occupe une place de 14 secteurs.
	for (int entry=0; entry<14*sectorSize; entry+=32)
	{
		if ((floppyDisk[REP+entry] > 0x20) && (floppyDisk[REP+entry] < reservedBlock))
		{
			char basename[13] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
			int c=0;
			for (int i=0; i<8; i++)
			{
				byte b = floppyDisk[REP+entry+i];
				if (b != 0x20)
				{
					basename[c++] = b;
				}
			}
			basename[c++] = '.';
			for (int j=8; j<11; j++)
			{
				byte b = floppyDisk[REP+entry+j];
				if (b != 0x20)
				{
					basename[c++] = b;
				}
			}
			printf("%s ", basename);
		}
	}
}

void addFile(char *filename)
{
	printf("addFile %s\n", filename);
	char *fileaddr = strstr(filename, ".BIN@");
	char *fileexec = NULL;
	if (fileaddr != NULL)
	{
		fileaddr[4] = 0;
		fileexec = strstr(fileaddr+5, "@");
	}
	FILE *fi=fopen(filename, "rb");
	if (fi==NULL)
	{
		printf("impossible d'ouvrir %s\n", filename);
		exit(1);
	}
	else
	{
		fseek(fi, 0, SEEK_END);
		int size = ftell(fi);
		int delta = 0;

		if (strstr(filename, ".BIN") != NULL)
		{
			// check header and footer of binary file and add if missing
			byte header[5], footer[5];
			fseek(fi, -5, SEEK_END);
			fread(footer, 1, 5, fi);
			fseek(fi, 0, SEEK_SET);
			fread(header, 1, 5, fi);

			int sizecont = size-10;
			if ((header[0]!=0x00) || (header[1]!=(sizecont >> 8) || header[2]!=(sizecont & 0xff)))
			{
				//printf("\t/!\\ ATTENTION : le fichier %s n'a pas de header\n", filename);
				size += 10;
				delta = 5;
			}
		}

		byte *fileData = malloc(size);
		memset(fileData, 0, size);
		fseek(fi, 0, SEEK_SET);

		int nbr = fread(&fileData[delta], 1, size, fi);
		fclose(fi);
		printf("\tlecture de %s (%d octets)\n", filename, size);
		if ((delta>0) && (fileaddr!=NULL))
		{
			int sizecont = size-10;
			int addrload = (int)strtol(&fileaddr[5], NULL, 16);
			int addrexec = addrload;
			if (fileexec != NULL)
			{
				addrexec = (int)strtol(&fileexec[1], NULL, 16);
			}
			printf("\tAjout du header et footer au fichier %s @ load %04X exec %04X\n", filename, addrload, addrexec);
			fileData[0] = 0x00;
			fileData[1] = (byte)(sizecont >> 8);
			fileData[2] = (byte)(sizecont & 0xff);
			fileData[3] = (byte)(addrload >> 8);
			fileData[4] = (byte)(addrload & 0xff);
			fileData[size-5] = 0xff;
			fileData[size-4] = 0x00;
			fileData[size-3] = 0x00;
			fileData[size-2] = (byte)(addrexec >> 8);
			fileData[size-1] = (byte)(addrexec & 0xff);
		}

		addFileContent(filename, fileData, size);
	}
}

void addAutoBat(char *binName)
{
	int loadlen = 2 + 2 + 2 + strlen(binName) + 2 + 3 + 1; // len + 10 + LOADM + binName + "" + ,,R + 0x00
	int fulllen = 1 + loadlen + 2;

	byte *fileData = malloc(fulllen);
	memset(fileData, 0, fulllen);
	int i = 0;

	// entête
	fileData[i++]=0xff;
	// taille du fichier
	fileData[i++]=(byte)(fulllen >> 8);
	fileData[i++]=(byte)(fulllen & 0xff);
	// *** première ligne ***
	// longueur de la ligne
	fileData[i++]=(byte)(loadlen >> 8);
	fileData[i++]=(byte)(loadlen & 0xff);
	// numéro de ligne
	fileData[i++]=0x00;
	fileData[i++]=0x0a; // 10
	// LOADM
	fileData[i++]=0xb3; // LOAD
	fileData[i++]=0x4d; // M
	// binName
	fileData[i++]=0x22; // "
	for (int j=0; j<strlen(binName); j++)
	{
		fileData[i++]=(byte)(binName[j]);
	}
	fileData[i++]=0x22; // "
	fileData[i++]=0x2c; // ,
	fileData[i++]=0x2c; // ,
	fileData[i++]=0x52; // R
	// fin de ligne
	fileData[i++]=0x00;
	// fin de fichier
	fileData[i++]=0x00;
	fileData[i++]=0x00;

	addFileContent("AUTO.BAT", fileData, i);
}

int main(int argc, char **argv)
{
	printf("FDFS pour Evil Dungeons 2 par OlivierP-To8\n");
	printf("basé sur https://github.com/OlivierP-To8/BootFloppyDisk/blob/main/tools/fdfs.c\n\n");

	floppyDisk = malloc(diskSize);
	formatDisk(argc >= 3 ? argv[2] : NULL);

	if ((argc==3) && (strcmp(argv[1], "-format") == 0))
	{
		FILE *fd=fopen(argv[2], "wb");
		if (fd==NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
			exit(1);
		}
		else
		{
			fwrite(floppyDisk, 1, diskSize, fd);
			fclose(fd);
		}
	}
	else if ((argc>=4) && (strcmp(argv[1], "-add") == 0))
	{
		FILE *fd=fopen(argv[2], "wb");
		if (fd==NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
			exit(1);
		}
		else
		{
			for (int i=3; i<argc; i++)
			{
				addFile(argv[i]);
			}
			fwrite(floppyDisk, 1, diskSize, fd);
			fclose(fd);
		}
	}
	else if ((argc>=5) && (strcmp(argv[1], "-addBL") == 0))
	{
		FILE *fd=fopen(argv[2], "wb");
		if (fd==NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
			exit(1);
		}
		else
		{
			for (int i=4; i<argc; i++)
			{
				addFile(argv[i]);
			}
			addBootLoader(argv[3], argc-4);
			fwrite(floppyDisk, 1, diskSize, fd);
			fclose(fd);
		}
	}
	else if ((argc>=4) && (strcmp(argv[1], "-ext") == 0))
	{
		FILE *fd=fopen(argv[2], "rb");
		if (fd==NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
			exit(1);
		}
		else
		{
			int size = diskSize;
			int nbr = fread(floppyDisk, 1, size, fd);
			fclose(fd);
			printf("lecture de %s (%d octets) %s\n", argv[2], size, size==nbr?"OK":"KO");

			for (int i=3; i<argc; i++)
			{
				char filename[13] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
				for (int c=0; c<strlen(argv[i]); c++)
				{
					filename[c] = toupper(argv[i][c]);
				}
				FILE *fi=fopen(filename, "wb");
				if (fi==NULL)
				{
					printf("impossible d'ouvrir %s\n", filename);
					exit(1);
				}
				else
				{
					extFile(filename, fi);
					fclose(fi);
				}
			}
		}
	}
	else if ((argc==3) && (strcmp(argv[1], "-list") == 0))
	{
		FILE *fd=fopen(argv[2], "rb");
		if (fd==NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
			exit(1);
		}
		else
		{
			int nbr = fread(floppyDisk, 1, diskSize, fd);
			list(fd);
			fclose(fd);
		}
	}
	else if ((argc >= 5) && (strcmp(argv[1], "-ED2") == 0))
	{
		FILE *fd = fopen(argv[2], "wb");
		if (fd == NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
			exit(1);
		}
		else
		{
			int nbBin = 0;
			for (int i=4; i<argc; i++)
			{
				if (strstr(argv[i], ".BIN") != NULL)
				{
					addFile(argv[i]);
					nbBin++;
				}
				else
				{
					addED2Pack(argv[i], (i+1<argc)?argv[i+1]:NULL);
					i++;
				}
			}
			addBootLoader(argv[3], nbBin); // bootloader avec boot sur les 3 premiers fichiers (entry 0, 1 et 2)
			fwrite(floppyDisk, 1, diskSize, fd);
			fclose(fd);
		}
	}
	else if ((argc >= 4) && (strcmp(argv[1], "-M7") == 0))
	{
		FILE *fd = fopen(argv[2], "wb");
		if (fd == NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
			exit(1);
		}
		else
		{
			for (int i=3; i<argc; i++)
			{
				if (strstr(argv[i], ".BIN") != NULL)
				{
					addFile(argv[i]);
					addAutoBat(argv[i]);
				}
				else
				{
					addContBloc(argv[i]);
				}
			}
			fwrite(floppyDisk, 1, diskSize, fd);
			fclose(fd);
		}
	}
	else
	{
		printf("usage : %s -format filename.fd\n", argv[0]);
		printf("usage : %s -add filename.fd filename1 filename2 ...\n", argv[0]);
		printf("usage : %s -addBL filename.fd BOOT.BIN LOAD.BIN filename1 filename2 ...\n", argv[0]);
		printf("usage : %s -ED2 filename.fd BOOTMOTO.BIN INTRO.BIN@2600@2752 INIT.BIN@6000@6156 ED2.BIN@2600 INIT1.DAT PACK1.DAT ...\n", argv[0]);
		printf("usage : %s -ext filename.fd filename1 filename2 ...\n", argv[0]);
		printf("usage : %s -list filename.fd\n", argv[0]);
	}

	return 0;
}

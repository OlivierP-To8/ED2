/*******************************************************************************
 * Rapide programme pour transformer un wav 8 bits en 6 bits
 * Auteur : OlivierP 
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main(int argc, char **argv)
{
	if (argc < 3)
		printf("usage : %s fichier.wav nom.bin\n", argv[0]);
	else
	{
		FILE *f = fopen(argv[1], "rb");
		if (f != NULL)
		{
			fseek(f, 0, SEEK_END);
			int taille = ftell(f);

			if (taille > 8000)
			{
				printf("Le sample est trop volumineux\n");
				return 1;
			}

			char filename[1024];

			fseek(f, 0, SEEK_SET);
			fread(&filename, 1, 4, f);
			if ((strncmp(filename, "RIFF", 4)) != 0)
			{
				printf("Le sample n'est pas un WAV\n");
				return 1;
			}

			fseek(f, 8, SEEK_SET);
			fread(&filename, 1, 4, f);
			if ((strncmp(filename, "WAVE", 4)) != 0)
			{
				printf("Le sample n'est pas un WAV\n");
				return 1;
			}

			fseek(f, 22, SEEK_SET);
			fread(&filename, 1, 1, f);
			if (filename[0] != 1)
			{
				printf("Le sample n'est pas un WAV mono\n");
				return 1;
			}

			fseek(f, 34, SEEK_SET);
			fread(&filename, 1, 1, f);
			if (filename[0] != 8)
			{
				printf("Le sample n'est pas un WAV 8 bits\n");
				return 1;
			}

			fseek(f, 44, SEEK_SET);
			sprintf(filename, "%s", argv[2]);
			FILE *fout = fopen(filename, "wb");
			if (fout != NULL)
			{
				while (!feof(f))
				{
					unsigned char c = fgetc(f);
					fputc(c/4, fout);
				}
				fclose(fout);
			}
			else printf("impossible d'ouvrir %s\n", filename);

			fclose(f);
		}
		else printf("impossible d'ouvrir %s\n", argv[1]);
	}
	return 0;
}

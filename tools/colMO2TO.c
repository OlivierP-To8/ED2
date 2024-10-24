/*******************************************************************************
 * Rapide programme pour transformer une couleur MO en TO
 * Auteur : OlivierP 
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

unsigned char mo2to(unsigned char in)
{
	// sur MO :
	// B7   : 1/2 teinte forme (0 = saturée, 1 = pastel)
	// B654 : couleur forme BVR
	// B3   : 1/2 teinte fond  (0 = saturée, 1 = pastel)
	// B210 : couleur fond BVR
	unsigned char pforme = (in & 0x80) >> 7;
	unsigned char forme = (in & 0x70) >> 4;
	unsigned char pfond = (in & 0x08) >> 3;
	unsigned char fond = in & 0x07;

	// sur TO :
	// B7   : 1/2 teinte fond  (1 = saturée, 0 = pastel)
	// B6   : 1/2 teinte forme (1 = saturée, 0 = pastel)
	// B543 : couleur forme BVR
	// B210 : couleur fond BVR
	unsigned char out = ((pfond ^ 1) << 7) | ((pforme ^ 1) << 6) | (forme << 3) | fond;

	return out;
}

int main(int argc, char **argv)
{
	if (argc < 3)
	{
		for (int i=0; i<=0xf; i++)
		{
			for (int j=0; j<=0xf; j++)
			{
				unsigned char in = (i<<4) | j;
				unsigned char out = mo2to(in);
				printf("\tc%02X EQU $%02X\n", in, out);
			}
		}
		printf("\nusage : %s input.bin output.bin\n", argv[0]);
	}
	else
	{
		FILE *fin = fopen(argv[1], "rb");
		if (fin != NULL)
		{
			FILE *fout = fopen(argv[2], "wb");
			if (fout != NULL)
			{
				while (!feof(fin))
				{
					unsigned char c = fgetc(fin);
					if (!feof(fin))
					{
						unsigned char o = mo2to(c);
						fputc(o, fout);
					}
				}
				fclose(fout);
			}
			else printf("impossible d'ouvrir %s\n", argv[2]);

			fclose(fin);
		}
		else printf("impossible d'ouvrir %s\n", argv[1]);
	}
	return 0;
}

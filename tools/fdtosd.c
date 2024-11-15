/*******************************************************************************
 * Rapide programme pour convertir une image disquette au format SD
 * Auteur : OlivierP-To8
 * Novembre 2023 https://github.com/OlivierP-To8/InufutoPorts/blob/main/Thomson/fdtosd.c
 * Novembre 2024 ajout .fd double face
 * https://github.com/OlivierP-To8/
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>


void FDtoSD(FILE *fd, FILE *sd)
{
	unsigned char sector_buffer[256];
	unsigned char empty[512];
	memset(empty, 0xff, sizeof(empty));

	for (int t=0; t<4*80; t++)
	{
		for (int s=1; s<=16; s++)
		{
			if (fread(sector_buffer, 1, 256, fd)==256)
			{
				fwrite(sector_buffer, 1, 256, sd);
				fwrite(empty, 1, 256, sd);
			}
			else
			{
				fwrite(empty, 1, 512, sd);
			}
		}
	}
}


int main(int argc, char **argv)
{
	if ((argc==4) && (strcmp(argv[1], "-conv")==0))
	{
		FILE *fd=fopen(argv[2], "rb");
		if (fd==NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
		}
		else
		{
			FILE *sd=fopen(argv[3], "wb");
			if (sd==NULL)
			{
				printf("impossible d'ouvrir %s\n", argv[3]);
			}
			else
			{
				FDtoSD(fd, sd);
				fclose(sd);
			}
			fclose(fd);
		}
	}
	else
	{
		printf("Usage : %s -conv disk.fd disk.sd", argv[0]);
	}
}

#include <stdio.h>
#include <string.h>

#define MAX(x, y) (((x) > (y)) ? (x) : (y))
#define MIN(x, y) (((x) < (y)) ? (x) : (y))

#include "upng.h"

int main(int argc, char **argv)
{
	if (argc <= 3)
	{
		printf("Usage: %s png forme fond\n", argv[0]);
		return 0;
	}

	upng_t *upng = upng_new_from_file(argv[1]);
	if (upng_get_error(upng) != UPNG_EOK)
	{
		printf("error: %u %u\n", upng_get_error(upng), upng_get_error_line(upng));
		return 0;
	}

	upng_decode(upng);
	if (upng_get_error(upng) != UPNG_EOK)
	{
		printf("error: %u %u\n", upng_get_error(upng), upng_get_error_line(upng));
		return 0;
	}

	printf("size:	%ux%ux%u (%u)\n", upng_get_width(upng), upng_get_height(upng), upng_get_bpp(upng), upng_get_size(upng));
	printf("format:	%u\n", upng_get_format(upng));

	if ((upng_get_format(upng) == UPNG_PALETTE4) ||
		(upng_get_format(upng) == UPNG_PALETTE8))
	{
		FILE *fo = fopen(argv[2], "wb");
		FILE *fd = fopen(argv[3], "wb");

		unsigned int w = upng_get_width(upng);
		unsigned int h = upng_get_height(upng);
		const unsigned char *buf = upng_get_buffer(upng);
		unsigned char fond = 0;
		if (strstr(argv[3],"ed2intro")!=NULL)
		{
			fond = 7;	// fond blanc
			printf("/!\\ ed2intro /!\\\n");
		}

		for (unsigned int y = 0; y < h; y++)
		{
			for (unsigned int x = 0; x < w / 8; x++)
			{
				unsigned char c[8];
				if (upng_get_format(upng) == UPNG_PALETTE4)
				{
					unsigned char p12 = *buf++;
					unsigned char p34 = *buf++;
					unsigned char p56 = *buf++;
					unsigned char p78 = *buf++;

					c[0] = (p12 >> 4);
					c[1] = (p12 & 0x0f);
					c[2] = (p34 >> 4);
					c[3] = (p34 & 0x0f);
					c[4] = (p56 >> 4);
					c[5] = (p56 & 0x0f);
					c[6] = (p78 >> 4);
					c[7] = (p78 & 0x0f);
				}
				else if (upng_get_format(upng) == UPNG_PALETTE8)
				{
					c[0] = *buf++;
					c[1] = *buf++;
					c[2] = *buf++;
					c[3] = *buf++;
					c[4] = *buf++;
					c[5] = *buf++;
					c[6] = *buf++;
					c[7] = *buf++;
				}

				if ((x == 0) && (y == 0))
				{
					fond = c[0];
				}
				unsigned char frm = c[0];
				unsigned char fnd = fond;
				for (int i=0; i<8; i++)
				{
					if ((c[i] != frm) && (c[i] != fnd))
					{
						if (c[i] != frm) {fnd = c[i];}
						if (c[i] != fnd) {frm = c[i];}
					}
				}

				unsigned minc = MIN(frm, fnd);
				unsigned maxc = MAX(frm, fnd);
				unsigned char coul = (maxc << 4) | minc;
				fwrite(&coul, 1, 1, fd);


				unsigned char pix = 0;
				if (frm != fnd)
				{
					for (int i=0; i<8; i++)
					{
						if (c[i] == maxc)
						{
							pix |= (1 << (7-i));
						}
					}
				}
				if ((pix==0) && (strstr(argv[3],"ed2titre")!=NULL))
				{
					pix = 0x33;	// forme pour les flammes
					printf("/!\\ ed2titre /!\\\n");
				}
				fwrite(&pix, 1, 1, fo);
			}
		}

		fclose(fo);
		fclose(fd);
	}

	upng_free(upng);
	return 0;
}

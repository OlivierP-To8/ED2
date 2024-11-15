/*******************************************************************************
 * Rapide programme pour convertir une image disquette Thomson au format HFE
 * Auteur : OlivierP-To8
 * Novembre 2023 https://github.com/OlivierP-To8/InufutoPorts/blob/main/Thomson/fdtohfe.c
 * Novembre 2024 ajout .fd double face
 * https://github.com/OlivierP-To8/
*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>


// https://hxc2001.com/download/floppy_drive_emulator/SDCard_HxC_Floppy_Emulator_HFE_file_format.pdf
typedef struct picfileformatheader_
{
	unsigned char HEADERSIGNATURE[8];
	unsigned char formatrevision;
	unsigned char number_of_track;
	unsigned char number_of_side;
	unsigned char track_encoding;
	unsigned short bitRate;
	unsigned short floppyRPM;
	unsigned char floppyinterfacemode;
	unsigned char dnu;
	unsigned short track_list_offset;
	unsigned char write_allowed;
	unsigned char single_step;
	unsigned char track0s0_altencoding;
	unsigned char track0s0_encoding;
	unsigned char track0s1_altencoding;
	unsigned char track0s1_encoding;
} picfileformatheader;

// floppyinterfacemode values
#define IBMPC_DD_FLOPPYMODE             0x00
#define IBMPC_HD_FLOPPYMODE             0x01
#define ATARIST_DD_FLOPPYMODE           0x02
#define ATARIST_HD_FLOPPYMODE           0x03
#define AMIGA_DD_FLOPPYMODE             0x04
#define AMIGA_HD_FLOPPYMODE             0x05
#define CPC_DD_FLOPPYMODE               0x06
#define GENERIC_SHUGGART_DD_FLOPPYMODE  0x07
#define IBMPC_ED_FLOPPYMODE             0x08
#define MSX2_DD_FLOPPYMODE              0x09
#define C64_DD_FLOPPYMODE               0x0A
#define EMU_SHUGART_FLOPPYMODE          0x0B
#define S950_DD_FLOPPYMODE              0x0C
#define S950_HD_FLOPPYMODE              0x0D
#define DISABLE_FLOPPYMODE              0xFE

// track_encoding / track0s0_encoding / track0s1_encoding values
#define ISOIBM_MFM_ENCODING     0x00
#define AMIGA_MFM_ENCODING      0x01
#define ISOIBM_FM_ENCODING      0x02
#define EMU_FM_ENCODING         0x03
#define UNKNOWN_ENCODING        0xFF

typedef struct pictrack_
{
	unsigned short offset;
	// Offset of the track data in block of 512 bytes (Ex: 2=0x400)
	unsigned short track_len; // Length of the track data in byte.
} pictrack;

picfileformatheader info;
pictrack tracklut[80];

void writeHfeHeader(FILE *file)
{
	memcpy(info.HEADERSIGNATURE, "HXCPICFE", 8);
	info.formatrevision       = 0;                   // Revision 0
	info.number_of_track      = 80;                  // Number of track in the file
	info.number_of_side       = 2;                   // Number of valid side (Not used by the emulator)
	info.track_encoding       = IBMPC_DD_FLOPPYMODE; // Track Encoding mode (Used for the write support)
	info.bitRate              = 250;                 // Bitrate in Kbit/s. Ex : 250=250000bits/s (Max value : 500)
	info.floppyRPM            = 0;                   // Rotation per minute (Not used by the emulator)
	info.floppyinterfacemode  = GENERIC_SHUGGART_DD_FLOPPYMODE; // Floppy interface mode.
	info.dnu                  = 1;                   // Free
	info.track_list_offset    = 1;                   // Offset of the track list LUT in block of 512 bytes (Ex: 1=0x200)
	info.write_allowed        = 0xff;                // The Floppy image is write protected ? 0x00 : Write protected, 0xFF: Unprotected
	info.single_step          = 0xff;                // 0xFF : Single Step – 0x00 Double Step mode
	info.track0s0_altencoding = UNKNOWN_ENCODING;    // 0x00 : Use an alternate track_encoding for track 0 Side 0
	info.track0s0_encoding    = UNKNOWN_ENCODING;    // alternate track_encoding for track 0 Side 0
	info.track0s1_altencoding = UNKNOWN_ENCODING;    // 0x00 : Use an alternate track_encoding for track 0 Side 1
	info.track0s1_encoding    = UNKNOWN_ENCODING;    // alternate track_encoding for track 0 Side 1
	fwrite(&info, sizeof(info), 1, file);

	unsigned char filler=0xff;
	for (int i=sizeof(info); i<512; i++)
	{
		fwrite(&filler, 1, 1, file);
	}

	for (int i=0; i<80; i++)
	{
		tracklut[i].offset=2+i*49;
		tracklut[i].track_len=25008;
	}
	fwrite(tracklut, sizeof(pictrack), 80, file);

	for (int i=80*sizeof(pictrack); i<512; i++)
	{
		fwrite(&filler, 1, 1, file);
	}
}

unsigned char hfe_cipher[256];
void makeHfeCipher()
{
	unsigned char vals[16]={0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15};

	int c=0;
	for (int i=0; i<16; i++)
	{
		for (int j=0; j<16; j++)
		{
			hfe_cipher[c++]=(vals[j] << 4) | vals[i];
		}
	}
}


// https://hp9845.net/9845_backup/projects/fdio/images/track-formats.png
enum mfmfield
{
	gap1     = 0,
	sync1    = 32,
	syncID   = 44,
	idam     = 47,
	cylinder = 48,
	head     = 49,
	sector   = 50,
	length   = 51,
	crcID    = 52,
	gap2     = 54,
	sync2    = 76,
	syncDT   = 88,
	dtam     = 91,
	data     = 92,
	crcDT    = 348,
	gap3     = 350
};

#define MFM_GAP  0x9254		// 0x4E
#define MFM_SYNC 0xaaaa		// 0x00
#define MFM_AM   0x4489		// 0xA1

typedef union mfmddsector_
{
	unsigned short word[368];
	unsigned char byte[736];
} mfmddsector;

mfmddsector mfmSector;


// http://info-coach.fr/atari/hardware/_fd-hard/floppy-ug.pdf
// https://stackoverflow.com/questions/39961631/crc-16-bit-polynomial-0x1021-ccitt-calculation-with-initial-value-0x0000
unsigned short crc16Ccitt(unsigned char bytes[], int nbbytes)
{
	unsigned short crc=0xffff;

	for (int i=0; i<nbbytes; i++)
	{
		crc=(unsigned short)(crc ^ (bytes[i] << 8));

		for (int j=0; j<8; j++)
		{
			if ((crc & 0x8000)!=0)
				crc=(unsigned short)((crc << 1) ^ 0x1021);
			else
				crc <<= 1;
		}
	}

	return crc;
}


// https://yogeshmodhe.files.wordpress.com/2016/01/chm_topic-2_notes_storage-devices-and-its-interfacing2.pdf
static int prev_val=0;
void mfmInit()
{
	prev_val=0;
}
unsigned short mfmEncode(unsigned char val)
{
	unsigned short ret=0;

	for (int i=7; i>=0; i--)
	{
		unsigned char b=val & (1 << i);
		if (b!=0)
		{
			ret=ret | (1 << (i << 1));
		}
		else if (prev_val==0)
		{
			ret=ret | (2 << (i << 1));
		}
		prev_val=b;
	}

	return ret;
}


void FDtoHFE(FILE *fd, FILE *hfe, unsigned char inter)
{
	int interleave[15][16] = {
		{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}, // 1
		{0,2,4,6,8,10,12,14,1,3,5,7,9,11,13,15}, // 2
		{0,3,6,9,12,15,2,5,8,11,14,1,4,7,10,13}, // 3
		{0,4,8,12,1,5,9,13,2,6,10,14,3,7,11,15}, // 4
		{0,5,10,15,4,9,14,3,8,13,2,7,12,1,6,11}, // 5
		{0,6,12,2,8,14,4,10,1,7,13,3,9,15,5,11}, // 6
		{0,7,14,5,12,3,10,1,8,15,6,13,4,11,2,9}, // 7
		{0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15}, // 8
		{0,9,2,11,4,13,6,15,8,1,10,3,12,5,14,7}, // 9
		{0,10,4,14,8,2,12,6,1,11,5,15,9,3,13,7}, // 10
		{0,11,6,1,12,7,2,13,8,3,14,9,4,15,10,5}, // 11
		{0,12,8,4,1,13,9,5,2,14,10,6,3,15,11,7}, // 12
		{0,13,10,7,4,1,14,11,8,5,2,15,12,9,6,3}, // 13
		{0,14,12,10,8,6,4,2,1,15,13,11,9,7,5,3}, // 14
		{0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1}  // 15
	};
	unsigned char sector_buffer[260];
	unsigned char hfe_buffer[160][12544];
	memset(hfe_buffer, 0, sizeof(hfe_buffer));

	writeHfeHeader(hfe);
	makeHfeCipher();

	// Gap 1
	for (int i=0; i<32; i++)
	{
		mfmSector.word[gap1+i]=MFM_GAP;
	}

	// ID field
	for (int i=0; i<12; i++)
	{
		mfmSector.word[sync1+i]=MFM_SYNC;
	}
	for (int i=0; i<3; i++)
	{
		mfmSector.word[syncID+i]=MFM_AM;
	}

	// Gap 2
	for (int i=0; i<22; i++)
	{
		mfmSector.word[gap2+i]=MFM_GAP;
	}

	// Data field
	for (int i=0; i<12; i++)
	{
		mfmSector.word[sync2+i]=MFM_SYNC;
	}
	for (int i=0; i<3; i++)
	{
		mfmSector.word[syncDT+i]=MFM_AM;
	}

	// Gap 3
	for (int i=0; i<30; i++)
	{
		mfmSector.word[gap3+i]=MFM_GAP;
	}

	// read FD image
	for (int t=0; t<160; t++)
	{
		int dataread = 0;
		for (int s=1; s<=16; s++)
		{
			int st = t<80 ? t : t-80;
			mfmInit();
			// track / sector info
			mfmSector.word[idam]=mfmEncode(0xfe);
			mfmSector.word[cylinder]=mfmEncode(st);	// Track number between 0 and 79.
			mfmSector.word[head]=mfmEncode(0);		// Always 0 on Thomson, for both sides.
			mfmSector.word[sector]=mfmEncode(s);	// Sector number between 1 and 16.
			mfmSector.word[length]=mfmEncode(1);	// 0 means: a 128 byte sector; 1 means: a 256 byte sector; 2 means: a 512 byte sector; 3 means: a 1024 byte sector.
			// CRC
			unsigned char chsl[8]={0xa1, 0xa1, 0xa1, 0xfe, st, 0, s, 1};
			unsigned short crc=crc16Ccitt(chsl, 8);
			mfmSector.word[crcID]=mfmEncode((crc >> 8) & 0xff);
			mfmSector.word[crcID+1]=mfmEncode(crc & 0xff);
			// Gap 2
			mfmSector.word[gap2]=mfmEncode(0x4e);
			// sector data
			mfmSector.word[dtam]=mfmEncode(0xfb);
			if (fread(&sector_buffer[4], 1, 256, fd)==256)
			{
				dataread = 1;
				for (int i=0; i<256; i++)
				{
					mfmSector.word[data+i]=mfmEncode(sector_buffer[i+4]);
				}
			}
			else
			{
				dataread = 0;
			}
			// CRC
			sector_buffer[0]=0xa1;
			sector_buffer[1]=0xa1;
			sector_buffer[2]=0xa1;
			sector_buffer[3]=0xfb;
			crc=crc16Ccitt(sector_buffer, 260);
			mfmSector.word[crcDT]=mfmEncode((crc >> 8) & 0xff);
			mfmSector.word[crcDT+1]=mfmEncode(crc & 0xff);
			// Gap 3
			prev_val=1;
			mfmSector.word[gap3]=mfmEncode(0x4e);

			if (dataread)
			{
				// HFE cipher mfmSector to track buffer
				int pos=interleave[inter-1][s-1]*724;
				for (int i=0; i<724; i+=2)
				{
					hfe_buffer[t][pos++]=hfe_cipher[mfmSector.byte[i+1]];
					hfe_buffer[t][pos++]=hfe_cipher[mfmSector.byte[i]];
				}
			}
		}

		if (dataread)
		{
			// Gap 4
			unsigned short val=MFM_GAP;
			unsigned char g1=hfe_cipher[(val >> 8) & 0xff];
			unsigned char g2=hfe_cipher[val & 0xff];
			for (int i=16*724; i<12544;)
			{
				hfe_buffer[t][i++]=g1;
				hfe_buffer[t][i++]=g2;
			}
		}
	}

	// write HFE tracks
	for (int t=0; t<80; t++)
	{
		for (int i=0; i<49; i++)
		{
			fwrite(&hfe_buffer[t][i*256], 1, 256, hfe);
			fwrite(&hfe_buffer[t+80][i*256], 1, 256, hfe);
		}
	}
}


void DecipherHFE(FILE *hfe, FILE *ext)
{
	unsigned char buffer[512];
	memset(buffer, 0, sizeof(buffer));

	makeHfeCipher();
	fread(buffer, 1, 512, hfe);
	fwrite(buffer, 1, 512, ext);
	fread(buffer, 1, 512, hfe);
	fwrite(buffer, 1, 512, ext);
	while (fread(buffer, 1, 512, hfe)==512)
	{
		for (int i=0; i<512; i++)
		{
			buffer[i]=hfe_cipher[buffer[i]];
		}

		fwrite(buffer, 1, 512, ext);
	}
}


int main(int argc, char **argv)
{
	if ((argc>=4) && (strcmp(argv[1], "-conv")==0))
	{
		FILE *fd=fopen(argv[2], "rb");
		if (fd==NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
		}
		else
		{
			int inter=7;
			if (argc==5)
			{
				inter=atoi(argv[4]);
			}
			if ((inter>=1) && (inter<=15))
			{
				FILE *hfe=fopen(argv[3], "wb");
				if (hfe==NULL)
				{
					printf("impossible d'ouvrir %s\n", argv[3]);
				}
				else
				{
					FDtoHFE(fd, hfe, inter);
				}
				fclose(hfe);
			}
			fclose(fd);
		}
	}
	else if ((argc>=4) && (strcmp(argv[1], "-decipher")==0))
	{
		FILE *hfe=fopen(argv[2], "rb");
		if (hfe==NULL)
		{
			printf("impossible d'ouvrir %s\n", argv[2]);
		}
		else
		{
			int inter=7;
			if (argc==5)
			{
				inter=atoi(argv[4]);
			}
			if ((inter>=1) && (inter<=15))
			{
				FILE *ext=fopen(argv[3], "wb");
				if (ext==NULL)
				{
					printf("impossible d'ouvrir %s\n", argv[3]);
				}
				else
				{
					DecipherHFE(hfe, ext);
				}
				fclose(ext);
			}
			fclose(hfe);
		}
	}
	else
	{
		printf("Usage : %s -conv disk.fd disk.hfe 2", argv[0]);
	}
}

; =============================================================================
; EVIL DUNGEONS II - DUNGEON CRAWLER POUR MO5 - PARTIE JEU
; Par Christophe PETIT
;
; Ce fichier contient la partie jeu d'Evil Dungeon 2. Les scripts ED2PACKx.vbs
; se chargent de la compilation et de la génération des binaires des packs dans 
; l'une des configurations ci-dessous.
;
; 1 - PACK1 pour la tour 1 (tour OUEST) : 
;     - Inclus INIT1.ASM et PACKE1.asm
;     - Génère les binaires INIT1.BIN, ED2NOPACK.BIN et PACKE1.BIN
; 2 - PACK2 pour la tour 2 (tour EST) :
;     - Inclus INIT2.ASM et PACKE2.asm
;     - Génère les binaires INIT2.BIN, ED2NOPACK.BIN et PACKE2.BIN
; 3 - PACK3 pour le niveau du portail :
;     - Inclus INIT3.ASM et PACKE3.asm
;     - Génère les binaires INIT3.BIN, ED2NOPACK.BIN et PACKE3.BIN
;
; A noter que dans tous les cas, le même binaire ED2NOPACK.BIN est généré. Il
; s'agit du tronc commun du jeu, sans pack. ED2.BIN est la concaténation de
; ED2NOPACK.BIN (tronc commun sans pack), INIT1.BIN (initialisation de la tour
; 1), PACKE1.BIN (pack d'ennemis de la tour 1) et PACKM1.BIN (pack de maps de
; la tour 1 généré par macro EXCEL). C'est le make.bat qui se charge de cette
; concaténation de ED2.BIN, pour la génération de l'image disque ED2.fd.
; =============================================================================

; Adaptation TO7-70/9/8/8D/9+ par OlivierP-To8

;******************************************************************************
;*                            CONSTANTES GENERALES                            *
;******************************************************************************

; Contrôleur de disque
DKOPC   	EQU $6048   ; Commande du contrôleur de disque
DKDRV   	EQU $6049   ; Numéro du disque (0 à 3)
DKTRK   	EQU $604B   ; Numéro de piste (0 à 39 ou 79)
DKSEC   	EQU $604C   ; Numéro de secteur (1 à 16)
DKSTA   	EQU $604E   ; Etat du contrôleur de disquettes
DKBUF   	EQU $604F   ; Pointeur de la zone tampon d'I/O disque (256 octets max)
DKCO    	EQU $E82A   ; Contrôleur de disque

; Buffers.
BUFFER		EQU	$6100	; Buffer général de 1536 octets ($6100 à $66FF).
BUFFERC		EQU	$6100	; Buffer de couleurs de 768 octets ($6100-63FF).
BUFFERF		EQU	$6400	; Buffer de forme de 768 octets ($6400-66FF).

; Init & Packs
MAPADDR		EQU $6100	; Map 1024 octets courante ($6100-$64FF).
INITADR 	EQU $6600	; Adresse d'initialisation
SCROFFSET	EQU $414A	; Offset d'affichage de l'écran de jeu.
SCRMINIMAP	EQU $4727	; Adresse écran de la minimap.
PACKADR 	EQU $C700	; Adresse de chargement des packs d'ennemi.
PACKMAP		EQU $D9C0	; Adresse des packs de map.
PACKSTART	EQU PACKMAP+$063A	; Adresse de fin de pack de map.

; Listes d'appel des éléments de décors et des ennemis ($6500-$66FF)
LISTE1		EQU $6500	; Liste de rétablissement des couleurs (25 appels possibles)
PLISTE1		EQU $654B	; Pointeur sur LISTE1.
LISTE2		EQU $654D	; Liste des murs, fonds, trous et sols 1 (30 appels possibles)
PLISTE2		EQU $65A7	; Pointeur sur LISTE2.
LISTE3		EQU $65A9	; Liste des murs, trous et sols 2 (21 appels possibles)
PLISTE3		EQU $65E8	; Pointeur sur LISTE3.
LISTE4_18	EQU $65EA	; Appel pour les ennemis ou objets en G18
LISTE4_19	EQU $65ED	; Appel pour les ennemis ou objets en G19
LISTE4_21	EQU $65F0	; Appel pour les ennemis ou objets en G21
LISTE4_23	EQU $65F3	; Appel pour les ennemis ou objets en G23
LISTE4_24	EQU $65F6	; Appel pour les ennemis ou objets en G24
LISTE4_09	EQU $65F9	; Appel pour les ennemis ou objets en G09
LISTE4_10	EQU $65FC	; Appel pour les ennemis ou objets en G10
LISTE4_12	EQU $65FF	; Appel pour les ennemis ou objets en G12
LISTE4_14	EQU $6602	; Appel pour les ennemis ou objets en G14
LISTE4_15	EQU $6605	; Appel pour les ennemis ou objets en G15
LISTE4_06	EQU $6608	; Appel pour les ennemis ou objets en G06
LISTE4RTS	EQU $660B	; Cloture de liste
LISTE0		EQU $660C	; Pré-liste de rétablissement des couleurs (25 appels possibles)
PLISTE0		EQU $6657	; Pointeur sur LISTE0.
LISTEA1_HP	EQU $6659	; Nombre de HP de l'attaque de front.
LISTEA1		EQU $665A	; Appel de l'attaque de front ou RTS.
LISTEA2_HP	EQU $665D	; Nombre de HP de l'attaque par la droite.
LISTEA2		EQU $665E	; Appel de l'attaque par la droite ou RTS.
LISTEA3_HP	EQU $6661	; Nombre de HP de l'attaque par derrière.
LISTEA3		EQU $6662	; Appel de l'attaque par derrière ou RTS.
LISTEA4_HP	EQU $6665	; Nombre de HP de l'attaque par la gauche.
LISTEA4		EQU $6666	; Appel de l'attaque par la gauche ou RTS.
LISTE_EN	EQU $6669	; Liste des 50 ennemis max du niveau courant = adresse map + PV.

; Valeurs d'initialisation du jeu.
PILE_S		EQU $60CC	; Adresse de la pile système (= STKEND du moniteur).
ODEPART		EQU 00		; Orientation de départ = Nord.

; Valeurs d'initialisation des timers et synchronisations
TELTIMER	EQU 9		; Timer pour les rotations de couleur des téléporteurs.
ATKDECL		EQU 30		; Tempo de déclenchement des attaques.
ATKTIMER	EQU 160		; Tempo entre les attaques d'ennemis (environ 1.5s).
DPLTIMER	EQU 160		; Tempo entre les déplacements d'ennemis (environ 1.5s).
PLATKTIMER	EQU 55		; Tempo entre les attaques du joueur (environ 0.5s).
POWTIMER	EQU 2354	; Tempo pour l'invulnérabilité et la lévitation (environ 20s).

; Points de mana des sorts (doivent être conformes au livre)
MANA_S0		EQU 10		; Régénération = 10 points de mana
MANA_S1		EQU 10		; Boule de feu = 10 points de mana
MANA_S2		EQU 15		; Boule de givre = 15 points de mana
MANA_S3		EQU 20		; Antimatière = 20 points de mana

; Tables de compression et décompression de maps.
TABCOMP		EQU $5F40	; Table de compression/décompression en mémoire vidéo.

; Sous-routines d'orientation dans la partie cachée de la mémoire vidéo forme.
PAS_NORD	EQU $5FC0	; Mise à jour des pas pour l'orientation Nord.
PAS_EST		EQU $5FD0	; Mise à jour des pas pour l'orientation Est.
PAS_SUD		EQU $5FE0	; Mise à jour des pas pour l'orientation Sud.
PAS_OUEST	EQU $5FF0	; Mise à jour des pas pour l'orientation Ouest.

; Données stoquées en mémoire vidéo forme.
W31_DATA	EQU $4029	; Données du mur W31
W41_DATA	EQU $4051	; Données du mur W41
W32_DATA	EQU $4079	; Données du mur W32
W42_DATA	EQU $40A1	; Données du mur W42
W49_DATA	EQU $40C9	; Données du mur W49
H1_DATA		EQU $4122	; Données du trou H1
H3_DATA		EQU $55C2	; Données du trou H3
H5_DATA		EQU $5EF1	; Données du trou H5
H11_DATA	EQU $400A	; Données du trou H11
H12_DATA_PIX EQU $5F25	; Données du trou H12PIX
H14_DATA	EQU $5591	; Données du trou H14
H16_DATA	EQU $4489	; Données du trou H16
H17_DATA	EQU $44B1	; Données du trou H17
H19_DATA	EQU $44D9	; Données du trou H19
H21_DATA_PIX EQU $5541	; Données du trou H21PIX
H23_DATA	EQU $55B9	; Données du trou H23
H24_DATA	EQU $5609	; Données du trou H24
H25_DATA	EQU $4529	; Données du trou H25
H26_DATA	EQU $4579	; Données du trou H26
CH5_DATA	EQU $55EB	; Données du trou CH5
CH7_DATA	EQU $40FB	; Données du trou CH7
CH11_DATA	EQU $5659	; Données du trou CH11
CH13_DATA	EQU $5E01	; Données du trou CH13
CH23_DATA	EQU $5621	; Données du trou CH23

; Touches de jeu par défaut.
TOUCHE_HAUT	EQU $0B	; Flèche haute = Avancer.
TOUCHE_BAS	EQU $0A	; Flèche basse = Reculer.
TOUCHE_GAUCHE EQU $08 ; Flèche gauche = Tourner d'un quart de tour à gauche.
TOUCHE_DROITE EQU $09 ; Flèche droite = Tourner d'un quart de tour à droite.
TOUCHE_ESPACE EQU $20 ; Espace = Action / Feu.
TOUCHE_A	EQU $41	; A = Valider message.
TOUCHE_B	EQU $42	; B = Lancer le sort sélectionné.
TOUCHE_C	EQU $43	; C = Pas à gauche.
TOUCHE_V	EQU $56	; V = Pas à droite.
TOUCHE_M	EQU $4D	; M = Affichage de la map.
TOUCHE_Q	EQU $51	; Q = Quitter.
TOUCHE_E	EQU $45	; E = Arme précédente.
TOUCHE_R	EQU $52	; E = Arme suivante.
TOUCHE_D	EQU $44	; D = Sort précédent.
TOUCHE_F	EQU $46	; F = Sort suivant.
TOUCHE_1	EQU $31	; 1 = Utilisation de l'objet 1.
TOUCHE_2	EQU $32	; 2 = Utilisation de l'objet 2.
TOUCHE_3	EQU $33	; 3 = Utilisation de l'objet 3.
TOUCHE_4	EQU $34	; 4 = Utilisation de l'objet 4.
TOUCHE_5	EQU $35	; 5 = Utilisation de l'objet 5.

; Codes des notes de musique
P		EQU	0	; Pause (silence)
DO		EQU	1	; DO
DOD		EQU	2	; DO#
RE		EQU	3	; RE
RED		EQU	4	; RE#
MI		EQU	5	; MI
FA		EQU	6	; FA
FAD		EQU	7	; FA#
SO		EQU	8	; SOL
SOD		EQU	9	; SOL#
LA		EQU	10	; LA
LAD		EQU	11	; LA#
SI		EQU	12	; SI

; Codes des octaves Ox
O1		EQU	13	; Octave 1
O2		EQU	14	; Octave 2
O3		EQU	15	; Octave 3
O4		EQU	16	; Octave 4
O5		EQU	17	; Octave 5

; Codes de durée des notes Lx
L1		EQU	18	; L1 (pour les sons très courts)
L2		EQU	19	; L2 = triple croche dans un triolet
L3		EQU	20	; L3 = triple croche
L4		EQU	21	; L4 = double croche dans un triolet
L5		EQU	22	; L5 = triple croche pointée
L6		EQU	23	; L6 = double croche
L8		EQU	24	; L8 = croche dans un triolet
L9		EQU	25	; L9 = double croche pointée
L12		EQU	26	; L12 = croche
L16		EQU	27	; L16 = noire dans un triolet
L18		EQU	28	; L18 = croche pointée
L24		EQU	29	; L24 = noire
L36		EQU	30	; L36 = noire pointée
L48		EQU	31	; L48 = blanche
L72		EQU	32	; L72 = blanche pointée
L96		EQU	33	; L96 = ronde

; Codes des attaque de notes Ax, limités à 110.
A0		EQU	34
A1		EQU	35
A2		EQU	36
A3		EQU	37
A4		EQU	38
A5		EQU	39
A6		EQU	40
A7		EQU	41
A8		EQU	42
A9		EQU	43
A10		EQU	44
A12		EQU	46
A13		EQU	47
A14		EQU	48
A15		EQU	49
A16		EQU	50
A17		EQU	51
A18		EQU	52
A19		EQU	53
A20		EQU	54
A21		EQU	55
A22		EQU	56
A23		EQU	57
A24		EQU	58
A25		EQU	59
A26		EQU	60
A27		EQU	61
A28		EQU	62
A29		EQU	63
A30		EQU	64
A31		EQU	65
A32		EQU	66
A33		EQU	67
A34		EQU	68
A35		EQU	69
A36		EQU	70
A37		EQU	71
A38		EQU	72
A39		EQU	73
A40		EQU	74
A41		EQU	75
A42		EQU	76
A43		EQU	77
A44		EQU	78
A45		EQU	79
A46		EQU	80
A47		EQU	81
A48		EQU	82
A49		EQU	83
A50		EQU	84
A51		EQU	85
A52		EQU	86
A53		EQU	87
A54		EQU	88
A55		EQU	89
A56		EQU	90
A57		EQU	91
A58		EQU	92
A59		EQU	93
A60		EQU	94
A61		EQU	95
A62		EQU	96
A63		EQU	97
A64		EQU	98
A65		EQU	99
A66		EQU	100
A67		EQU	101
A68		EQU	102
A69		EQU	103
A70		EQU	104
A71		EQU	105
A72		EQU	106
A73		EQU	107
A74		EQU	108
A75		EQU	109
A76		EQU	110
A77		EQU	111
A78		EQU	112
A79		EQU	113
A80		EQU	114
A81		EQU	115
A82		EQU	116
A83		EQU	117
A84		EQU	118
A85		EQU	119
A86		EQU	120
A87		EQU	121
A88		EQU	122
A89		EQU	123
A90		EQU	124
A91		EQU	125
A92		EQU	126
A93		EQU	127
A94		EQU	128
A95		EQU	129
A96		EQU	130
A97		EQU	131
A98		EQU	132
A99		EQU	133
A100	EQU	134
A101	EQU	135
A102	EQU	136
A103	EQU	137
A104	EQU	138
A105	EQU	139
A106	EQU	140
A107	EQU	141
A108	EQU	142
A109	EQU	143
A110	EQU	144

; Codes de tempo Tx, limités à 110.
T1		EQU	145
T2		EQU	146
T3		EQU	147
T4		EQU	148
T5		EQU	149
T6		EQU	150
T7		EQU	151
T8		EQU	152
T9		EQU	153
T10		EQU	154
T11		EQU	155
T12		EQU	156
T13		EQU	157
T14		EQU	158
T15		EQU	159
T16		EQU	160
T17		EQU	161
T18		EQU	162
T19		EQU	163
T20		EQU	164
T21		EQU	165
T22		EQU	166
T23		EQU	167
T24		EQU	168
T25		EQU	169
T26		EQU	170
T27		EQU	171
T28		EQU	172
T29		EQU	173
T30		EQU	174
T31		EQU	175
T32		EQU	176
T33		EQU	177
T34		EQU	178
T35		EQU	179
T36		EQU	180
T37		EQU	181
T38		EQU	182
T39		EQU	183
T40		EQU	184
T41		EQU	185
T42		EQU	186
T43		EQU	187
T44		EQU	188
T45		EQU	189
T46		EQU	190
T47		EQU	191
T48		EQU	192
T49		EQU	193
T50		EQU	194
T51		EQU	195
T52		EQU	196
T53		EQU	197
T54		EQU	198
T55		EQU	199
T56		EQU	200
T57		EQU	201
T58		EQU	202
T59		EQU	203
T60		EQU	204
T61		EQU	205
T62		EQU	206
T63		EQU	207
T64		EQU	208
T65		EQU	209
T66		EQU	210
T67		EQU	211
T68		EQU	212
T69		EQU	213
T70		EQU	214
T71		EQU	215
T72		EQU	216
T73		EQU	217
T74		EQU	218
T75		EQU	219
T76		EQU	220
T77		EQU	221
T78		EQU	222
T79		EQU	223
T80		EQU	224
T81		EQU	225
T82		EQU	226
T83		EQU	227
T84		EQU	228
T85		EQU	229
T86		EQU	230
T87		EQU	231
T88		EQU	232
T89		EQU	233
T90		EQU	234
T91		EQU	235
T92		EQU	236
T93		EQU	237
T94		EQU	238
T95		EQU	239
T96		EQU	240
T97		EQU	241
T98		EQU	242
T99		EQU	243
T100	EQU	244
T101	EQU	245
T102	EQU	246
T103	EQU	247
T104	EQU	248
T105	EQU	249
T106	EQU	250
T107	EQU	251
T108	EQU	252
T109	EQU	253
T110	EQU	254

; Caractère de fin de partition.
FIN		EQU	255

	INCLUDE colMO2TO.asm

;******************************************************************************
;* (RE)INITIALISATION DU SYSTEME DE JEU DE LA TOUR COURANTE                   *
;******************************************************************************

	ORG	$6600		; Initialisation à charger entre $6600 et $66FF

	IFEQ INIT-1
		INCLUDE INIT1.asm		; A sélectionner pour la compilation du pack 1.
	ENDC
	IFEQ INIT-2
		INCLUDE INIT2.asm		; A sélectionner pour la compilation du pack 2.
	ENDC
	IFEQ INIT-3
		INCLUDE INIT3.asm		; A sélectionner pour la compilation du pack 2.
	ENDC

;******************************************************************************
;*             VARIABLES ET DONNEES GLOBALES PROTEGEES EN $6700               *
;*                                                                            *
;* Ces variables et données sont utilisables par les packs compilés. Elles ne *
;* Elles ne sont pas écrasées par le buffer en $6100.                         *
;******************************************************************************

; Données des points des armes et des sorts du joueur.
PA_W0		FCB 02		; Epée (=10 pour la tronçonneuse, =20 pour le creuset)
PA_W1		FCB 01		; Arbalète légère
PA_W2		FCB 03		; Arbalète lourde
PA_W3		FCB 05		; Revolver 9mm
PA_W4		FCB 15		; Pistolet mitrailleur 9mm
PA_W5		FCB 20		; Pistolet plasma
PA_W6		FCB 60		; Fusil d'assaut plasma
PA_S0		FCB 40		; Sort de régénération
PA_S1		FCB 10		; Sort de boule de feu
PA_S2		FCB 20		; Sort de boule de givre
PA_S3		FCB 50		; Sort d'antimatière

; Variables globales à usage général.
VARDB1		FCB $00		; Variable 8 bits d'utilisation générale 1
VARDB2		FCB $00		; Variable 8 bits d'utilisation générale 2
VARDB3		FCB $00		; Variable 8 bits d'utilisation générale 3
VARDB4		FCB $00		; Variable 8 bits d'utilisation générale 4
VARDB5		FCB $00		; Variable 8 bits d'utilisation générale 5
VARDB6		FCB $00		; Variable 8 bits d'utilisation générale 6
VARDB7		FCB $00		; Variable 8 bits d'utilisation générale 7
VARDB8		FCB $00		; Variable 8 bits d'utilisation générale 8

VARDW1		FDB $0000	; Variable 16 bits d'utilisation générale 1
VARDW2		FDB $0000	; Variable 16 bits d'utilisation générale 2
VARDW3		FDB $0000	; Variable 16 bits d'utilisation générale 3
VARDW4		FDB $0000	; Variable 16 bits d'utilisation générale 4
VARDW5		FDB $0000	; Variable 16 bits d'utilisation générale 5
VARDW6		FDB $0000	; Variable 16 bits d'utilisation générale 6
VARDW7		FDB $0000	; Variable 16 bits d'utilisation générale 7
VARDW8		FDB $0000	; Variable 16 bits d'utilisation générale 8

; Données de jeu et du joueur (mêmes variables que dans INIT.asm)
STATEF		FCB $00		; Etats de jeu.
FMINIMAP	FCB	$01		; 0 = pas d'affichage de la minimap. 1 = affichage.
PACKNUM		FCB $00		; Numéro de pack de map (commence à 0).
MAPNUM		FCB $00		; Numéro de map (Niveau 1 = map n°0, montée = +1).
SQRADDR		FDB $64D0	; Adresse de la case courante dans la map.
ORIENT		FCB $00		; Orientation
						; 00 ($00) - Nord
						; 16 ($10) - Est
						; 32 ($20) - Sud
						; 48 ($30) - Ouest
MAPCOUL1 	FCB c87 	; Couleurs sol/mur de map primaires.
MAPCOUL21	FCB c04		; Couleurs sol/mur de map secondaires, niveau 1.
MAPCOUL22	FCB c04		; Couleurs sol/mur de map secondaires, niveau 2.
MAPCOUL23	FCB c04		; Couleurs sol/mur de map secondaires, niveau 3.
MAPCOUL24	FCB c04		; Couleurs sol/mur de map secondaires, niveau 4.
MAPCOULC	FCB c87		; Couleurs sol/mur de map courantes.
VARPL_PV	FCB 40		; 40 Points de vie
VARPL_BOUC	FCB 40		; 40 Points de bouclier
VARPL_MANA	FCB 40		; 40 Points de mana
SCORE_E1	FCB 0		; Nombre d'ennemis tués pour le score.
SCORE_S1	FCB 0		; Nombre de secrets trouvés pour le score.
SCORE_I1	FCB 0		; Nombre d'items ramassés pour le score.
SCORE_O1	FCB 0		; Nombre d'ornements détruits pour le score.
INVW_COUR	FCB $00		; N° d'arme courante (0-6)
INVS_COUR	FCB $00		; N° de sort courant (0-3)
INVW_OBJ1	FCB $00		; Quantité d'objet 1 (invulnérabilité) = 0-9
INVW_OBJ2	FCB $00		; Quantité d'objet 2 (lévitation) = 0-9
INVW_OBJ3	FCB $00		; Quantité d'objet 3 (potion de vie) = 0-9
INVW_OBJ4	FCB $00		; Quantité d'objet 4 (bouclier) = 0-9
INVW_OBJ5	FCB $00		; Quantité d'objet 5 (potion de mana) = 0-9
INVW_MUN1	FCB 0		; Niveau de munition 1 (carreaux) = 00-99
INVW_MUN2	FCB 0		; Niveau de munition 2 (cartouches 9mm) = 00-99
INVW_MUN3	FCB 0		; Niveau de munition 3 (charges plasma) = 00-99
INVW_0		FCB 1		; Acquisition épée (0 = non acquis, 1 = acquis).
INVW_1		FCB 0		; Acquisition arbalette légère (0 = non acquis, 1 = acquis).
INVW_2		FCB 0		; Acquisition arbalette lourde (0 = non acquis, 1 = acquis).
INVW_3		FCB 0		; Acquisition revolver (0 = non acquis, 1 = acquis).
INVW_4		FCB 0		; Acquisition pistolet mitrailleur (0 = non acquis, 1 = acquis).
INVW_5		FCB 0		; Acquisition pistolet plasma (0 = non acquis, 1 = acquis).
INVW_6		FCB 0		; Acquisition fusil plasma (0 = non acquis, 1 = acquis).
INVK1		FCB 0		; Acquisition de la clé jaune (0 = non acquise, 1 = acquise).
INVK2		FCB 0		; Acquisition de la clé bleue (0 = non acquise, 1 = acquise).
INVK3		FCB 0		; Acquisition de la clé rouge (0 = non acquise, 1 = acquise).
INVS0		FCB 1		; Acquisition du sort 0 = régénération (0 = non acquis, 1 = acquis).
INVS1		FCB 0		; Acquisition du sort 1 = boule de feu (0 = non acquis, 1 = acquis).
INVS2		FCB 0		; Acquisition du sort 2 = éclair (0 = non acquis, 1 = acquis).
INVS3		FCB 0		; Acquisition du sort 3 = antimatière (0 = non acquis, 1 = acquis).

; Timers et synchronisations (initialisées dans le jeu)
ATKPL_TYPE	FCB $00		; Type d'attaque du joueur. 0 = arme, 1 = sort.
ATKPL_TEMP	FCB $00		; Temps de récupération entre deux attaques.
TEMPATK		FCB $00		; Tempo d'attaque d'ennemis.
TEMPDPL		FCB $00		; Tempo de déplacement d'ennemis.
TEMPINV		FDB $0000	; Tempo d'invulnérabilité
TEMPLEVIT	FDB $0000	; Tempo de lévitation

; Autres variables protégées
SCORE_E2	FCB 0		; Nombre d'ennemis à tuer dans la tour courante.
SCORE_S2	FCB 0		; Nombre de secrets à trouver dans la tour courante.
SCORE_I2	FCB 0		; Nombre d'items à ramasser.
SCORE_O2	FCB 0		; Nombre d'ornements à détruire dans la tour courante.
MINIMAP 	FDB $0000	; Adresse de la minimap dans la map courante.
ADDRBLD		FDB $0000	; Adresse d'affichage écran de la tâche de sang.
COULBLD		FCB c17		; Couleurs des tâches de sang (varie selon les monstres).
DETEC_CHEST	FCB $00		; Détection de coffre (variable protégée)
VARBOSS_PV	FCB $00		; Points de vie du boss (préservés des changements de niveau).
CHEAT		FCB 0		; <>0 = invulnérabilité.

;******************************************************************************
;*                              ROUTINES GLOBALES                             *
;*                                                                            *
;* Ces routines sont utilisables par les packs compilés.                      *
;******************************************************************************
; Sélection video couleur avec A
VIDEOC_A:
	LDA	$E7C3
	ANDA #%11111110
	STA	$E7C3
GAME_RTS:
	RTS

; Sélection video couleur avec B
VIDEOC_B:
	LDB	$E7C3
	ANDB #%11111110
	STB	$E7C3
	RTS

; Sélection video forme. A la suite de LBSR VIDEOC_x, préférer INC $E7C3
VIDEOF:
	LDA	$E7C3
	ORA #%00000001
	STA	$E7C3
	RTS

; Routine générique pour l'affichage de sprites 16x16.
; X = Adresse écran du sprite. Y = adresse d'appel pour l'affichage.
BSPRITE16:
	STX >VARDW6
	STY >BSPRITE16A+1 ; Adresse d'appel automodifiée.

	BSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne
	LDY #LISTE1		; Y pointe la liste 1 pour le buffer de fond.
	BSR BSAVE2_16	; 16x2 octets de couleur à mémoriser.

	INC $E7C3		; Sélection vidéo forme
	LEAX -640,X		; X pointe de nouveau le sprite.
	BSR BSAVE2_16	; 16x2 octets de forme à mémoriser.
	LEAX -640,X		; X pointe de nouveau le sprite.

BSPRITE16A:
	JSR GAME_RTS	; Appel automodifiable pour la routine d'affichage

BSPRITE16B:
	BSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne
	LDX >VARDW6		; X pointe le sprite 16x16 à l'écran.
	LDY #LISTE1		; Y pointe la liste 1 pour le buffer de fond.
	LBSR DISPLAY_2YX_16 ; 16x2 octets de couleur à restaurer.

	INC $E7C3		; Sélection vidéo forme
	LEAX -640,X		; X pointe de nouveau le sprite.
	LBRA DISPLAY_2YX_16 ; 16x2 octets de forme à restaurer.

; Routines de sauvegarde de fond de deux octets sur N lignes.
BSAVE2_48:
	BSR BSAVE2_16
BSAVE2_32:
	BSR BSAVE2_8
BSAVE2_24:
	BSR BSAVE2_8
BSAVE2_16:
	BSR BSAVE2_3
BSAVE2_13:
	BSR BSAVE2_5
BSAVE2_8:
	LDA ,X
	STA ,Y+
	LDA 1,X
	STA ,Y+
	ABX
BSAVE2_7:
	LDA ,X
	STA ,Y+
	LDA 1,X
	STA ,Y+
	ABX
BSAVE2_6:
	LDA ,X
	STA ,Y+
	LDA 1,X
	STA ,Y+
	ABX
BSAVE2_5:
	LDA ,X
	STA ,Y+
	LDA 1,X
	STA ,Y+
	ABX
BSAVE2_4:
	LDA ,X
	STA ,Y+
	LDA 1,X
	STA ,Y+
	ABX
BSAVE2_3:
	LDA ,X
	STA ,Y+
	LDA 1,X
	STA ,Y+
	ABX
BSAVE2_2:
	LDA ,X
	STA ,Y+
	LDA 1,X
	STA ,Y+
	ABX
BSAVE2_1:
	LDA ,X
	STA ,Y+
	LDA 1,X
	STA ,Y+
	ABX
	RTS

; Routines de sauvegarde de fond sur N octets sur une ligne.
BSAVEN_20:
	BSR BSAVEN_4
BSAVEN_16:
	BSR BSAVEN_6
BSAVEN_10:
	LDA ,Y+		; 10
	STA ,X+
BSAVEN_9:
	LDA ,Y+		; 9
	STA ,X+
BSAVEN_8:
	LDA ,Y+		; 8
	STA ,X+
BSAVEN_7:
	LDA ,Y+		; 7
	STA ,X+
BSAVEN_6:
	LDA ,Y+		; 6
	STA ,X+
BSAVEN_5:
	LDA ,Y+		; 5
	STA ,X+
BSAVEN_4:
	LDA ,Y+		; 4
	STA ,X+
BSAVEN_3:
	LDA ,Y+		; 3
	STA ,X+
BSAVEN_2:
	LDA ,Y+		; 2
	STA ,X+
BSAVEN_1:
	LDA ,Y+		; 1
	STA ,X+
	RTS

; Affichage A->(X) sur N lignes. 
DISPLAY_A_128:
	BSR DISPLAY_A_64
DISPLAY_A_64:
	BSR DISPLAY_A_16
DISPLAY_A_48:
	BSR DISPLAY_A_16
DISPLAY_A_32:
	BSR DISPLAY_A_8
DISPLAY_A_24:
	STA	,X
	ABX
DISPLAY_A_23:
	STA	,X
	ABX
DISPLAY_A_22:
	STA	,X
	ABX
DISPLAY_A_21:
	STA	,X
	ABX
DISPLAY_A_20:
	STA	,X
	ABX
DISPLAY_A_19:
	STA	,X
	ABX
DISPLAY_A_18:
	STA	,X
	ABX
DISPLAY_A_17:
	STA	,X
	ABX
DISPLAY_A_16:
	STA	,X
	ABX
DISPLAY_A_15:
	STA	,X
	ABX
DISPLAY_A_14:
	STA	,X
	ABX
DISPLAY_A_13:
	STA	,X
	ABX
DISPLAY_A_12:
	STA	,X
	ABX
DISPLAY_A_11:
	STA	,X
	ABX
DISPLAY_A_10:
	STA	,X
	ABX
DISPLAY_A_9:
	STA	,X
	ABX
DISPLAY_A_8:
	STA	,X
	ABX
DISPLAY_A_7:
	STA	,X
	ABX
DISPLAY_A_6:
	STA	,X
	ABX
DISPLAY_A_5:
	STA	,X
	ABX
DISPLAY_A_4:
	STA	,X
	ABX
DISPLAY_A_3:
	STA	,X
	ABX
DISPLAY_A_2:
	STA	,X
	ABX
DISPLAY_A_1:
	STA	,X
	ABX
	RTS

; Affichage $00->(X) + A->(X+1) sur N lignes. 
DISPLAY_0A_16:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_15:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_14:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_13:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_12:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_11:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_10:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_9:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_8:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_7:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_6:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_5:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_4:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_3:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_2:
	CLR	,X
	STA	1,X
	ABX
DISPLAY_0A_1:
	CLR	,X
	STA	1,X
	ABX
	RTS

; Affichage A->(X) + $00->(X+1) sur N lignes. 
DISPLAY_A0_16:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_15:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_14:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_13:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_12:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_11:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_10:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_9:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_8:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_7:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_6:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_5:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_4:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_3:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_2:
	STA	,X
	CLR	1,X
	ABX
DISPLAY_A0_1:
	STA	,X
	CLR	1,X
	ABX
	RTS

; Affichage A->(X) + A->(X+1) sur N lignes. 
DISPLAY_2A_76:
	BSR DISPLAY_2A_12
DISPLAY_2A_64:
	BSR DISPLAY_2A_16
DISPLAY_2A_48:
	BSR DISPLAY_2A_16
DISPLAY_2A_32:
	BSR DISPLAY_2A_16
DISPLAY_2A_16:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_15:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_14:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_13:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_12:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_11:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_10:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_9:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_8:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_7:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_6:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_5:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_4:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_3:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_2:
	STA ,X
	STA 1,X
	ABX
DISPLAY_2A_1:
	STA ,X
	STA 1,X
	ABX
	RTS

; Affichage (Y)->(X) sur N lignes.
DISPLAY_YX_48:
	BSR DISPLAY_YX_16
DISPLAY_YX_32:
	BSR DISPLAY_YX_16
DISPLAY_YX_16:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_15:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_14:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_13:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_12:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_11:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_10:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_9:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_8:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_7:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_6:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_5:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_4:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_3:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_2:
	LDA ,Y+
	STA ,X
	ABX
DISPLAY_YX_1:
	LDA ,Y+
	STA ,X
	ABX
	RTS

; Affichage (Y+)->(X+) + (Y+)->(X+) sur N lignes.
DISPLAY_2YX_48:
	BSR DISPLAY_2YX_16
DISPLAY_2YX_32:
	BSR DISPLAY_2YX_16
DISPLAY_2YX_16:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_15:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_14:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_13:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_12:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_11:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_10:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_9:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_8:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_7:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_6:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_5:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_4:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_3:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_2:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
DISPLAY_2YX_1:
	LDA ,Y+
	STA ,X
	LDA ,Y+
	STA 1,X
	ABX
	RTS

; Mise à jour des drapeaux des éléments de décors masqués par les murs visibles.
MASK_ALL:
	CLR >G2D		; Sol, plafond et trous en G2 marqués comme non affichés
	CLR >H2D
	CLR >CH2D
	CLR >W36D		; W36 marqué comme non affiché.
	LBSR MASK_W36	; Ainsi que tout ce qu'il y a derrière.
	CLR >W2D		; W2 marqué comme non affiché.
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a derrière.
	CLR >W46D		; W46 marqué comme non affiché.
					; Ainsi que tout ce qu'il y a derrière.
MASK_W46:
	CLR >G3D		; Sol, plafond et trous en G3 marqués comme non affichés
	CLR >W3D		; W3 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W3:
	CLR >G8D		; Sol, plafond et trous en G8 marqués comme non affichés
	CLR >W8D		; W8 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W8:
	CLR >G15D		; Sol, plafond et trous en G15 marqués comme non affichés
	CLR >H15D
	CLR >CH15D
	CLR >W16D		; W16 marqué comme non affiché.
	BSR MASK_W16	; Ainsi que tout ce qu'il y a derrière.
	CLR >W41D		; W41 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W41:
	CLR >W17D		; W17 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W17:
	CLR >G26D		; Sol, plafond et trous en G26 marqués comme non affichés
	CLR >W30D		; W30 marqué comme non affiché. Rien derrière.
	CLR >B30D		; B30 marqué comme non affiché.
	CLR >B30DRD
	RTS

;------------------------------------------------------------------------------
MASK_W16:
	CLR >W42D		; W42 marqué comme non affiché.
					; Ainsi que tout ce qu'il y a derrière.
MASK_W42:
	CLR >G25D		; Sol G25 marqués comme non affichés
	CLR >W29D		; W29 marqué comme non affiché. Rien derrière.
	CLR >B29D		; B29 marqué comme non affiché.
	RTS

;------------------------------------------------------------------------------
MASK_W47:
	CLR >G7D		; Sol, plafond et trous en G7 marqués comme non affichés
	CLR >W7D		; W7 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W7:
	CLR >G14D		; Sol, plafond et trous en G14 marqués comme non affichés
	CLR >H14D
	CLR >CH14D
MASK_W7B:
	CLR >W15D		; W15 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W15:
	CLR >W27D		; W27 marqué comme non affiché. Rien derrière.
	CLR >B27D		; B27 marqué comme non affiché.
	CLR >B27DRD
MASK_W15B:
	CLR >W43D		; W43 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W43:
	CLR >W28D		; W28 marqué comme non affiché. Rien derrière.
	CLR >B28D		; B28 marqué comme non affiché.
MASK_W43B:
	CLR >G24D		; Sol, plafond et trous en G24 marqués comme non affichés
	RTS

;------------------------------------------------------------------------------
MASK_W48:
	CLR >G13D		; Sol, plafond et trous en G13 marqués comme non affichés
	CLR >W14D		; W14 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W14:
	CLR >G23D		; Sol, plafond et trous en G23 marqués comme non affichés
MASK_W14B:
	CLR >W26D		; W26 marqué comme non affiché. Rien derrière.
	CLR >B26D		; B26 marqué comme non affiché.
	RTS

;------------------------------------------------------------------------------
MASK_W49:
	CLR >G22D		; Sol, plafond et trous en G22 marqués comme non affichés
	CLR >W25D		; W25 marqué comme non affiché. Rien derrière.
	CLR >B25D		; B25 marqué comme non affiché.
	RTS

;------------------------------------------------------------------------------
MASK_W2:
	CLR >W37D		; W37 marqué comme non affiché.
	LBSR MASK_W37	; Ainsi que tout ce qu'il y a derrière.
	CLR >G6D		; Sol, plafond et trous en G6 marqués comme non affichés
	CLR >H6D
	CLR >CH6D
	CLR >W47D		; W47 marqué comme non affiché.
	LBSR MASK_W47	; Ainsi que tout ce qu'il y a derrière.
	CLR >W6D		; W6 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W6:
	CLR >W38D		; W38 marqué comme non affiché.
	BSR MASK_W38	; Ainsi que tout ce qu'il y a derrière.
	CLR >W48D		; W48 marqué comme non affiché.
	BSR MASK_W48	; Ainsi que tout ce qu'il y a derrière.
MASK_W6B:
	CLR >G12D		; Sol, plafond et trous en G12 marqués comme non affichés
	CLR >H12D
	CLR >CH12D
	CLR >W13D		; W13 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W13:
	CLR >W39D		; W39 marqué comme non affiché.
	BSR MASK_W39	; Ainsi que tout ce qu'il y a derrière.
MASK_W13A:
	CLR >W49D		; W49 marqué comme non affiché.
	BSR MASK_W49	; Ainsi que tout ce qu'il y a derrière.
MASK_W13B:
	CLR >G21D		; Sol, plafond et trous en G21 marqués comme non affichés
	CLR >H21D
	CLR >CH21D
MASK_W13C:
	CLR >W24D		; W24 marqué comme non affiché. Rien derrière.
MASK_W13D:
	CLR >B24D		; B24 marqué comme non affiché.
	CLR >B24GAD
	CLR >B24DRD
	CLR >B24GDD
	RTS

;------------------------------------------------------------------------------
MASK_W39:
	CLR >G20D		; Sol, plafond et trous en G20 marqués comme non affichés
	CLR >W23D		; W23 marqué comme non affiché. Rien derrière.
	CLR >B23D		; B23 marqué comme non affiché.
	RTS

;------------------------------------------------------------------------------
MASK_W38:
	CLR >G11D		; Sol, plafond et trous en G11 marqués comme non affichés
	CLR >W12D		; W12 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W12:
	CLR >G19D		; Sol, plafond et trous en G19 marqués comme non affichés
MASK_W12B:
	CLR >W22D		; W22 marqué comme non affiché. Rien derrière.
	CLR >B22D		; B22 marqué comme non affiché.
	RTS

;------------------------------------------------------------------------------
MASK_W37:
	CLR >G5D		; Sol, plafond et trous en G5 marqués comme non affichés
	CLR >W5D		; W5 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W5:
	CLR >G10D		; Sol, plafond et trous en G10 marqués comme non affichés
	CLR >H10D
	CLR >CH10D
	CLR >W11D		; W11 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W11:
	CLR >W21D		; W21 marqué comme non affiché. Rien derrière.
	CLR >B21D		; B21 marqué comme non affiché.
	CLR >B21GAD
MASK_W11B:
	CLR >W33D		; W33 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W33:
	CLR >W20D		; W20 marqué comme non affiché. Rien derrière.
	CLR >B20D		; B20 marqué comme non affiché.
MASK_W33B:
	CLR >G18D		; Sol, plafond et trous en G18 marqués comme non affichés
	RTS

;------------------------------------------------------------------------------
MASK_W36:
	CLR >G1D		; Sol, plafond et trous en G1 marqués comme non affichés
	CLR >W1D		; W1 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W1:
	CLR >G4D		; Sol, plafond et trous en G4 marqués comme non affichés
	CLR >W4D		; W4 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W4:
	CLR >G9D		; Sol, plafond et trous en G9 marqués comme non affichés
	CLR >H9D
	CLR >CH9D
	CLR >W31D		; W31 marqué comme non affiché.
	BSR MASK_W31	; Ainsi que tout ce qu'il y a derrière.
MASK_W4B:
	CLR >W10D		; W10 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W10:
	CLR >W32D		; W32 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W32:
	CLR >G17D		; Sol, plafond et trous en G17 marqués comme non affichés
	CLR >W19D		; W19 marqué comme non affiché.	Rien derrière.
	CLR >B19D		; B19 marqué comme non affiché.
	RTS

;------------------------------------------------------------------------------
MASK_W31:
	CLR >W9D		; W9 marqué comme non affiché et tout ce qu'il y a derrière.

MASK_W9:
	CLR >G16D		; Sol, plafond et trous en G16 marqués comme non affichés
	CLR >W18D		; W18 marqué comme non affiché. Rien derrière.
	CLR >B18D		; B18 marqué comme non affiché.
	CLR >B18GAD
	RTS

;******************************************************************************
;******************************************************************************
;*                              PROGRAMME PRINCIPAL                           *
;******************************************************************************
;******************************************************************************
DONJON:
	LBSR MAPDECOMP	; Décompression de la map courante.
	LBSR DLISTE_EN	; Mise à jour de la liste des ennemis de la map.

DONJON0:
	LBSR FEN_COUL	; Initialisation des couleurs sol/mur de la fenêtre de jeu.

DONJON1:
	LBSR MASK_ALL	; Initialisation de tous les drapeaux.
	LDA #$39		; A = code machine de l'opérande RTS.
	STA >LISTE0		; LISTE0 initialisée avec un RTS (aucun pré-affichage).

DONJON2:
	LBSR MAJ_PAS	; Mise à jour des routines de pas.

DONJON3:
	LBSR SET00		; Affichage des décors.

DONJON_TOUCHE:
	LBSR CLAVIER		; Lecture clavier.              
	TSTB
	LBNE DONJON_TOUCHE1 ; Touche active => DONJON_TOUCHE1. Sinon gestion des états.

; Gestion des tempos et des états de jeu.
; 76543210 STATEF
; ||||||++-- %00 = Pas d'état = analyse des mouvements.
; ||||||     %01 = Téléporteur visible en secteur G4.
; ||||||     %10 = Téléporteur visible en secteur G6.
; ||||||     %11 = Téléporteur visible en secteur G8.
; |||||+----  %1 = Attaque en cours.
; ||||+-----  %1 = inutilisé.
; |||+------  %1 = inutilisé.
; ||+-------  %1 = inutilisé.
; |+--------  %1 = inutilisé.
; +---------  %1 = inutilisé.
SET_STATE:
	LDA >ATKPL_TEMP	; A = Tempo d'attaque du joueur
	BEQ SET_STATE_1	; Tempo = 0 => SET_STATE_1
	DEC >ATKPL_TEMP	; Sinon tempo - 1

SET_STATE_1:
	LDX >TEMPINV	; X = Tempo d'invulnérabilité du joueur
	BEQ SET_STATE_2	; Tempo = 0 => SET_STATE_2

	LEAX -1,X		; Tempo - 1
	STX >TEMPINV
	BNE SET_STATE_2	; Tempo <> 0 => SET_STATE_2

	BSR SET_STATE_INV ; Effacement de l'icône d'invulnérabilité.

SET_STATE_2:
	LDX >TEMPLEVIT	; D = Tempo de lévitation du joueur
	BEQ SET_STATE_3	; Tempo = 0 => SET_STATE_3

	LEAX -1,X		; Tempo - 1
	STX >TEMPLEVIT
	BNE SET_STATE_3	; Tempo <> 0 => SET_STATE_3

	BSR SET_STATE_LEV ; Effacement de l'icône de lévitation.

	LDX >SQRADDR	; X = adresse de la case courante
	LDA ,X			; A = code de la case courante
	ANDA #%01110000	; A = type de la case
	CMPA #%01010000	; Case = trou dans le sol?
	LBEQ DONJON_TEST_TROU0 ; Oui = chute dans le trou => DONJON_TEST_TROU0

SET_STATE_3:
	LDA >STATEF		; A = Flags d'état.
	BNE SET_STATE_4 ; Etats en cours => SET_STATE_4

	LBSR SET_STATE_M ; Sinon gestion des mouvements des ennemis.
	BRA DONJON_TOUCHE ; Retour à l'attente d'une touche.

SET_STATE_4:
	CMPA #%00000100	; Attaques en cours?
	BEQ SET_STATE_5	; Oui => SET_STATE_5
	BCC DONJON_TOUCHE ; Non, état non géré => DONJON_TOUCHE. Sinon téléporteur

	BSR SET_STATE_TEL ; Gestion des téléporteurs
	BRA DONJON_TOUCHE ; Retour à l'attente d'une touche.

; Effacement des icônes d'invulnérabilité et de lévitation.
; Routines réutilisées par les diverses compensations de tempo.
SET_STATE_INV:
	LDX #$5618		; X pointe l'icône d'invulnérabilité
	BRA SET_STATE_LEV2

SET_STATE_LEV:
	LDX #$561F		; X pointe l'icône de lévitation
SET_STATE_LEV2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDD #c0028		; A = noir sur fond noir. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_2A_13 ; Effacement de l'icône.
	INC $E7C3		; Sélection vidéo forme.
	RTS

SET_STATE_5:
	BSR SET_STATE_ATK ; Gestion des attaques => SET_STATE_ATK
	LDA >VARPL_PV	; A = nombre de points de vie du joueur
	BNE DONJON_TOUCHE ; A <> 0 => DONJON_TOUCHE. Sinon perso mort.

; Mort du perso
SET_STATE_DEATH:
	LDA >CHEAT		; Triche d'invulnérabilité activée?
	BNE DONJON_TOUCHE ; Oui => DONJON_TOUCHE.

	LBSR FEN_NOIR	; Remplissage de la fenêtre en noir.
	LDX #SCROFFSET+$0640 ; X pointe l'écran pour un message.
	LDU #MESSAGEMJ	; U pointe le message de mort.
	LBSR PRINTM		; Affichage du message + demande d'appui sur A

	LDA >PACKNUM	; A = n° de pack
	LBSR PACK_LOAD	; Rechargement de la tour courante
	LBRA INITADR	; => Initialisation

; Téléporteurs
SET_STATE_TEL:
	CMPA #%00000010	; TEL06?
	LBEQ TEL06_ROT	; Oui => TEL06_ROT.
	LBCS TEL04_ROT	; Non, T04 => TEL04_ROT
	LBRA TEL08_ROT	; Sinon T08 => TEL08_ROT (T04+T08 non autorisé)

; Attaque en cours
SET_STATE_ATK:
	LDA >TEMPATK	; A = tempo d'attaque.
	BEQ SET_STATE_ATK1 ; Si tempo = 0 => attaque
	DECA			; Sinon tempo - 1.
	STA >TEMPATK
	RTS

; Attaque frontale
SET_STATE_ATK1:
	LDA >LISTEA1_HP	; LISTEA1_HP = 0?
	BEQ SET_STATE_ATK2 ; Oui => SET_STATE_ATK2

	LBSR LISTEA1	; Appel de l'attaque de front en LISTEA1
	LDA >LISTEA1_HP
	STA >VARDB1
	BSR SET_STATE_HIT0 ; Gestion des dégats

; Attaque latérale droite
SET_STATE_ATK2:
	LDA >LISTEA2_HP	; LISTEA2_HP = 0?
	BEQ SET_STATE_ATK3 ; Oui => SET_STATE_ATK3

	LDX #SCROFFSET+$085A ; X pointe la tâche de sang à droite de l'écran.
	LDY #LISTEA2	; Y pointe l'attaque lattérale droite en LISTEA2
	BSR SET_STATE_HIT ; Gestion des dégats

; Attaque dorsale
SET_STATE_ATK3:
	LDA >LISTEA3_HP	; LISTEA3_HP = 0?
	BEQ SET_STATE_ATK4 ; Oui => SET_STATE_ATK4

	LDX #SCROFFSET+$1201 ; X pointe le symbole en bas de l'écran.
	LDY #LISTEA3	; Y pointe l'attaque par derrière en LISTEA4
	BSR SET_STATE_HIT ; Gestion des dégats

; Attaque latérale gauche
SET_STATE_ATK4:
	LDA >LISTEA4_HP	; LISTEA4_HP = 0?
	BEQ SET_STATE_ATK5 ; Oui => SET_STATE_ATK5

	LDX #SCROFFSET+$0848 ; X pointe le symbole à gauche de l'écran.
	LDY #LISTEA4	; Y pointe l'attaque lattérale gauche en LISTEA4
	BSR SET_STATE_HIT ; Gestion des dégats

SET_STATE_ATK5:
	LDA #ATKTIMER
	STA >TEMPATK	; Réinitialisation de la tempo.
	RTS

; Gestion des dégats. A = PA des ennemis ou dégats.
SET_STATE_HIT:
	STA >VARDB1
	LDA #c17		; A = rouge sur fond blanc.
	STA >VARDB8
	LBSR BLOOD06_2	; Affichage de la tâche de sang à l'écran.

SET_STATE_HIT0:
	LDX >TEMPINV	; Invulnérabilité temporaire en cours?
	BEQ SET_STATE_HIT1 ; Non => SET_STATE_HIT1
	CLR >VARDB1		; Oui = 0 dégats.

SET_STATE_HIT1:
	LDA >VARPL_BOUC	; Bouclier > 0?
	BNE SET_STATE_HIT3 ; Oui => SET_STATE_HIT3

	LDA >VARPL_PV	; A = PV du joueur
	SUBA >VARDB1	; A = PV - points d'attaque
	BCC SET_STATE_HIT2 ; A >= 0 => SET_STATE_HIT2
	CLRA			; Sinon PV = 0

SET_STATE_HIT2:
	STA >VARPL_PV	; Mémorisation des nouveaux PV
	LBRA AFF_BAR	; Actualisation des barres d'énergie + RTS

SET_STATE_HIT3:
	SUBA >VARDB1	; A = Bouclier - points d'attaque
	BCC SET_STATE_HIT5 ; A >= 0 => SET_STATE_HIT5.

	ADDA >VARPL_PV	; A = dégats non absorbés (nombre négatif) + PV
	BPL SET_STATE_HIT4 ; Si A positif => SET_STATE_HIT4
	CLRA			; Sinon PV = 0

SET_STATE_HIT4:
	STA >VARPL_PV	; Mémorisation des nouveaux PV
	CLR >VARPL_BOUC	; Bouclier = 0
	LBRA AFF_BAR	; Actualisation des barres d'énergie + RTS

SET_STATE_HIT5:
	STA >VARPL_BOUC	; Mémorisation des nouveaux points de bouclier
	LBRA AFF_BAR	; Actualisation des barres d'énergie + RTS

; Gestion des mouvements ennemis. 
SET_STATE_M:
	LDA >TEMPDPL	; A = Tempo de déplacement d'ennemis.
	BEQ SET_STATE_M2 ; Si tempo = 0 => mouvement
	DECA			; Sinon tempo - 1.
	STA >TEMPDPL
SET_STATE_M1:
	RTS

SET_STATE_M2:
	LDA #DPLTIMER
	STA >TEMPDPL	; Réinitialisation de la tempo.
	LDA #ATKDECL
	STA >TEMPATK	; Tempo de répétition des attaques = tempo de déclenchement.

	LBSR DEPLEN		; Déplacement des ennemis dans la zone de la minimap
	LDA >VARDB4		; Mouvement détecté?
	BEQ SET_STATE_M1 ; Non = pas de réaffichage => SET_STATE_M1

	LDX >SQRADDR	; X pointe la case courante
	LDA ,X			; A = code de la case.
	ANDA #%01110000	; A = type de case
	CMPA #%00100000	; Echelle?
	BEQ SET_STATE_M1 ; Oui = pas de réaffichage => SET_STATE_M1

	LBSR PAS_AV		; X pointe la case juste devant.
	LDA ,X			; A = code de la case.
	ANDA #%01110000	; A = type de case
	CMPA #%00100000	; Echelle?
	BEQ SET_STATE_M1 ; Oui = pas de réaffichage => SET_STATE_M1
	LBCS SET00_NMAP ; Non, sol %000 ou %001 = réaffichage des décors

	CMPA #%01000000	; Sol %100?
	BEQ SET_STATE_M3 ; Oui => SET_STATE_M3
	BCS SET_STATE_M1 ; Non, téléporteur = pas de réaffichage => SET_STATE_M1

	CMPA #%01110000	; Obstacle?
	LBCS SET00_NMAP	; Non, trou dans le sol ou dans le plafond = réaffichage des décors

	LDA ,X			; A = code de la case.
	ANDA #%00001111	; A = contenu de la case
	CMPA #%00001000	; Mur simple?
	LBEQ SET00_NMAP	; Oui = réaffichage des décors.
	BCS SET_STATE_M1 ; Non, porte = pas de réaffichage => SET_STATE_M1

	CMPA #%00001011	; Mur escamotable?
	LBEQ SET00_NMAP	; Oui = réaffichage des décors.
	BRA SET_STATE_M1 ; Non, ornement = pas de réaffichage => SET_STATE_M1

SET_STATE_M3:
	LDA ,X			; A = code de la case.
	ANDA #%00001111	; A = contenu de la case
	LBNE SET00_NMAP	; Case occupée par un ennemi = réaffichage des décors.

	LBSR PAS_AV		; X pointe la case encore devant.
	LDA ,X			; A = code de la case.
	ANDA #%01110000	; A = type de case
	CMPA #%00100000	; Echelles?
	LBNE SET00_NMAP	; Non = réaffichage des décors.
	RTS				; Oui = pas de réaffichage

; Identification des touches. Attention, les étiquettes indiquent les touches
; par défaut. Les valeurs sont suceptibles de changer par auto-modification
; de code dans la partie initialisation du jeu.
DONJON_TOUCHE1:
	CMPB #TOUCHE_HAUT ; Touche "Haut"?
	LBEQ DONJON_HAUT ; Oui => DONJON_HAUT

	CMPB #TOUCHE_BAS ; Touche "Bas"?
	LBEQ DONJON_BAS	; Oui => DONJON_BAS

	CMPB #TOUCHE_GAUCHE	; Touche "Gauche"?
	LBEQ DONJON_GAUCHE ; Oui => DONJON_GAUCHE

	CMPB #TOUCHE_DROITE	; Touche "Droite"?
	LBEQ DONJON_DROITE ; Oui => DONJON_DROITE

	CMPB #TOUCHE_ESPACE	; Touche "Barre Espace"?
	LBEQ DONJON_FEU	; Oui => DONJON_FEU

	CMPB #TOUCHE_B	; Touche "B"?
	LBEQ DONJON_B	; Oui => DONJON_B

	CMPB #TOUCHE_C	; Touche "C"?
	LBEQ DONJON_C	; Oui => DONJON_C

	CMPB #TOUCHE_V	; Touche "V"?
	LBEQ DONJON_V	; Oui => DONJON_V

	CMPB #TOUCHE_M	; Touche "M"?
	LBEQ DONJON_M	; Oui => DONJON_M

	CMPB #TOUCHE_Q	; Touche "Q"?
	LBEQ DONJON_Q	; Oui => DONJON_Q

	CMPB #TOUCHE_E	; Touche "E"?
	LBEQ DONJON_E	; Oui => DONJON_E

	CMPB #TOUCHE_R	; Touche "R"?
	LBEQ DONJON_R	; Oui => DONJON_R

	CMPB #TOUCHE_D	; Touche "D"?
	LBEQ DONJON_D	; Oui => DONJON_D

	CMPB #TOUCHE_F	; Touche "F"?
	LBEQ DONJON_F	; Oui => DONJON_F

	CMPB #TOUCHE_1	; Touche "1"?
	LBEQ DONJON_SEL1 ; Oui => DONJON_SEL1

	CMPB #TOUCHE_2	; Touche "2"?
	LBEQ DONJON_SEL2 ; Oui => DONJON_SEL2

	CMPB #TOUCHE_3	; Touche "3"?
	LBEQ DONJON_SEL3 ; Oui => DONJON_SEL3

	CMPB #TOUCHE_4	; Touche "4"?
	LBEQ DONJON_SEL4 ; Oui => DONJON_SEL4

	CMPB #TOUCHE_5	; Touche "5"?
	LBEQ DONJON_SEL5 ; Oui => DONJON_SEL5
	LBRA DONJON_TOUCHE ; Non, rebouclage => DONJON_TOUCHE

; V = Pas à droite
DONJON_V:
	LDX >SQRADDR	; X pointe la case courante.
	LBSR PAS_DR		; Puis la case juste à droite.
	LBRA DONJON_TEST ; Affichage des décors à la nouvelle position, si autorisée.

; C = Pas à gauche
DONJON_C:
	LDX >SQRADDR	; X pointe la case courante.
	LBSR PAS_GA		; Puis la case juste à gauche.
	LBRA DONJON_TEST ; Affichage des décors à la nouvelle position, si autorisée.

; H = Pas en avant
DONJON_HAUT:
	LDX >SQRADDR	; X pointe la case courante.
	LBSR PAS_AV		; Puis la case juste devant.
	LBRA DONJON_TEST ; Affichage des décors à la nouvelle position, si autorisée.

; B = Pas en arrière
DONJON_BAS:
	LDX >SQRADDR	; X pointe la case courante
	LBSR PAS_AR		; Puis la case juste derrière
	LBRA DONJON_TEST ; Affichage des décors à la nouvelle position, si autorisée.

; G = Quart de tour à gauche
DONJON_GAUCHE:
	LDA >ORIENT		; A = Orientation actuelle.
	SUBA #$10		; Rotation à gauche. Ex : $10 (Est) => $00 (Nord).
	BPL DONJON_GAUCHE2 ; Si A >= 0 => DONJON_GAUCHE2.
	LDA #$30		; A = $30 (Ouest) 
DONJON_GAUCHE2:
	STA >ORIENT		; Orientation mise à jour.
	BSR DONJON_GAUCHE_R1 ; Compensation de tempos.
	LBSR BOUSSOLE	; Mise à jour de la boussole.
	LBRA DONJON2 	; Rebouclage avec affichage des décors.

; Compensation de tempos pour les portes, téléporteurs, trous et échelles.
DONJON_GAUCHE_R0:
	LDA #ATKDECL
	STA >TEMPATK	; Tempo de répétition des attaques = tempo de déclenchement.
	LDA #DPLTIMER
	STA >TEMPDPL	; Tempo de déplacement d'ennemis au maximum.

	LDD #220		; Environ 2s de compensation pour l'invulnérabilité et la lévitation.
	PSHS D			; Compensation empilée.
	BRA DONJON_GAUCHE_R3

; Compensation de tempos pour les tirs, rotations et déplacement.
DONJON_GAUCHE_R1:
	LDD #5			; Compensation moyenne.
	PSHS D			; Compensation empilée.
	LDA >TEMPATK	; A = tempo d'attaque
	BEQ DONJON_GAUCHE_R3 ; Si tempo = 0 => DONJON_GAUCHE_R3
	SUBA 1,S		; Sinon tempo - compensation
	BCC DONJON_GAUCHE_R2 ; Si tempo >= 0 => DONJON_GAUCHE_R2
	CLRA			; Sinon tempo = 0

DONJON_GAUCHE_R2:
	STA >TEMPATK	; Tempo d'attaque mise à jour.

DONJON_GAUCHE_R3:
	LDD >TEMPINV	; D = tempo d'invulnérabilité
	BEQ DONJON_GAUCHE_R5 ; Si tempo = 0 => DONJON_GAUCHE_R5
	SUBD ,S			; Sinon tempo - compensation
	BCC DONJON_GAUCHE_R4 ; Si tempo >= 0 => DONJON_GAUCHE_R4

	LBSR SET_STATE_INV ; Effacement de l'icône d'invulnérabilité.
	LDD #0			; Tempo d'invulnérabilité = 0

DONJON_GAUCHE_R4:
	STD >TEMPINV	; Tempo d'invulnérabilité mise à jour.

DONJON_GAUCHE_R5:
	LDD >TEMPLEVIT	; D = tempo de lévitation
	BEQ DONJON_GAUCHE_R7 ; Si tempo = 0 => DONJON_GAUCHE_R7
	SUBD ,S			; Sinon tempo - compensation
	BCC DONJON_GAUCHE_R6 ; Si tempo >= 0 => DONJON_GAUCHE_R6

	LBSR SET_STATE_LEV ; Effacement de l'icône de lévitation.
	LDD #0			; Tempo de lévitation = 0

DONJON_GAUCHE_R6:
	STD >TEMPLEVIT	; Tempo de lévitation mise à jour.

DONJON_GAUCHE_R7:
	PULS D,PC		; Pour libérer la pile.
	;RTS

; D = Quart de tour à droite
DONJON_DROITE:
	LDA >ORIENT		; A = Orientation actuelle.
	ADDA #$10		; Rotation à droite. Ex : $00 (Nord) => $10 (Est).
	CMPA #$40		; A = $40?
	BNE DONJON_GAUCHE2 ; Non => DONJON_GAUCHE2.
	CLRA			; Oui => A = $00 (Nord).
	BRA DONJON_GAUCHE2 

; M = Map du niveau courant
DONJON_M:
	LBSR DMAP		; Lancement de la map.
	LBRA DONJON0 	; Rebouclage avec affichage des décors.

; Test de la case sur laquelle le joueur souhaite se déplacer. Si la case n'est
; pas infranchissable, les décors sont affichés à la nouvelle position.
DONJON_TEST:
	LDA ,X			; A = code de la case pointée par X.
	ANDA #%01110000	; A = type de case.
	CMPA #%01110000	; Type = mur ou obstacle?
	BNE DONJON_TEST1 ; Non => DONJON_TEST1.

	LDA ,X			; A = code de la case pointée par X.
	ANDA #%00001111	; A = contenu de la case.
	CMPA #%00000100	; Case = porte fermée?
	LBCS DONJON_TOUCHE ; Oui => Rebouclage.

	CMPA #%00001000	; Case = mur simple?
	LBEQ DONJON_TOUCHE ; Oui => Rebouclage.
	BCS DONJON_TEST_OK ; Non, porte ouverte => DONJON_TEST_OK.
	LBRA DONJON_TOUCHE ; Non, ornement ou mur déplaçable => Rebouclage.

DONJON_TEST1:
	CMPA #%00100000	; Type = échelle 010?
	BEQ DONJON_TEST_ECH ; Oui => DONJON_TEST_ECH.
	BCS DONJON_TEST_OK ; Non, sol simpe 000 ou 001 => DONJON_TEST_OK.

	CMPA #%00110000	; Type = téléporteur ou destination 011?
	LBEQ DONJON_TEST_TEL ; Oui => DONJON_TEST_TEL. Sinon sol ou trou occupable.

	LDA ,X			; A = code de la case pointée par X.
	ANDA #%00001111	; A = contenu de la case.
	LBNE DONJON_TOUCHE ; Si case occupée par un ennemi => Rebouclage.

	LDA ,X			; A = code de la case pointée par X.
	ANDA #%01110000	; A = type de case.
	CMPA #%01010000	; Type = trou dans le sol 101?
	LBEQ DONJON_TEST_TROU ; Oui => DONJON_TEST_TROU. Sinon déplacement accepté.

; Déplacement accepté
DONJON_TEST_OK:
	STX >SQRADDR	; Adresse de la nouvelle case mémorisée.
	LDY #SON_PAS_D	; Bruit de pas.
	LBSR MUS
	LDD #4			; Pour la compensation de tempos.
	LBSR DONJON_GAUCHE_R1 ; Compensation de tempos.
	LDA #DPLTIMER
	STA >TEMPDPL	; Tempo de déplacement d'ennemis au maximum.
	LBRA DONJON3 	; Rebouclage avec affichage des décors.

; Echelles
DONJON_TEST_ECH:
	STX >SQRADDR	; Adresse de la nouvelle case mémorisée.

DONJON_TEST_ECH1:
	LBSR SET00		; Affichage des décors.

	LDB #50			; Tempo à réajuster
	LBSR TEMPO

	LDX >SQRADDR	; X pointe la case courante.
	LBSR PAS_AV		; X pointe la case devant.
	LDA ,X			; A = code de la case devant.
	ANDA #%01110000	; A = type de la case devant.
	CMPA #%01110000	; Case devant = mur ou obstacle?
	BNE DONJON_TEST_ECHM2 ; Non = échelle visible => DONJON_TEST_ECHM2
	BSR DONJON_ROTD	; Rotation à droite.
	BRA DONJON_TEST_ECH1 ; => Affichage des décors.

; Rotation à droite + mise à jour des routines de pas.
DONJON_ROTD:
	LDA >ORIENT		; A = Orientation actuelle.
	ADDA #$10		; Rotation à droite. Ex : $00 (Nord) => $10 (Est).
	CMPA #$40		; A = $40?
	BNE DONJON_ROTD2 ; Non => DONJON_ROTD2.
	CLRA			; Oui => A = $00 (Nord).

DONJON_ROTD2:
	STA >ORIENT

; Mise à jour des routines de pas.
MAJ_PAS:
	LDB >ORIENT		; B = orientation.
	LDY #PAS_NORD	; Y pointe les routines d'orientation.
	LEAY B,Y		; Y pointe les routines de l'orientation actuelle.
	LDX #PAS_AV		; X pointe les routines de pas à mettre à jour.
	LDB #1
	LBRA DISPLAY_YX_16 ; Recopie de 16 octets.

DONJON_TEST_ECHM2:
	LDB #50			; Tempo à réajuster
	LBSR TEMPO

	LBSR FEN_NOIR	; Remplissage de la fenêtre en noir.
	LBSR MAPCOMP	; Compression et sauvegarde de la map courante.

	LDX >SQRADDR	; X pointe la case courante.
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu.
	BNE DONJON_TEST_ECHM4 ; Echelle montante => DONJON_TEST_ECHM4.

DONJON_TEST_ECHM3:
	DEC >MAPNUM		; Descente = niveau - 1 (pas de sécurité si A = 0).
	BRA DONJON_TEST_ECHM5

DONJON_TEST_ECHM4:
	INC >MAPNUM		; Remontée = niveau + 1 (pas de sécurité si A = 3).

DONJON_TEST_ECHM5:
	LDB #70			; Tempo à réajuster
	LBSR TEMPO
	LBSR DONJON_GAUCHE_R0 ; Compensation de tempo pour l'invulnérabilité et la lévitation.
	LBRA DONJON 	; Rebouclage avec affichage des décors.

; Téléporteurs
DONJON_TEST_TEL:
	LDA ,X			; A = code de la case pointée par X.
	ANDA #%00001111	; A = contenu de la case.
	CMPA #%00001000	; Case = destination de téléporteur?
	LBCC DONJON_TEST_OK ; Oui, => DONJON_TEST_OK.

	STX >SQRADDR	; Adresse de la nouvelle case mémorisée.
	LBSR SET00		; Affichage des décors.

	LDX >SQRADDR	; X pointe la case courante du téléporteur.
	LDA ,X			; A = code de la case du téléporteur.
	ANDA #%00000011	; A = Numéro du téléporteur.
	ORA #%00111000	; A = code de la case de destination ($38 à $3B)

	LDB >MAPCOUL1	; B = couleurs sol/mur pour les téléporteurs n°1 à 3.
	CMPA #$3B		; A = code de destination de téléporteur n°4?
	BNE DONJON_TEST_TEL1 ; Non => DONJON_TEST_TEL1

	LDY #MAPCOUL21	; Y pointe les couleurs secondaires.
	LDB >MAPNUM		; B = niveau courant = n° de map.
	LDB B,Y			; B = couleurs secondaires du niveau courant.

DONJON_TEST_TEL1:
	STB >MAPCOULC	; Couleurs sol/mur courantes mémorisées.
	LDX #MAPADDR+32	; X pointe la map + 32 (première ligne = murs).

DONJON_TEST_TEL2:
	LDB ,X+			; Analyse case par case.
	ANDB #%01111111	; Suppression du flag de découverte de case.
	PSHS B
	CMPA ,S+		; A = B?
	BNE DONJON_TEST_TEL2 ; Non => rebouclage.

	LEAX -1,X		; Retour d'une case en arrière.
	STX >SQRADDR	; Adresse de la nouvelle case mémorisée.
	LDY #SON_TELEPORT_D ; Bruitage de téléportation.
	LBSR MUS
	LBSR DONJON_GAUCHE_R0 ; Compensation de tempo pour l'invulnérabilité et la lévitation.
	LBRA DONJON0 	; Rebouclage avec couleurs courrantes et affichage des décors.

; Trous dans le sol
DONJON_TEST_TROU:
	STX >SQRADDR	; Adresse de la nouvelle case mémorisée.
	LBSR SET00		; Affichage des décors.
	LDD >TEMPLEVIT	; D = Tempo de lévitation du joueur
	LBNE DONJON_TOUCHE ; Tempo <> 0 => DONJON_TOUCHE

DONJON_TEST_TROU0:	; Commun avec SET_STATE_2
	LBSR MAPCOMP	; Compression et sauvegarde de la map courrante.

	LDB #40			; Tempo à réajuster
	LBSR TEMPO
	LBSR VIDEOC_A	; Sélection video couleur.
	LDX #SCROFFSET+$1450 ; 1ère étape = ligne noire en bas de l'écran.
	CLRA
	LBSR G2_R1_20
	LDY #SON_CHUTE_D ; Y pointe les sons à jouer lors de la chute.
	LBSR SON_CHUTE1	; Initialisation des sons + 1ère note.
	LDA #120		; Etapes suivantes = décalage de la fenêtre vers le haut.

DONJON_TEST_TROU1:
	STA >VARDB1
	LBSR VIDEOC_A	; Sélection video couleur.
	BSR DONJON_TEST_TROU_R2	; Recopie de B lignes de 20 octets.
	LDB #20			; Offset pour les sauts de lignes.
	CLRA
	LBSR G2_R1_10x20 ; 10 lignes noires à compléter.
	INC	$E7C3		; Sélection vidéo forme + recopie de B lignes de 20 octets.
	BSR DONJON_TEST_TROU_R2	; Recopie de B lignes de 20 octets.

	LBSR SON_CHUTE	; Son de chute.

	LDA >VARDB1
	SUBA #10
	BNE DONJON_TEST_TROU1

	LBSR FEN_NOIR	; Remplissage de la fenêtre en noir.

	DEC >MAPNUM		; Descente = niveau - 1 (pas de sécurité si A = 0).
	LBSR MAPDECOMP	; Décompression de la map du niveau suivant.
	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LDA ,X			; A = code de la case courante.
	ANDA #%00000111	; A = n° d'ennemi s'il y en a un en-dessous.
	BEQ DONJON_TEST_TROU2 ; S'il n'y en a pas => DONJON_TEST_TROU2

	LDA ,X			; A = code de la case courante.
	ANDA #%11110000	; Suppression du contenu = élimination de l'ennemi en dessous.
	STA ,X
	INC >SCORE_E1	; Ennemi tué + 1 pour le score.

DONJON_TEST_TROU2:
	LBSR DLISTE_EN	; Mise à jour de la liste des ennemis de la map.
	LBSR DONJON_GAUCHE_R0 ; Compensation de tempo pour l'invulnérabilité et la lévitation.
	LBSR FEN_COUL	; Initialisation des couleurs sol/mur de la fenêtre de jeu.
	LBSR MASK_ALL	; Initialisation de tous les drapeaux.
	LDA #$39		; A = code machine de l'opérande RTS.
	STA >LISTE0		; LISTE0 initialisée avec un RTS (aucun pré-affichage).
	LBSR SET00		; Affichage des décors.

	LDY #SON_CHUTE2_D ; Son d'attérrissage.
	LBSR MUS

	LDA #8			; Chute = 8 points de dégat (1/5 de barre de bouclier ou de vie)
	STA >VARDB1
	LBSR SET_STATE_HIT0 ; Gestion des dégats
	LBNE DONJON_TOUCHE ; PV > 0 => DONJON_TOUCHE
	LBRA SET_STATE_DEATH ; Sinon perso mort => SET_STATE_DEATH

DONJON_TEST_TROU_R2:
	LDX #SCROFFSET	; X pointe le début de l'écran.
	LDY #SCROFFSET+$0190 ; Y pointe la partie d'écran à recopier.
	LDB >VARDB1		; B = nombre de lignes à recopier.

DONJON_TEST_TROU_R3:
	LBSR BSAVEN_20	; Recopie d'une ligne de 20 octets.
	LEAX 20,X		; X pointe la ligne suivante.
	LEAY 20,Y		; Y pointe la ligne suivante.
	DECB
	BNE DONJON_TEST_TROU_R3 ; B lignes à recopier.
	RTS

; Q = Quitter.
DONJON_Q:
	LDX #$0000		; Différent de $A55A
	STX $60FE		; Redémarrage à froid du TO.
	JMP $E82D		; Retour au menu principal

; B = Lancement du sort sélectionné.
DONJON_B:
	LDA >ATKPL_TEMP	; A = Tempo d'attaque du joueur
	LBNE DONJON_TOUCHE ; Tempo <> 0 => DONJON_TOUCHE.

	LDA >INVS_COUR	; A = n° de sort courant
	BNE DONJON_B_1	; Sort d'attaque => DONJON_B_1

	LDA >VARPL_MANA	; A = niveau de mana du joueur
	CMPA #MANA_S0	; >= 10 points de mana?
	LBCS DONJON_TOUCHE ; Non = sort annulé => DONJON_TOUCHE

	SUBA #MANA_S0	; -10 points de mana
	STA >VARPL_MANA
	LBRA DONJON_SEL3A ; +40 PV, son, mise à jour des barres d'énergie

DONJON_B_1:
	LDA #1			; Type d'attaque par sort.
	STA >ATKPL_TYPE

	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LBSR PAS_AV		; Puis la case G6 devant.
	STX >VARDW3		; Adresse sauvegardée.
	LDA ,X			; A = code de la case G6.
	ANDA #%01110000 ; A = type de case
	CMPA #%01110000	; Mur ou obstacle? 
	BNE DONJON_FEU_2 ; Non => DONJON_FEU_2

	LDA ,X			; A = code de la case G6.
	ANDA #%00001111	; A = contenu de la case.
	CMPA #%00001000	; Mur simple, ornement ou mur escamotable?
	LBCC DONJON_FEU_3 ; Oui = tir dans le vide

	CMPA #%00000100	; Porte fermée?
	LBCS DONJON_FEU_3 ; Oui = tir dans le vide
	LBRA DONJON_FEU_12 ; Non, ouverte = attaque en secteur 12 => DONJON_FEU_12

; Action ou Feu.
DONJON_FEU:
	CLR >ATKPL_TYPE	; Type d'attaque par arme
	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LBSR PAS_AV		; Puis la case G6 devant.
	STX >VARDW3		; Adresse sauvegardée.
	LDA ,X			; A = code de la case G6.
	ANDA #%01110000 ; A = type de case
	CMPA #%01110000	; Mur ou obstacle? 
	BNE DONJON_FEU_2 ; Non => DONJON_FEU_2

	LDA ,X			; A = code de la case G6.
	ANDA #%00001111	; A = contenu de la case.
	CMPA #%00001000	; Mur simple?
	BEQ DONJON_FEU_3 ; Oui = attaque dans le vide => DONJON_FEU_3.
	LBCS DONJON_111_P ; Non, porte ouverte ou fermée => DONJON_111_P.

	CMPA #%00001011	; Mur escamotable?
	BCS DONJON_FEU_0 ; Non, ornement 1 ou 2 => DONJON_FEU_0

	LDY #SON_MURE_D ; Son de mur escamotable
	LBSR MUS
	INC >SCORE_S1	; Secrets trouvés + 1 pour le score.
	BRA DONJON_FEU_1 ; Puis destruction du mur => DONJON_FEU_1

DONJON_FEU_0: 
	LDY #SON_ORN12_D ; Son d'ornement
	LBSR MUS
	INC >SCORE_O1	; Ornements détruits + 1 pour le score

DONJON_FEU_1:
	LDX >VARDW3		; X pointe la case G6 devant. 
	LDA #%11000000	; Case remplacée par un sol occupable %100 vide.
	STA ,X			; Code de la case modifié.
	LBRA DONJON3 	; Affichage des décors modifiés => DONJON3.

DONJON_FEU_2:		; Code commun avec DONJON_B
	LDA >ATKPL_TEMP	; A = Tempo d'attaque du joueur
	LBNE DONJON_TOUCHE ; Tempo <> 0 => DONJON_TOUCHE.

	LDA ,X			; A = code de la case G6.
	ANDA #%01110000 ; A = type de case
	CMPA #%00100000	; Echelles? 
	BEQ DONJON_FEU_3 ; Oui = attaque dans le vide => DONJON_FEU_3
	LBCS DONJON_FEU_12 ; Non, sol %000 ou %001 = pas d'ennemi => DONJON_FEU_12

	CMPA #%00110000	; Téléporteur?
	BNE DONJON_FEU_06 ; Non, case occupable %100, %101 ou %110 => DONJON_FEU_06

	LDA ,X			; A = code de la case G6.
	ANDA #%00001111 ; A = contenu de la case.
	CMPA #%00000100	; Téléporteur?
	LBCC DONJON_FEU_12 ; Non, destination => DONJON_FEU_12. Oui = attaque dans le vide

DONJON_FEU_3:
	LDA >ATKPL_TEMP	; A = Tempo d'attaque du joueur
	LBNE DONJON_TOUCHE ; Tempo <> 0 => DONJON_TOUCHE.

	LDX #SCROFFSET+$05D1 ; X pointe le milieu de l'écran pour les sorts
	STX >VARDW5
	CLR >VARDB6		; Pas d'ennemi en vue.
	LBSR ATKPL		; Attaque dans le vide = animation seule.
	LBRA DONJON_TOUCHE ; Retour => DONJON_TOUCHE.

; Attaque en secteur 06
DONJON_FEU_06:
	LDA >VARDW3		; X pointe la case G6.
	LDA ,X			; A = code de la case G6.
	ANDA #%00001111 ; A = contenu de la case.
	BEQ DONJON_FEU_12 ; Pas d'ennemi => DONJON_FEU_12

	LDY #DEN_A0600	; Y pointe l'adresse écran de la tâche de sang en secteur 06
	LBSR ATKPL0		; Animation de l'attaque.
	LBEQ DONJON_TOUCHE ; Si attaque annulée => DONJON_TOUCHE.

	STA >VARDB2		; Sinon, points d'attaque sauvegardés.
	LDX >VARDW5		; X pointe de nouveau la tâche de sang à l'écran.
	LBSR BLOOD06	; Affichage de la tâche de sang.

DONJON_FEU_06A:
	LDY #DEN_FLAG0	; Y pointe les flags de l'ennemi.
	LDA >VARDB6		; A = n° d'ennemi
	LDA A,Y			; A = flags de l'ennemi.
	ANDA #%10000000	; Boss?
	LBNE DONJON_FEU_BOSS ; Oui => DONJON_FEU_BOSS. Sinon ennemi normal.

	LDX >VARDW3		; X = adresse de la case de l'ennemi.
	LDY #LISTE_EN-3	; Y pointe la liste des ennemis dans la map courante.

DONJON_FEU_06B:
	LEAY 3,Y		; Y pointe l'adresse suivante dans LISTE_EN
	CMPX ,Y			; Adresse = adresse courante dans LISTE_EN?
	BNE DONJON_FEU_06B ; Non = rebouclage.

	LDA 2,Y			; A = points de vie de l'ennemi.
	SUBA >VARDB2	; A = A - points d'attaque.
	BHI DONJON_FEU_06D ; A > 0 => DONJON_FEU_06D. Sinon ennemi éliminé.

	LDA ,X			; A = code de la case de l'ennemi.
	ANDA #%11110000	; Suppression de l'ennemi dans le code de case.
	STA ,X			; Code de case mis à jour.
	INC >SCORE_E1	; Ennemis tués + 1 pour le score.

	LDA >PACKNUM	; A = Numéro de pack de map
	CMPA #2			; Niveau du portail?
	BCS DONJON_FEU_06C ; Non => DONJON_FEU_06C

	LDA >SCORE_E1	; A = nombre d'ennemis tués au niveau portail
	CMPA >SCORE_E2	; Ennemis tués = nombre d'ennemis à tuer?
	BNE DONJON_FEU_06C ; Non => DONJON_FEU_06C

	; CHARGER LA CONCLUSION
	LDX #SCROFFSET+$0668 ; X pointe l'écran pour un message.
	LDU #MESSAGEFIN	; U pointe le message de fin.
	LBRA DONJON_FEU_BOSS1 ; Affichage du message + score + conclusion

DONJON_FEU_06C:
	LBSR DLISTE_EN	; Mise à jour de la liste des ennemis de la map.
	LBRA DONJON3 	; Affichage des décors modifiés => DONJON3.

DONJON_FEU_06D:
	STA 2,Y			; Points de vie actualisés dans LISTE_EN
	LBRA DONJON_TOUCHE ; => DONJON_TOUCHE.

; Attaque en secteur 12
DONJON_FEU_12:
	LDA >ATKPL_TYPE	; A = type d'attaque
	BNE DONJON_FEU_12_1	; Type 1 = sort => DONJON_FEU_12_1.
	LDA >INVW_COUR	; A = arme courante.
	LBEQ DONJON_FEU_3 ; Epée = attaque dans le vide => DONJON_FEU_3

DONJON_FEU_12_1:
	LDX >VARDW3		; X pointe la case G6
	LBSR PAS_AV		; Puis la case G12 devant.
	STX >VARDW3		; Adresse sauvegardée.
	LDA ,X			; A = code de la case G12.
	ANDA #%01110000 ; A = type de case
	CMPA #%01110000	; Mur ou obstacle? 
	LBEQ DONJON_FEU_3 ; Oui = attaque dans le vide => DONJON_FEU_3

	CMPA #%00100000	; Echelles? 
	LBEQ DONJON_FEU_3 ; Oui = attaque dans le vide => DONJON_FEU_3
	BCS DONJON_FEU_21 ; Non, sol %000 ou %001 => DONJON_FEU_21

	CMPA #%00110000	; Téléporteur? 
	BNE DONJON_FEU_12A ; Non, case occupable %100, %101 ou %110 => DONJON_FEU_12A
	BRA DONJON_FEU_21 ; Sinon c'est forcément une case destination => DONJON_FEU_21

DONJON_FEU_12A:
	LDA ,X			; A = code de la case G12.
	ANDA #%00001111 ; A = contenu de la case.
	BEQ DONJON_FEU_21 ; Pas d'ennemi => DONJON_FEU_21

	LDY #DEN_A1200 ; Y pointe l'adresse écran de la tâche de sang en secteur 12
	BRA DONJON_FEU_21_2

; Attaque en secteur 21
DONJON_FEU_21:
	LDA >ATKPL_TYPE	; A = type d'attaque
	BNE DONJON_FEU_21_1	; Type 1 = sort => DONJON_FEU_21_1.
	LDA >INVW_COUR	; A = arme courante.
	LBEQ DONJON_FEU_3 ; Epée = attaque dans le vide => DONJON_FEU_3

DONJON_FEU_21_1:
	LDX >VARDW3		; X pointe la case G12
	LBSR PAS_AV		; Puis la case G21 devant.
	STX >VARDW3		; Adresse sauvegardée.
	LDA ,X			; A = code de la case G21.
	ANDA #%01110000 ; A = type de case
	CMPA #%01110000	; Mur ou obstacle? 
	LBEQ DONJON_FEU_3 ; Oui = attaque dans le vide => DONJON_FEU_3

	CMPA #%01000000	; Sol occupable %100? 
	LBCS DONJON_FEU_3 ; Non, sol %000 ou %001, échelle ou destiation de téléporteur => DONJON_FEU_3

	LDA ,X			; A = code de la case G21.
	ANDA #%00001111 ; A = contenu de la case.
	LBEQ DONJON_FEU_3 ; Pas d'ennemi => DONJON_FEU_3

	LDY #DEN_A2100	; Y pointe l'adresse écran de la tâche de sang en secteur 21

DONJON_FEU_21_2:
	LBSR ATKPL0		; Animation de l'attaque.
	LBEQ DONJON_TOUCHE ; Si attaque annulée => DONJON_TOUCHE.

	STA >VARDB2		; Sinon, points d'attaque sauvegardés.
	LDX >VARDW5		; X pointe la tache de sang à l'écran.
	LBSR BLOOD12	; Affichage de la tâche de sang.
	LBRA DONJON_FEU_06A ; Gestion des points de vie en moins => DONJON_FEU_06A

; Gestion des dégats sur le boss.
DONJON_FEU_BOSS:
	LDA >VARBOSS_PV	; A = nombre de PV du boss.
	SUBA >VARDB2	; - les dégats du joueurs
	BHI DONJON_FEU_BOSS2 ; A > 0 => DONJON_FEU_BOSS2. Sinon Boss éliminé.

DONJON_FEU_BOSS0:
	INC >SCORE_E1	; Ennemis tués + 1 pour le score.
	LDX #SCROFFSET+$0410 ; X pointe l'écran pour un message.
	LDU #MESSAGEFT	; U pointe le message de fin de tour.

DONJON_FEU_BOSS1:
	LBSR PRINTM		; Affichage du message + demande d'appui sur A

	LBSR AFF_SCORE	; Affichage des scores
	LBSR TOUCHE		; Attente de touche.

	LBSR VIDEOC_A	; Sélection vidéo couleur
	LDY #INVS_COUR	; Y pointe l'inventaire à sauvegarder
	LDX #$5FE9		; X pointe le buffer de sauvegarde en mémoire vidéo couleur
	LBSR BSAVEN_16	; 16 octets à sauvegarder (objets, armes et munitions)
	LEAY 3,Y
	LEAX 3,X
	LBSR BSAVEN_4	; + 4 octets pour les acquisitions de sorts
	INC $E7C3		; Sélection vidéo forme.

	LDA >PACKNUM	; A = n° de pack
	INCA			; A = Tour suivante
	LBSR PACK_LOAD	; Chargement de la tour suivante.
	LBRA INITADR	; => Initialisation

DONJON_FEU_BOSS2:
	STA >VARBOSS_PV	; Mise à jour des PV du boss
	LBRA DONJON_TOUCHE ; => DONJON_TOUCHE.

; Portes
DONJON_111_P:
	CMPA #%00000100	; Porte fermée?
	BCS DONJON_111_PF ; Oui => DONJON_111_PF. Sinon porte ouverte.

; Porte ouverte
DONJON_111_PO:
	CMPA #%00000111	; Porte ouverte à bouton?
	BEQ DONJON_111_PO1 ; Oui => DONJON_111_PO1

	LDX #INVK1		; X pointe les acquisitions de clés.
	SUBA #4
	LEAX A,X		; puis la l'acquisition liée à la serrure courante.
	LDA ,X			; Clé acquise?
	BEQ DONJON_111_PO2 ; Non = fin. Sinon fermeture de la porte.

DONJON_111_PO1:
	LBSR DCLOSE		; Fermeture de la porte.
DONJON_111_PO2:
	LBRA DONJON_TOUCHE ; => DONJON_TOUCHE.

; Porte fermée
DONJON_111_PF:
	CMPA #%00000011	; Porte fermée à bouton?
	BEQ DONJON_111_PF1 ; Oui => DONJON_111_PF1

	LDX #INVK1		; X pointe les acquisitions de clés.
	LEAX A,X		; puis la l'acquisition liée à la serrure courante.
	LDA ,X			; Clé acquise?
	BEQ DONJON_111_PF2 ; Non = fin. Sinon ouverture de la porte.

DONJON_111_PF1:
	LBSR DOPEN		; Ouverture de la porte.
DONJON_111_PF2:
	LBRA DONJON_TOUCHE ; => Rebouclage

; E = Sélection de l'arme précédente.
DONJON_E:
	LDA >INVW_COUR	; A = numéro d'arme courante.

DONJON_E_1:
	DECA			; Numéro d'arme - 1
	BPL DONJON_E_2	; Numéro >= 0 => DONJON_E_2
	LDA #6			; Sinon arme n° = 6 (fusil plasma)

DONJON_E_2:
	LDX #INVW_0		; X pointe l'inventaire des armes.
	LEAX A,X		; Puis l'arme suivante.
	LDB ,X			; Arme disponible?
	BEQ DONJON_E_1	; Non, sélection arme suivante => DONJON_E_1
	BRA DONJON_R_3	; Oui => DONJON_R_3

; R = Sélection de l'arme suivante.
DONJON_R:
	LDA >INVW_COUR	; A = numéro d'arme courante.

DONJON_R_1:
	INCA			; Numéro d'arme + 1
	CMPA #7
	BCS DONJON_R_2	; Numéro < 7 => DONJON_R_2
	CLRA			; Sinon arme n° = 0 (épée)

DONJON_R_2:
	LDX #INVW_0		; X pointe l'inventaire des armes.
	LEAX A,X		; Puis l'arme suivante.
	LDB ,X			; Arme disponible?
	BEQ DONJON_R_1	; Non, sélection arme suivante => DONJON_R_1

DONJON_R_3:
	CMPA >INVW_COUR	; Arme suivante = arme courante?
	LBEQ DONJON_TOUCHE ; Oui = action annulée => DONJON_TOUCHE

	STA >INVW_COUR	; Sauvegarde du n° d'arme suivante.
	LBSR AFF_INVW	; Affichage de l'arme dans l'inventaire.
	LDY #SON_SELECT1_D
	LBSR MUS		; + son.
	LBRA DONJON_TOUCHE ; => DONJON_TOUCHE

; D = Sélection du sort précédent.
DONJON_D:
	LDA >INVS_COUR	; A = numéro de sort courant.

DONJON_D_1:
	DECA			; Numéro de sort - 1
	BPL DONJON_D_2	; Numéro >= 0 => DONJON_D_2
	LDA #3			; Sinon de sort n° = 3 (sphère d'antimatière)

DONJON_D_2:
	LDX #INVS0		; X pointe l'inventaire des sorts.
	LEAX A,X		; Puis le sort suivant.
	LDB ,X			; Sort disponible?
	BEQ DONJON_D_1	; Non, sélection sort suivant => DONJON_D_1
	BRA DONJON_F_3	; Oui => DONJON_F_3

; F = Sélection du sort suivant.
DONJON_F:
	LDA >INVS_COUR	; A = numéro de sort courant.

DONJON_F_1:
	INCA			; Numéro de sort + 1
	CMPA #4
	BCS DONJON_F_2	; Numéro < 4 => DONJON_F_2
	CLRA			; Sinon sort n° = 0 (régénération)

DONJON_F_2:
	LDX #INVS0		; X pointe l'inventaire des sorts.
	LEAX A,X		; Puis le sort suivant.
	LDB ,X			; Sort disponible?
	BEQ DONJON_F_1	; Non, sélection sort suivant => DONJON_F_1

DONJON_F_3:
	CMPA >INVS_COUR	; Sort suivant = sort courant?
	LBEQ DONJON_TOUCHE ; Oui = action annulée => DONJON_TOUCHE

	STA >INVS_COUR	; Sauvegarde du n° de sort suivant.
	LBSR AFF_INVS	; Affichage du sort dans l'inventaire.
	LDY #SON_SELECT2_D
	LBSR MUS		; + son.
	LBRA DONJON_TOUCHE ; => DONJON_TOUCHE

; 1 = Sélection de l'objet 1 : invulnérabilité
DONJON_SEL1:
	LDA >INVW_OBJ1
	LBEQ DONJON_TOUCHE ; Quantité d'objets = 0 => DONJON_TOUCHE

	DEC >INVW_OBJ1	; Objet - 1
	LDD #POWTIMER
	STD >TEMPINV	; Tempo d'invulnérabilité mise à jour

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDX #$5618		; X pointe l'icône d'invulnérabilité
	LDD #c0628		; A = noir sur fond turquoise. B = 40 pour les sauts de ligne.
	BRA DONJON_SEL2A

; 2 = Sélection de l'objet 2 : lévitation
DONJON_SEL2:
	LDA >INVW_OBJ2
	LBEQ DONJON_TOUCHE ; Quantité d'objets = 0 => DONJON_TOUCHE

	DEC >INVW_OBJ2	; Objet - 1
	LDD #POWTIMER
	STD >TEMPLEVIT	; Tempo de lévitation mise à jour

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDX #$561F		; X pointe l'icône de lévitation
	LDD #c0328		; A = noir sur fond jaune vif. B = 40 pour les sauts de ligne.

DONJON_SEL2A:
	LBSR DISPLAY_2A_13 ; Allumage de l'icône.
	INC $E7C3		; Sélection vidéo forme.
	LBSR AFF_INVO	; Mise à jour de l'affichage de l'inventaire.
	LDY #SON_REGEN_D
	LBSR MUS		; Bruitage
	LBRA DONJON_TOUCHE ; => DONJON_TOUCHE

; 3 = Sélection de l'objet 3 : potion de vie
DONJON_SEL3:
	LDA >INVW_OBJ3
	LBEQ DONJON_TOUCHE ; Quantité d'objets = 0 => DONJON_TOUCHE

	DEC >INVW_OBJ3	; Objet - 1
DONJON_SEL3A:
	LDA #40			; +40 PV
	STA >VARPL_PV
DONJON_SEL3B:
	LBSR AFF_INVO	; Mise à jour de l'affichage de l'inventaire.
	LDY #SON_REGEN_D
	LBSR MUS		; Bruitage du sort
	LBSR AFF_BAR	; Mise à jour des barres d'énergie dans l'interface
	LBRA DONJON_TOUCHE

; 4 = Sélection de l'objet 4 : bouclier
DONJON_SEL4:
	LDA >INVW_OBJ4
	LBEQ DONJON_TOUCHE ; Quantité d'objets = 0 => DONJON_TOUCHE

	DEC >INVW_OBJ4	; Objet - 1
	LDA #40			; 40 bouclier
	STA >VARPL_BOUC
	BRA DONJON_SEL3B

; 5 = Sélection de l'objet 5 : potion de mana
DONJON_SEL5:
	LDA >INVW_OBJ5
	LBEQ DONJON_TOUCHE ; Quantité d'objets = 0 => DONJON_TOUCHE

	DEC >INVW_OBJ5	; Objet - 1
	LDA #40			; 40 points de mana
	STA >VARPL_MANA
	BRA DONJON_SEL3B

;******************************************************************************
;******************************************************************************
;*                       MOTEUR D'AFFICHAGE DES DECORS                        *
;******************************************************************************
;******************************************************************************

;------------------------------------------------------------------------------
; SET00 = préparation à l'analyse des cases
; Initilisation des listes d'appel et des pointeurs de liste.
;------------------------------------------------------------------------------
; Sous-routine d'initialisation de la liste 4 réutilisée par DCLOSE_FIN2
SET00_R1:
	CLRA				; A = 0 points d'attaques des ennemis.
	STA >LISTEA1_HP
	STA >LISTEA2_HP
	STA >LISTEA3_HP
	STA >LISTEA4_HP
	RTS

; Point d'entrée sans affichage de la minimap
SET00_NMAP:
	CLRA			; Pas d'actualisation de la minimap recquis.
	BRA SET00_0

; Point d'entrée avec affichage de la minimap
SET00:
	LDA #1			; Actualisation de la minimap requis.

SET00_0:
	STA >FMINIMAP

	LDY #LISTE0		; Y pointe la pré-liste de rétablissement LISTE0.
	STY >PLISTE0	; PLISTE0 pointe la liste 0.
	LDX #LISTE1		; X pointe la liste de rétablissement LISTE1.
	STX >PLISTE1	; PLISTE1 pointe la liste 1.

	LDB #2
	LBSR DISPLAY_2YX_48	; LISTE1 = LISTE0 (96 octets à recopier).
	LDA #$39		; A = code machine de l'opérande RTS.
	STA ,X			; LISTE1 terminée par un RTS par sécurité.
	STA >LISTE4RTS	; LISTE4 terminée par un RTS par sécurité.

	LDX #LISTE2
	STX >PLISTE2	; PLISTE2 pointe la liste 2.

	LDX #LISTE3
	STX >PLISTE3	; PLISTE3 pointe la liste 3.

	LDA #$BD		; A = code machine de l'opérande JSR.
	LDY #GAME_RTS	; Y = adresse de GAME_RTS
	LDX #LISTE4_18	; X pointe la liste 4
	LDB #11			; 11 appels à initialiser.
SET00_1:
	STA ,X+			; "JSR"
	STY ,X++		; + adresse de GAME_RTS
	DECB
	BNE SET00_1

	BSR SET00_R1	; Initialisation de la liste 4.
	CLR >STATEF		; Initialisation des flags d'état.
	CLR >DETEC_CHEST ; Initialisation de la détection de coffre.

;------------------------------------------------------------------------------
; SET02 = analyse de la case de G2
;------------------------------------------------------------------------------
SET02:
	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type.

	BEQ SET02_000	; Sol simple vide ou avec arme %000? Oui => SET02_000.

	CMPA #%00100000	; Echelles %010?
	BEQ SET02_010	; Oui => SET02_010.
	BCS SET02_001	; Non, sol simple vide ou avec objet %001 => SET02_001.

	CMPA #%01010000	; Trou dans le sol occupable %101? 
	LBEQ SET02_101	; Oui => SET02_101.
	LBCS SET02_G	; Non, sol occupable %100 ou téléporteur %011 => SET02_G
					; (Pas d'ennemi et téléporteur d'apparence sol en G2).
	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	LBEQ SET02_110	; Oui => SET02_110. Sinon, porte ouverte.

; Mur ou obstacle. Ici il ne peut s'agir que d'une porte ouverte.
SET02_111:
	LBSR PAS_AV		; X pointe la case devant.
	LDA ,X			; A = code de la case devant.
	ANDA #%01110000	; A = type de la case devant.
	LDX >SQRADDR	; X pointe de nouveau la case courante G2 dans la map.

	CMPA #%01110000	; Case devant = obstacle? Si oui c'est forcément un mur.
	LBNE SET02_G	; Sinon c'est un sol => SET02_G

	LDD #DP2		; D = adresse du montant de porte DP2
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #DP2_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LBRA SET02_G

; Sol simple interdit aux ennemis, vide ou avec arme ou munition.
SET02_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	LBEQ SET02_G	; Case vide = sol simple => SET02_G. Sinon coffre

SET02_000_1:
	INC	>DETEC_CHEST ; Coffre détecté
	LBRA SET02_G

; Sol simple interdit aux ennemis, vide ou avec objet.
SET02_001:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BNE SET02_000_1	; Coffre => SET02_000_1. Sinon case de configuration de boss.

	LDA #$C0		; Case courante remplacée par un sol %100 occupable, vide et visible.
	STA ,X
	PSHS X
	LBSR INIBOSS 	; Lancement de la procédure d'initialisation du boss
	PULS X			; dans le pack de monstres.
	LDA >DEN_PV00
	STA >VARBOSS_PV	; Initialisation des PVs du boss.
	LBRA SET02_G	; => SET02_G

; Echelles.
SET02_010:
	LBSR PAS_AV		; X pointe la case devant.
	LDB ,X			; B = code de la case devant.
	STB	>VARDB1		; Code sauvegardé.
	ANDB #%01110000	; B = type de la case devant.
	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case courante.
	BNE SET02_010_M	; Echelle montante => SET02_010_M

; Echelle descendante.
SET02_010_D:
	CMPB #%01110000	; Case devant = mur ou obstacle?
	BEQ SET02_101	; Oui = échelle non visible => SET02_101

SET02_010_D1:
	BSR SET02_101_R1 ; Affichage du trou si nécessaire.

	LDD #L02D		; D = adresse de l'échelle descendante.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #L02D_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LBRA SET01		; Etape suivante.

; Echelle montante.
SET02_010_M:
	CMPB #%01110000	; Case devant = mur ou obstacle?
	BEQ SET02_110	; Oui = échelle non visible => SET02_110

SET02_010_M1:
	BSR SET02_110_R1 ; Affichage du trou si nécessaire.

	LDD #L02U		; D = adresse de l'échelle montante.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #L02U_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LBRA SET01		; Etape suivante.

; Trou dans le sol
SET02_101:
	BSR SET02_101_R1 ; Affichage du trou si nécessaire.
	BRA SET01		; Etape suivante

SET02_101_R1:		; Réutilisé par SET02_010_D1.
	LDA >H2D
	BNE SET02_101_R2 ; Si trou déjà affiché => SET02_101_R2

	LDD #H2			; D = adresse du trou entier.
	BRA SET02_101_R3

SET02_101_R2:
	LDD #H2_2		; D = adresse des pixels à raffraichir.

SET02_101_R3:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	LDD #H2_REST	; D = adresse de rétablissement des pixels rafraichis.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	INC >H2D		; H2 marqué comme affiché.
	CLR >CH2D		; CH2 marqué comme non affiché.
	CLR >G2D		; G2 marqué comme non affiché.
	RTS

; Trou dans le plafond occupable par l'ennemi.
SET02_110:
	BSR SET02_110_R1 ; Affichage du trou si nécessaire.
	BRA SET01		; Etape suivante

SET02_110_R1:		; Réutilisé par SET02_010_M1.
	LDD #CH2D		; D = adresse du trou CH2.
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire.

SET02_110_R2:
	INC >CH2D		; CH2 marqué comme affiché.
	CLR >H2D		; H2 marqué comme non affiché.
	CLR >G2D		; G2 marqué comme non affiché.
	RTS

; Sol simple G2
SET02_G:
	LDD #G2D		; D = adresse du sol G2.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire
	CLR >H2D		; H2 marqué comme non affiché.
	CLR >CH2D		; CH2 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET01 = analyse de la case de G1
;------------------------------------------------------------------------------
SET01:
	LBSR PAS_GA		; Adresse G1 = Adresse G2 + pas à gauche
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00100000	; Echelles %010?
	BEQ SET01_010	; Oui => SET01_010.

	CMPA #%01010000	; Trou dans le sol occupable %101? 
	BEQ SET01_101	; Oui => SET01_101.
	BCS SET01_G		; Non, sols simples %000,%001,%100 ou destination %011 (pas
					; d'objets ou d'ennemi ici) => SET01_G.
	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BEQ SET01_110	; Oui => SET01_110. Sinon, mur ou obstacle %111.

; Mur ou obstacle. En G1, seul les murs et les sols sont visibles.
SET01_111:
	LDA ,X			; A = code de la case courante
	ANDA #%00001111	; A = contenu de la case

	CMPA #%00001000	; Mur simple?
	BEQ SET01_W		; Oui => SET01_W

	CMPA #%00001011	; Mur déplaçable?
	BEQ SET01_W		; Oui => SET01_W
	BRA	SET01_G		; Autre = apparence d'un sol en G1 => SET01_G

; Echelles. En G1, seuls les trous apparaissent.
SET01_010:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BNE SET01_110	; Echelle montante = trou CH1. Sinon trou H1.

; Trou dans le sol occupable par un ennemi flottant. En G1 pas d'ennemi visible.
SET01_101:
	LDD #H1			; D = adresse de H1.
	BRA SET01_110_2

; Trou dans le plafond occupable par l'ennemi. En G1 pas d'ennemi visible.
SET01_110:
	LDD #CH1		; D = adresse de CH1.
SET01_110_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G1D		; G1 marqué comme à réafficher
	BRA SET01_G0	; Etape suivante.

; Mur simple W36
SET01_W:
	LBSR MASK_W36	; Masquage des éléments cachés derrière le mur.
	LDD #W36D		; D = adresse du mur W36.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LBRA SET06		; => Analyse de la case de G6.

; Sol simple G1
SET01_G:
	LDD #G1D		; D = adresse du sol G1.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
SET01_G0:
	CLR >W36D		; W36 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET04 = analyse de la case de G4
; En G4 les échelles sont interdites, car il faut deux cases de profondeur dans
; le couloir. Et ni les objets ni les ennemis ne sont visibles sur cette case.
;------------------------------------------------------------------------------
SET04:
	LBSR PAS_AV		; Adresse G4 = Adresse G1 + pas en avant.
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type.

	CMPA #%00110000	; Téléporteur ou destination de téléporteur?
	BEQ SET04_011	; Oui => SET04_011
	LBCS SET04_G	; Non, sol simple %000 ou %001, ou échelles => SET04_G

	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	BEQ SET04_101	; Oui => SET04_101.
	LBCS SET04_G	; Non, sol simple occupé ou occupable %100 => SET04_G

	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BEQ SET04_110	; Oui => SET04_110. Sinon mur ou obstacle.

; Mur ou obstacle.
SET04_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00000100	; Porte fermée?
	BCS SET04_111_PF ; Oui => SET04_111_PF.

	CMPA #%00001000	; Mur simple %1000?
	LBEQ SET04_W	; Oui => SET04_W.
	BCS SET04_111_PO ; Non, porte ouverte => SET01_111_PO.

	CMPA #%00001010	; Ornement mural 2 %1010?
	BCS SET04_111_O1 ; Non, ornement mural 1 => SET04_111_O1.
	BEQ SET04_111_O2 ; Oui, ornement mural 2 => SET04_111_O2.
	LBRA SET04_W	; Autre = mur.

; Porte fermée
SET04_111_PF:
	LDD #D04		; D = adresse de la porte D04
	BRA SET04_011_1	; Même type d'affichage que le téléporteur.

; Porte ouverte
SET04_111_PO:
	LDD #D04H		; D = adresse du haut de porte porte D04H.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #D04H_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	CLR >W2D		; W2 forcé à "non affiché".
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a dans la zone de W2.

	LBRA SET04_G	; Affichage de G4 puis étape suivante.

; Ornement 1 = bannière Baphomet
SET04_111_O1:
	LDD #BAN04		; D = adresse de BAN04.
	BRA SET04_011_1	; Même type d'affichage que le téléporteur.

; Ornement 2 = têtes sur des piques
SET04_111_O2:
	LBSR MASK_W4	; Masquage des éléments cachés derrière W4.
	LDD #W4D		; D = adresse du mur W4.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	LDD #ORN04		; D = adresse de ORN04.
	BRA SET04_011_1	; Même type d'affichage que le téléporteur.

; Téléporteur ou destination de téléporteur.
SET04_011:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	CMPA #%00001000	; Destination de téléporteur?
	BCC SET04_G		; Oui, donc apparence de sol simple => SET04_G

	LDA #%00000001	; Etat de jeu = Téléporteur visible en secteur G4.
	STA >STATEF
	LDD #TEL04		; D = adresse de TEL04.

SET04_011_1:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #G4D		; D = adresse du sol G4.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2, si pas déjà affiché.

	LDD #D04_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	CLR >W1D		; W1 marqué comme non affiché.
	LBSR MASK_W1	; Ainsi que tout ce qu'il y a dans la zone de W1.

	CLR >W2D		; W2 forcé à "non affiché".
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a dans la zone de W2.

	LBRA SET06		; => Etape suivante.

; Trou dans le sol occupable par un ennemi flottant. Pas d'ennemi visible.
SET04_101:
	LDD #H4			; D = adresse de H4.
	BRA SET04_110_2	; Etape suivante => SET04_110_2

; Trou dans le plafond occupable par l'ennemi. Pas d'ennemi visible.
SET04_110:
	LDD #CH4		; D = adresse de CH4.
SET04_110_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G4D		; G4 marqué comme à réafficher.
	BRA SET04_G0	; Etape suivante => SET04_G0

; Mur W1
SET04_W:
	LBSR MASK_W1	; Masquage des éléments cachés derrière le mur.
	LDD #W1D		; D = adresse du mur W1.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LBRA SET06		; => Analyse de la case de G6.

; Sol G4
SET04_G:
	LDD #G4D		; D = adresse du sol G4.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
SET04_G0:
	CLR >W1D		; W1 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET09 = première partie de la case G9
; Par économie, les téléporteurs, les portes et les ornements types 1 et 2 ne 
; sont pas affichés à cette distance. Les échelles sont maintenues mais elles 
; ne sont pas visibles sur cette case. Les trous sont maintenus.
;------------------------------------------------------------------------------
SET09:
	LBSR PAS_AV		; Adresse G9 = Adresse G4 + pas en avant.
	STX >VARDW1		; Adresse de G9 sauvegardée.
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type.

	CMPA #%00100000	; Echelles 010?
	BEQ SET09_010	; Oui => SET09_010.
	BCS SET09_000	; Non, sol %000 ou %001 => SET09_000

	CMPA #%01000000	; Sol simple occupé ou occupable %100? 
	BEQ SET09_100	; Oui => SET09_100.
	LBCS SET09_G	; Non, téléporteur ignoré = sol simple => SET09_G

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110? 
	BCS SET09_101	; Non, trou dans le sol occupé ou occupable %101 => SET09_101.
	BEQ SET09_110	; Oui => SET09_110. Sinon mur ou obstacle ignoré => SET09_W.

; Mur W4
SET09_W:
	LBSR MASK_W4	; Masquage des éléments cachés derrière le mur.
	LDD #W4D		; D = adresse du mur W4.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LBRA SET06		; => Analyse de la case de G6.

; Sol %000 avec ou sans objet, ou sol %001 avec ou sans arme ou munition.
SET09_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	LBEQ SET09_G	; Case vide = sol simple => SET09_G.

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_09
	LDD #CHEST09
	STD >LISTE4_09+1 ; Appel au coffre G9 empilé dans LISTE4

	LDD #REST09B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LBRA SET09_G	; Affichage du sol => SET09_G

; Echelles. En G9, seuls les trous sont visibles.
SET09_010:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BNE SET09_010_M	; Echelle montante => SET09_010_M

; Echelle descendante non visible = trou dans le sol. Pas d'ennemi possible.
SET09_010_D:
	BSR SET09_101_R1 ; Affichage du trou dans le sol.
	BRA SET09_010_M2 ; Affichage des murs derrière, puis étape suivante.

; Echelle montante non visible = trou dans le plafond. Pas d'ennemi possible.
SET09_010_M:
	BSR SET09_110_R1 ; Affichage du trou dans le plafond.

SET09_010_M2:
	LDD #W10D		; D = adresse du mur W10.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	LDD #W31D		; D = adresse du mur 31.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	CLR >W10D		; W10 marqué comme à réafficher.
	LBSR MASK_W10	; Ainsi que tout ce qu'il y a derrière.

	CLR >W31D		; W31 marqué comme à réafficher.
	LBSR MASK_W31	; Ainsi que tout ce qu'il y a derrière.

	LBRA SET06		; Etape suivante.

; Sol simple occupé ou occupable par un ennemi.
SET09_100:
	BSR SET09_TM	; Test de présence ennemie.
	BRA SET09_G		; Affichage du sol puis étape suivante.

; Traitement des ennemis en G09
SET09_TM:
	LDU #E0X_G09	; U pointe les adresses des ennemis en G09.
	LDY #LISTE4_09	; Y pointe la liste 4.
	LBRA SETXX_TM	; Si ennemi présent, empilement en listes 4 et liste 0.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET09_101:
	BSR SET09_TM	; Test de présence ennemie.
	BSR SET09_101_R1 ; Affichage du trou.
	BRA SET09B		; Etape suivante.

SET09_101_R1:		; Routine réutilisée par SET09_010_D
	LDD #H9D		; D = adresse du trou H9.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire.

	INC >H9D		; H9 marqué comme affiché.
	CLR >CH9D		; CH9 marqué comme non affiché.
	CLR >G9D		; G9 marqué comme à réafficher.
	CLR >W4D		; W4 marqué comme non affiché.
	RTS

; Trou dans le plafond occupable par l'ennemi.
SET09_110:
	BSR SET09_TM	; Test de présence ennemie.
	BSR SET09_110_R1 ; Affichage du trou.
	BRA SET09B		; Etape suivante.

SET09_110_R1:		; Routine réutilisée par SET09_110_M
	LDD #CH9D		; D = adresse du trou CH9D.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire.

	INC >CH9D		; CH9 marqué comme affiché.
	CLR >H9D		; H9 marqué comme non affiché.
	CLR >G9D		; G9 marqué comme non affiché.
	CLR >W4D		; W4 marqué comme non affiché.
	RTS

; Sol G9
SET09_G:
	CLR >W4D		; W4 marqué comme non affiché.
	CLR >CH9D		; CH9 marqué comme non affiché.
	CLR >H9D		; H9 marqué comme non affiché.
	LDD #G9D		; D = adresse du sol G9.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

;------------------------------------------------------------------------------
; SET09B = deuxième partie de la case G9
;------------------------------------------------------------------------------
SET09B:
	LBSR PAS_GA		; Adresse G9B = Adresse G9 + pas à gauche
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01110000	; Mur ou obstacle %111? 
	BNE SET16		; Non = apparence de sol en G09B => SET16

; Mur ou obstacle. En G09B, seuls les murs et les sols sont visibles.
SET09B_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00001000	; Mur simple?
	BEQ SET09B_W	; Oui => SET09B_W

	CMPA #%00001011	; Mur déplaçable?
	BNE	SET16		; Non = apparence de sol en G09B => SET16

; Mur W31, à réafficher dans tous les cas à cause de G9
SET09B_W:
	LBSR MASK_W31	; Masquage des éléments cachés derrière le mur
	LDD #W31		; D = adresse du mur W31
	LBSR LISTE3_SAV2 ; Appel de W31 empilé dans LISTE3 sans condition
	LDD #W31_REST	; D = adresse de rétablissement des pixels.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	LBRA SET17B		; => Analyse de la case 17B

;------------------------------------------------------------------------------
; SET16 = analyse de la case de G16
; Par économie, les téléporteurs, les échelles, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; En case G16, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET16:
	LBSR PAS_AV		; Adresse G16 = Adresse G9B + pas en avant
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	BCS SET16_G		; Non, sol vide ou type de case ignoré => SET16_G.
	BEQ SET16_101	; Oui => SET16_101. Sinon mur ou obstacle.

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110?
	BNE SET16_W		; Non, mur ou obstacle ignoré => SET16_W.

; Trou dans le plafond occupable par l'ennemi. En G16 pas d'ennemi visible.
SET16_110:
	LDD #CH16		; D = adresse de CH16
	BRA SET16_101_2	; Analyse de la case au-delà de G16.

; Trou dans le sol occupable par un ennemi flottant. En G16 pas d'ennemi visible.
SET16_101:
	LDD #H16		; D = adresse de H16.
SET16_101_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G16D		; G16 marqué comme à réafficher.
	BRA SET16_G0	; Analyse de la case au-delà de G16.

; Mur W9
SET16_W:
	LBSR MASK_W9	; Masquage des éléments cachés derrière le mur
	LDD #W9D		; D = adresse du mur W9
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	BRA SET17B		; => Analyse de la case 17B

; Sol G16 
SET16_G:
	LDD #G16D		; D = adresse du sol G16
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET16_G0:
	CLR >W9D		; W9 marqué comme non affiché

	LBSR PAS_AV		; X pointe la case au-delà de G16
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET16_GW	; Si oui c'est forcémment un mur => SET16_GW

	LBSR PAS_GA		; X pointe la case à gauche de celle au-delà de G16
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET16_G2	; Si oui c'est forcémment un mur => SET16_G2

SET16_G1:
	CLR >B18GAD		; B18GA marqué comme non affiché
	LDD #B18D		; D = adresse du fond B18
	BRA SET16_G3

SET16_G2:
	CLR >B18D		; B18 marqué comme non affiché
	LDD #B18GAD		; D = adresse du fond B18GA

SET16_G3:
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B18_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	CLR >W18D		; W18 marqué comme non affiché
	BRA SET17B

SET16_GW:
	CLR >B18D		; B18 marqué comme non affiché
	CLR >B18GAD		; B18GA marqué comme non affiché
	LDD #W18D		; D = adresse du mur W18
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET17B = deuxième partie de la case G17
; Par économie, les téléporteurs, les portes, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus, mais le trou
; H17B est supprimé car il ne concernait qu'un pixel blanc et un pixel gris.
; En case G17B, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET17B:
	LDX >VARDW1		; X pointe l'adresse de G9
	LBSR PAS_AV		; Adresse G17B = Adresse G9 + pas en avant
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #$70		; Case courante = mur simple vide?
	BNE SET17B_G	; Pas un mur simple => SET17B_G

; Mur W10
SET17B_W:
	LBSR MASK_W10	; Masquage des éléments cachés derrière le mur
	LDD #W10D		; D = adresse du mur W10
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET06		; => Analyse de la case G06

SET17B_G:
	CLR >W10D		; W10 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET17 = première partie de la case G17
; Par économie, les téléporteurs, les échelles, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; En case G17, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET17:
	LBSR PAS_GA		; Adresse G17 = Adresse G17B + pas à gauche
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	BCS SET17_G		; Non, sol vide ou type de case ignoré => SET17_G.
	BEQ SET17_101	; Oui => SET17_101. Sinon mur ou obstacle.

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110?
	BNE SET17_W		; Non, mur ou obstacle ignoré => SET17_W.

; Trou dans le plafond occupable par l'ennemi. En G17 pas d'ennemi visible.
SET17_110:
	LDD #CH17		; D = adresse de CH17
	BRA SET17_101_2	; Analyse de la case au-delà de G17.

; Trou dans le sol occupable par un ennemi flottant. En G17 pas d'ennemi visible.
SET17_101:
	LDD #H17		; D = adresse de H17.
SET17_101_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G17D		; G17 marqué comme à réafficher.
	BRA SET17_G0	; Analyse de la case au-delà de G17.

; Mur W32
SET17_W:
	LBSR MASK_W32	; Masquage des éléments cachés derrière le mur
	LDD #W32D		; D = adresse du mur W32
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	BRA SET06		; => Analyse de la case G06

; Sol G17
SET17_G:
	LDD #G17D		; D = adresse du sol G17
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET17_G0:
	CLR >W32D		; W32 marqué comme non affiché

	LBSR PAS_AV		; X pointe la case au-delà de G17
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET17_GW	; Si oui c'est forcémment un mur => SET17_GW

	CLR >W19D		; W19 marqué comme non affiché
	LDD #B19D		; D = adresse du fond B19
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B19_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	BRA SET06

SET17_GW:
	CLR >B19D		; B19 marqué comme non affiché
	LDD #W19D		; D = adresse du mur W19
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET06 = analyse de la case de G06
;------------------------------------------------------------------------------
SET06:
	LDX >SQRADDR	; X pointe l'adresse de G2
	LBSR PAS_AV		; Adresse G6 = Adresse G2 + pas en avant
	STX >VARDW1		; Adresse de G6 sauvegardée
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00100000	; Echelles %010?
	LBCS SET06_000	; Non, sol %000 ou %001 => SET06_000
	LBEQ SET06_010	; Oui => SET06_010.

	CMPA #%01000000	; Sol simple occupable ou occupé %100? 
	LBEQ SET06_100	; Oui => SET06_100.
	LBCS SET06_011	; Non, téléporteur ou destination %011 => SET06_011.

	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	LBCS SET06_101	; Non, trou dans le sol occupable %101 => SET06_101.
	LBEQ SET06_110	; Oui => SET06_110. Sinon mur ou obstacle.

; Mur ou obstacle.
SET06_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00000100	; Porte fermée?
	LBCS SET06_111_PF ; Oui => SET06_111_PF.

	CMPA #%00001000	; Mur simple %1000?
	LBEQ SET06_W	; Oui => SET06_W.
	BCS SET06_111_PO ; Non, porte ouverte => SET06_111_PO.

	CMPA #%00001010	; Ornement mural 2 %1010?
	BCS SET06_111_O1 ; Non, ornement mural 1 => SET06_111_O1.
	BEQ SET06_111_O2 ; Oui, ornement mural 2 => SET06_111_O2.
	LBRA SET06_W	; Autre = mur.

; Porte fermée
SET06_111_PF:
	BSR SET06_111_PF_R0 ; Affichage des murs, des montants et de la serrure.

	LDD #D06		; D = adresse de la porte D06
	LBRA SET06_011_1

SET06_111_PF_R0:	; Partie commune avec les portes ouvertes
	BSR SET06_111_PF_R5 ; Empilement de G6, W37 et W47

	LDD #DP1		; D = adresse du montant de porte DP1.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDA ,X			; A = code de la case courante.
	ANDA #%00000011	; A = type de serrure.
	BEQ SET06_111_PF_R1 ; %00 = serrure jaune => SET06_111_PF_R1

	CMPA #%00000010	; Serrure rouge %10?
	BEQ SET06_111_PF_R3 ; Oui => SET06_111_PF_R3
	BCS SET06_111_PF_R2 ; Non, bleue %01 => SET06_111_PF_R2. Sinon, c'est bouton %11.

	LDD #DL4_OFF	; D = adresse du bouton DL4 en position OFF
	BRA SET06_111_PF_R4

SET06_111_PF_R3:	; Serrure rouge.
	LDD #DL3		; D = adresse de la serrure rouge.
	BRA SET06_111_PF_R4

SET06_111_PF_R2:	; Serrure bleue.
	LDD #DL2		; D = adresse de la serrure bleue.
	BRA SET06_111_PF_R4

SET06_111_PF_R1:	; Serrure jaune.
	LDD #DL1		; D = adresse de la serrure jaune.

SET06_111_PF_R4:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #DL_REST	; D = adresse de rétablissement des couleurs.
	LBRA LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

SET06_111_PF_R5:
	LDD #G6D		; D = adresse du sol G6.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

SET06_111_PF_R6:
	LDD #W37D		; D = adresse du mur W37.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	LDD #W47D		; D = adresse du mur W47.
	LBRA LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

; Porte ouverte
SET06_111_PO:
	BSR SET06_111_PF_R0 ; Affichage des murs, des montants et de la serrure.

	LDD #DP3		; D = adresse du montant de porte DP3.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #DP3H		; D = adresse de la barre noire du montant DP3. 
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #DP3_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LBRA SET12		; Etape suivante.

; Ornement 1 = bannière Baphomet
SET06_111_O1:
	BSR SET06_111_PF_R5 ; Empilement de G6, W37 et W47.
	LDD #BAN06		; D = adresse de BAN06.
	BRA SET06_011_1

; Ornement 2 = têtes sur des piques
SET06_111_O2:
	BSR SET06_111_PF_R5 ; Empilement de G6, W37 et W47.
	LDD #W6D		; D = adresse du mur W6.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LDD #ORN06		; D = adresse de ORN06.
	BRA SET06_011_1

; Sol %000 avec ou sans objet, ou sol %001 avec ou sans arme ou munition.
SET06_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	LBEQ SET06_G	; Case vide = sol simple => SET06_G

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_06
	LDD #CHEST06
	STD >LISTE4_06+1 ; Appel au coffre G6 empilé dans LISTE4

	LDD #REST06B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LBRA SET06_G	; Affichage du sol => SET06_G

; Echelles.
SET06_010:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BNE SET06_010_M	; Echelle montante => SET06_010_M

; Echelle descendante.
SET06_010_D:
	LBSR SET06_101_R1 ; Affichage du trou dans le sol => SET06_101_R1.

	LDD #L06D		; D = adresse de l'échelle descendante.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #L06D_REST	; D = adresse de rétablissement des couleurs.
	BRA SET06_010_M2 ; Etape suivante.

; Echelle montante.
SET06_010_M:
	LBSR SET06_110_R1 ; Affichage du trou dans le plafond => SET06_110_R1.

	LDD #L06U		; D = adresse de l'échelle montante.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #L06U_REST	; D = adresse de rétablissement des couleurs.

SET06_010_M2:
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LDD #W6D		; D = adresse du mur W6.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	LBSR SET06_111_PF_R6 ; Empilement de W37 et W47.

	LDD #W46D		; D = adresse du mur W46.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LBSR MASK_W46	; Tout ce qu'il y a derrière W46 est à réafficher.

	CLR >W2D		; W2 marqué comme à réafficher à cause de l'échelle.
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a derrière.

	LBRA SET_FIN	; => SET_FIN.

; Téléporteur ou destination de téléporteur.
SET06_011:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	CMPA #%00001000	; Destination de téléporteur?
	LBCC SET06_G	; Oui, donc apparence de sol simple => SET06_G

	LDA #%00000010	; Etat de jeu = Téléporteur visible en secteur G6.
	STA >STATEF

	LBSR SET06_111_PF_R5 ; Empilement de G6, W37 et W47.

	LDD #TEL06		; D = adresse de TEL06.

SET06_011_1:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #D06_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	CLR >W2D		; W2 marqué comme non affiché.
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a derrière.

	LBRA SET03		; Etape suivante.

; Sol simple occupé ou occupable par un ennemi.
SET06_100:
	LBSR SET06_TM	; Test de présence ennemie.
	BRA SET06_G		; => Affichage du sol et étape suivante.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET06_101:
	LBSR SET06_TM	; Test de présence ennemie.
	BSR SET06_101_R1 ; Affichage du trou.
	BRA SET05		; Etape suivante.

SET06_101_R1:		; Réutilisé par SET06_010_D.
	LDA >H6D
	BNE SET06_101_R2 ; Si trou déjà affiché => SET06_101_R2

	LDD #H6			; D = adresse du trou entier.
	BRA SET06_101_R3

SET06_101_R2:
	LDD #H6_2		; D = adresse des pixels à raffraichir.

SET06_101_R3:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	LDD #H6_REST	; D = adresse de rétablissement des pixels rafraichis.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	INC >H6D		; H6 marqué comme affiché.
	CLR >W2D		; W2 marqué comme non affiché.
	CLR >CH6D		; CH6 marqué comme non affiché.
	CLR >G6D		; G6 marqué comme non affiché.
	RTS

; Trou dans le plafond occupable par l'ennemi.
SET06_110:
	LBSR SET06_TM	; Test de présence ennemie.
	BSR SET06_110_R1 ; Affichage du trou => SET06_110_R1.
	BRA SET05		; Etape suivante.

SET06_110_R1:		; Réutilisé par SET06_010_M.
	LDA >CH6D
	BNE SET06_110_R2 ; Si trou déjà affiché => SET06_110_R2

	LDD #CH6		; D = adresse du trou entier.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	BRA SET06_110_R3

SET06_110_R2:
	LDD #CH6_2		; D = adresse des pixels à raffraichir.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

SET06_110_R3:
	LDD #CH6_REST	; D = adresse de rétablissement des pixels rafraichis.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	INC >CH6D		; CH6 marqué comme affiché.
	CLR >H6D		; H6 marqué comme non affiché.
	CLR >G6D		; G6 marqué comme non affiché.
	CLR >W2D		; W2 marqué comme non affiché.
	RTS

; Mur W2
SET06_W:
	LBSR MASK_W2	; Masquage des éléments cachés derrière le mur.
	LDD #W2D		; D = adresse du mur W2.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LBRA SET03		; => Analyse de la case G03.

; Sol G6
SET06_G:
	CLR >W2D		; W2 marqué comme non affiché.
	CLR >H6D		; H6 marqué comme non affiché.
	CLR >CH6D		; CH6 marqué comme non affiché.
	LDD #G6D		; D = adresse du sol G6
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire

;------------------------------------------------------------------------------
; SET05 = analyse de la case de G05
; En G5 les échelles sont interdites, car il faut deux cases de profondeur dans
; le couloir. Et les objets et les ennemis ne sont pas visibles sur cette case.
;------------------------------------------------------------------------------
SET05:
	LBSR PAS_GA		; Adresse G5 = Adresse G6 + pas à gauche
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupable %101? 
	BEQ SET05_101	; Oui => SET05_101.
	BCS SET05_G		; Non, sol simple %000,%001,%100 escalier %010 ou téléporteur
					; ou destination %011 = apparence de sol en G5 => SET05_G.
	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BEQ SET05_110	; Oui => SET05_110. Sinon mur ou obstacle.

; Mur ou obstacle. En G5, seuls les murs et les sols sont visibles.
SET05_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00001000	; Mur simple?
	BEQ SET05_W		; Oui => SET05_W

	CMPA #%00001011	; Mur déplaçable?
	BEQ SET05_W		; Oui => SET05_W
	BRA	SET05_G		; Autre = apparence de sol en G5 => SET05_G

; Trou dans le sol occupable par un ennemi flottant. En G5 pas d'ennemi visible.
SET05_101:
	LDD #H5			; D = adresse de H5.
	BRA SET05_110_2	; Etape suivante => SET05_110_2

; Trou dans le plafond occupable par l'ennemi. En G5 pas d'ennemi visible.
SET05_110:
	LDD #CH5		; D = adresse de CH5
SET05_110_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G5D		; G5 marqué comme à réafficher.
	BRA SET05_G0	; Etape suivante => SET05_G0

; Mur W37
SET05_W:
	LBSR MASK_W37	; Masquage des éléments cachés derrière le mur.
	LDD #W37D		; D = adresse du mur W37.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LBRA SET12		; => Analyse de la case G12.

; Sol G5
SET05_G:
	LDD #G5D		; D = adresse du sol G5.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
SET05_G0:
	CLR >W37D		; W37 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET10 = analyse de la case de G10
; Par économie, les téléporteurs, les portes et les ornements types 1 et 2 ne 
; sont pas affichés à cette distance. Les échelles sont maintenues mais elles 
; ne sont pas visibles sur cette case. Les trous sont maintenus.
;------------------------------------------------------------------------------
SET10:
	LBSR PAS_AV		; Adresse G10 = Adresse G5 + pas en avant.
	STX >VARDW2		; Sauvegarde de l'adresse.
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type.

	CMPA #%00100000	; Echelles %010?
	BCS SET10_000	; Non, sol %000 ou %001 => SET10_000

	CMPA #%01000000	; Sol simple occupable ou occupé %100? 
	BEQ SET10_100	; Oui => SET10_100.
	BCS SET10_G		; Non, échelles ou téléporteur ignorés => SET10_G.

	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BCS SET10_101	; Non, trou dans le sol occupable %101 => SET10_101.
	BEQ SET10_110	; Oui => SET10_110. Sinon mur ou obstacle ignoré => SET10_W.

; Mur W5
SET10_W:
	LBSR MASK_W5	; Masquage des éléments cachés derrière le mur.
	LDD #W5D		; D = adresse du mur W5.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LBRA SET12		; => Analyse de la case G12.

; Sol %000 avec ou sans objet, ou sol %001 avec ou sans arme ou munition.
SET10_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BEQ SET10_G		; Case vide = sol simple => SET10_G

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_10
	LDD #CHEST10
	STD >LISTE4_10+1 ; Appel au coffre G10 empilé dans LISTE4

	LDD #REST10B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	BRA SET10_G		; Affichage du sol => SET10_G

; Sol simple occupé ou occupable par un ennemi.
SET10_100:
	BSR SET10_TM	; Test de présence ennemie.
	BRA SET10_G		; Affichage du sol puis étape suivante.

; Traitement des ennemis en G10
SET10_TM:
	LDU #E0X_G10	; U pointe les adresses des ennemis en G10.
	LDY #LISTE4_10	; Y pointe la liste 4.
	LBRA SETXX_TM	; Si ennemi présent, empilement en listes 4 et liste 0.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET10_101:
	LDD #H10D		; D = adresse du trou entier.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire.

	INC >H10D		; H10 marqué comme affiché.
	CLR >CH10D		; CH10 marqué comme non affiché.
	BRA SET10_110_1

; Trou dans le plafond occupable par l'ennemi.
SET10_110:
	LDD #CH10D		; D = adresse du trou entier.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire.

	INC >CH10D		; CH10 marqué comme affiché.
	CLR >H10D		; H10 marqué comme non affiché.

SET10_110_1:
	CLR >G10D		; G10 marqué comme à réafficher.
	BSR SET10_TM	; Test de présence ennemie.
	CLR >W5D		; W5 marqué comme non affiché.
	BRA SET10_G0	; Etape suivante.

; Sol G10
SET10_G:
	CLR >CH10D		; CH10 marqué comme non affiché.
	CLR >H10D		; H10 marqué comme non affiché.
	LDD #G10D		; D = adresse du sol G10.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
SET10_G0:
	CLR >W5D		; W5 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET18 = première partie de la case G18
; Par économie, les téléporteurs, les échelles, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
;------------------------------------------------------------------------------
SET18:
	LDX >VARDW2		; X pointe l'adresse de G10.
	LBSR PAS_AV		; Adresse G18 = Adresse G10 + pas en avant
	STX >VARDW2		; Adresse de G18 sauvegardée
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00100000	; Echelles 010?
	BCS SET18_000	; Non, sol %000 ou %001 => SET18_000

	CMPA #%01000000	; Sol simple occupé ou occupable %100? 
	BEQ SET18_100	; Oui => SET18_100.
	BCS SET18_G		; Non, échelle ou téléporteur ignoré => SET18_G

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110? 
	BCS SET18_101	; Non, trou dans le sol occupé ou occupable %101 => SET18_101.
	BEQ SET18_110	; Oui => SET18_110.	Sinon, mur ou obstacle ignoré => SET18_W

; Mur W11
SET18_W:
	LBSR MASK_W11	; Masquage des éléments cachés derrière le mur
	LDD #W11D		; D = adresse du mur W11
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET12		; => Analyse de la case G12

; Sol simple interdit aux ennemis, vide ou avec arme ou munition.
SET18_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BEQ SET18_G		; Case vide = sol simple => SET18_G.

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_18
	LDD #CHEST18
	STD >LISTE4_18+1 ; Appel au coffre G18 empilé dans LISTE4

	LDD #REST18B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	BRA SET18_G		; Affichage du sol => SET18_G

; Sol simple occupé ou occupable par un ennemi.
SET18_100:
	BSR SET18_TM	; Test de présence ennemie.
	BRA SET18_G		; Affichage du sol puis étape suivante.

; Traitement des ennemis en G18
SET18_TM:
	LDU #E0X_G18	; U pointe les adresses des ennemis en G18.
	LDY #LISTE4_18	; Y pointe la liste 4.
	LBRA SETXX_TM	; Si ennemi présent, empilement en listes 4 et liste 0.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET18_101:
	LDD #H18		; D = adresse du trou entier.
	BRA SET18_110_1	; Test de présence ennemi puis étape suivante.

; Trou dans le plafond occupable par l'ennemi.
SET18_110:
	LDD #CH18		; D = adresse du trou entier.

SET18_110_1:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	BSR SET18_TM	; Test de présence ennemie.
	LDD #G18D		; D = adresse du sol G18
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2, si pas déjà affiché.
	CLR >G18D		; G18 marqué comme à réafficher.
	BRA SET18_G0	; => Analyse du fond de G18.

; Sol G18
SET18_G:
	LDD #G18D		; D = adresse du sol G18
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET18_G0:
	CLR >W11D		; W11 marqué comme non affiché

	LDX >VARDW2		; X pointe l'adresse de la case G18,
	LBSR PAS_AV		; puis la case au-delà de G18.
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET18_GW	; Si oui c'est forcémment un mur => SET18_GW

	LBSR PAS_GA		; X pointe la case à gauche de celle au-delà de G18
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET18_G2	; Si oui c'est forcémment un mur => SET18_G2

SET18_G1:
	CLR >B21GAD		; B21GA marqué comme non affiché
	LDD #B21D		; D = adresse du fond B21
	BRA SET18_G3

SET18_G2:
	CLR >B21D		; B21 marqué comme non affiché
	LDD #B21GAD		; D = adresse du fond B21GA

SET18_G3:
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B21_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	CLR >W21D		; W21 marqué comme non affiché
	BRA SET18B

SET18_GW:
	CLR >B21D		; B21 marqué comme non affiché
	CLR >B21GAD		; B21GA marqué comme non affiché
	LDD #W21D		; D = adresse du mur W21
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET18B = deuxième partie de la case G18
; Par économie, les téléporteurs, les portes, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; En case G18B, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET18B:
	LDX >VARDW2		; X pointe l'adresse de G18
	LBSR PAS_GA		; Adresse G18B = Adresse G18 + pas à gauche
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	BCS SET18B_G	; Non, sol vide ou type de case ignoré => SET18B_G.
	BEQ SET18B_101	; Oui => SET18B_101. Sinon mur ou obstacle.

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110?
	BNE SET18B_W	; Non, mur ou obstacle ignoré => SET18B_W.

; Trou dans le plafond occupable par l'ennemi. En G18B pas d'ennemi visible.
SET18B_110:
	LDD #CH18B		; D = adresse de CH18B
	BRA SET18B_101_1 ; Analyse de la case au-delà de G18B.

; Trou dans le sol occupable par un ennemi flottant. En G18B pas d'ennemi visible.
SET18B_101:
	LDD #H18B		; D = adresse de H18B

SET18B_101_1:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	CLR >G18D		; G18 marqué comme non affiché.
	BRA SET18B_G	; Analyse de la case au-delà de G18B.

; Mur W33, à réafficher dans tous les cas à cause de G18
SET18B_W:
	LBSR MASK_W33	; Masquage des éléments cachés derrière le mur
	LDD #W33		; D = adresse du mur W33
	LBSR LISTE2_SAV2 ; Appel de W33 empilé dans la liste d'appel sans condition
	LDA #1
	STA >W33D		; W33 marqué comme affiché
	BRA SET12

; Sol G18B
SET18B_G:
	CLR >W33D		; W33 marqué comme non affiché

	LBSR PAS_AV		; X pointe la case au-delà de G18B
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET18B_GW	; Si oui c'est forcémment un mur => SET18B_GW

	CLR >W20D		; W20 marqué comme non affiché
	LDD #B20D		; D = adresse du fond B20
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B20_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	BRA SET12

SET18B_GW:
	CLR >B20D		; B20 marqué comme non affiché
	LDD #W20D		; D = adresse du mur W20
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET12 = analyse de la case de G12
; Par économie, les téléporteurs, les portes et les ornements types 1 et 2 ne
; sont pas affichés à cette distance. Les trous et les échelles sont maintenus.
;------------------------------------------------------------------------------
SET12:
	LDX >VARDW1		; X pointe l'adresse de G6
	LBSR PAS_AV		; Adresse G12 = Adresse G6 + pas en avant
	STX >VARDW2		; Adresse de G12 mémorisée
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00100000	; Echelles 010?
	BEQ SET12_010	; Oui => SET12_010.
	BCS SET12_000	; Non, sol %000 ou %001 => SET12_000.

	CMPA #%01000000	; Sol simple occupé ou occupable %100? 
	BEQ SET12_100	; Oui => SET12_100.
	LBCS SET12_G	; Non, téléporteur ignoré = sol simple => SET12_G

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110? 
	BCS SET12_101	; Non, trou dans le plafond occupé ou occupable %101 => SET12_101.
	LBEQ SET12_110	; Oui => SET12_110. Sinon mur ou obstacle ignoré => SET12_W.

; Mur W6
SET12_W:
	LDD #W6D		; D = adresse du mur W6.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LBSR MASK_W6	; Masquage des éléments cachés derrière le mur
	LBRA SET07		; => Analyse de la case de G7

; Sol simple interdit aux ennemis, vide ou avec arme ou munition.
SET12_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	LBEQ SET12_G	; Case vide = sol simple => SET12_G.

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_12
	LDD #CHEST12
	STD >LISTE4_12+1 ; Appel au coffre G12 empilé dans LISTE4

	LDD #REST12B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LBRA SET12_G	; Affichage du sol => SET12_G

; Echelles.
SET12_010:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BNE SET12_010_M	; Echelle montante => SET12_010_M

; Echelle descendante.
SET12_010_D:
	BSR SET12_101_R1 ; Affichage du trou dans le sol => SET12_101_R1.

	LDD #L12D		; D = adresse de l'échelle descendante.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #L12D_REST	; D = adresse de rétablissement des couleurs.
	BRA SET12_010_M2 ; Etape suivante.

; Echelle montante.
SET12_010_M:
	BSR SET12_110_R1 ; Affichage du trou dans le plafond => SET12_110_R1.

	LDD #L12U		; D = adresse de l'échelle montante.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #L12U_REST	; D = adresse de rétablissement des couleurs.

SET12_010_M2:
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LDD #W38D		; D = adresse du mur W38.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	LDD #W13D		; D = adresse du mur W13.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	LDD #W48D		; D = adresse du mur W48.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	LDD #W47D		; D = adresse du mur W47.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	CLR >W2D		; W2 marqué comme non affiché.
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a derrière.

	LBRA SET03		; Etape suivante.

; Sol simple occupé ou occupable par un ennemi.
SET12_100:
	LBSR SET12_TM	; Test de présence ennemie.
	BRA SET12_G		; => Affichage du sol et étape suivante.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET12_101:
	LBSR SET12_TM	; Test de présence ennemie.
	BSR SET12_101_R1 ; Affichage du trou.
	BRA SET11		; Etape suivante.

SET12_101_R1:		; Réutilisé par SET12_010_D.
	LDA >H12D
	BNE SET12_101_R2 ; Si trou déjà affiché => SET12_101_R2

	LDD #H12		; D = adresse du trou entier.
	BRA SET12_101_R3

SET12_101_R2:
	LDD #H12_2		; D = adresse des pixels à raffraichir.

SET12_101_R3:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	LDD #H12_REST	; D = adresse de rétablissement des pixels rafraichis.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	INC >H12D		; H12 marqué comme affiché.
	CLR >CH12D		; CH12 marqué comme non affiché.
	CLR >G12D		; G12 marqué comme non affiché.
	CLR >W6D		; W6 marqué comme non affiché.
	RTS

; Trou dans le plafond occupable par l'ennemi.
SET12_110:
	LBSR SET12_TM	; Test de présence ennemie.
	BSR SET12_110_R1 ; Affichage du trou => SET12_110_R1.
	BRA SET11		; Etape suivante.

SET12_110_R1:		; Sous-routine aussi utilisée par SET12_010_M.
	LDA >CH12D
	BNE SET12_110_R2 ; Si trou déjà affiché => SET12_110_R2

	LDD #CH12		; D = adresse du trou entier.
	BRA SET12_110_R3

SET12_110_R2:
	LDD #CH12_2		; D = adresse des pixels à raffraichir.

SET12_110_R3:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	LDD #CH12_REST	; D = adresse de rétablissement des pixels rafraichis.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	INC >CH12D		; CH12 marqué comme affiché.
	CLR >H12D		; H12 marqué comme non affiché.
	CLR >G12D		; G12 marqué comme non affiché.
	CLR >W6D		; W6 marqué comme non affiché.
	RTS

; Sol G12
SET12_G:
	CLR >W6D		; W6 marqué comme non affiché.
	CLR >CH12D		; CH12 marqué comme non affiché.
	CLR >H12D		; H12 marqué comme non affiché.
	LDD #G12D		; D = adresse du sol G12
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire

;------------------------------------------------------------------------------
; SET11 = analyse de la case de G11
; Par économie, les téléporteurs, les portes et les ornements types 1 et 2 ne 
; sont pas affichés à cette distance. Les échelles sont maintenues mais elles 
; ne sont pas visibles sur cette case. Les trous sont maintenus.
;------------------------------------------------------------------------------
SET11:
	LBSR PAS_GA		; Adresse G11 = Adresse G12 + pas à gauche
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupable %101? 
	BEQ SET11_101	; Oui => SET11_101.
	BCS SET11_G		; Non, sol simple %000,%001,%100 escalier %010 ou téléporteur
					; ou destination %011 = apparence de sol en G11 => SET11_G.
	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BEQ SET11_110	; Oui => SET11_110. Sinon mur ou obstacle.

; Mur ou obstacle. En G11, seuls les murs et les sols sont visibles.
SET11_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00001000	; Mur simple?
	BEQ SET11_W		; Oui => SET11_W

	CMPA #%00001011	; Mur déplaçable?
	BEQ SET11_W		; Oui => SET11_W
	BRA	SET11_G		; Autre = apparence de sol en G11 => SET11_G

; Trou dans le sol occupable par un ennemi flottant. En G11 pas d'ennemi visible.
SET11_101:
	LDD #H11		; D = adresse de H11.
	BRA SET11_110_2	; Etape suivante => SET11_110_2

; Trou dans le plafond occupable par l'ennemi. En G11 pas d'ennemi visible.
SET11_110:
	LDD #CH11		; D = adresse de CH11
SET11_110_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G11D		; G11 marqué comme à réafficher.
	BRA SET11_G0	; Etape suivante => SET11_G0

; Mur W38
SET11_W:
	LBSR MASK_W38	; Masquage des éléments cachés derrière le mur
	LDD #W38D		; D = adresse du mur W38
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET21		; => Analyse de la case de SET21

; Sol G11
SET11_G:
	LDD #G11D		; D = adresse du sol G11.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
SET11_G0:
	CLR >W38D		; W38 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET19 = analyse de la case de G19
; Par économie, les téléporteurs, les échelles, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; Les objets et les armes ne sont pas visibles en G19, seulement en G18.
;------------------------------------------------------------------------------
SET19:
	LBSR PAS_AV		; Adresse G19 = Adresse G11 + pas en avant.
	STX >VARDW3		; Sauvegarde de l'adresse.
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type.

	CMPA #%00100000	; Echelles 010?
	BCS SET19_000	; Non, sol %000 ou %001 => SET19_000

	CMPA #%01000000	; Sol simple occupé ou occupable %100? 
	BEQ SET19_100	; Oui => SET19_100.
	BCS SET19_G		; Non, échelle ou téléporteur ignoré => SET19_G

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110? 
	BCS SET19_101	; Non, trou dans le sol occupé ou occupable %101 => SET19_101.
	BEQ SET19_110	; Oui => SET19_110. Sinon, mur ou obstacle ignoré => SET19_W

; Mur W12
SET19_W:
	LBSR MASK_W12	; Masquage des éléments cachés derrière le mur
	LDD #W12D		; D = adresse du mur W12
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	BRA SET21		; => Analyse de la case de SET21

; Sol simple interdit aux ennemis, vide ou avec arme ou munition.
SET19_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BEQ SET19_G		; Case vide = sol simple => SET19_G.

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_19
	LDD #CHEST19
	STD >LISTE4_19+1 ; Appel au coffre G19 empilé dans LISTE4

	LDD #REST19B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	BRA SET19_G		; Affichage du sol => SET19_G

; Sol simple occupé ou occupable par un ennemi.
SET19_100:
	BSR SET19_TM	; Test de présence ennemie.
	BRA SET19_G	; Affichage du sol puis étape suivante.

; Traitement des ennemis en G19
SET19_TM:
	LDU #E0X_G19	; U pointe les adresses des ennemis en G19.
	LDY #LISTE4_19	; Y pointe la liste 4.
	LBRA SETXX_TM	; Si ennemi présent, empilement en listes 4 et liste 0.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET19_101:
	LDD #H19		; D = adresse du trou entier.
	BRA SET19_110_1

; Trou dans le plafond occupable par l'ennemi.
SET19_110:
	LDD #CH19		; D = adresse du trou entier.

SET19_110_1:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G19D		; G19 marqué comme à réafficher.
	BSR SET19_TM	; Test de présence ennemie.
	BRA SET19_G0	; => Analyse du fond de G19.

; Sol G19
SET19_G:
	LDD #G19D		; D = adresse du sol G19
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET19_G0:
	CLR >W12D		; W12 marqué comme non affiché.

	LDX >VARDW3		; X pointe l'adresse de la case G19,
	LBSR PAS_AV		; puis la case au-delà de G19.
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET19_GW	; Si oui c'est forcémment un mur => SET19_GW

	CLR >W22D		; W22 marqué comme non affiché
	LDD #B22D		; D = adresse du fond B22
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B22_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	BRA SET21

SET19_GW:
	CLR >B22D		; B22 marqué comme non affiché
	LDD #W22D		; D = adresse du mur W22
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET21 = analyse de la case de G21
; Par économie, les téléporteurs, les échelles, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
;------------------------------------------------------------------------------
SET21:
	LDX >VARDW2		; X pointe l'adresse de G12
	LBSR PAS_AV		; Adresse G21 = Adresse G12 + pas en avant
	STX >VARDW3		; Adresse de G21 mémorisée
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00100000	; Echelles 010?
	BCS SET21_000	; Non, sol %000 ou %001 => SET21_000

	CMPA #%01000000	; Sol simple occupé ou occupable %100? 
	BEQ SET21_100	; Oui => SET21_100.
	LBCS SET21_G	; Non, échelles ou téléporteur ignoré => SET21_G0

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110? 
	BCS SET21_101	; Non, trou dans le sol occupé ou occupable %101 => SET21_101.
	BEQ SET21_110	; Oui => SET21_110. Sinon mur ou obstacle ignoré => SET21_W.

; Mur W13
SET21_W:
	LBSR MASK_W13	; Masquage des éléments cachés derrière le mur
	LDD #W13D		; D = adresse du mur W13
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET13		; => Analyse de la case G13

; Sol simple interdit aux ennemis, vide ou avec arme ou munition.
SET21_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BEQ SET21_G		; Case vide = sol simple => SET21_G.

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_21
	LDD #CHEST21
	STD >LISTE4_21+1 ; Appel au coffre G21 empilé dans LISTE4

	LDD #REST21B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	BRA SET21_G		; Affichage du sol => SET21_G

; Sol simple occupé ou occupable par un ennemi.
SET21_100:
	LBSR SET21_TM	; Test de présence d'un ennemi.
	BRA SET21_G		; Affichage du sol puis étape suivante.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET21_101:
	LBSR SET21_TM	; Test de présence d'un ennemi.
	BSR SET21_101_R1 ; Affichage du trou.
	BRA SET21_G0	; Analyse de la case au-delà de G21 => SET21_G0.

SET21_101_R1:		; Sous-routine aussi utilisée par SET21_010_D.
	LDA >H21D
	BNE SET21_101_R2 ; Si trou déjà affiché => SET21_101_R2

	LDD #H21		; D = adresse du trou entier.
	BRA SET21_101_R3

SET21_101_R2:
	LDD #H21_2		; D = adresse des pixels à raffraichir.

SET21_101_R3:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	LDD #H21_REST	; D = adresse de rétablissement des pixels rafraichis.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	INC >H21D		; H21 marqué comme affiché.
	CLR >CH21D		; CH21 marqué comme non affiché.
	CLR >G21D		; G21 marqué comme non affiché.
	RTS

; Trou dans le plafond occupable par l'ennemi.
SET21_110:
	LBSR SET21_TM	; Test de présence d'un ennemi.
	BSR SET21_110_R1 ; Affichage du trou => SET21_110_R1.
	BRA SET21_G0	; Analyse de la case au-delà de G21 => SET21_G0.

SET21_110_R1:		; Sous-routine aussi utilisée par SET21_010_M.
	LDA >CH21D
	BNE SET21_110_R2 ; Si trou déjà affiché => SET21_110_R2

	LDD #CH21		; D = adresse du trou entier.
	BRA SET21_110_R3

SET21_110_R2:
	LDD #CH21_2		; D = adresse des pixels à raffraichir.

SET21_110_R3:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	LDD #CH21_REST	; D = adresse de rétablissement des pixels rafraichis.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	INC >CH21D		; CH21 marqué comme affiché.
	CLR >H21D		; H21 marqué comme non affiché.
	CLR >G21D		; G21 marqué comme non affiché.
	RTS

; Sol G21
SET21_G:
	LDD #G21D		; D = adresse du sol G21
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire
	CLR >CH21D		; CH21 marqué comme non affiché.
	CLR >H21D		; H21 marqué comme non affiché.

SET21_G0:
	CLR >W13D		; W13 marqué comme non affiché

	LBSR PAS_AV		; X pointe la case au-delà de G21
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET21_GW	; Si oui c'est forcémment un mur => SET21_GW

	LBSR PAS_GA		; X pointe la case à gauche de celle au-delà de G21
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET21_G2	; Si oui c'est forcémment un mur => SET21_G2

	LBSR PAS_DR
	LBSR PAS_DR		; X pointe la case à droite de celle au-delà de G21
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET21_G1B	; Si oui c'est forcémment un mur => SET21_G1B

SET21_G1A:
	LDD #B24D		; D = adresse du fond B24
	CLR >B24DRD		; B24DR marqué comme non affiché
	BRA SET21_G1B2

SET21_G1B:
	LDD #B24DRD		; D = adresse du fond B24DR
	CLR >B24D		; B24 marqué comme non affiché
SET21_G1B2:
	CLR >B24GAD		; B24GA marqué comme non affiché
	CLR >B24GDD		; B24GD marqué comme non affiché
	BRA SET21_G3

SET21_G2:
	LBSR PAS_DR
	LBSR PAS_DR		; X pointe la case à droite de celle au-delà de G21
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET21_G2B	; Si oui c'est forcémment un mur => SET21_G2B

SET21_G2A:
	LDD #B24GAD		; D = adresse du fond B24GA
	CLR >B24GDD		; B24GD marqué comme non affiché
	BRA SET21_G2B2

SET21_G2B:
	LDD #B24GDD		; D = adresse du fond B24GD
	CLR >B24GAD		; B24GA marqué comme non affiché
SET21_G2B2:
	CLR >B24D		; B24 marqué comme non affiché
	CLR >B24DRD		; B24DR marqué comme non affiché

SET21_G3:
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B24_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	CLR >W24D		; W24 marqué comme non affiché
	BRA SET20

SET21_GW:
	CLR >B24D		; B24 marqué comme non affiché
	CLR >B24GAD		; B24GA marqué comme non affiché
	CLR >B24DRD		; B24DR marqué comme non affiché
	CLR >B24GDD		; B24GD marqué comme non affiché
	LDD #W24D		; D = adresse du mur W24
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET20 = analyse de la case de G20
; Par économie, les téléporteurs, les portes, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; En case G20, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET20:
	LDX >VARDW3		; X pointe l'adresse de G21
	LBSR PAS_GA		; Adresse G20 = Adresse G21 + pas à gauche
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	BCS SET20_G		; Non, sol vide ou type de case ignoré => SET20_G.
	BEQ SET20_101	; Oui => SET20_101. Sinon mur ou obstacle.

	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BEQ SET20_110	; Oui => SET20_110. Sinon mur ou obstacle.

; Mur ou obstacle. En G20, seuls les murs et les sols sont visibles.
SET20_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00001000	; Mur simple?
	BEQ SET20_W		; Oui => SET20_W

	CMPA #%00001011	; Mur déplaçable?
	BEQ SET20_W		; Oui => SET20_W
	BRA	SET20_G		; Autre = apparence de sol en G20 => SET20_G

; Trou dans le plafond occupable par l'ennemi. En G20 pas d'ennemi visible.
SET20_110:
	LDD #CH20		; D = adresse de CH20
	BRA SET20_101_2	; Analyse de la case au-delà de G20.

; Trou dans le sol occupable par un ennemi flottant. En G20 pas d'ennemi visible.
SET20_101:
	LDD #H20		; D = adresse de H20.
SET20_101_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G20D		; G20 marqué comme à réafficher.
	BRA SET20_G0	; Analyse de la case au-delà de G20.

; Mur W39
SET20_W:
	LBSR MASK_W39	; Masquage des éléments cachés derrière le mur
	LDD #W39D		; D = adresse du mur W39
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	BRA SET22		; => Analyse de la case de SET22

; Sol G20
SET20_G:
	LDD #G20D		; D = adresse du sol G20
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET20_G0:
	CLR >W39D		; W39 marqué comme non affiché

	LBSR PAS_AV		; X pointe la case au-delà de G20
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET20_GW	; Si oui c'est forcémment un mur => SET20_GW

	CLR >W23D		; W23 marqué comme non affiché
	LDD #B23D		; D = adresse du fond B23
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B23_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	BRA SET22

SET20_GW:
	CLR >B23D		; B23 marqué comme non affiché
	LDD #W23D		; D = adresse du mur W23
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET22 = analyse de la case de G22
; Par économie, les téléporteurs, les portes, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; En case G22, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET22:
	LDX >VARDW3		; X pointe l'adresse de G21
	LBSR PAS_DR		; Adresse G22 = Adresse G21 + pas à droite
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	BCS SET22_G		; Non, sol vide ou type de case ignoré => SET22_G.
	BEQ SET22_101	; Oui => SET22_101. Sinon mur ou obstacle.

	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BEQ SET22_110	; Oui => SET22_110. Sinon mur ou obstacle.

; Mur ou obstacle. En G22, seuls les murs et les sols sont visibles.
SET22_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00001000	; Mur simple?
	BEQ SET22_W		; Oui => SET22_W

	CMPA #%00001011	; Mur déplaçable?
	BEQ SET22_W		; Oui => SET20_W
	BRA	SET22_G		; Autre = apparence de sol en G22 => SET22_G

; Trou dans le plafond occupable par l'ennemi. En G22 pas d'ennemi visible.
SET22_110:
	LDD #CH22		; D = adresse de CH22
	BRA SET22_101_2	; Analyse de la case au-delà de G22.

; Trou dans le sol occupable par un ennemi flottant. En G22 pas d'ennemi visible.
SET22_101:
	LDD #H22		; D = adresse de H22.
SET22_101_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G22D		; G22 marqué comme à réafficher
	BRA SET22_G0	; Analyse de la case au-delà de G22.

; Mur W49
SET22_W:
	LBSR MASK_W49	; Masquage des éléments cachés derrière le mur
	LDD #W49D		; D = adresse du mur W49
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	BRA SET13		; => Analyse de la case de SET13

; Sol G22
SET22_G:
	LDD #G22D		; D = adresse du sol G22
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET22_G0:
	CLR >W49D		; W49 marqué comme non affiché

	LBSR PAS_AV		; X pointe la case au-delà de G22
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET22_GW	; Si oui c'est forcémment un mur => SET22_GW

	CLR >W25D		; W25 marqué comme non affiché
	LDD #B25D		; D = adresse du fond B25
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B25_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	BRA SET13

SET22_GW:
	CLR >B25D		; B25 marqué comme non affiché
	LDD #W25D		; D = adresse du mur W25
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET13 = analyse de la case de G13
; Par économie, les téléporteurs et les portes ne sont pas affichés à cette 
; distance. Les échelles sont maintenues mais ne sont pas visibles sur cette
; case. Les trous et les ornements muraux sont également maintenus.
;------------------------------------------------------------------------------
SET13:
	LDX >VARDW2		; X pointe l'adresse de G12
	LBSR PAS_DR		; Adresse G13 = Adresse G12 + pas à droite
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupable %101? 
	BEQ SET13_101	; Oui => SET13_101.
	BCS SET13_G		; Non, échelles ou téléporteur ignorés => SET13_G.

	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BEQ SET13_110	; Oui => SET13_110. Sinon mur ou obstacle.

; Mur ou obstacle. En G13, seuls les murs et les sols sont visibles.
SET13_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00001000	; Mur simple?
	BEQ SET13_W		; Oui => SET13_W

	CMPA #%00001011	; Mur déplaçable?
	BEQ SET13_W		; Oui => SET13_W
	BRA	SET13_G		; Autre = apparence de sol en G13 => SET13_G

; Trou dans le sol occupable par un ennemi flottant. En G13 pas d'ennemi visible.
SET13_101:
	LDD #H13		; D = adresse de H13.
	BRA SET13_110_2	; Etape suivante => SET13_110_2

; Trou dans le plafond occupable par l'ennemi. En G13 pas d'ennemi visible.
SET13_110:
	LDD #CH13		; D = adresse de CH13.
SET13_110_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G13D		; G13 marqué comme à réafficher.
	BRA SET13_G0	; Etape suivante => SET13_G0

; Mur W48
SET13_W:
	LBSR MASK_W48	; Masquage des éléments cachés derrière le mur
	LDD #W48D		; D = adresse du mur W48
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET07		; => Analyse de la case de SET07

; Sol G13
SET13_G:
	LDD #G13D		; D = adresse du sol G13.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
SET13_G0:
	CLR >W48D		; W48 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET23 = analyse de la case de G23
; Par économie, les téléporteurs, les échelles, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; Les objets et les armes ne sont pas visibles en G23, seulement en G24.
;------------------------------------------------------------------------------
SET23:
	LBSR PAS_AV		; Adresse G23 = Adresse G13 + pas en avant
	STX >VARDW3		; Sauvegarde de l'adresse.
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00100000	; Echelles 010?
	BCS SET23_000	; Non, sol %000 ou %001 => SET23_000

	CMPA #%01000000	; Sol simple occupé ou occupable %100? 
	BEQ SET23_100	; Oui => SET23_100.
	BCS SET23_G		; Non, échelle ou téléporteur ignorés => SET23_G

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110? 
	BCS SET23_101	; Non, trou dans le sol occupé ou occupable %101 => SET23_101.
	BEQ SET23_110	; Oui => SET23_110. Sinon, mur ou obstacle ignoré => SET23_W

; Mur W14
SET23_W:
	LBSR MASK_W14	; Masquage des éléments cachés derrière le mur
	LDD #W14D		; D = adresse du mur W14
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	BRA SET07		; => Analyse de la case de SET07

; Sol simple interdit aux ennemis, vide ou avec arme ou munition.
SET23_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BEQ SET23_G		; Case vide = sol simple => SET23_G.

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_23
	LDD #CHEST23
	STD >LISTE4_23+1 ; Appel au coffre G23 empilé dans LISTE4

	LDD #REST23B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	BRA SET23_G		; Affichage du sol => SET18_G

; Sol simple occupé ou occupable par un ennemi.
SET23_100:
	BSR SET23_TM	; Test de présence ennemie.
	BRA SET23_G		; Affichage du sol puis étape suivante.

; Traitement des ennemis en G09
SET23_TM:
	LDU #E0X_G23	; U pointe les adresses des ennemis en G23.
	LDY #LISTE4_23	; Y pointe la liste 4.
	LBRA SETXX_TM	; Si ennemi présent, empilement en listes 4 et liste 0.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET23_101:
	LDD #H23		; D = adresse du trou entier.
	BRA SET23_110_1	; Test de présence ennemi puis étape suivante.

; Trou dans le plafond occupable par l'ennemi.
SET23_110:
	LDD #CH23		; D = adresse du trou entier.
SET23_110_1:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	BSR SET23_TM	; Test de présence ennemie.
	CLR >G23D		; G23 marqué comme à réafficher.
	BRA SET23_G0	; => Analyse du fond de G23.

; Sol G23
SET23_G:
	LDD #G23D		; D = adresse du sol G23
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET23_G0:
	CLR >W14D		; W14 marqué comme non affiché

	LDX >VARDW3		; X pointe l'adresse de la case G23.
	LBSR PAS_AV		; Puis la case au-delà de G23.
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET23_GW	; Si oui c'est forcémment un mur => SET23_GW

	CLR >W26D		; W26 marqué comme non affiché
	LDD #B26D		; D = adresse du fond B26
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B26_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	BRA SET07

SET23_GW:
	CLR >B26D		; B26 marqué comme non affiché
	LDD #W26D		; D = adresse du mur W26
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET07 = analyse de la case de G07
;------------------------------------------------------------------------------
SET07:
	LDX >VARDW1		; X pointe l'adresse de G6
	LBSR PAS_DR		; Adresse G7 = Adresse G6 + pas à droite
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupable %101? 
	BEQ SET07_101	; Oui => SET07_101.
	BCS SET07_G		; Non, sol simple %000,%001,%100 escalier %010 ou téléporteur
					; ou destination %011 = apparence de sol en G7 => SET07_G.
	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BEQ SET07_110	; Oui => SET07_110. Sinon mur ou obstacle.

; Mur ou obstacle. En G7, seuls les murs et les sols sont visibles.
SET07_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00001000	; Mur simple?
	BEQ SET07_W		; Oui => SET07_W

	CMPA #%00001011	; Mur déplaçable?
	BEQ SET07_W		; Oui => SET07_W
	BRA	SET07_G		; Autre = apparence de sol en G7 => SET07_G

; Trou dans le sol occupable par un ennemi flottant. En G7 pas d'ennemi visible.
SET07_101:
	LDD #H7			; D = adresse de H7.
	BRA SET07_110_2	; Etape suivante => SET07_110_2

; Trou dans le plafond occupable par l'ennemi. En G7 pas d'ennemi visible.
SET07_110:
	LDD #CH7		; D = adresse de CH7
SET07_110_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G7D		; G7 marqué comme non affiché.
	BRA SET07_G0	; Etape suivante => SET07_G0

; Mur W47
SET07_W:
	LBSR MASK_W47	; Masquage des éléments cachés derrière le mur
	LDD #W47D		; D = adresse du mur W47
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET03		; => Analyse de la case de SET03

; Sol G7
SET07_G:
	LDD #G7D		; D = adresse du sol G7
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
SET07_G0:
	CLR >W47D		; W47 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET14 = analyse de la case de G14
; Par économie, les téléporteurs, les portes et les ornements types 1 et 2 ne 
; sont pas affichés à cette distance. Les échelles sont maintenues mais elles 
; ne sont pas visibles sur cette case. Les trous sont maintenus.
;------------------------------------------------------------------------------
SET14:
	LBSR PAS_AV		; Adresse G14 = Adresse G7 + pas en avant
	STX >VARDW2		; Sauvegarde de l'adresse.
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00100000	; Echelles 010?
	BCS SET14_000	; Non, sol %000 ou %001 => SET14_000

	CMPA #%01000000	; Sol simple occupable ou occupé %100? 
	BEQ SET14_100	; Oui => SET14_100.
	BCS SET14_G		; Non, échelles ou téléporteur ignorés => SET14_G.

	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BCS SET14_101	; Non, trou dans le sol occupable %101 => SET14_101.
	BEQ SET14_110	; Oui => SET14_110. Sinon mur ou obstacle ignoré => SET14_W.

; Mur W7
SET14_W:
	LBSR MASK_W7	; Masquage des éléments cachés derrière le mur
	LDD #W7D		; D = adresse du mur W7
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET03		; => Analyse de la case de SET03

; Sol %000 avec ou sans objet, ou sol %001 avec ou sans arme ou munition.
SET14_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BEQ SET14_G		; Case vide = sol simple => SET14_G.

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_14
	LDD #CHEST14
	STD >LISTE4_14+1 ; Appel au coffre G14 empilé dans LISTE4

	LDD #REST14B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	BRA SET14_G		; Affichage du sol => SET14_G

; Sol simple occupé ou occupable par un ennemi.
SET14_100:
	BSR SET14_TM	; Test de présence ennemie.
	BRA SET14_G		; Affichage du sol puis étape suivante.

; Traitement des ennemis en G14
SET14_TM:
	LDU #E0X_G14	; U pointe les adresses des ennemis en G14.
	LDY #LISTE4_14	; Y pointe la liste 4.
	LBRA SETXX_TM	; Si ennemi présent, empilement en listes 4 et liste 0.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET14_101:
	LDD #H14D		; D = adresse du trou entier.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire.

	INC >H14D		; H14 marqué comme affiché.
	CLR >CH14D		; CH14 marqué comme non affiché.
	BRA SET14_110_1

; Trou dans le plafond occupable par l'ennemi.
SET14_110:
	LDD #CH14D		; D = adresse du trou entier.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire.

	INC >CH14D		; CH14 marqué comme affiché.
	CLR >H14D		; H14 marqué comme non affiché.

SET14_110_1:
	CLR >G14D		; G14 marqué comme à réafficher.
	BSR SET14_TM	; Test de présence ennemie.
	BRA SET14_G0	; Etape suivante.

; Sol G14
SET14_G:
	CLR >H14D		; H14 marqué comme non affiché.
	CLR >CH14D		; CH14 marqué comme non affiché.
	LDD #G14D		; D = adresse du sol G14.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
SET14_G0:
	CLR >W7D		; W7 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET24 = première partie de la case de G24
; Par économie, les téléporteurs, les échelles, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
;------------------------------------------------------------------------------
SET24:
	LDX >VARDW2		; X pointe l'adresse de G14.
	LBSR PAS_AV		; Adresse G24 = Adresse G14 + pas en avant.
	STX >VARDW2		; Sauvegarde de l'adresse de G24.
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00100000	; Echelles 010?
	BCS SET24_000	; Non, sol %000 ou %001 => SET24_000

	CMPA #%01000000	; Sol simple occupé ou occupable %100? 
	BEQ SET24_100	; Oui => SET24_100.
	BCS SET24_G		; Non, échelle ou téléporteur ignoré => SET24_G

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110? 
	BCS SET24_101	; Non, trou dans le sol occupé ou occupable %101 => SET24_101.
	BEQ SET24_110	; Oui => SET24_110.	Sinon, mur ou obstacle ignoré => SET24_W

; Mur W15
SET24_W:
	LBSR MASK_W15	; Masquage des éléments cachés derrière le mur
	LDD #W15D		; D = adresse du mur W15
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET03		; => Analyse de la case de SET03

; Sol simple interdit aux ennemis, vide ou avec arme ou munition.
SET24_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BEQ SET24_G		; Case vide = sol simple => SET24_G.

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_24
	LDD #CHEST24
	STD >LISTE4_24+1 ; Appel au coffre G24 empilé dans LISTE4

	LDD #REST24B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	BRA SET24_G

; Sol simple occupé ou occupable par un ennemi.
SET24_100:
	BSR SET24_TM	; Test de présence ennemie.
	BRA SET24_G		; Affichage du sol puis étape suivante.

; Traitement des ennemis en G09
SET24_TM:
	LDU #E0X_G24	; U pointe les adresses des ennemis en G24.
	LDY #LISTE4_24	; Y pointe la liste 4.
	LBRA SETXX_TM	; Si ennemi présent, empilement en listes 4 et liste 0.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET24_101:
	LDD #H24		; D = adresse du trou entier.
	BRA SET24_110_1	; Test de présence ennemi puis étape suivante.

; Trou dans le plafond occupable par l'ennemi.
SET24_110:
	LDD #CH24		; D = adresse du trou entier.

SET24_110_1:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	BSR SET24_TM	; Test de présence ennemie.
	LDD #G24D		; D = adresse du sol G24
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2, si pas déjà affiché.
	CLR >G24D		; G24 marqué comme à réafficher.
	BRA SET24_G0	; => Analyse du fond de G24.

; Sol G24
SET24_G:
	LDD #G24D		; D = adresse du sol G24
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET24_G0:
	CLR >W15D		; W15 marqué comme non affiché

	LDX >VARDW2		; X pointe l'adresse de la case G24,
	LBSR PAS_AV		; puis la case au-delà de G24.
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET24_GW	; Si oui c'est forcémment un mur => SET24_GW

	LBSR PAS_DR		; X pointe la case à droite de celle au-delà de G24
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET24_G2	; Si oui c'est forcémment un mur => SET24_G2

SET24_G1:
	CLR >B27DRD		; B27DR marqué comme non affiché
	LDD #B27D		; D = adresse du fond B27
	BRA SET24_G3

SET24_G2:
	CLR >B27D		; B27 marqué comme non affiché
	LDD #B27DRD		; D = adresse du fond B27DR

SET24_G3:
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B27_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	CLR >W27D		; W27 marqué comme non affiché
	BRA SET24B

SET24_GW:
	CLR >B27D		; B27 marqué comme non affiché
	CLR >B27DRD		; B27DR marqué comme non affiché
	LDD #W27D		; D = adresse du mur W27
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET24B = deuxième partie de la case de G24
; Par économie, les téléporteurs, les portes, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; En case G24B, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET24B:
	LDX >VARDW2		; X pointe l'adresse de G24.
	LBSR PAS_DR		; Adresse G24B = Adresse G24 + pas à droite
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	BCS SET24B_G	; Non, sol vide ou type de case ignoré => SET24B_G.
	BEQ SET24B_101	; Oui => SET24B_101. Sinon mur ou obstacle.

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110?
	BNE SET24B_W	; Non, mur ou obstacle ignoré => SET24B_W.

; Trou dans le plafond occupable par l'ennemi. En G24B pas d'ennemi visible.
SET24B_110:
	LDD #CH24B		; D = adresse de CH24B
	BRA SET24B_101_1 ; Analyse de la case au-delà de G24B.

; Trou dans le sol occupable par un ennemi flottant. En G24B pas d'ennemi visible.
SET24B_101:
	LDD #H24B		; D = adresse de H24B

SET24B_101_1:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.
	CLR >G24D		; G24 marqué comme non affiché.
	BRA SET24B_G	; Analyse de la case au-delà de G24B.

; Mur W43, à réafficher dans tous les cas à cause de G24
SET24B_W:
	LBSR MASK_W43	; Masquage des éléments cachés derrière le mur
	LDD #W43		; D = adresse du mur W43
	LBSR LISTE2_SAV2 ; Appel de W43 empilé dans la liste d'appel sans condition
	LDA #1
	STA >W43D
	BRA SET03

; Sol G24B
SET24B_G:
	CLR >W43D		; W43 marqué comme non affiché

	LBSR PAS_AV		; X pointe la case au-delà de G24B
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET24B_GW	; Si oui c'est forcémment un mur => SET24B_GW

	CLR >W28D		; W28 marqué comme non affiché
	LDD #B28D		; D = adresse du fond B28
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B28_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	BRA SET03

SET24B_GW:
	CLR >B28D		; B28 marqué comme non affiché
	LDD #W28D		; D = adresse du mur W28
	LBSR LISTE3_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET03 = analyse de la case de G03
;------------------------------------------------------------------------------
SET03:
	LDX >SQRADDR	; X pointe l'adresse de la case G2.
	LBSR PAS_DR		; Adresse G3 = Adresse G2 + pas à droite.
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type.

	CMPA #%00100000	; Echelles %010?
	BEQ SET03_010	; Oui => SET03_010.

	CMPA #%01010000	; Trou dans le sol occupable %101? 
	BEQ SET03_101	; Oui => SET03_101.
	BCS SET03_G		; Non, sols simples %000,%001,%100 ou destination %011 (pas
					; d'objets ou d'ennemi ici) => SET03_G.
	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	BEQ SET03_110	; Oui => SET03_110. Sinon, mur ou obstacle %111.

; Mur ou obstacle.
SET03_111:
	LDA ,X			; A = code de la case courante
	ANDA #%00001111	; A = contenu de la case

	CMPA #%00001000	; Mur simple %1000?
	BEQ SET03_W		; Oui => SET03_W

	CMPA #%00001011	; Mur déplaçable 1011?
	BEQ SET03_W		; Oui => SET03_W
	BRA SET03_G		; Autre = apparence de sol en G3 => SET03_G

; Echelles. En G3, seuls les trous apparaissent.
SET03_010:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BNE SET03_110	; Echelle montante = trou CH3. Sinon trou H3.

; Trou dans le sol occupable par un ennemi flottant
SET03_101:
	LDD #H3			; D = adresse de H3
	BRA SET03_110_2	; Etape suivante.

; Trou dans le plafond occupable par l'ennemi.
SET03_110:
	LDD #CH3		; D = adresse de CH3.
SET03_110_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G3D		; G3 marqué comme à réafficher.
	BRA SET03_G0	; Etape suivante.

; Mur W46
SET03_W:
	LBSR MASK_W46	; Masquage des éléments cachés derrière le mur.
	LDD #W46D		; D = adresse du mur W46.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
	LBRA SET_FIN	; => SET_FIN.

; Sol G3
SET03_G:
	LDD #G3D		; D = adresse du sol G3.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
SET03_G0:
	CLR >W46D		; W46 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET08 = analyse de la case de G08
; En G8 les échelles sont interdites, car il faut deux cases de profondeur dans
; le couloir. Et ni les objets ni les ennemis ne sont visibles sur cette case.
;------------------------------------------------------------------------------
SET08:
	LBSR PAS_AV		; Adresse G8 = Adresse G3 + pas en avant
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00110000	; Téléporteur ou destination de téléporteur %011?
	LBEQ SET08_011	; Oui => SET08_011
	LBCS SET08_G	; Non, sol simple %000 ou %001, ou échelles => SET08_G
					; (pas d'échelles ni d'objets apparents ici).
	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	LBEQ SET08_101	; Oui => SET08_101.
	LBCS SET08_G	; Non, sol simple occupé ou occupable %100 => SET08_G

	CMPA #%01100000	; Trou dans le plafond occupable %110? 
	LBEQ SET08_110	; Oui => SET08_110. Sinon mur ou obstacle.

; Mur ou obstacle.
SET08_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00000100	; Porte fermée?
	BCS SET08_111_PF ; Oui => SET08_111_PF.

	CMPA #%00001000	; Mur simple %1000?
	LBEQ SET08_W	; Oui => SET08_W.
	BCS SET08_111_PO ; Non, porte ouverte => SET01_111_PO.

	CMPA #%00001010	; Ornement mural 2 %1010?
	BCS SET08_111_O1 ; Non, ornement mural 1 => SET08_111_O1.
	BEQ SET08_111_O2 ; Oui, ornement mural 2 => SET08_111_O2.
	LBRA SET08_W	; Autre = mur.

; Porte fermée
SET08_111_PF:
	LDD #D08		; D = adresse de la porte D08
	BRA SET08_011_1	; Même type d'affichage que le téléporteur.

; Porte ouverte
SET08_111_PO:
	LDD #D08H		; D = adresse du haut de porte porte D08H.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #D08H_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	CLR >W2D		; W2 forcé à "non affiché".
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a dans la zone de W2.

	LBRA SET08_G	; Affichage de G8 puis étape suivante.

; Ornement 1 = bannière Baphomet
SET08_111_O1:
	LDD #BAN08		; D = adresse de BAN08.
	BRA SET08_011_1	; Même type d'affichage que le téléporteur.

; Ornement 2 = têtes sur des piques
SET08_111_O2:
	LBSR MASK_W8	; Masquage des éléments cachés derrière W8.
	LDD #W8D		; D = adresse du mur W8.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	LDD #ORN08		; D = adresse de ORN08.
	BRA SET08_011_1	; Même type d'affichage que le téléporteur.

; Téléporteur ou destination de téléporteur.
SET08_011:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	CMPA #%00001000	; Destination de téléporteur?
	BCC SET08_G		; Oui, donc apparence de sol simple => SET08_G

	LDA #%00000011	; Etat de jeu = Téléporteur visible en secteur G8.
	STA >STATEF

	LDD #TEL08		; D = adresse de TEL08.

SET08_011_1:
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #G8D		; D = adresse du sol G8.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2, si pas déjà affiché.

	LDD #D08_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	CLR >W3D		; W3 marqué comme non affiché.
	LBSR MASK_W3	; Ainsi que tout ce qu'il y a dans la zone de W3.

	CLR >W2D		; W2 forcé à "non affiché".
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a dans la zone de W2.

	LBRA SET_FIN	; Etape suivante.

; Trou dans le sol occupable par un ennemi flottant. En G8 pas d'ennemi visible.
SET08_101:
	LDD #H8			; D = adresse de H8
	BRA SET08_110_2	; Etape suivante => SET08_110_2

; Trou dans le plafond occupable par l'ennemi. En G4 pas d'ennemi visible.
SET08_110:
	LDD #CH8		; D = adresse de CH8
SET08_110_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G8D		; G8 marqué comme à réafficher.
	BRA SET08_G0	; Etape suivante => SET08_G0

; Mur W3
SET08_W:
	LBSR MASK_W3	; Masquage des éléments cachés derrière le mur
	LDD #W3D		; D = adresse du mur W3
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET_FIN	; => SET_FIN

; Sol G8
SET08_G:
	LDD #G8D		; D = adresse du sol G8.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.
SET08_G0:
	CLR >W3D		; W3 marqué comme non affiché.

;------------------------------------------------------------------------------
; SET15 = première partie de la case de G15
; Par économie, les téléporteurs, les portes et les ornements types 1 et 2 ne 
; sont pas affichés à cette distance. Les échelles et les trous sont maintenus.
;------------------------------------------------------------------------------
SET15:
	LBSR PAS_AV		; Adresse G15 = Adresse G8 + pas en avant
	STX >VARDW2		; Sauvegarde de l'adresse de G15
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%00100000	; Echelles 010?
	BEQ SET15_010	; Oui => SET15_010.
	BCS SET15_000	; Non, sol %000 ou %001 => SET15_000.

	CMPA #%01000000	; Sol simple occupé ou occupable %100? 
	BEQ SET15_100	; Oui => SET15_100.
	LBCS SET15_G	; Non, téléporteur ignoré => SET15_G

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110? 
	BCS SET15_101	; Non, trou dans le sol occupé ou occupable %101 => SET15_101.
	LBEQ SET15_110	; Oui => SET15_110. Sinon mur ou obstacle ignoré => SET15_W.

; Mur W8
SET15_W:
	LBSR MASK_W8	; Masquage des éléments cachés derrière le mur
	LDD #W8D		; D = adresse du mur W8
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET_FIN	; => SET_FIN

; Sol %000 avec ou sans objet, ou sol %001 avec ou sans arme ou munition.
SET15_000:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	LBEQ SET15_G	; Case vide = sol simple => SET15_G.

	LDA #$BD		; A = code machine de l'opérande JSR.
	STA >LISTE4_15
	LDD #CHEST15
	STD >LISTE4_15+1 ; Appel au coffre G15 empilé dans LISTE4

	LDD #REST15B 	; D = adresse de rétablissement des couleurs du coffre.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	LBRA SET15_G	; Affichage du sol => SET15_G

; Echelles.
SET15_010:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.
	BNE SET15_010_M	; Echelle montante => SET15_010_M

; Echelle descendante.
SET15_010_D:
	BSR SET15_101_R1 ; Affichage du trou dans le sol => SET15_101_R1.

	LDD #L15D		; D = adresse de l'échelle descendante.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #L15D_REST	; D = adresse de rétablissement des couleurs.

	BRA SET15_010_M2 ; Etape suivante.

; Echelle montante.
SET15_010_M:
	BSR SET15_110_R1 ; Affichage du trou dans le plafond => SET15_110_R1.

	LDD #L15U		; D = adresse de l'échelle montante.
	LBSR LISTE3_SAV2 ; Elément empilé dans LISTE3 sans condition.

	LDD #L15U_REST	; D = adresse de rétablissement des couleurs.

SET15_010_M2:
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

	CLR >H15D		; H15 marqué comme non affiché.
	CLR >CH15D		; CH15 marqué comme non affiché.

	LDD #W16D		; D = adresse du mur W16.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	LDD #W41D		; D = adresse du mur W41.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

	CLR >W16D		; W16 marqué comme à réafficher.
	LBSR MASK_W16	; Ainsi que tout ce qu'il y a derrière.

	CLR >W41D		; W41 marqué comme à réafficher.
	LBSR MASK_W41	; Ainsi que tout ce qu'il y a derrière.

	LBRA SET_FIN	; Etape suivante.

; Sol simple occupé ou occupable par un ennemi.
SET15_100:
	BSR SET15_TM	; Test de présence ennemie.
	BRA SET15_G		; Affichage du sol puis étape suivante.

; Traitement des ennemis en G15
SET15_TM:
	LDU #E0X_G15	; U pointe les adresses des ennemis en G15.
	LDY #LISTE4_15	; Y pointe la liste 4.
	LBRA SETXX_TM	; Si ennemi présent, empilement en listes 4 et liste 0.

; Trou dans le sol occupé ou occupable par un ennemi flottant.
SET15_101:
	BSR SET15_TM	; Test de présence ennemie.
	BSR SET15_101_R1 ; Affichage du trou.
	BRA SET15B		; Etape suivante.

SET15_101_R1:
	LDD #H15D		; D = adresse du trou entier.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire.

	INC >H15D		; H15 marqué comme affiché.
	CLR >W8D		; W8 marqué comme non affiché.
SET15_101_R2:
	CLR >CH15D		; CH15 marqué comme non affiché.
	CLR >G15D		; G15 marqué comme à réafficher.
	RTS

; Trou dans le plafond occupable par l'ennemi.
SET15_110:
	BSR SET15_TM	; Test de présence ennemie.
	BSR SET15_110_R1 ; Affichage du trou.
	BRA SET15B		; Etape suivante.

SET15_110_R1:		; Routine réutilisée par SET15_110_M
	LDD #CH15D		; D = adresse du trou entier.
	LBSR LISTE2_SAV1 ; Elément empilé dans LISTE2 si nécessaire.

	INC >CH15D		; CH15 marqué comme affiché.
	CLR >H15D		; H15 marqué comme non affiché.
	CLR >G15D		; G15 marqué comme non affiché.
	CLR >W8D		; W8 marqué comme non affiché.
	RTS

; Sol G15
SET15_G:
	CLR >W8D		; W8 marqué comme non affiché.
	CLR >H15D		; H15 marqué comme non affiché.
	CLR >CH15D		; CH15 marqué comme non affiché.
	LDD #G15D		; D = adresse du sol G15.
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché.

;------------------------------------------------------------------------------
; SET15B = deuxième partie de la case de G15
;------------------------------------------------------------------------------
SET15B:
	LBSR PAS_DR		; Adresse G15B = Adresse G15 + pas à droite
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01110000	; Mur ou obstacle %111? 
	BNE SET26		; Non = apparence de sol en G15B => SET26

; Mur ou obstacle. En G15B, seuls les murs et les sols sont visibles.
SET15B_111:
	LDA ,X			; A = code de la case courante.
	ANDA #%00001111	; A = contenu de la case.

	CMPA #%00001000	; Mur simple?
	BEQ SET15B_W	; Oui => SET15B_W

	CMPA #%00001011	; Mur déplaçable?
	BNE	SET26		; Non = apparence de sol en G15B => SET26

; Mur W41, à réafficher dans tous les cas à cause de G15
SET15B_W:
	LBSR MASK_W41	; Masquage des éléments cachés derrière le mur
	LDD #W41		; D = adresse du mur W41
	LBSR LISTE3_SAV2 ; Appel de W41 empilé dans LISTE3 sans condition
	LDD #W41_REST	; D = adresse de rétablissement des pixels.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	LBRA SET25B		; => SET25B

;------------------------------------------------------------------------------
; SET26 = analyse de la case de G26
; Par économie, les téléporteurs, les échelles, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; En case G26, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET26:
	LBSR PAS_AV		; Adresse G26 = Adresse G15B + pas en avant
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	BCS SET26_G		; Non, sol vide ou type de case ignoré => SET26_G.
	BEQ SET26_101	; Oui => SET26_101. Sinon mur ou obstacle.

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110?
	BNE SET26_W		; Non, mur ou obstacle ignoré => SET26_W.

; Trou dans le plafond occupable par l'ennemi. En G26 pas d'ennemi visible.
SET26_110:
	LDD #CH26		; D = adresse de CH26
	BRA SET26_101_2	; Analyse de la case au-delà de G26.

; Trou dans le sol occupable par un ennemi flottant. En G26 pas d'ennemi visible.
SET26_101:
	LDD #H26		; D = adresse de H26.
SET26_101_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G26D		; G26 marqué comme à réafficher.
	BRA SET26_G0	; Analyse de la case au-delà de G26.

; Mur W17
SET26_W:
	LBSR MASK_W17	; Masquage des éléments cachés derrière le mur
	LDD #W17D		; D = adresse du mur W17
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	BRA SET25B		; => Analyse de la case 25B

; Sol G26
SET26_G:
	LDD #G26D		; D = adresse du sol G26
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET26_G0:
	CLR >W17D		; W17 marqué comme non affiché

	LBSR PAS_AV		; X pointe la case au-delà de G26
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET26_GW	; Si oui c'est forcémment un mur => SET26_GW

	LBSR PAS_DR		; X pointe la case à droite de celle au-delà de G26
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET26_G2	; Si oui c'est forcémment un mur => SET26_G2

SET26_G1:
	CLR >B30DRD		; B30DR marqué comme non affiché
	LDD #B30D		; D = adresse du fond B30
	BRA SET26_G3

SET26_G2:
	CLR >B30D		; B30 marqué comme non affiché
	LDD #B30DRD		; D = adresse du fond B30DR

SET26_G3:
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B30_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	CLR >W30D		; W30 marqué comme non affiché
	BRA SET25B

SET26_GW:
	CLR >B30D		; B30 marqué comme non affiché
	CLR >B30DRD		; B30DR marqué comme non affiché
	LDD #W30D		; D = adresse du mur W30
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET25B = deuxième partie de la case de G25
; Par économie, les téléporteurs, les portes, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus, mais le trou
; H17B est supprimé car il ne concernait qu'un pixel blanc et un pixel gris.
; En case G25B, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET25B:
	LDX >VARDW2		; X pointe l'adresse de G15
	LBSR PAS_AV		; Adresse G25B = Adresse G15 + pas en avant
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01110000	; Case courante = mur simple vide?
	BNE SET25B_G	; Non, sol ou case ignorée => SET25B_G

; Mur W16
SET25B_W:
	LBSR MASK_W16	; Masquage des éléments cachés derrière le mur
	LDD #W16D		; D = adresse du mur W16
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	LBRA SET_FIN	; => SET_FIN

SET25B_G:
	CLR >W16D		; W16 marqué comme non affiché

;------------------------------------------------------------------------------
; SET25 = première partie de la case de G25
; Par économie, les téléporteurs, les échelles, les portes et les ornements ne
; sont pas affichés à cette distance. Les trous sont maintenus.
; En case G25, les objets et les ennemis ne sont pas visibles.
;------------------------------------------------------------------------------
SET25:
	LBSR PAS_DR		; Adresse G25 = Adresse G25B + pas à droite
	LBSR SQR_ID		; Case courante marquée comme vue + identification du type

	CMPA #%01010000	; Trou dans le sol occupé ou occupable %101? 
	BCS SET25_G		; Non, sol vide ou type de case ignoré => SET25_G.
	BEQ SET25_101	; Oui => SET25_101. Sinon mur ou obstacle.

	CMPA #%01100000	; Trou dans le plafond occupé ou occupable %110?
	BNE SET25_W		; Non, mur ou obstacle ignoré => SET25_W.

; Trou dans le plafond occupable par l'ennemi. En G25 pas d'ennemi visible.
SET25_110:
	LDD #CH25		; D = adresse de CH25
	BRA SET25_101_2	; Analyse de la case au-delà de G25.

; Trou dans le sol occupable par un ennemi flottant. En G25 pas d'ennemi visible.
SET25_101:
	LDD #H25		; D = adresse de H25.
SET25_101_2:
	LBSR LISTE2_SAV2 ; Elément empilé dans LISTE2 sans condition.
	CLR >G25D		; G25 marqué comme à réafficher.
	BRA SET25_G0	; Analyse de la case au-delà de G25.

; Mur W42
SET25_W:
	LBSR MASK_W42	; Masquage des éléments cachés derrière le mur
	LDD #W42D		; D = adresse du mur W42
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché
	BRA SET_FIN		; => SET_FIN

; Sol G25
SET25_G:
	LDD #G25D		; D = adresse du sol G25
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

SET25_G0:
	CLR >W42D		; W42 marqué comme non affiché

	LBSR PAS_AV		; X pointe la case au-delà de G25
	LDA ,X			; A = code de la case
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle?
	BEQ SET25_GW	; Si oui c'est forcémment un mur => SET25_GW

	CLR >W29D		; W29 marqué comme non affiché
	LDD #B29D		; D = adresse du fond B29
	LBSR LISTE3_SAV1 ; Elément empilé dans LISTE3 si nécessaire
	LDD #B29_REST 	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	BRA SET_FIN

SET25_GW:
	CLR >B29D		; B59 marqué comme non affiché
	LDD #W29D		; D = adresse du mur W29
	LBSR LISTE2_SAV1 ; Elément empilé dans la liste d'appel si pas déjà affiché

;------------------------------------------------------------------------------
; SET_FIN = restauration des couleurs, affichage des listes d'appel et de la
; minimap puis détection des attaques hors champs de vision.
;------------------------------------------------------------------------------
SET_FIN:
	LDA #$39		; A = code machine de l'opérande RTS
	LDX >PLISTE0	; X = adresse de pointage d'appel dans LISTE0
	STA ,X			; Cloture de la liste d'appel avec un RTS
	LDX >PLISTE2	; X = adresse de pointage d'appel dans LISTE2
	STA ,X			; Cloture de la liste d'appel avec un RTS
	LDX >PLISTE3	; X = adresse de pointage d'appel dans LISTE3
	STA ,X			; Cloture de la liste d'appel avec un RTS

	LBSR VIDEOC_A	; Sélection video couleur.
	LDB #40			; Pour les sauts de ligne
	LBSR LISTE1		; Rétablissement des couleurs et de certains pixels de forme.

	INC	$E7C3		; Sélection video forme
	LDB #40			; Pour les sauts de ligne (par sécurité).
	LBSR LISTE2		; Affichage des murs et des sols.
	LBSR LISTE3		; Affichage des trous et autres éléments de décors.
	LBSR LISTE4_18	; Affichage des ennemis et objets au sol.

	LDA >FMINIMAP	; Actualisation de la minimap recquis?
	BEQ SET_FIN_A	; Non => SET_FIN_A
	LBSR DMINIMAP	; Affichage de la minimap.

SET_FIN_A:
	LDA >DETEC_CHEST ; Coffre détecté?
	BEQ SET_FIN_0	; Non => SET_FIN_0
	LBSR PRINTO		; Affichage du contenu du coffre
	INC >SCORE_I1	; Item ramassé + 1 pour le score

SET_FIN_0:
	LDU #LISTEA2_HP	; U pointe la liste d'attaque lattérale droite.
	BSR SET_FIN_1	; Analyse des cases à droite LISTEA2.
	LDU #LISTEA3_HP	; U pointe la liste d'attaque par derrière.
	BSR SET_FIN_1	; Analyse des cases derrière LISTEA3.
	LDU #LISTEA4_HP	; U pointe la liste d'attaque lattérale gauche.
	BSR SET_FIN_1	; Analyse des cases à gauche LISTEA4.
	LBRA DONJON_ROTD ; Retour en position de front et fin.

SET_FIN_1:
	LBSR DONJON_ROTD ; Rotation d'un quart de tour à droite.

	LDX >SQRADDR	; X pointe la case courante.
	LBSR PAS_AV		; Puis la case juste devant.
	LDA ,X			; A = code de la case pointée par X.
	ANDA #%01110000	; A = type de case.
	CMPA #%01110000	; Type = mur ou obstacle?
	BEQ SET_FIN_4	; Oui = Fin (pas d'attaque sous les portes ouvertes).

	CMPA #%00100000	; Type = échelle?
	BEQ SET_FIN_4	; Oui = Fin.
	BCS SET_FIN_2	; Non, sol %000 ou %001 => SET_FIN_2

	CMPA #%00110000	; Type = téléporteur?
	BEQ SET_FIN_4	; Oui = Fin.

	CLRB			; Type d'attaque rapprochée
	LDA ,X			; A = code de la case pointée par X.
	ANDA #%00000111	; A = contenu de case.
	BNE SET_FIN_5	; Si ennemi détecté => SET_FIN_5

SET_FIN_2:
	LBSR PAS_AV		; X pointe la deuxième case devant.
	LDA ,X			; A = code de la case pointée par X.
	ANDA #%01110000	; A = type de case.
	CMPA #%01110000	; Type = mur ou obstacle?
	BEQ SET_FIN_4	; Oui = Fin.

	CMPA #%00100000	; Type = échelle?
	BEQ SET_FIN_4	; Oui = Fin.
	BCS SET_FIN_3	; Non, sol %000 ou %001 => SET_FIN_3. Pas de téléporteur ici.

	LDB #%00000001	; Type d'attaque distante
	LDA ,X			; A = code de la case pointée par X.
	ANDA #%00000111	; A = contenu de case.
	BNE SET_FIN_5	; Si ennemi détecté => SET_FIN_5

SET_FIN_3:
	LBSR PAS_AV		; X pointe la troisième case devant.
	LDA ,X			; A = code de la case pointée par X.
	ANDA #%01110000	; A = type de case.
	CMPA #%01110000	; Type = mur ou obstacle?
	BEQ SET_FIN_4	; Oui = Fin.

	CMPA #%01000000	; Type = sol occupable %100?
	BCS SET_FIN_4	; Non, sol ou case ignorée => SET_FIN_4

	LDB #%00000001	; Type d'attaque distante
	LDA ,X			; A = code de la case pointée par X.
	ANDA #%00000111	; A = contenu de case.
	BNE SET_FIN_5	; Si ennemi détecté => SET_FIN_5

SET_FIN_4:
	RTS				; Sinon fin.

SET_FIN_5:
	STB >SET12_TM5+1 ; Automodification de la comparaison en SET12_TM5
	CLRB			; Offset pour les attaques sonores.
	BRA SET12_TM3

;------------------------------------------------------------------------------
; SET06_TM : Test de présence ennemie + préparation d'attaque en G06.
;------------------------------------------------------------------------------
SET06_TM:
	LDU #E0X_G06	; U pointe les adresses des ennemis en G06.
	LDY #LISTE4_06	; Y pointe la liste 4, case G06.
	CLRA			; Type d'attaque rapprochée
	BRA SET12_TM2

;------------------------------------------------------------------------------
; SET21_TM : Test de présence ennemie + préparation d'attaque en G21.
;------------------------------------------------------------------------------
SET21_TM:
	LDU #E0X_G21	; U pointe les adresses des ennemis en G21.
	LDY #LISTE4_21	; Y pointe la liste 4, case G21.
	BRA SET12_TM1	; Même gestion d'attaque qu'en G12.

;------------------------------------------------------------------------------
; SET12_TM : Test de présence ennemie + préparation d'attaque en G12.
;------------------------------------------------------------------------------
SET12_TM:
	LDU #E0X_G12	; U pointe les adresses des ennemis en G12.
	LDY #LISTE4_12	; Y pointe la liste 4, case G12.

SET12_TM1:
	LDA #%00000001	; Type d'attaque distante

SET12_TM2:
	STA >SET12_TM5+1 ; Automodification de la comparaison en SET12_TM5
	BSR SETXX_TM	; Test de présence ennemie.
	BEQ SET12_TM6	; Si pas d'ennemi => RTS

	LDB #7			; Offset pour les attaques animées.
	LDU #LISTEA1_HP	; U pointe la liste 1.
	LDA ,X
	ANDA #%00000111	; A = n° d'ennemi.

SET12_TM3:
	PSHS A
	DECA
	LSLA			; A <= 2*(n° d'ennemi - 1).
	LDY #E0X_ATK	; Y pointe les animations d'attaque.
	LEAY A,Y		; Y pointe l'adresse de l'ennemi.
	LDY ,Y			; Y = adresse de l'attaque.
	LEAY B,Y		; Y pointe l'attaque sonore hors champ, ou animée frontale.
	STY >VARDW5		; Adesse sauvegardée pour éviter d'utiliser X (Pb SET0X)
	PULS A

	LDY #DEN_FLAG0	; Y pointe les flags des ennemis.
	LEAY A,Y		; Puis les flags de l'ennemi courant.
	LDA ,Y			; A = flags de l'ennemi courant.

	TSTB			; L'attaque en cours est-elle frontale?
	BNE SET12_TM4	; Oui => SET12_TM4. Sinon attaque latérale ou dorsale.

	BITA #$40		; L'ennemi est-il frontal uniquement (Méduse)?
	BNE SET12_TM6	; Si oui, attaque annulée => SET12_TM6

SET12_TM4:
	ANDA #%00000001	; A = type d'attaque de l'ennemi

SET12_TM5:
	CMPA #%00000001	; Attaque autorisée? (COMPARAISON AUTOMIDIFIEE)
	BCS SET12_TM6	; Si non, attaque annulée => RTS.

	LDA 6,Y			; A = nombre de points d'attaque de l'ennemi courant.
	STA ,U+			; Mémorisation dans la liste d'attaque.
	LDA #$7E		; A = code machine de l'opérande JMP.
	STA ,U+			; "JMP"
	LDY >VARDW5
	STY ,U			; + adresse de l'attaque.

	LDA #%00000100
	STA >STATEF		; Etat de jeu = attaque ennemie en cours.

SET12_TM6:
	RTS

;------------------------------------------------------------------------------
; SETXX_TM : Routine commune de détection des ennemis.
;------------------------------------------------------------------------------
SETXX_TM:
	LDA ,X			; A = code de la case courante.
	ANDA #%00000111	; A = numéro d'ennemi (E01 à E05).
	BEQ SET12_TM6	; Si A = %000, pas d'ennemi => RTS

	DECA
	LSLA			; A <= 2*(n° d'ennemi - 1).
	LSLA			; A <= 4*(n° d'ennemi - 1).
	LEAU A,U		; U pointe l'ennemi courant.
	LDA #$BD		; A = code machine de l'opérande JSR.
	STA ,Y+			; LISTE4_XX = affichage de l'ennemi en GXX
	LDA ,U+
	STA ,Y+
	LDA ,U+
	STA ,Y+
	LDD ,U			; D = adresse de restauration des couleurs.
	LBRA LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

;------------------------------------------------------------------------------
; Sous-routines de pas, à mettre à jour en fonction de l'orientation ORIENT.
; Les sous-routines d'orientation sont PAS_NORD, PAS_EST, PAS_SUD et PAS_OUEST.
;------------------------------------------------------------------------------
PAS_AV:
	FCB $30,$88,$E0,$39	; PAS AVANT   = LEAX -32,X ; RTS
PAS_DR:
	FCB $30,$01,$39,$12	; PAS DROITE  = LEAX 1,X ; RTS ; NOP
PAS_AR:
	FCB $30,$88,$20,$39	; PAS ARRIERE = LEAX 32,X ; RTS
PAS_GA:
	FCB $30,$1F,$39,$12	; PAS GAUCHE  = LEAX -1,X ; RTS ; NOP

;------------------------------------------------------------------------------
; Sous-routines d'empilement des objets de décors dans les listes d'appel. Les 
; appels sont réalisés avec des sauts absolus vers sous-routines JSR pour plus 
; de flexibilité avec les relocalisations du programme et de la map.
;
; LISTE0_SAV2 : empillement dans LISTE0, sans vérification de drapeaux.
; LISTE2_SAV1 : empillement dans LISTE2, avec vérification de drapeaux.
; LISTE2_SAV2 : empillement dans LISTE2, sans vérification de drapeaux.
; LISTE3_SAV1 : empillement dans LISTE3, avec vérification de drapeaux.
; LISTE3_SAV2 : empillement dans LISTE3, sans vérification de drapeaux.
;
; Entrées :
; D = adresse => A = poids fort, B = poids faible (ex: $400C => A = $40, B = $0C)
;------------------------------------------------------------------------------

; Empilement des routines de rétablissement de couleur dans LISTE0, sans vérification du drapeau
LISTE0_SAV2:
	LDY >PLISTE0	; Y = adresse de pointage d'appel dans LISTE0
	BSR LISTE_SAV2	; Empilement de l'élément sans condition
	STY >PLISTE0	; Adresse de pointage d'appel mise à jour
	RTS

; Empilement des éléments de décors dans LISTE2, avec vérification du drapeau
LISTE2_SAV1:
	LDY >PLISTE2	; Y = adresse de pointage d'appel dans LISTE2
	BSR LISTE_SAV1	; Empilement de l'élément, s'il n'est pas déjà affiché
	STY >PLISTE2	; Adresse de pointage d'appel mise à jour
	RTS

; Empilement des éléments de décors dans LISTE2, sans vérification du drapeau
LISTE2_SAV2:
	LDY >PLISTE2	; Y = adresse de pointage d'appel dans LISTE2
	BSR LISTE_SAV2	; Empilement de l'élément sans condition
	STY >PLISTE2	; Adresse de pointage d'appel mise à jour
	RTS

; Empilement des éléments de décors dans LISTE3, avec vérification du drapeau
LISTE3_SAV1:
	LDY >PLISTE3	; Y = adresse de pointage d'appel dans LISTE3
	BSR LISTE_SAV1	; Empilement de l'élément, s'il n'est pas déjà affiché
	STY >PLISTE3	; Adresse de pointage d'appel mise à jour
	RTS

; Empilement des éléments de décors dans LISTE3, sans vérification du drapeau
LISTE3_SAV2:
	LDY >PLISTE3	; Y = adresse de pointage d'appel dans LISTE3
	BSR LISTE_SAV2	; Empilement de l'élément sans condition
	STY >PLISTE3	; Adresse de pointage d'appel mise à jour
	RTS

; Empilement avec vérification du drapeau. Y doit pointer la liste.
LISTE_SAV1:
	PSHS X

	TFR D,X			; X = D = Adresse du drapeau de l'élément à afficher
	ADDD #$0001		; D = Adresse de l'élément à afficher
	STA	>LISTE_SAVDB ; Poids faible de l'adresse sauvegardé
	LDA ,X			; A = drapeau de l'élément à afficher
	BNE LISTE_SAV1A	; Element déjà affiché => LISTE_SAV1A

	INC ,X			; Elément marqué comme affiché
	BSR LISTE_SAV3	; Elément empilé dans la liste d'appel 

LISTE_SAV1A:
	PULS X,PC
	;RTS

; Empilement sans vérification du drapeau. Y doit pointer la liste.
LISTE_SAV2:
	STA	>LISTE_SAVDB ; Poids faible de l'adresse sauvegardé

LISTE_SAV3:
	LDA	#$BD		; $BD = code machine de JSR
	STA ,Y+			; Code machine empilé.
	LDA >LISTE_SAVDB
	STA ,Y+			; Poids fort de l'adresse empilé
	STB ,Y+			; Poids faible de l'adresse empilé
	RTS

; Variable locale protégée
LISTE_SAVDB FCB $00

;------------------------------------------------------------------------------
; Sous-routines d'identification de la case courante
;
; Entrées : X pointe la case courante dans la map, donc le code de cette case.
; Sorties : A = type de case (%0xxx0000).
;------------------------------------------------------------------------------
SQR_ID:
	LDA ,X			; A = code de la case courante
	ORA #%10000000	; Case marquée comme découverte, même si elle l'est déjà
	STA ,X			; Code de case mis à jour.
	ANDA #%01110000	; A = type de case.
	RTS

;******************************************************************************
;******************************************************************************
;*               ROUTINES D'AFFICHAGE DES ELEMENTS DE DECORS                  *
;******************************************************************************
;******************************************************************************

;------------------------------------------------------------------------------
; Mur W2
;------------------------------------------------------------------------------
; Drapeau d'affichage
W2D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W2:
	LDX #SCROFFSET+$0142
	BSR W2_R1
	LDX #SCROFFSET+$0144
	LDY #W2_DATA+1
	BSR W2_R1_1
	LDX #SCROFFSET+$0146
	BSR W2_R1
	LDX #SCROFFSET+$0148
	BSR W1_R1
	LDX #SCROFFSET+$014A
	BSR W2_R1
	LDX #SCROFFSET+$014C
	BSR W2_R1
	LDX #SCROFFSET+$014E
	BSR W2_R3
	LDX #SCROFFSET+$0150

W2_R1:
	LDY #W2_DATA
W2_R1_1:
	LDA	#$FF
	STA ,X
	STA	1,X
	ABX
	LDA	,Y			; + 23 lignes $00,$00 + 1 ligne grise $FF,$FF
	BSR W1_R2_2
	CLRA			; + 23 lignes vides $00,$00 + 1 ligne grise $FF,$FF
	BSR W1_R2_2
	LDA	,Y			; + 23 lignes $00,$00 + 1 ligne grise $FF,$FF
	BSR W1_R2_2
	CLRA			; + 23 lignes vides $00,$00 + 1 ligne grise $FF,$FF
	BRA W1_R2_2

W2_R3:
	LDA	#$FF		; 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA	#$80		; + 23 lignes $80,$00 + 1 ligne grise $FF,$FF
	LBSR W3_R2_2
	CLRA			; + 23 lignes vides $00,$00 + 1 ligne grise $FF,$FF
	LBSR W3_R2_2
	LDA	#$80		; + 23 lignes $80,$00 + 1 ligne grise $FF,$FF
	LBSR W3_R2_2
	CLRA			; + 23 lignes vides $00,$00 + 1 ligne grise $FF,$FF
	LBRA W3_R2_2

;------------------------------------------------------------------------------
; Mur W1
;------------------------------------------------------------------------------
; Drapeau d'affichage
W1D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W1:
	LDX #SCROFFSET+$0140 ; X pointe le mur à l'écran

W1_R1:
	LDA	#$FF		; 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	BSR W1_R2_1		; Lignes 2 à 49

W1_R2_1:			; Lignes 50 à 97
	CLRA
	LBSR DISPLAY_0A_16	; 16 lignes $00,(A) 
	LBSR DISPLAY_0A_7	; + 7 lignes $00,(A) 
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA	#$01		; + 23 lignes $00,$01 + 1 ligne grise $FF,$FF

W1_R2_2:
	LBSR DISPLAY_0A_15	; 15 lignes $00,(A) 
W1_R2_2A:
	LBSR DISPLAY_0A_8	; + 8 lignes $00,(A) 
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	RTS

;------------------------------------------------------------------------------
; Mur W3
;------------------------------------------------------------------------------
; Drapeau d'affichage
W3D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W3:
	LDX #SCROFFSET+$0152 ; X pointe le mur à l'écran

W3_R1:
	LDA	#$FF		; 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	BSR W3_R2_1		; Lignes 2 à 49

W3_R2_1:			; Lignes 50 à 97
	CLRA			; 23 lignes vides $00,$00 + 1 ligne grise $FF,$FF
	BSR W3_R2_2
	LDA	#$80		; + 23 lignes $80,$00 + 1 ligne grise $FF,$FF

W3_R2_2:
	LBSR DISPLAY_A0_15	; 15 lignes (A),$00 
W3_R2_2A:
	LBSR DISPLAY_A0_8	; + 8 lignes (A),$00 
W3_R2_3:
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	RTS

;------------------------------------------------------------------------------
; Mur W7
;------------------------------------------------------------------------------
; Drapeau d'affichage
W7D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W7:
	LDX #SCROFFSET+$032F ; X pointe la première colonne
	LDY #W7_DATA
	BSR W5_1		; Colonne 1 = colonne 3 de W5
	LDX #SCROFFSET+$0330 ; X pointe la deuxième colonne

; Partie commune avec W6
W7_1:
	LDY #W7_DATA+2	; Y pointe les données des colonnes 2 et 3
	LDA	#$FF		; 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA ,Y			; A = $08
	LBSR DISPLAY_0A_14	; + 14 Lignes $00,(A)
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA 1,Y			; A = $00
	LBSR DISPLAY_0A_14	; + 14 Lignes $00,(A)
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA ,Y			; A = $08
	LBSR DISPLAY_0A_14	; + 14 Lignes $00,(A)
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA 1,Y			; A = $00
	LBSR DISPLAY_0A_14	; + 14 Lignes $00,(A)
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	RTS

W7_DATA:
	FCB $00		; Données de la colonnes 1
W14B_DATA:
	FCB $80
	FCB $08		; Données des colonnes 2 et 3
W13B_DATA:
	FCB $00

;------------------------------------------------------------------------------
; Mur W5
;------------------------------------------------------------------------------
; Drapeau d'affichage
W5D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W5:
	LDX #SCROFFSET+$0322 ; X pointe la première colonne
	LDY #W5_DATA
	BSR W4_1		; Colonnes 1 et 2 = W14
	LDX #SCROFFSET+$0324 ; X pointe la troisième colonne
	LEAY 2,Y		; Y pointe les données de la colonne 3

; Partie commune avec W7.
W5_1:
	LDA	#$FF		; 1 ligne grise $FF
	STA ,X
	ABX
	LDA ,Y			; + 14 lignes vides $00
	LBSR DISPLAY_A_14 
	LDA	#$FF		; + 1 ligne grise $FF
	STA ,X
	ABX
	LDA 1,Y			; + 14 lignes vides $01
	LBSR DISPLAY_A_14
	LDA	#$FF		; + 1 ligne grise $FF
	STA ,X
	ABX
	LDA ,Y			; + 14 lignes vides $00
	LBSR DISPLAY_A_14 
	LDA	#$FF		; + 1 ligne grise $FF
	STA ,X
	ABX
	LDA 1,Y			; + 14 lignes vides $01
	LBSR DISPLAY_A_14
	LDA	#$FF		; + 1 ligne grise $FF
	STA ,X
	RTS

W5_DATA:
	FCB $10		; Données des colonnes 1 et 2
W4_DATA:
	FCB $00
W2_DATA:
	FCB $00		; Données de la colonne 3
	FCB $01

;------------------------------------------------------------------------------
; Mur W6
;------------------------------------------------------------------------------
; Drapeau d'affichage
W6D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W6:
	LDX #SCROFFSET+$0325 ; X pointe la colonne 1
	BSR W4_0		; Colonnes 1 et 2 = W4
	LDX #SCROFFSET+$0327 ; X pointe la colonne 3
	LDY #W5_DATA
	BSR W4_1		; Colonnes 3 et 4 = W5
	LDX #SCROFFSET+$0329 ; X pointe la colonne 5
	LDY #W2_DATA
	BSR W4_1
	LDX #SCROFFSET+$032B ; X pointe la colonne 7
	LBSR W7_1		; Colonnes 7 et 8 = W5
	LDX #SCROFFSET+$032D ; X pointe la colonne 9
	BRA W4_0		; Colonnes 9 et 10 = W4

;------------------------------------------------------------------------------
; Mur W8
;------------------------------------------------------------------------------
; Drapeau d'affichage
W8D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W8:
	LDX #SCROFFSET+$0332 ; X pointe le mur à l'écran
	BRA W4_0		; W8 = W4

;------------------------------------------------------------------------------
; Mur W4
;------------------------------------------------------------------------------
; Drapeau d'affichage
W4D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W4:
	LDX #SCROFFSET+$0320 ; X pointe le mur à l'écran

; Partie commune avec W6 et W8
W4_0:
	LDY #W4_DATA

; Partie commune avec W5 et W6
W4_1:
	LDA	#$FF		; 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA ,Y			; A = $00
	LBSR DISPLAY_A0_14	; + 14 Lignes (A),$00
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA 1,Y			; A = $00
	LBSR DISPLAY_A0_14	; + 14 Lignes (A),$00
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA ,Y			; A = $00
	LBSR DISPLAY_A0_14	; + 14 Lignes (A),$00
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA 1,Y			; A = $00
	LBSR DISPLAY_A0_14	; + 14 Lignes (A),$00
	LDA	#$FF		; + 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	RTS

;------------------------------------------------------------------------------
; Mur W14
;------------------------------------------------------------------------------
; Drapeau d'affichage
W14D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W14:
	LDX #SCROFFSET+$046D ; X pointe le mur à l'écran
	BRA W14B_0

; Routine adaptée au buffer, pour l'ouverture des portes.
W14B:
	LDB #10
	LDX #BUFFERF+138 ; X pointe le mur dans le buffer de forme.
W14B_0:
	LDY #W14B_DATA
W14B_1:
	LDA	#$FF		; 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA #$08
	LBSR W1_R2_2A	; + 8 Lignes $00,$08 + 1 ligne grise $FF,$FF
	LDA ,Y
	LBSR W3_R2_2A	; + 8 Lignes $80,$00 + 1 ligne grise $FF,$FF
	LDA #$08
	LBSR W1_R2_2A	; + 8 Lignes $00,$08 + 1 ligne grise $FF,$FF
	LDA ,Y
	LBRA W3_R2_2A	; + 8 Lignes $80,$00 + 1 ligne grise $FF,$FF

;------------------------------------------------------------------------------
; Mur W15
;------------------------------------------------------------------------------
; Drapeau d'affichage
W15D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W15:
	LDX #SCROFFSET+$046F ; X pointe la première colonne
	BSR W10_1		; Colonne 1 = W10
	LDX #SCROFFSET+$0470 ; X pointe la deuxième colonne
	BRA W14B_0		; Colonnes 2 et 3 = W14

;------------------------------------------------------------------------------
; Mur W12
;------------------------------------------------------------------------------
; Drapeau d'affichage
W12D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W12:
	LDX #SCROFFSET+$0465 ; X pointe le mur à l'écran
	BRA W12B_0

; Routine adaptée au buffer, pour l'ouverture des portes.
W12B:
	LDB #10
	LDX #BUFFERF+130 ; X pointe le mur dans le buffer de forme.
W12B_0:
	LDA	#$FF		; 1 ligne grise $FF,$FF
	STA ,X
	STA	1,X
	ABX
	LDA #$10
	LBSR W3_R2_2A	; + 8 Lignes $10,$00 + 1 ligne grise $FF,$FF
	LDA #$01
	LBSR W1_R2_2A	; + 8 Lignes $00,$01 + 1 ligne grise $FF,$FF
	LDA #$10
	LBSR W3_R2_2A	; + 8 Lignes $10,$00 + 1 ligne grise $FF,$FF
	LDA #$01
	LBRA W1_R2_2A	; + 8 Lignes $00,$01 + 1 ligne grise $FF,$FF

;------------------------------------------------------------------------------
; Mur W11
;------------------------------------------------------------------------------
; Drapeau d'affichage
W11D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W11:
	LDX #SCROFFSET+$0462 ; X pointe le mur à l'écran
	BSR W12B_0		; Colonnes 1 et 2 = W12
	LDX #SCROFFSET+$0464 ; X pointe la troisième colonne
	BRA W10_1		; = W10

;------------------------------------------------------------------------------
; Mur W13
;------------------------------------------------------------------------------
; Drapeau d'affichage
W13D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W13:
	LDX #SCROFFSET+$0467 ; X pointe le mur à l'écran
	BRA W13B_0

; Routine adaptée au buffer, pour l'ouverture des portes. 
W13B:
	LDB #10
	LDX #BUFFERF+132 ; X pointe le mur dans le buffer de forme.
W13B_0:
	PSHS X
	BSR W10_1		; Colonne 1 = W10
	PULS X
	LEAX 1,X
	PSHS X
	BSR W12B_0		; Colonnes 2 et 3 = W12
	PULS X
	LEAX 2,X
	PSHS X			; Colonnes 4 et 5
	LDY #W13B_DATA
	BSR W14B_1
	PULS X
	LEAX 2,X
	BRA W10_1		; Colonne 6 = W10

;------------------------------------------------------------------------------
; Mur W10
;------------------------------------------------------------------------------
; Drapeau d'affichage
W10D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W10:
	LDX #SCROFFSET+$0461 ; X pointe le mur à l'écran
W10_1:
	LDY #W4_DATA
	BRA W9_1

;------------------------------------------------------------------------------
; Mur W16
;------------------------------------------------------------------------------
; Drapeau d'affichage
W16D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W16:
	LDX #SCROFFSET+$0472 ; X pointe le mur à l'écran
	BRA W10_1		; = W10

;------------------------------------------------------------------------------
; Mur W17
;------------------------------------------------------------------------------
; Drapeau d'affichage
W17D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W17:
	LDX #SCROFFSET+$0473 ; X pointe le mur à l'écran
	LDY #W7_DATA
	BRA W9_1

;------------------------------------------------------------------------------
; Mur W9
;------------------------------------------------------------------------------
; Drapeau d'affichage
W9D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W9:
	LDX #SCROFFSET+$0460 ; X pointe le mur à l'écran
	LDY #W2_DATA
W9_1:
	LDA	#$FF		; 1 ligne grise $FF
	STA ,X
	ABX
	BSR W9_2
W9_2:
	LDA ,Y			; + 8 lignes vides $00
	LBSR DISPLAY_A_8 
	LDA	#$FF		; + 1 ligne grise $FF
	STA ,X
	ABX
	LDA 1,Y			; + 8 lignes vides $01
	LBSR DISPLAY_A_8
	LDA	#$FF		; + 1 ligne grise $FF
	STA ,X
	ABX
	RTS

;------------------------------------------------------------------------------
; Mur W28
;------------------------------------------------------------------------------
; Drapeau d'affichage
W28D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W28:
	LDX #SCROFFSET+$0510 ; X pointe le mur à l'écran
	BSR W25_1		; 1ère colonne = W25
	LDX #SCROFFSET+$0511
	BRA W27_1		; 2ème colonne = W27

;------------------------------------------------------------------------------
; Mur W26
;------------------------------------------------------------------------------
; Drapeau d'affichage
W26D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W26:
	LDX #SCROFFSET+$050D ; X pointe le mur à l'écran
	BSR W27_1		; 1ère colonne = W27
	LDX #SCROFFSET+$050E
	BRA W25_1		; 2ème colonne = W25

;------------------------------------------------------------------------------
; Mur W30
;------------------------------------------------------------------------------
; Drapeau d'affichage
W30D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W30:
	LDX #SCROFFSET+$0513 ; X pointe le mur à l'écran
	BRA W27_1		; W30 = W27

;------------------------------------------------------------------------------
; Mur W27
;------------------------------------------------------------------------------
; Drapeau d'affichage
W27D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W27:
	LDX #SCROFFSET+$050F ; X pointe le mur à l'écran
W27_1:
	LDY #W27_DATA	; Y pointe les données du mur.
	LBSR DISPLAY_YX_13	; Lignes 1 à 13.
	LEAY -12,Y
	LBRA DISPLAY_YX_12	; Lignes 14 à 25.

;------------------------------------------------------------------------------
; Mur W29
;------------------------------------------------------------------------------
; Drapeau d'affichage
W29D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W29:
	LDX #SCROFFSET+$0512 ; X pointe le mur à l'écran
	BRA W25_1		; W29 = W25

;------------------------------------------------------------------------------
; Mur W25
;------------------------------------------------------------------------------
; Drapeau d'affichage
W25D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W25:
	LDX #SCROFFSET+$050C ; X pointe le mur à l'écran
W25_1:
	LDY #W25_DATA	; Y pointe les données du mur.
	LBSR DISPLAY_YX_13	; Lignes 1 à 13.
	LEAY -12,Y
	LBRA DISPLAY_YX_12	; Lignes 14 à 25.

;------------------------------------------------------------------------------
; Mur W24
;------------------------------------------------------------------------------
; Drapeau d'affichage
W24D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W24:
	LDX #SCROFFSET+$0508 ; X pointe le mur à l'écran
	BSR W18_1		; 1ère colonne = W18
	LDX #SCROFFSET+$0509
	BSR W19_1		; 2ème colonne = W19
	LDX #SCROFFSET+$050A
	BSR W18_1		; 3ème colonne = W18
	LDX #SCROFFSET+$050B
	LDY #W24_DATA	; Y pointe les données du mur.
	LBSR DISPLAY_YX_13	; Lignes 1 à 13.
	LEAY -12,Y
	LBRA DISPLAY_YX_12	; Lignes 14 à 25.

;------------------------------------------------------------------------------
; Mur W22
;------------------------------------------------------------------------------
; Drapeau d'affichage
W22D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W22:
	LDX #SCROFFSET+$0505 ; X pointe le mur à l'écran
	BSR W19_1		; 1ère colonne = W19
	LDX #SCROFFSET+$0506
	BRA W18_1		; 2ème colonne = W18

;------------------------------------------------------------------------------
; Mur W20
;------------------------------------------------------------------------------
; Drapeau d'affichage
W20D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W20:
	LDX #SCROFFSET+$0502 ; X pointe le mur à l'écran
	BSR W18_1		; 1ère colonne = W18
	LDX #SCROFFSET+$0503
	BRA W19_1		; 2ème colonne = W19

;------------------------------------------------------------------------------
; Mur W21
;------------------------------------------------------------------------------
; Drapeau d'affichage
W21D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W21:
	LDX #SCROFFSET+$0504 ; X pointe le mur à l'écran
	BRA W18_1		; W21 = W18

;------------------------------------------------------------------------------
; Mur W23
;------------------------------------------------------------------------------
; Drapeau d'affichage
W23D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W23:
	LDX #SCROFFSET+$0507 ; X pointe le mur à l'écran
	BRA W19_1		; W23 = W19

;------------------------------------------------------------------------------
; Mur W18
;------------------------------------------------------------------------------
; Drapeau d'affichage
W18D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W18:
	LDX #SCROFFSET+$0500 ; X pointe le mur à l'écran.

W18_1:
	LDY #W18_DATA	; Y pointe les données du mur.
	LBSR DISPLAY_YX_13	; Lignes 1 à 13.
	LEAY -12,Y
	LBRA DISPLAY_YX_12	; Lignes 14 à 25.

;------------------------------------------------------------------------------
; Mur W19
;------------------------------------------------------------------------------
; Drapeau d'affichage
W19D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W19:
	LDX #SCROFFSET+$0501 ; X pointe le mur à l'écran

W19_1:
	LDY #W19_DATA	; Y pointe les données du mur.
	LBSR DISPLAY_YX_13	; Lignes 1 à 13.
	LEAY -12,Y
	LBRA DISPLAY_YX_12	; Lignes 14 à 25.

;------------------------------------------------------------------------------
; Mur W31
; La routine de restauration permet de rétablir le sol gris en $0A28 pour ne
; pas réafficher G9, H9 ou CH9.
;------------------------------------------------------------------------------
; Drapeau d'affichage
W31D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W31:
	LDX #SCROFFSET+$0460 ; X pointe les colonnes à l'écran
	LDY #W31_DATA	; Y pointe les données du mur W31
	LBRA W41_1		; Affichage des lignes 1 à 39

; Routine de restauration
W31_REST:
	INC	$E7C3		; Sélection vidéo forme
	LDA #$FF
	STA >SCROFFSET+$0A28 ; 8 pixels gris dans la zone de G9.
	LBRA VIDEOC_A	; Sélection video couleur + fin

;------------------------------------------------------------------------------
; Mur W32
;------------------------------------------------------------------------------
; Drapeau d'affichage
W32D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W32:
	LDX #SCROFFSET+$0461 ; X pointe les colonnes à l'écran
	LDY #W32_DATA	; Y pointe les données du mur W32
	LBSR DISPLAY_YX_32	; Lignes 1 à 32
	LBRA DISPLAY_YX_5	; Lignes 33 à 37

;------------------------------------------------------------------------------
; Mur W33
;------------------------------------------------------------------------------
; Drapeau d'affichage
W33D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W33:
	LDX #SCROFFSET+$04B2 ; X pointe les colonnes à l'écran
	LDY #W33_DATA	; Y pointe les données du mur W33
	LBSR DISPLAY_2YX_16	; Lignes 1 à 16
	LBSR DISPLAY_2YX_12	; Lignes 17 à 27
	LBRA DISPLAY_YX_4	; Lignes 28 à 31

;------------------------------------------------------------------------------
; Mur W36
;------------------------------------------------------------------------------
; Drapeau d'affichage
W36D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W36:
	LDX #SCROFFSET+$0050 ; X pointe le mur à l'écran
	BSR W36_R0			; Lignes 1 à 15
	LBSR DISPLAY_A0_16	; Lignes 9 à 24
	STA	,X				; Lignes 25 à 28
	CLR	1,X
	ABX
	STA	,X
	CLR	1,X
	ABX
	STA	,X
	CLR	1,X
	ABX
	STA	,X
	CLR	1,X
	ABX
	LBSR DISPLAY_2YX_3	; Lignes 29 à 31
	LDA #$01
	LBSR DISPLAY_0A_16	; Lignes 32 à 47
	LBSR DISPLAY_0A_7	; Lignes 48 à 54
	LBSR DISPLAY_2YX_5	; Lignes 55 à 59
	LDA #$02
	LBSR DISPLAY_A0_16	; Lignes 60 à 75
	STA	,X				; Lignes 76 à 78
	CLR	1,X
	ABX
	STA	,X
	CLR	1,X
	ABX
	STA	,X
	CLR	1,X
	ABX
	LBSR DISPLAY_2YX_10	; Lignes 79 à 88
	LDA #$01
	LBSR DISPLAY_0A_15	; Lignes 89 à 103
	LBSR DISPLAY_2YX_6	; Lignes 104 à 109
	LBRA DISPLAY_YX_8	; Lignes 110 à 117

W36_R0:				; Routine commune avec W37
	LDY #W36_DATA	; Y pointe les données du mur W36
	LBSR DISPLAY_YX_4	; Lignes 1 à 4
	LBSR DISPLAY_2YX_3	; Lignes 5 à 7
	LDA #$02
	STA	,X			; Ligne 8
	CLR	1,X
	ABX
	RTS

;------------------------------------------------------------------------------
; Mur W37
;------------------------------------------------------------------------------
; Drapeau d'affichage
W37D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W37:
; Colonnes 1 et 2
	LDX #SCROFFSET+$0192 ; X pointe les colonnes à l'écran
	LBSR W36_R0			; Lignes 1 à 8
	LBSR DISPLAY_A0_14	; Lignes 9 à 22
	LBSR DISPLAY_2YX_3	; Lignes 23 à 25
	LDA #$04
	LBSR DISPLAY_0A_16	; Lignes 26 à 41
	CLR	,X				; Ligne 42
	STA	1,X
	ABX
	LDY #W37_DATA		; Y pointe les données du mur W37
	LBSR DISPLAY_2YX_5	; Lignes 43 à 47
	LDA #$02
	LBSR DISPLAY_A0_13	; Lignes 48 à 60
	LBSR DISPLAY_2YX_10	; Lignes 61 à 70
	LDA #$04
	LBSR DISPLAY_0A_8	; Lignes 71 à 78
	LBSR DISPLAY_2YX_7	; Lignes 79 à 85
	LBSR DISPLAY_YX_8	; Lignes 86 à 93
; Colonne 3
	LDX #SCROFFSET+$02D4 ; X pointe la colonne à l'écran
	LDA #$20
	STA >VARDB1
	LDA #$01
W37_R0:
	STA >VARDB2
	LBSR DISPLAY_YX_3	; Lignes 1 à 3
	LDA >VARDB1
	LBSR DISPLAY_A_13	; Lignes 4 à 16
	LDA ,Y+			; Lignes 17 à 18
	STA ,X
	ABX
	LDA ,Y+
	STA ,X
	ABX
	LDA >VARDB2
	LBSR DISPLAY_A_14	; Lignes 19 à 32
	LBSR DISPLAY_YX_3	; Lignes 33 à 35
	LDA >VARDB1
	LBSR DISPLAY_A_12	; Lignes 36 à 47
	LBSR DISPLAY_YX_5	; Lignes 48 à 52
	LDA >VARDB2
	LBSR DISPLAY_A_11	; Lignes 53 à 63
	LBRA DISPLAY_YX_6	; Lignes 64 à 69

;------------------------------------------------------------------------------
; Mur W38
;------------------------------------------------------------------------------
; Drapeau d'affichage
W38D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W38:
	LDX #SCROFFSET+$0375 ; X pointe les colonnes à l'écran
W38_1:
	LDY #W38_DATA	; Y pointe les données du mur W38
	LBSR DISPLAY_YX_4	; Lignes 1 à 4
	LBSR DISPLAY_2YX_32	; Lignes 5 à 36
	LBSR DISPLAY_2YX_13	; Lignes 37 à 49
	LBRA DISPLAY_YX_8	; Lignes 50 à 57

; Routine adaptée au buffer, pour l'ouverture des portes. 
W38B:
	LDB #10
	LDX #BUFFERF+70 ; X pointe le mur dans le buffer de forme, ligne 8.
	BRA W38_1

;------------------------------------------------------------------------------
; Mur W39
;------------------------------------------------------------------------------
; Drapeau d'affichage
W39D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W39:
	LDX #SCROFFSET+$04B7 ; X pointe les colonnes à l'écran
	LDY #W39_DATA	; Y pointe les données du mur W39
	LBSR DISPLAY_YX_32	; Lignes 1 à 32
	LDA #$7F
	STA	,X			; Ligne 33
	RTS

;------------------------------------------------------------------------------
; Mur W41
; La routine de restauration permet de rétablir le sol gris en $0A3B pour ne
; pas réafficher G15, H15 ou CH15.
;------------------------------------------------------------------------------
; Drapeau d'affichage
W41D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W41:
	LDX #SCROFFSET+$0473 ; X pointe les colonnes à l'écran
	LDY #W41_DATA	; Y pointe les données du mur W41
W41_1:
	LBSR DISPLAY_YX_32	; Lignes 1 à 32
	LBRA DISPLAY_YX_6	; Lignes 33 à 38
	LDA #$FF			; Ligne 39
	STA ,X
	RTS

; Routine de restauration
W41_REST:
	INC	$E7C3		; Sélection vidéo forme
	LDA #$FF
	STA >SCROFFSET+$0A3B ; 8 pixels gris dans la zone de G15.
	LBRA VIDEOC_A	; Sélection video couleur + fin

;------------------------------------------------------------------------------
; Mur W42
;------------------------------------------------------------------------------
; Drapeau d'affichage
W42D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W42:
	LDX #SCROFFSET+$0472 ; X pointe les colonnes à l'écran
	LDY #W42_DATA	; Y pointe les données du mur W42
	LBSR DISPLAY_YX_32	; Lignes 1 à 32
	LBRA DISPLAY_YX_5	; Lignes 33 à 37

;------------------------------------------------------------------------------
; Mur W43
;------------------------------------------------------------------------------
; Drapeau d'affichage
W43D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W43:
	LDX #SCROFFSET+$04C0 ; X pointe les colonnes à l'écran
	LDY #W43_DATA	; Y pointe les données du mur W43
	LBSR DISPLAY_2YX_16	; Lignes 1 à 16
	LBSR DISPLAY_2YX_12	; Lignes 17 à 27
	LEAX 1,X
	LBRA DISPLAY_YX_4	; Lignes 28 à 31

;------------------------------------------------------------------------------
; Mur W46
;------------------------------------------------------------------------------
; Drapeau d'affichage
W46D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W46:
	LDX #SCROFFSET+$0063 ; X pointe les colonnes à l'écran
	BSR W46_R1			; Lignes 1 à 22
	LBSR DISPLAY_0A_6	; Lignes 23 à 28
	LBSR DISPLAY_2YX_3	; Lignes 29 à 31
	LDA #$80
	LBSR DISPLAY_A0_16	; Lignes 32 à 47
	LBSR DISPLAY_A0_7	; Lignes 48 à 54
	LBSR DISPLAY_2YX_5	; Lignes 55 à 59
	LDA #$40
	LBSR DISPLAY_0A_16	; Lignes 60 à 75
	CLR	,X				; Lignes 76 à 78
	STA	1,X
	ABX
	CLR	,X
	STA	1,X
	ABX
	CLR	,X
	STA	1,X
	ABX
	LBSR DISPLAY_2YX_10	; Lignes 79 à 88
	LDA #$80
	LBSR DISPLAY_A0_15	; Lignes 89 à 103
	LBSR DISPLAY_2YX_6	; Lignes 104 à 109
	LEAX 1,X
	LBRA DISPLAY_YX_8	; Lignes 110 à 117

W46_R1:
	LDY #W46_DATA	; Y pointe les données du mur W46
	LBSR DISPLAY_YX_4	; Lignes 1 à 4
	LEAX -1,X
	LBSR DISPLAY_2YX_3	; Lignes 5 à 7
	LDA #$40
	LBRA DISPLAY_0A_15	; Lignes 8 à 22

;------------------------------------------------------------------------------
; Mur W47
;------------------------------------------------------------------------------
; Drapeau d'affichage
W47D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W47:
; Colonnes 2 et 3
	LDX #SCROFFSET+$01A1 ; X pointe les colonnes à l'écran
	BSR W46_R1			; Lignes 1 à 22
	LBSR DISPLAY_2YX_3	; Lignes 23 à 25
	LDY #W47_DATA		; Y pointe les données du mur W47
	LDA #$20
	LBSR DISPLAY_A0_16	; Lignes 26 à 41
	STA	,X				; Ligne 42
	CLR	1,X
	ABX
	LBSR DISPLAY_2YX_5	; Lignes 43 à 47
	LDA #$40
	LBSR DISPLAY_0A_13	; Lignes 48 à 60
	LBSR DISPLAY_2YX_10	; Lignes 61 à 70
	LDA #$20
	LBSR DISPLAY_A0_8	; Lignes 71 à 78
	LBSR DISPLAY_2YX_7	; Lignes 79 à 85
	LEAX 1,X
	LBSR DISPLAY_YX_8	; Lignes 86 à 93
; Colonne 1
	LDX #SCROFFSET+$02DF ; X pointe la colonne à l'écran
	LDA #$04
	STA >VARDB1
	LDA #$80
	LBRA W37_R0

;------------------------------------------------------------------------------
; Mur W48
;------------------------------------------------------------------------------
; Drapeau d'affichage
W48D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W48:
	LDX #SCROFFSET+$037E ; X pointe les colonnes à l'écran
W48_1:
	LDY #W48_DATA	; Y pointe les données du mur W48
	LBSR DISPLAY_YX_4	; Lignes 1 à 4
	LEAX -1,X
	LBSR DISPLAY_2YX_32	; Lignes 5 à 36
	LBSR DISPLAY_2YX_13	; Lignes 37 à 49
	LEAX 1,X
	LBRA DISPLAY_YX_8	; Lignes 50 à 57

; Routine adaptée au buffer, pour l'ouverture des portes.
W48B:
	LDB #10
	LDX #BUFFERF+79 ; X pointe le mur dans le buffer de forme, ligne 8.
	BRA W48_1

;------------------------------------------------------------------------------
; Mur W49
;------------------------------------------------------------------------------
; Drapeau d'affichage
W49D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
W49:
	LDX #SCROFFSET+$04BC ; X pointe les colonnes à l'écran
	LDY #W49_DATA	; Y pointe les données du mur W49
	LBSR DISPLAY_YX_32	; Lignes 1 à 32
	LDA #$FE
	STA	,X			; Ligne 33
	RTS

;------------------------------------------------------------------------------
; Fond B20
;------------------------------------------------------------------------------
; Drapeau d'affichage
B20D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B20:
	LDX #SCROFFSET+$0502 ; X pointe la 1ère colonne.
	LBSR B18_1
	LDX #SCROFFSET+$0503 ; X pointe la 2ème colonne.
	LBRA B18_1

; Rétablissement des couleurs pour LISTE0
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B20_REST:
	LDA >B20D		; B20 doit-il être (ré)affiché?
	BEQ B20_REST_1 ; Non => B20_REST_1
	RTS				; Si oui, pas besoin de rétablir les couleurs.

B20_REST_1:
	LDX #SCROFFSET+$0502 ; X pointe la 1ère colonne.
	LBSR B18_REST_1
	LDX #SCROFFSET+$0503 ; X pointe la 2ème colonne.
	LBRA B18_REST_1

;------------------------------------------------------------------------------
; Fond B22
;------------------------------------------------------------------------------
; Drapeau d'affichage
B22D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B22:
	LDX #SCROFFSET+$0505 ; X pointe la 1ère colonne.
	LBSR B18_1
	LDX #SCROFFSET+$0506 ; X pointe la 2ème colonne.
	LBRA B18_1

; Rétablissement des couleurs pour LISTE0
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B22_REST:
	LDA >B22D		; B22 doit-il être (ré)affiché?
	BEQ B22_REST_1 ; Non => B22_REST_1
	RTS				; Si oui, pas besoin de rétablir les couleurs.

B22_REST_1:
	LDX #SCROFFSET+$0505 ; X pointe la 1ère colonne.
	LBSR B18_REST_1
	LDX #SCROFFSET+$0506 ; X pointe la 2ème colonne.
	LBRA B18_REST_1

;------------------------------------------------------------------------------
; Fond B26
;------------------------------------------------------------------------------
; Drapeau d'affichage
B26D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B26:
	LDX #SCROFFSET+$050D ; X pointe la 1ère colonne.
	LBSR B18_1
	LDX #SCROFFSET+$050E ; X pointe la 2ème colonne.
	LBRA B18_1

; Rétablissement des couleurs pour LISTE0
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B26_REST:
	LDA >B26D		; B26 doit-il être (ré)affiché?
	BEQ B26_REST_1	; Non => B26_REST_1
	RTS				; Si oui, pas besoin de rétablir les couleurs.

B26_REST_1:
	LDX #SCROFFSET+$050D ; X pointe la 1ère colonne.
	LBSR B18_REST_1
	LDX #SCROFFSET+$050E ; X pointe la 2ème colonne.
	LBRA B18_REST_1

;------------------------------------------------------------------------------
; Fond B28
;------------------------------------------------------------------------------
; Drapeau d'affichage
B28D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B28:
	LDX #SCROFFSET+$0510 ; X pointe la 1ère colonne.
	LBSR B18_1
	LDX #SCROFFSET+$0511 ; X pointe la 2ème colonne.
	LBRA B18_1

; Rétablissement des couleurs pour LISTE0
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B28_REST:
	LDA >B28D		; B28 doit-il être (ré)affiché?
	BEQ B28_REST_1 ; Non => B28_REST_1

B28_REST_0:
	RTS				; Si oui, pas besoin de rétablir les couleurs.

B28_REST_1:
	LDX #SCROFFSET+$0510 ; X pointe la 1ère colonne.
	LBSR B18_REST_1
	LDX #SCROFFSET+$0511 ; X pointe la 2ème colonne.
	LBRA B18_REST_1

;------------------------------------------------------------------------------
; Fond B24
;------------------------------------------------------------------------------
; Drapeau d'affichage
B24D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B24:
	LDX #SCROFFSET+$0508 ; X pointe la 1ère colonne.
	BSR B18_1
B24_1:
	LDX #SCROFFSET+$0509 ; X pointe la 2ème colonne.
	BSR B18_1
	LDX #SCROFFSET+$050A ; X pointe la 3ère colonne.
	BSR B18_1
	LDX #SCROFFSET+$050B ; X pointe la 4ème colonne.
	BRA B18_1

; Rétablissement des couleurs pour LISTE0 (valable pour B24, B24GA, B24DR et B24GD)
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B24_REST:
	LDA >B24D		; B24 doit-il être (ré)affiché?
	BNE B28_REST_0 ; Si oui, pas besoin de rétablir les couleurs => RTS
	LDA >B24GAD		; B24GA doit-il être (ré)affiché?
	BNE B28_REST_0 ; Si oui, pas besoin de rétablir les couleurs => RTS
	LDA >B24DRD		; B24DR doit-il être (ré)affiché?
	BNE B28_REST_0 ; Si oui, pas besoin de rétablir les couleurs => RTS
	LDA >B24GDD		; B24GD doit-il être (ré)affiché?
	BNE B28_REST_0 ; Si oui, pas besoin de rétablir les couleurs => RTS

	LDX #SCROFFSET+$0508 ; X pointe la 1ère colonne.
	BSR B18_REST_1
	LDX #SCROFFSET+$0509 ; X pointe la 2ème colonne.
	BSR B18_REST_1
	LDX #SCROFFSET+$050A ; X pointe la 3ère colonne.
	BSR B18_REST_1
	LDX #SCROFFSET+$050B ; X pointe la 4ème colonne.
	BRA B18_REST_1

;------------------------------------------------------------------------------
; Fond B24GA
; = B24 avec l'ombre d'un mur à gauche.
;------------------------------------------------------------------------------
; Drapeau d'affichage
B24GAD	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B24GA:
	LDX #SCROFFSET+$0508 ; X pointe la 1ère colonne.
	LDY #B18GA_DATA
	BSR B18_2
	BRA B24_1

;------------------------------------------------------------------------------
; Fond B24DR
; = B24 avec l'ombre d'un mur à droite.
;------------------------------------------------------------------------------
; Drapeau d'affichage
B24DRD	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B24DR:
	LDX #SCROFFSET+$0508 ; X pointe la 1ère colonne.
	BSR B18_1
B24DR_1:
	LDX #SCROFFSET+$0509 ; X pointe la 2ème colonne.
	BSR B18_1
	LDX #SCROFFSET+$050A ; X pointe la 3ère colonne.
	BSR B18_1
	LDX #SCROFFSET+$050B ; X pointe la 4ème colonne.
	LDY #B27DR_DATA
	BRA B18_2

;------------------------------------------------------------------------------
; Fond B24GD
; = B24 avec l'ombre d'un mur à gauche et l'ombre d'un mur à droite.
;------------------------------------------------------------------------------
; Drapeau d'affichage
B24GDD	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B24GD:
	LDX #SCROFFSET+$0508 ; X pointe la 1ère colonne.
	LDY #B18GA_DATA
	BSR B18_2
	BRA B24DR_1

;------------------------------------------------------------------------------
; Fond B18
;------------------------------------------------------------------------------
; Drapeau d'affichage
B18D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B18:
	LDX #SCROFFSET+$0500 ; X pointe le fond à l'écran.
B18_1:
	LDY #B18_DATA	; Y pointe les données du fond.
B18_2:
	LBSR DISPLAY_YX_16	; Lignes 1 à 16
	LBSR DISPLAY_YX_9	; Lignes 17 à 25
	LBSR VIDEOC_A	; Sélection video couleur.
	LEAX -960,X		; Retour en haut de la tuile + 1 ligne
	LDA >MAPCOULC	; Couleurs sol/mur courantes.
	ANDA #%11110000	; A = couleurs sol/noir (0).
	LBSR DISPLAY_A_23	; Lignes 2 à 24
	INC	$E7C3		; Sélection vidéo forme.

B18_3:
	RTS

; Rétablissement des couleurs pour LISTE0 (valable pour B18 et B18GA)
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B18_REST:
	LDA >B18D		; B18 doit-il être (ré)affiché?
	BNE B18_3		; Si oui, pas besoin de rétablir les couleurs => RTS
	LDA >B18GAD		; B18 doit-il être (ré)affiché?
	BNE B18_3		; Si oui, pas besoin de rétablir les couleurs => RTS

	LDX #SCROFFSET+$0500 ; X pointe le fond à l'écran.

B18_REST_1:
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	ABX
	LBRA DISPLAY_A_23	; 23 lignes à restaurer.

;------------------------------------------------------------------------------
; Fond B18GA
; = B18 avec l'ombre d'un mur à gauche.
;------------------------------------------------------------------------------
; Drapeau d'affichage
B18GAD	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B18GA:
	LDX #SCROFFSET+$0500 ; X pointe le fond à l'écran.
	LDY #B18GA_DATA	; Y pointe les données du fond.
	BRA B18_2

;------------------------------------------------------------------------------
; Fond B19
;------------------------------------------------------------------------------
; Drapeau d'affichage
B19D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B19:
	LDX #SCROFFSET+$0501 ; X pointe le fond à l'écran.
	BRA B18_1

; Rétablissement des couleurs pour LISTE0
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B19_REST:
	LDX #SCROFFSET+$0501 ; X pointe le fond à l'écran.
	LDA >B19D		; B19 doit-il être (ré)affiché?
	BEQ B18_REST_1 ; Non => B18_REST_1

B19_REST_1:
	RTS				; Si oui, pas besoin de rétablir les couleurs.

;------------------------------------------------------------------------------
; Fond B21
;------------------------------------------------------------------------------
; Drapeau d'affichage
B21D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B21:
	LDX #SCROFFSET+$0504 ; X pointe le fond à l'écran.
	BRA B18_1

; Rétablissement des couleurs pour LISTE0 (valable aussi pour B21GA)
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B21_REST:
	LDA >B21D		; B21 doit-il être (ré)affiché?
	BNE B19_REST_1 ; Si oui, pas besoin de rétablir les couleurs => RTS
	LDA >B21GAD		; B21GA doit-il être (ré)affiché?
	BNE B19_REST_1 ; Si oui, pas besoin de rétablir les couleurs => RTS

	LDX #SCROFFSET+$0504 ; X pointe le fond à l'écran.
	BRA B18_REST_1 ; => B18_REST_1

;------------------------------------------------------------------------------
; Fond B21GA
; = B21 avec l'ombre d'un mur à gauche.
;------------------------------------------------------------------------------
; Drapeau d'affichage
B21GAD	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B21GA:
	LDX #SCROFFSET+$0504 ; X pointe le fond à l'écran.
	LDY #B18GA_DATA	; Y pointe les données du fond.
	LBRA B18_2

;------------------------------------------------------------------------------
; Fond B23
;------------------------------------------------------------------------------
; Drapeau d'affichage
B23D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B23:
	LDX #SCROFFSET+$0507 ; X pointe le fond à l'écran.
	LBRA B18_1

; Rétablissement des couleurs pour LISTE0
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B23_REST:
	LDX #SCROFFSET+$0507 ; X pointe le fond à l'écran.
	LDA >B23D		; B23 est-il à réafficher?
	LBEQ B18_REST_1 ; Non => B18_REST_1
	RTS				; Si oui, pas besoin de rétablir les couleurs.

;------------------------------------------------------------------------------
; Fond B25
;------------------------------------------------------------------------------
; Drapeau d'affichage
B25D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B25:
	LDX #SCROFFSET+$050C ; X pointe le fond à l'écran.
	LBRA B18_1

; Rétablissement des couleurs pour LISTE0
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B25_REST:
	LDX #SCROFFSET+$050C ; X pointe le fond à l'écran.
	LDA >B25D		; B25 est-il à réafficher?
	LBEQ B18_REST_1 ; Non => B18_REST_1

B25_REST_1:
	RTS				; Si oui, pas besoin de rétablir les couleurs.

;------------------------------------------------------------------------------
; Fond B27
;------------------------------------------------------------------------------
; Drapeau d'affichage
B27D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B27:
	LDX #SCROFFSET+$050F ; X pointe le fond à l'écran.
	LBRA B18_1

; Rétablissement des couleurs pour LISTE0 (valable pour B27 et B27DR)
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B27_REST:
	LDA >B27D		; B27 doit-il être (ré)affiché?
	BNE B25_REST_1 ; Si oui, pas besoin de rétablir les couleurs => RTS
	LDA >B27DRD		; B27DR doit-il être (ré)affiché?
	BNE B25_REST_1 ; Si oui, pas besoin de rétablir les couleurs => RTS

	LDX #SCROFFSET+$050F ; X pointe le fond à l'écran.
	LBRA B18_REST_1 ; => B18_REST_1

;------------------------------------------------------------------------------
; Fond B27DR
; = B27 avec l'ombre d'un mur à droite.
;------------------------------------------------------------------------------
; Drapeau d'affichage
B27DRD	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B27DR:
	LDX #SCROFFSET+$050F ; X pointe le fond à l'écran.
	LDY #B27DR_DATA	; Y pointe les données du fond.
	LBRA B18_2

;------------------------------------------------------------------------------
; Fond B29
;------------------------------------------------------------------------------
; Drapeau d'affichage
B29D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B29:
	LDX #SCROFFSET+$0512 ; X pointe le fond à l'écran.
	LBRA B18_1

; Rétablissement des couleurs pour LISTE0
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B29_REST:
	LDX #SCROFFSET+$0512 ; X pointe le fond à l'écran.
	LDA >B29D		; B29 est-il à réafficher?
	LBEQ B18_REST_1 ; Non => B18_REST_1

B29_REST_1:
	RTS				; Si oui, pas besoin de rétablir les couleurs.

;------------------------------------------------------------------------------
; Fond B30
;------------------------------------------------------------------------------
; Drapeau d'affichage
B30D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B30:
	LDX #SCROFFSET+$0513 ; X pointe le fond à l'écran.
	LBRA B18_1

; Rétablissement des couleurs pour LISTE0 (valable aussi pour B30DR)
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
B30_REST:
	LDA >B30D		; B30 doit-il être (ré)affiché?
	BNE B29_REST_1 ; Si oui, pas besoin de rétablir les couleurs => RTS
	LDA >B30DRD		; B30DR doit-il être (ré)affiché?
	BNE B29_REST_1 ; Si oui, pas besoin de rétablir les couleurs => RTS

	LDX #SCROFFSET+$0513 ; X pointe le fond à l'écran.
	LBRA B18_REST_1 ; => B18_REST_1

;------------------------------------------------------------------------------
; Fond B30DR
; = B30 avec l'ombre d'un mur à droite.
;------------------------------------------------------------------------------
; Drapeau d'affichage
B30DRD	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
B30DR:
	LDX #SCROFFSET+$0513 ; X pointe le fond à l'écran.
	LDY #B27DR_DATA	; Y pointe les données du fond.
	LBRA B18_2

;------------------------------------------------------------------------------
; Sol + plafond G26
;------------------------------------------------------------------------------
; Drapeau d'affichage
G26D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G26:
	BSR G26_2

; Routine commune avec CH26
G26_1:
	LDX #SCROFFSET+$08FB ; X pointe le sol à l'écran
	LDA #$FF
	LBRA DISPLAY_A_8

; Routine commune avec H26
G26_2:
	LDX #SCROFFSET+$0473 ; X pointe le plafond à l'écran
	LDA #$FF
	LBRA DISPLAY_A_4

;------------------------------------------------------------------------------
; Sol + plafond G25
;------------------------------------------------------------------------------
; Drapeau d'affichage
G25D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G25:
	BSR G25_2

; Routine commune avec CH25
G25_1:
	LDX #SCROFFSET+$08FA ; X pointe le sol à l'écran
	LDA #$FF
	LBRA DISPLAY_A_8

; Routine commune avec H25
G25_2:
	LDX #SCROFFSET+$0472 ; X pointe le plafond à l'écran
	LDA #$FF
	LBRA DISPLAY_A_4

;------------------------------------------------------------------------------
; Sol + plafond G17
;------------------------------------------------------------------------------
; Drapeau d'affichage
G17D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G17:
	BSR G17_2

; Routine commune avec CH17
G17_1:
	LDX #SCROFFSET+$08E9 ; X pointe le sol à l'écran
	LDA #$FF
	LBRA DISPLAY_A_8

; Routine commune avec H17
G17_2:
	LDX #SCROFFSET+$0461 ; X pointe le plafond à l'écran
	LDA #$FF
	LBRA DISPLAY_A_4

;------------------------------------------------------------------------------
; Sol + plafond G16
;------------------------------------------------------------------------------
; Drapeau d'affichage
G16D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G16:
	BSR G16_2

; Routine commune avec CH16
G16_1:
	LDX #SCROFFSET+$08E8 ; X pointe le sol à l'écran
	LDA #$FF
	LBRA DISPLAY_A_8

; Routine commune avec H16
G16_2:
	LDX #SCROFFSET+$0460 ; X pointe le plafond à l'écran
	LDA #$FF
	LBRA DISPLAY_A_4

;------------------------------------------------------------------------------
; Sol + plafond G24
; Les trous H24, H24B, CH24 et CH24B doivent rester superposés à G24 en liste 3.
;------------------------------------------------------------------------------
; Drapeau d'affichage
G24D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G24:
	LDX #SCROFFSET+$08F7 ; X pointe le sol à l'écran
	BRA G18_0

;------------------------------------------------------------------------------
; Sol + plafond G18
; Les trous H18, H18B, CH18 et CH18B doivent rester superposés à G18 en liste 3.
;------------------------------------------------------------------------------
; Drapeau d'affichage
G18D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G18:
	LDX #SCROFFSET+$08EA ; X pointe le sol à l'écran

G18_0:
	LDA #$FF		; Remplissage gris.
	LBSR DISPLAY_2A_8	; Affichage des colonnes 1 et 2.
	LEAX -318,X		; X pointe la colonne 3.
	LBSR DISPLAY_A_8	; Affichage de la colonne 3.

	LEAX -1482,X	; X pointe le plafond à l'écran.
	LBSR DISPLAY_2A_4	; Colonnes 1 et 2
	LEAX -158,X		; X pointe la colonne 3.
	LBRA DISPLAY_A_4	; Affichage de la colonne 3.

;------------------------------------------------------------------------------
; Sol + plafond G14
;------------------------------------------------------------------------------
; Drapeau d'affichage
G14D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G14:
	BSR G14_2

; Routine commune avec CH14
G14_1:
	LDX #SCROFFSET+$0A37 ; X pointe le sol à l'écran
	BRA G10_1_1

; Routine commune avec H14
G14_2:
	LDX #SCROFFSET+$032F ; X pointe le plafond à l'écran
	BRA G10_2_1

;------------------------------------------------------------------------------
; Sol + plafond G10
;------------------------------------------------------------------------------
; Drapeau d'affichage
G10D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G10:
	BSR G10_2

; Routine commune avec CH10
G10_1:
	LDX #SCROFFSET+$0A2A ; X pointe le sol à l'écran
G10_1_1:
	LDA #$FF		; Remplissage gris.
	LBSR DISPLAY_2A_16	; Affichage des colonnes 1 et 2.
	LEAX -638,X		; X pointe la colonne 3.
	LBRA DISPLAY_A_16	; Affichage de la colonne 3.

; Routine commune avec H10
G10_2:
	LDX #SCROFFSET+$0322 ; X pointe le plafond à l'écran
G10_2_1:
	LDA #$FF		; Remplissage gris.
	LBSR DISPLAY_2A_8		; Affichage des colonnes 1 et 2.
	LEAX -318,X		; X pointe la colonne 3.
	LBRA DISPLAY_A_8	; Affichage de la colonne 3.

;------------------------------------------------------------------------------
; Sol + plafond G15
;------------------------------------------------------------------------------
; Drapeau d'affichage
G15D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G15:
	BSR G15_2

; Routine commune avec CH15
G15_1:
	LDX #SCROFFSET+$0A3A ; X pointe le sol à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_16

; Routine commune avec H15
G15_2:
	LDX #SCROFFSET+$0332 ; X pointe le plafond à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_8

;------------------------------------------------------------------------------
; Sol + plafond G9
;------------------------------------------------------------------------------
; Drapeau d'affichage
G9D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G9:
	BSR G9_2

; Routine commune avec CH9
G9_1:
	LDX #SCROFFSET+$0A28 ; X pointe le sol à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_16

; Routine commune avec H9
G9_2:
	LDX #SCROFFSET+$0320 ; X pointe le plafond à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_8

;------------------------------------------------------------------------------
; Sol + plafond G8
;------------------------------------------------------------------------------
; Drapeau d'affichage
G8D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G8:
	BSR G8_2

; Routine commune avec CH4
G8_1:
	LDX #SCROFFSET+$0CBA ; X pointe le sol à l'écran
	LDA #$FF		; Remplissage gris
	LBSR DISPLAY_2A_16
	LBRA DISPLAY_2A_8

; Routine commune avec H4
G8_2:
	LDX #SCROFFSET+$0152 ; X pointe le plafond à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_12

;------------------------------------------------------------------------------
; Sol + plafond G4
;------------------------------------------------------------------------------
; Drapeau d'affichage
G4D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G4:
	BSR G4_2

; Routine commune avec CH4
G4_1:
	LDX #SCROFFSET+$0CA8 ; X pointe le sol à l'écran
	LDA #$FF		; Remplissage gris
	LBSR DISPLAY_2A_16
	LBRA DISPLAY_2A_8

; Routine commune avec H4
G4_2:
	LDX #SCROFFSET+$0140 ; X pointe le plafond à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_12

;------------------------------------------------------------------------------
; Sol + plafond G19
;------------------------------------------------------------------------------
; Drapeau d'affichage
G19D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G19:
	BSR G19_2

; Routine commune avec CH19
G19_1:
	LDX #SCROFFSET+$08ED ; X pointe le sol à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_8

; Routine commune avec H19
G19_2:
	LDX #SCROFFSET+$0465 ; X pointe le plafond à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_4

;------------------------------------------------------------------------------
; Sol + plafond G23
;------------------------------------------------------------------------------
; Drapeau d'affichage
G23D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G23:
	BSR G23_2

; Routine commune avec CH23
G23_1:
	LDX #SCROFFSET+$08F5 ; X pointe le sol à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_8

; Routine commune avec H23
G23_2:
	LDX #SCROFFSET+$046D ; X pointe le plafond à l'écran
	LDA #$FF		; Remplissage gris
	LBRA DISPLAY_2A_4

;------------------------------------------------------------------------------
; Sol + plafond G21
;------------------------------------------------------------------------------
; Drapeau d'affichage
G21D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G21:
	BSR G21_2

; Routine commune avec CH21
G21_1:
	LDX #SCROFFSET+$08F0 ; X pointe le sol à l'écran
	LDD #$FF25		; A = Remplissage gris. B = 37.
	LBSR G2_R1_6x4	; 6 lignes de 4 octets gris
	LEAX -1,X
	LDB #35
	LBSR G2_R1_2x6	; 2 lignes de 6 octets gris
	LDB	#40			; Offset pour les lignes suivante
	RTS

; Routine commune avec H21
G21_2:
	LDX #SCROFFSET+$0467 ; X pointe le plafond à l'écran
	LDD #$FF23		; A = gris. B = 35.
	LBSR G2_R1_2x6	; 2 lignes de 6 octets gris
	LEAX 1,X
	LDB #37
	LBSR G2_R1_2x4	; 2 lignes de 4 octets gris
	LDB	#40			; Offset pour les lignes suivante
	RTS

;------------------------------------------------------------------------------
; Sol + plafond G12
;------------------------------------------------------------------------------
; Drapeau d'affichage
G12D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G12:
	BSR G12_2

; Routine commune avec CH12
G12_1:
	LDX #SCROFFSET+$0A2F ; X pointe le sol à l'écran
	LDD #$FF23		; A = Remplissage gris. B = 35.
	LBSR G2_R1_6x6	; 6 lignes de 6 octets gris
	LEAX -1,X
	LBSR G2_R1_8x8	; 8 lignes de 8 octets gris
	LEAX -1,X
	LBSR G2_R1_2x10	; 2 lignes de 10 octets gris
	LDB	#40			; Offset pour les lignes suivante
	RTS

; Routine commune avec H12
G12_2:
	LDX #SCROFFSET+$0325 ; X pointe le plafond à l'écran
	LDA #$FF		; Remplissage gris
	LBSR G2_R1_2x10	; 2 lignes de 10 octets gris
	LEAX 1,X
	LDB #32
	LBSR G2_R1_4x8	; 4 lignes de 8 octets gris
	LEAX 1,X
	LDB #35
	LBSR G2_R1_2x6	; 4 lignes de 6 octets gris
	LDB	#40			; Offset pour les lignes suivante
	RTS

;------------------------------------------------------------------------------
; Sol + plafond G6
;------------------------------------------------------------------------------
; Drapeau d'affichage
G6D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G6:
	BSR G6_2

; Routine commune avec CH6
G6_1:
	LDX #SCROFFSET+$0CAD ; X pointe le sol à l'écran
	LDA #$FF		; Remplissage gris
	LBSR G2_R1_6x10	; 6 lignes de 10 octets gris
	LEAX -1,X
	LDB #28
	LBSR G2_R1_8x12	; 8 lignes de 12 octets gris
	LEAX -1,X
	LDB #26
	LBSR G2_R1_8x14	; 8 lignes de 14 octets gris
	LEAX -1,X
	LDB #24
	LBSR G2_R1_2x16	; 2 lignes de 16 octets gris
	LDB	#40			; Offset pour les lignes suivante
	RTS

; Routine commune avec H6
G6_2:
	LDX #SCROFFSET+$0142 ; X pointe le plafond à l'écran
	LDD #$FF18		; A = remplissage en gris. B = 24.
	LBSR G2_R1_2x16	; 2 lignes de 16 octets gris
	LEAX 1,X
	LDB #26
	LBSR G2_R1_4x14	; 4 lignes de 14 octets gris
	LEAX 1,X
	LDB #28
	LBSR G2_R1_4x12	; 4 lignes de 12 octets gris
	LEAX 1,X
	LBSR G2_R1_2x10	; 2 lignes de 10 octets gris
	LDB	#40			; Offset pour les lignes suivante
	RTS

;------------------------------------------------------------------------------
; Sol + plafond G2
;------------------------------------------------------------------------------
; Drapeau d'affichage
G2D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G2:
	BSR G2_2

; Routine commune avec CH2
G2_1:
	LDX #SCROFFSET+$106A ; X pointe le sol à l'écran
	LDD #$FF18		; A = Remplissage gris. B = 24
	BSR G2_R1_6x16	; 6 lignes de 16 octets gris
	LEAX -1,X
	LDB #22
	LBSR G2_R1_8x18	; 8 lignes de 18 octets gris
	LEAX -1,X
	LDB #20
	LBSR G2_R1_12x20 ; 12 lignes de 20 octets gris
	LDB	#40			; Offset pour les lignes suivante
	RTS

; Routine commune avec H2
G2_2:
	LDX #SCROFFSET	; X pointe le plafond à l'écran
	LDD #$FF14		; Remplissage gris. B = 20.
	LBSR G2_R1_2x20	; 2 lignes de 20 octets gris
	LEAX 1,X
	LDB #22
	LBSR G2_R1_4x18	; 4 lignes de 18 octets gris
	LEAX 1,X
	LDB #24
	BSR G2_R1_2x16	; 2 lignes de 16 octets gris
	LDB	#40			; Offset pour les lignes suivante
	RTS

; Lignes de 16 octets. B doit être égal à 24
G2_R1_131x16:
	BSR G2_R1_3x16
G2_R1_128x16:
	BSR G2_R1_64x16
G2_R1_64x16:
	BSR G2_R1_16x16
G2_R1_48x16:
	BSR G2_R1_16x16
G2_R1_32x16:
	BSR G2_R1_16x16
G2_R1_16x16:
	BSR G2_R1_16
G2_R1_15x16:
	BSR G2_R1_16
G2_R1_14x16:
	BSR G2_R1_16
G2_R1_13x16:
	BSR G2_R1_16
G2_R1_12x16:
	BSR G2_R1_16
G2_R1_11x16:
	BSR G2_R1_16
G2_R1_10x16:
	BSR G2_R1_16
G2_R1_9x16:
	BSR G2_R1_16
G2_R1_8x16:
	BSR G2_R1_16
G2_R1_7x16:
	BSR G2_R1_16
G2_R1_6x16:
	BSR G2_R1_16
G2_R1_5x16:
	BSR G2_R1_16
G2_R1_4x16:
	BSR G2_R1_16
G2_R1_3x16:
	BSR G2_R1_16
G2_R1_2x16:
	BSR G2_R1_16
	BRA G2_R1_16

; Lignes de 18 octets.  B doit être égal à 22
G2_R1_56x18:
	LDB #22
	BSR G2_R1_8x18
	BSR G2_R1_8x18
	BSR G2_R1_8x18
	BSR G2_R1_8x18
	BSR G2_R1_8x18
	BSR G2_R1_8x18
G2_R1_8x18:
	BSR G2_R1_18
	BSR G2_R1_18
	BSR G2_R1_18
	BSR G2_R1_18
G2_R1_4x18:
	BSR G2_R1_18
	BSR G2_R1_18
	BSR G2_R1_18
	BRA G2_R1_18

; Lignes de 20 octets. B doit être égal à 20
G2_R1_131x20:
	LDB #20			; Offset pour les sauts de lignes
	LDX #SCROFFSET	; X pointe l'écran en &0000
	BSR G2_R1_20
G2_R1_130x20:
	BSR G2_R1_10x20
	BSR G2_R1_12x20
	BSR G2_R1_12x20
	BSR G2_R1_12x20
	BSR G2_R1_12x20
	BSR G2_R1_12x20
	BSR G2_R1_12x20
	BSR G2_R1_12x20
G2_R1_36x20:
	BSR G2_R1_12x20
	BSR G2_R1_12x20
G2_R1_12x20:
	BSR G2_R1_2x20
G2_R1_10x20:
	BSR G2_R1_2x20
	BSR G2_R1_2x20
	BSR G2_R1_2x20
	BSR G2_R1_2x20
G2_R1_2x20:
	BSR G2_R1_20
G2_R1_20:
	STA	,X+		; 20
	STA	,X+		; 19
G2_R1_18:
	STA	,X+		; 18
	STA	,X+		; 17
G2_R1_16:
	STA	,X+		; 16
	STA	,X+		; 15
G2_R1_14:
	STA	,X+		; 14
	STA	,X+		; 13
G2_R1_12:
	STA	,X+		; 12
G2_R1_11:
	STA	,X+		; 11
G2_R1_10:
	STA	,X+		; 10
G2_R1_9:
	STA	,X+		; 9
G2_R1_8:
	STA	,X+		; 8
	STA	,X+		; 7
	STA	,X+		; 6
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X+		; 1
	ABX
	RTS

; Lignes de 14 octets. B doit être égal à 26
G2_R1_8x14:
	BSR G2_R1_14
	BSR G2_R1_14
	BSR G2_R1_14
	BSR G2_R1_14
G2_R1_4x14:
	BSR G2_R1_14
	BSR G2_R1_14
	BSR G2_R1_14
	BRA G2_R1_14

; Lignes de 12 octets. B doit être égal à 28
G2_R1_48x12:
	BSR G2_R1_8x12
	BSR G2_R1_8x12
	BSR G2_R1_8x12
	BSR G2_R1_8x12
	BSR G2_R1_8x12
G2_R1_8x12:
	BSR G2_R1_12
	BSR G2_R1_12
	BSR G2_R1_12
	BSR G2_R1_12
G2_R1_4x12:
	BSR G2_R1_12
	BSR G2_R1_12
	BSR G2_R1_12
	BRA G2_R1_12

; Lignes de 10 octets. B doit être égal à 30
G2_R1_32x10:
	BSR G2_R1_16x10
G2_R1_16x10:
	BSR G2_R1_8x10
G2_R1_8x10:
	BSR G2_R1_2x10
G2_R1_6x10:
	BSR G2_R1_2x10
G2_R1_4x10:
	BSR G2_R1_2x10
G2_R1_2x10:
	LDB #30
	BSR G2_R1_10
	BRA G2_R1_10

; Lignes de 8 octets. B doit être égal à 32.
G2_R1_40x8:
	BSR G2_R1_8x8
	BSR G2_R1_8x8
	BSR G2_R1_8x8
	BSR G2_R1_8x8
G2_R1_8x8:
	LDB #32
	BSR G2_R1_8
	BSR G2_R1_8
	BSR G2_R1_8
	BSR G2_R1_8
G2_R1_4x8:
	BSR G2_R1_8
	BSR G2_R1_8
	BSR G2_R1_8
	BRA G2_R1_8

; Lignes de 4 octets. B doit être égal à 37.
G2_R1_80x4:
	LDB #37
	BSR G2_R1_16x4
G2_R1_64x4:
	BSR G2_R1_32x4
G2_R1_32x4:
	BSR G2_R1_16x4
G2_R1_16x4:
	BSR G2_R1_8x4
G2_R1_8x4:
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_7x4:
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_6x4:
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_5x4:
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_4x4:
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_3x4:
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_2x4:
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_1x4:
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
	RTS

; Lignes de 6 octets. B doit être égal à 35.
G2_R1_48x6:
	BSR G2_R1_24x6
G2_R1_24x6:
	BSR G2_R1_8x6
G2_R1_16x6:
	BSR G2_R1_8x6
G2_R1_8x6:
	STA	,X+		; 6
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_7x6:
	STA	,X+		; 6
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_6x6:
	STA	,X+		; 6
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_5x6:
	STA	,X+		; 6
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_4x6:
	STA	,X+		; 6
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_3x6:
	STA	,X+		; 6
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_2x6:
	STA	,X+		; 6
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_1x6:
	STA	,X+		; 6
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
	RTS

; Lignes de 5 octets. B doit être égal à 36.
G2_R1_64x5:
	BSR G2_R1_32x5
G2_R1_32x5:
	BSR G2_R1_16x5
G2_R1_16x5:
	BSR G2_R1_8x5
G2_R1_8x5:
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_7x5:
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_6x5:
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_5x5:
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_4x5:
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_3x5:
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_2x5:
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
G2_R1_1x5:
	STA	,X+		; 5
	STA	,X+		; 4
	STA	,X+		; 3
	STA	,X+		; 2
	STA	,X		; 1
	ABX
	RTS

;------------------------------------------------------------------------------
; Sol + plafond G22
;------------------------------------------------------------------------------
; Drapeau d'affichage
G22D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G22:
	BSR G22_2

; Routine comme avec CH22
G22_1:
	LDX #SCROFFSET+$08F4 ; X pointe le sol à l'écran
	LDA #$FF
	LBRA DISPLAY_A_6	; 6 lignes grises

; Routine comme avec H22
G22_2:
	LDX #SCROFFSET+$04BC ; X pointe le plafond à l'écran
	LDA #$FF
	STA	,X
	ABX
	STA	,X
	RTS

;------------------------------------------------------------------------------
; Sol + plafond G7
;------------------------------------------------------------------------------
; Drapeau d'affichage
G7D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G7:
	BSR G7_2

; Routine commune avec CH7
G7_1:
	LDX #SCROFFSET+$0CB7 ; X pointe la première colonne du sol à l'écran
	LDA #$FF		; Ligne grise
	LBSR DISPLAY_2A_6
	LEAX 1,X
	LBSR DISPLAY_A_8
	LDX #SCROFFSET+$0CB9 ; X pointe la troisième colonne du sol à l'écran
	LBRA DISPLAY_A_22

; Routine commune avec H7
G7_2:
	LDX #SCROFFSET+$01A1 ; X pointe la troisième colonne du plafond à l'écran
	LDA #$FF		; Ligne grise
	LBSR DISPLAY_A_10
	LDX #SCROFFSET+$0240 ; X pointe la deuxième colonne du plafond à l'écran
	LBSR DISPLAY_A_4
	LEAX -1,X
	LBRA DISPLAY_2A_2

;------------------------------------------------------------------------------
; Sol + plafond G13
;------------------------------------------------------------------------------
; Drapeau d'affichage
G13D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G13:
	BSR G13_2

; Routine commune avec CH13
G13_1:
	LDX #SCROFFSET+$0A35 ; X pointe le sol à l'écran
	BRA G3_1_1

; Routine commune avec H13
G13_2:
	LDX #SCROFFSET+$037E ; X pointe le plafond à l'écran
	BRA G3_2_1

;------------------------------------------------------------------------------
; Sol + plafond G3
;------------------------------------------------------------------------------
; Drapeau d'affichage
G3D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G3:
	BSR G3_2

; Routine commune avec CH3
G3_1:
	LDX #SCROFFSET+$107A ; X pointe le sol à l'écran
G3_1_1:
	LDA #$FF		; Ligne grise
	LBSR DISPLAY_2A_6
	LEAX 1,X
	LBRA DISPLAY_A_8

; Routine commune avec H3
G3_2:
	LDX #SCROFFSET+$0063 ; X pointe le plafond à l'écran
G3_2_1:
	LDA #$FF		; Ligne grise
	LBSR DISPLAY_A_4
	LEAX -1,X
	STA ,X
	STA 1,X
	ABX
	STA ,X
	STA 1,X
	RTS

;------------------------------------------------------------------------------
; Sol + plafond G20
;------------------------------------------------------------------------------
; Drapeau d'affichage
G20D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G20:
	BSR G20_2

; Routine comme avec CH20
G20_1:
	LDX #SCROFFSET+$08EF ; X pointe le sol à l'écran
	LDA #$FF
	LBRA DISPLAY_A_6	; 6 lignes grises

; Routine comme avec H20
G20_2:
	LDX #SCROFFSET+$04B7 ; X pointe le plafond à l'écran
	LDA #$FF
	STA	,X
	ABX
	STA	,X
	RTS

;------------------------------------------------------------------------------
; Sol + plafond G5
;------------------------------------------------------------------------------
; Drapeau d'affichage
G5D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G5:
	BSR G5_2

; Routine comme avec CH5
G5_1:
	LDX #SCROFFSET+$0CAA ; X pointe la première colonne du sol à l'écran
	LDA #$FF		; Ligne grise
	LBSR DISPLAY_A_22
	LDX #SCROFFSET+$0CAB ; X pointe la deuxième colonne du sol à l'écran
	LBSR DISPLAY_2A_6
	LBRA DISPLAY_A_8

; Routine comme avec H5
G5_2:
	LDX #SCROFFSET+$0192 ; X pointe la première colonne du plafond à l'écran
	LDA #$FF		; Ligne grise
	LBSR DISPLAY_A_10
	LDX #SCROFFSET+$0233 ; X pointe la deuxième colonne du plafond à l'écran
	BRA G1_4

;------------------------------------------------------------------------------
; Sol + plafond G11
;------------------------------------------------------------------------------
; Drapeau d'affichage
G11D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G11:
	BSR G11_2

; Routine commune avec CH11
G11_1:
	LDX #SCROFFSET+$0A2D ; X pointe le sol à l'écran
	LDA #$FF		; Ligne grise
	LBSR DISPLAY_2A_6
	LBRA DISPLAY_A_8

; Routine commune avec H11
G11_2:
	LDX #SCROFFSET+$0375 ; X pointe le plafond à l'écran
	BRA G1_3

;------------------------------------------------------------------------------
; Sol + plafond G1
;------------------------------------------------------------------------------
; Drapeau d'affichage
G1D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
G1:
	BSR G1_2

; Routine commune avec CH1
G1_1:
	LDX #SCROFFSET+$1068 ; X pointe le sol à l'écran
	LDA #$FF		; Ligne grise
	LBSR DISPLAY_2A_6
	LBRA DISPLAY_A_8

; Routine commune avec H1
G1_2:
	LDX #SCROFFSET+$0050 ; X pointe le plafond à l'écran
G1_3:
	LDA #$FF		; Ligne grise
G1_4:
	LBSR DISPLAY_A_4
	STA ,X
	STA 1,X
	ABX
	STA ,X
	STA 1,X
	RTS

;------------------------------------------------------------------------------
;                        DONNEES DES MURS ET DES FONDS
;------------------------------------------------------------------------------
B18_DATA:
	FCB $FF	; 1
	FCB $55	; 2
	FCB $00	; 3
	FCB $00	; 4
	FCB $00	; 5
	FCB $00	; 6
	FCB $00	; 7
	FCB $00	; 8
	FCB $00	; 9
	FCB $00	; 10
	FCB $00	; 11
	FCB $00	; 12
	FCB $00	; 13
	FCB $00	; 14
	FCB $00	; 15
	FCB $00	; 16
	FCB $00	; 17
	FCB $00	; 18
	FCB $00	; 19
	FCB $00	; 20
	FCB $00	; 21
	FCB $00	; 22
	FCB $AA	; 23
	FCB $55	; 24
	FCB $FF	; 25

B18GA_DATA:
	FCB $FF	; 1
	FCB $55	; 2
	FCB $80	; 3
	FCB $40	; 4
	FCB $80	; 5
	FCB $40	; 6
	FCB $80	; 7
	FCB $40	; 8
	FCB $80	; 9
	FCB $40	; 10
	FCB $80	; 11
	FCB $40	; 12
	FCB $80	; 13
	FCB $40	; 14
	FCB $80	; 15
	FCB $40	; 16
	FCB $80	; 17
	FCB $40	; 18
	FCB $80	; 19
	FCB $40	; 20
	FCB $80	; 21
	FCB $40	; 22
	FCB $AA	; 23
	FCB $55	; 24
	FCB $FF	; 25

B27DR_DATA:
	FCB $FF	; 1
	FCB $55	; 2
	FCB $02	; 3
	FCB $01	; 4
	FCB $02	; 5
	FCB $01	; 6
	FCB $02	; 7
	FCB $01	; 8
	FCB $02	; 9
	FCB $01	; 10
	FCB $02	; 11
	FCB $01	; 12
	FCB $02	; 13
	FCB $01	; 14
	FCB $02	; 15
	FCB $01	; 16
	FCB $02	; 17
	FCB $01	; 18
	FCB $02	; 19
	FCB $01	; 20
	FCB $02	; 21
	FCB $01	; 22
	FCB $AA	; 23
	FCB $55	; 24
	FCB $FF	; 25

W18_DATA:
	FCB $FF
	FCB $55
	FCB $AB
	FCB $55
	FCB $AB
	FCB $55
W19_DATA:
	FCB $FF
	FCB $55
	FCB $AA
	FCB $55
	FCB $AA
	FCB $55
	FCB $FF
	FCB $55
	FCB $AB
	FCB $55
	FCB $AB
	FCB $55
	FCB $FF

W24_DATA:
	FCB $FF
	FCB $55
	FCB $AA
	FCB $55
	FCB $AA
	FCB $55
	FCB $FF
	FCB $55
	FCB $AA
	FCB $55
	FCB $AA
	FCB $55
	FCB $FF

W25_DATA:
	FCB $FF
	FCB $55
	FCB $AA
	FCB $55
	FCB $AA
	FCB $55
W27_DATA:
	FCB $FF
	FCB $D5
	FCB $AA
	FCB $D5
	FCB $AA
	FCB $D5
	FCB $FF
	FCB $55
	FCB $AA
	FCB $55
	FCB $AA
	FCB $55
	FCB $FF

; W31_DATA (voir les constantes).
; W32_DATA (voir les constantes).

W33_DATA:
	FCB $FF,$FF
	FCB $1F,$FF
	FCB $44,$BF
	FCB $11,$55
	FCB $44,$BA
	FCB $11,$55
	FCB $44,$BA
	FCB $11,$55
	FCB $FF,$FF
	FCB $15,$55
	FCB $44,$AB
	FCB $15,$55
	FCB $44,$AB
	FCB $15,$55
	FCB $44,$FF
	FCB $FF,$55
	FCB $44,$BA
	FCB $11,$55
	FCB $44,$BA
	FCB $11,$55
	FCB $44,$BF
	FCB $11,$55
	FCB $47,$EB
	FCB $7D,$55
	FCB $C4,$AB
	FCB $15,$55
	FCB $44,$AB
	FCB $15,$5F
	FCB $44
	FCB $17
	FCB $7F
	FCB $FF

W36_DATA:
	FCB $3F
	FCB $0F
	FCB $03
	FCB $02
	FCB $02,$3F
	FCB $02,$0F
	FCB $02,$03
	FCB $F2,$00
	FCB $0F,$F0
	FCB $00,$0F
	FCB $00,$03
	FCB $00,$3C
	FCB $03,$C0
	FCB $3E,$00
	FCB $C2,$00
	FCB $02,$01
	FCB $02,$07
	FCB $02,$09
	FCB $02,$31
	FCB $02,$C1
	FCB $03,$01
	FCB $06,$01
	FCB $08,$01
	FCB $30,$01
	FCB $C0,$01
	FCB $00,$03
	FCB $00,$07
	FCB $00,$0F
	FCB $00,$1F
	FCB $00,$3F
	FCB $00,$7F
	FCB $00
	FCB $01
	FCB $03
	FCB $07
	FCB $0F
	FCB $1F
	FCB $3F
	FCB $7F

W37_DATA:
	FCB $00,$07		; Colonnes 1 et 2
	FCB $00,$3C
	FCB $03,$C0
	FCB $3E,$00
	FCB $C2,$00
	FCB $02,$01
	FCB $02,$06
	FCB $02,$0C
	FCB $02,$34
	FCB $02,$C4
	FCB $03,$04
	FCB $06,$04
	FCB $08,$04
	FCB $30,$04
	FCB $C0,$04
	FCB $00,$05
	FCB $00,$07
	FCB $00,$07
	FCB $00,$0F
	FCB $00,$1F
	FCB $00,$3F
	FCB $00,$7F
	FCB $00
	FCB $01
	FCB $03
	FCB $07
	FCB $0F
	FCB $1F
	FCB $3F
	FCB $7F
	FCB $3F			; Colonne 3
	FCB $2F
	FCB $23
	FCB $F0
	FCB $0F
	FCB $03
	FCB $3C
	FCB $E0
	FCB $21
	FCB $27
	FCB $29
	FCB $31
	FCB $C1
	FCB $03
	FCB $07
	FCB $0F
	FCB $1F
	FCB $3F
	FCB $7F

W38_DATA:
	FCB $3F
	FCB $0F
	FCB $0B
	FCB $08
	FCB $08,$3F
	FCB $08,$1F
	FCB $08,$13
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $F8,$10
	FCB $0F,$F0
	FCB $00,$8F
	FCB $00,$81
	FCB $00,$81
	FCB $00,$81
	FCB $00,$81
	FCB $00,$81
	FCB $00,$81
	FCB $00,$81
	FCB $00,$81
	FCB $00,$83
	FCB $00,$BC
	FCB $03,$D0
	FCB $3C,$10
	FCB $C8,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$11
	FCB $08,$17
	FCB $08,$19
	FCB $08,$31
	FCB $08,$C1
	FCB $09,$81
	FCB $0E,$81
	FCB $08,$81
	FCB $30,$81
	FCB $C0,$81
	FCB $00,$83
	FCB $00,$87
	FCB $00,$8F
	FCB $00,$9F
	FCB $00,$BF
	FCB $00,$FF
	FCB $00
	FCB $01
	FCB $03
	FCB $07
	FCB $0F
	FCB $1F
	FCB $3F
	FCB $7F

W39_DATA:
	FCB $7F
	FCB $CF
	FCB $57
	FCB $CD
	FCB $56
	FCB $CD
	FCB $56
	FCB $F5
	FCB $4F
	FCB $1D
	FCB $4B
	FCB $1D
	FCB $4B
	FCB $1D
	FCB $4B
	FCB $3D
	FCB $CE
	FCB $55
	FCB $CE
	FCB $55
	FCB $CF
	FCB $57
	FCB $CD
	FCB $7B
	FCB $DD
	FCB $0B
	FCB $5D
	FCB $0B
	FCB $5F
	FCB $0F
	FCB $5F
	FCB $3F ; 32

; W41_DATA (voir les constantes).
; W42_DATA (voir les constantes).

W43_DATA:
	FCB $FF,$FF
	FCB $FF,$F2
	FCB $FE,$88
	FCB $5D,$22
	FCB $AA,$88
	FCB $5D,$22
	FCB $AA,$88
	FCB $5D,$22
	FCB $FF,$FF
	FCB $D5,$22
	FCB $AA,$A8
	FCB $D5,$22
	FCB $AA,$A8
	FCB $D5,$22
	FCB $FF,$A8
	FCB $5D,$FF
	FCB $AA,$88
	FCB $5D,$22
	FCB $AA,$88
	FCB $5D,$22
	FCB $EA,$88
	FCB $DD,$22
	FCB $AB,$E8
	FCB $D5,$2E
	FCB $AA,$A9
	FCB $D5,$22
	FCB $AA,$A8
	FCB $FD,$22
	FCB     $A8
	FCB     $E2
	FCB     $FC
	FCB     $FF

W46_DATA:
	FCB     $FC
	FCB     $F0
	FCB     $C0
	FCB     $40
	FCB $FC,$40
	FCB $F0,$40
	FCB $C0,$40
	FCB $00,$4F
	FCB $0F,$F0
	FCB $F0,$00
	FCB $C0,$00
	FCB $3C,$00
	FCB $03,$C0
	FCB $00,$7C
	FCB $00,$43
	FCB $80,$40
	FCB $E0,$40
	FCB $90,$40
	FCB $8C,$40
	FCB $83,$40
	FCB $80,$C0
	FCB $80,$60
	FCB $80,$10
	FCB $80,$0C
	FCB $80,$03
	FCB $C0,$00
	FCB $E0,$00
	FCB $F0,$00
	FCB $F8,$00
	FCB $FC,$00
	FCB $FE,$00
	FCB     $00
	FCB     $80
	FCB     $C0
	FCB     $E0
	FCB     $F0
	FCB     $F8
	FCB     $FC
	FCB     $FE

W47_DATA:
	FCB $E0,$00		; Colonnes 3 et 4
	FCB $3C,$00
	FCB $03,$C0
	FCB $00,$7C
	FCB $00,$43
	FCB $80,$40
	FCB $60,$40
	FCB $30,$40
	FCB $2C,$40
	FCB $23,$40
	FCB $20,$C0
	FCB $20,$60
	FCB $20,$10
	FCB $20,$0C
	FCB $20,$03
	FCB $A0,$00
	FCB $E0,$00
	FCB $E0,$00
	FCB $F0,$00
	FCB $F8,$00
	FCB $FC,$00
	FCB $FE,$00
	FCB     $00
	FCB     $80
	FCB     $C0
	FCB     $E0
	FCB     $F0
	FCB     $F8
	FCB     $FC
	FCB     $FE
	FCB $FC			; Colonne 3
	FCB $F4
	FCB $C4
	FCB $0F
	FCB $F0
	FCB $C0
	FCB $3C
	FCB $07
	FCB $84
	FCB $E4
	FCB $94
	FCB $8C
	FCB $83
	FCB $C0
	FCB $E0
	FCB $F0
	FCB $F8
	FCB $FC
	FCB $FE

W48_DATA:
	FCB     $FC
	FCB     $F0
	FCB     $D0
	FCB     $10
	FCB $FC,$10
	FCB $F8,$10
	FCB $C8,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$1F
	FCB $0F,$F0
	FCB $F1,$00
	FCB $81,$00
	FCB $81,$00
	FCB $81,$00
	FCB $81,$00
	FCB $81,$00
	FCB $81,$00
	FCB $81,$00
	FCB $81,$00
	FCB $C1,$00
	FCB $3D,$00
	FCB $0B,$C0
	FCB $08,$3C
	FCB $08,$13
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $08,$10
	FCB $88,$10
	FCB $E8,$10
	FCB $98,$10
	FCB $8C,$10 
	FCB $83,$10
	FCB $81,$90
	FCB $81,$70
	FCB $81,$10
	FCB $81,$0C
	FCB $81,$03
	FCB $C1,$00
	FCB $E1,$00
	FCB $F1,$00
	FCB $F9,$00
	FCB $FD,$00
	FCB $FF,$00
	FCB     $00
	FCB     $80
	FCB     $C0
	FCB     $E0
	FCB     $F0
	FCB     $F8
	FCB     $FC
	FCB     $FE

; W49_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H1 (superposé au sol de G1)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H1:
	LBSR G1_2		; Affichage du plafond.

	LDX #SCROFFSET+$1068 ; X pointe le trou à l'écran.
	LDY #H1_DATA	; Y pointe les données du trou
	LBSR DISPLAY_2YX_6
	LBRA DISPLAY_YX_8

; H1_DATA (voir les constantes)

;------------------------------------------------------------------------------
; Trou dans le sol H2 (superposé au sol de G2)
; Le drapeau est maintenu pour les rotations en lévitation au-dessus du trou.
;------------------------------------------------------------------------------
; Drapeau d'affichage
H2D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
H2:
	LBSR G2_2		; Affichage du plafond.

	LDX #SCROFFSET+$1159 ; X pointe la partie gauche du trou
	LDY #H2_DATA	; Y pointe les données du trou
	LBSR DISPLAY_YX_8	; Lignes 7 à 14
	LEAX -1,X
	LBSR DISPLAY_2YX_12	; Lignes 15 à 26

	LDX #SCROFFSET+$116A ; X pointe la partie droite du trou
	LBSR DISPLAY_YX_8	; Lignes 7 à 14
	LBSR DISPLAY_2YX_12	; Lignes 15 à 26

	LDX #SCROFFSET+$106A ; X pointe la partie centrale du trou
	LDD #$FF18		; A = gris. B = 24 pour les sauts de ligne.
	LBSR G2_R1_3x16
	INCB			; Offset de saut de ligne = 25 octets
	BSR H2_R1		; Lignes 4 à 14
	DECB			; Offset de saut de ligne = 24 octets
	LDA #$FF
	LBSR G2_R1_16	; Ligne 15 = ligne grise
	INCB			; Offset de saut de ligne = 25 octets
	BSR H2_R2		; Lignes 16 à 26
	LDB	#40			; Offset de saut de ligne = 40 octets

; Pixels à rafraichir après affichage de murs lattéraux
H2_2:
	LDX #SCROFFSET+$1131
	LDA ,X
	ANDA #%11111101
	STA ,X

	LDX #SCROFFSET+$1270
	LDA ,X
	ANDA #%11111101
	STA ,X

	LDX #SCROFFSET+$1142
	LDA ,X
	ANDA #%10111111
	STA ,X

	LDX #SCROFFSET+$1283
	LDA ,X
	ANDA #%10111111
	STA ,X

	RTS

H2_R1:
	BSR H2_R1_1
H2_R1_10:
	BSR H2_R1_4
H2_R1_6:			; Réutilisé par CH2
	BSR H2_R1_2
H2_R1_4:
	BSR H2_R1_2
H2_R1_2:
	BSR H2_R1_1
H2_R1_1:
	LDA #$01
	CLR ,X+
	CLR ,X+
	CLR ,X+
	STA ,X+

	CLR ,X+
	CLR ,X+
	CLR ,X+
	STA ,X+

	CLR ,X+
	CLR ,X+
	CLR ,X+
	CLR ,X+

	LDA #$80
	STA ,X+
	CLR ,X+
	CLR ,X+
	CLR ,X

	ABX
	RTS

H2_R2:
	LDA #$01
	BSR H2_R2_1
H2_R2_10:
	BSR H2_R2_4
H2_R2_6:
	BSR H2_R2_2
H2_R2_4:
	BSR H2_R2_2
H2_R2_2:
	BSR H2_R2_1
H2_R2_1:
	CLR ,X+
	STA ,X+
	CLR ,X+
	CLR ,X+

	CLR ,X+
	STA ,X+
	CLR ,X+
	CLR ,X+

	CLR ,X+
	STA ,X+
	CLR ,X+
	CLR ,X+

	CLR ,X+
	STA ,X+
	CLR ,X+
	CLR ,X

	ABX
	RTS

; Rétablissement des pixels pour LISTE0
H2_REST:
	INC	$E7C3		; Sélection vidéo forme

	LDX #SCROFFSET+$1131
	LDA ,X
	ORA  #%00000010
	STA ,X

	LDX #SCROFFSET+$1270
	LDA ,X
	ORA  #%00000010
	STA ,X

	LDX #SCROFFSET+$1142
	LDA ,X
	ORA  #%01000000
	STA ,X

	LDX #SCROFFSET+$1283
	LDA ,X
	ORA  #%01000000
	STA ,X

	LBRA VIDEOC_A	; Sélection video couleur + fin

; Data
H2_DATA:
	FCB     $F9
	FCB     $F1
	FCB     $E1
	FCB     $C1
	FCB     $81
	FCB     $01
	FCB     $01
	FCB     $01
	FCB $F9,$01
	FCB $F1,$03
	FCB $E1,$05
	FCB $C1,$09
	FCB $81,$11
	FCB $01,$21
	FCB $01,$21
	FCB $01,$41
	FCB $01,$81
	FCB $01,$01
	FCB $02,$01
	FCB $04,$01

	FCB $9F
	FCB $8F
	FCB $87
	FCB $83
	FCB $81
	FCB $80
	FCB $80
	FCB $80
	FCB $80,$9F
	FCB $C0,$8F
	FCB $A0,$87
	FCB $90,$83
	FCB $88,$81
	FCB $84,$80
	FCB $84,$80
	FCB $82,$80
	FCB $81,$80
	FCB $80,$80
	FCB $80,$40
	FCB $80,$20

;------------------------------------------------------------------------------
; Trou dans le sol H3 (superposé au sol de G3)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H3:
	LBSR G3_2		; Affichage du plafond.

	LDX #SCROFFSET+$107A ; X pointe le trou à l'écran.
	LDY #H3_DATA	; Y pointe les données du trou
	LBSR DISPLAY_2YX_6
	LEAX 1,X
	LBRA DISPLAY_YX_8

; H3_DATA (voir les constante)

;------------------------------------------------------------------------------
; Trou dans le sol H4 (superposé au sol de G4)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H4:
	LBSR G4_2		; Affichage du plafond.

	LDX #SCROFFSET+$0CA8 ; X pointe le sol
	LDY #H4_DATA	; Y pointe les données du trou
	BRA H4_R1_2

H4_R1_10:
	BSR H4_R1_2
	BSR H4_R1_2
	BSR H4_R1_2
	BSR H4_R1_2
H4_R1_2:
	BSR H4_R1_1
H4_R1_1:
	LDA #$FF
	STA ,X			; Ligne 1
	ABX
	STA ,X			; Ligne 2
	ABX
	LDA ,Y
	LBSR DISPLAY_A_6 ; Ligne 3 à 8
	LDA #$FF
	STA ,X			; Ligne 9 grise
	ABX
	LDA 1,Y
	LBSR DISPLAY_A_6 ; Ligne 10 à 15
	LDA #$FF
	STA ,X			; Ligne 16 grise
	ABX
	LDA ,Y++
	LBSR DISPLAY_A_5 ; Ligne 17 à 21
	LDA #$FF
	STA ,X			; Ligne 22
	ABX
	STA ,X			; Ligne 23
	ABX
	STA ,X			; Ligne 24
	LEAX -919,X
	RTS

;------------------------------------------------------------------------------
; Trou dans le sol H5 (superposé au sol de G5)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H5:
	LBSR G5_2		; Affichage du plafond.

	LDY #H5_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0CAA ; X pointe la 1ère colonne
	LBSR DISPLAY_YX_16
	LBSR DISPLAY_YX_6
	LDX #SCROFFSET+$0CAB ; X pointe la 2ème colonne
	LBSR DISPLAY_YX_14
	LDX #SCROFFSET+$0CAC ; X pointe la 3ème colonne
	LDA ,Y+
	STA ,X
	ABX
	LDA ,Y
	STA ,X
	ABX
	LEAY -5,Y
	LBRA DISPLAY_YX_4

; Data
; H5_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H6 (superposé au sol de G6)
; Le drapeau est maintenu pour de meilleures performances lors des déplacements
; de monstres.
;------------------------------------------------------------------------------
; Drapeau d'affichage
H6D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
H6:
	LBSR G6_2		; Affichage du plafond.

	LDY #H6_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0D9C ; X pointe la partie gauche du trou
	LBSR DISPLAY_YX_8	; Lignes 7 à 14
	LEAX -1,X
	LBSR DISPLAY_2YX_10	; Lignes 15 à 24

	LDX #SCROFFSET+$101A ; X pointe le sol en bas à gauche.
	LDA #$FF
	STA ,X
	ABX
	STA ,X

; Partie droite du trou
	LDX #SCROFFSET+$0DA7 ; X pointe la partie droite du trou
	LBSR DISPLAY_YX_8	; Lignes 7 à 14
	LBSR DISPLAY_2YX_10	; Lignes 15 à 24

	LDX #SCROFFSET+$1029 ; X pointe le sol en bas à droite.
	LDA #$FF
	STA ,X
	ABX
	STA ,X

; Partie centrale du trou
	LDX #SCROFFSET+$0CAD ; X pointe la partie centrale du trou à l'écran
	LBSR H4_R1_10	; Affichage de 10 colonnes de briques
	LDB	#40			; Offset de saut de ligne = 40 octets

; Pixels à rafraichir après affichage de murs lattéraux
H6_2:
	LDY #H6_DATA_PIX ; Y pointe les données
	LDX #SCROFFSET+$0D4C ; Partie gauche
	BSR H6_R1_2

	LDX #SCROFFSET+$0E63
	BSR H6_R1_3

	LDX #SCROFFSET+$0FA2
	BSR H6_R1_2

	LDX #SCROFFSET+$0D57 ; Partie droite
	BSR H6_R1_2

	LDX #SCROFFSET+$0E70
	BSR H6_R1_3

	LDX #SCROFFSET+$0FB1
	BRA H6_R1_2

;H6_R1_5:
;	LDA ,X
;	ANDA ,Y+
;	STA ,X
;	ABX
H6_R1_4:
	LDA ,X
	ANDA ,Y+
	STA ,X
	ABX
H6_R1_3:
	LDA ,X
	ANDA ,Y+
	STA ,X
	ABX
H6_R1_2:
	LDA ,X
	ANDA ,Y+
	STA ,X
	ABX
H6_R1_1:
	LDA ,X
	ANDA ,Y+
	STA ,X
	RTS

; Rétablissement des pixels pour LISTE0
H6_REST:
	INC	$E7C3		; Sélection vidéo forme

	LDY #H6_DATA_PIX ; Y pointe les données
	LDX #SCROFFSET+$0D4C ; Partie gauche
	BSR H6_R2_2

	LDX #SCROFFSET+$0E63
	BSR H6_R2_3

	LDX #SCROFFSET+$0FA2
	BSR H6_R2_2

	LDX #SCROFFSET+$0D57 ; Partie droite
	BSR H6_R2_2

	LDX #SCROFFSET+$0E70
	BSR H6_R2_3

	LDX #SCROFFSET+$0FB1
	BSR H6_R2_2

	LBRA VIDEOC_A	; Sélection video couleur + fin

;H6_R2_5:
;	LDA ,Y+
;	COMA
;	ORA ,X
;	STA ,X
;	ABX
H6_R2_4:
	LDA ,Y+
	COMA
	ORA ,X
	STA ,X
	ABX
H6_R2_3:
	LDA ,Y+
	COMA
	ORA ,X
	STA ,X
	ABX
H6_R2_2:
	LDA ,Y+
	COMA
	ORA ,X
	STA ,X
	ABX
H6_R2_1:
	LDA ,Y+
	COMA
	ORA ,X
	STA ,X
	RTS

; Data
H6_DATA:
	FCB     $F1
	FCB     $E1
	FCB     $E1
	FCB     $A1
	FCB     $23
	FCB     $25
	FCB     $29
	FCB     $31
	FCB $F0,$21
	FCB $E0,$41
	FCB $C0,$41
	FCB $C0,$83
	FCB $41,$85
	FCB $42,$89
	FCB $44,$91
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF

	FCB $8F
	FCB $87
	FCB $87
	FCB $85
	FCB $C4
	FCB $A4
	FCB $94
	FCB $8C
	FCB $84,$0F
	FCB $82,$07
	FCB $82,$03
	FCB $C1,$03
	FCB $A1,$82
	FCB $91,$42
	FCB $89,$22
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF

	FCB $00,$00
	FCB $00,$40
CH4_DATA:
	FCB $10,$00
	FCB $00,$04
	FCB $01,$00
	FCB $00,$00
	FCB $00,$40
	FCB $08,$00
	FCB $00,$04
	FCB $00,$00

H6_DATA_PIX:
	FCB %11111101
	FCB %11111001
	FCB %11111110
	FCB %11111100
	FCB %11111000
	FCB %11111110
	FCB %11111100
	FCB %10111111
	FCB %10011111
	FCB %01111111
	FCB %00111111
	FCB %00011111
	FCB %01111111
	FCB %00111111

;------------------------------------------------------------------------------
; Trou dans le sol H7 (superposé au sol de G7)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H7:
	LBSR G7_2		; Affichage du plafond.

	LDY #H7_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0CB7 ; X pointe la 1ère colonne
	LBSR DISPLAY_YX_6
	LDX #SCROFFSET+$0CB8 ; X pointe la 2ème colonne
	LBSR DISPLAY_YX_14
	LDX #SCROFFSET+$0CB9 ; X pointe la 3ème colonne
	LBSR DISPLAY_YX_16
	LBRA DISPLAY_YX_6

; Data
H7_DATA:
	FCB $FF		; Colonne 1
	FCB $FF
	FCB $FC
	FCB $FE
	FCB $FF
	FCB $FF

	FCB $FF		; Colonne 2
	FCB $FF
	FCB $00
	FCB $00
	FCB $00
	FCB $80
	FCB $C0
	FCB $E0
	FCB $FF
	FCB $F8
	FCB $FC
	FCB $FE
	FCB $FF
	FCB $FF

	FCB $FF		; Colonne 3
	FCB $FF
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $FF
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $C0
	FCB $FF
	FCB $F0
	FCB $F8
	FCB $FC
	FCB $FE
	FCB $FF
	FCB $FF

;------------------------------------------------------------------------------
; Trou dans le sol H8 (superposé au sol de G8)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H8:
	LBSR G8_2		; Affichage du plafond.

	LDX #SCROFFSET+$0CBA  ; X pointe la 1ère colonne
	LDY #H8_DATA	; Y pointe les données du trou
	LBRA H4_R1_2

H8_DATA:
	FCB $20,$00
	FCB $00,$04

;------------------------------------------------------------------------------
; Trou dans le sol H9 (superposé au sol de G9)
; Le drapeau est maintenu pour adapter les couleurs des ennemis en lévitation
; au dessus du trou.
;------------------------------------------------------------------------------
; Drapeau d'affichage
H9D		FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
H9:
	LBSR G9_2		; Affichage du plafond.

	LDX #SCROFFSET+$0A28 ; X pointe la première colonne
	LDY #H9_DATA	; Y pointe les données du trou
	LBSR DISPLAY_YX_16	; Lignes 1 à 16

	LDX #SCROFFSET+$0A29 ; X pointe la deuxième colonne
	BRA H9_R1_1		; Lignes 1 à 16

H9_R1_6:
	BSR H9_R1_3
H9_R1_3:
	BSR H9_R1_1
	BSR H9_R1_1
H9_R1_1:
	LDA #$FF
	STA ,X			; Ligne 1
	ABX
	STA ,X			; Ligne 2
	ABX
	LDA ,Y
	STA	,X			; Ligne 3
	ABX
	STA	,X			; Ligne 4
	ABX
	STA	,X			; Ligne 5
	ABX
	STA	,X			; Ligne 6
	ABX
	LDA #$FF
	STA ,X			; Ligne 7
	ABX
	LDA 1,Y
	STA	,X			; Ligne 8
	ABX
	STA	,X			; Ligne 9
	ABX
	STA	,X			; Ligne 10
	ABX
	STA	,X			; Ligne 11
	ABX
	LDA #$FF
	STA ,X			; Ligne 12
	ABX
	LDA ,Y++
	STA	,X			; Ligne 13
	ABX
	STA	,X			; Ligne 14
	ABX
	LDA #$FF
	STA ,X			; Ligne 15
	ABX
	STA	,X			; Ligne 16
	LEAX -599,X
	RTS

; Data
H9_DATA:
	FCB $FF
	FCB $FF
	FCB $F0
	FCB $90
	FCB $10
	FCB $10
	FCB $1F
	FCB $70
	FCB $90
	FCB $10
	FCB $10
	FCB $1F
	FCB $70
	FCB $90
	FCB $FF
	FCB $FF

	FCB $01,$40

;------------------------------------------------------------------------------
; Trou dans le sol H10 (superposé au sol de G10)
; Le drapeau est maintenu pour adapter les couleurs des ennemis en lévitation
; au dessus du trou.
;------------------------------------------------------------------------------
; Drapeau d'affichage
H10D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
H10:
	LBSR G10_2		; Affichage du plafond.
	LDX #SCROFFSET+$0A2A ; X pointe la première colonne
	LDY #H10_DATA	; Y pointe les données du trou
	BRA H9_R1_3

;------------------------------------------------------------------------------
; Trou dans le sol H11 (superposé au sol de G11)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H11:
	LBSR G11_2		; Affichage du plafond.

	LDY #H11_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0A2D ; X pointe la 1ère colonne
	LBSR DISPLAY_YX_14	; Lignes 1 à 14
	LDX #SCROFFSET+$0A2E ; X pointe la 2ème colonne
	LBRA DISPLAY_YX_6	; Lignes 1 à 6

; H11_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H12 (superposé au sol de G12)
; Le drapeau est maintenu pour de meilleures performances lors des déplacements
; de monstres.
;------------------------------------------------------------------------------
; Drapeau d'affichage
H12D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
H12:
	LBSR G12_2		; Affichage du plafond.

	LDY #H12_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0B1E ; X pointe la deuxième colonne
	LBSR DISPLAY_YX_10
	LDX #SCROFFSET+$0B25 ; X pointe la neuvième colonne
	LBSR DISPLAY_YX_10
	LDX #SCROFFSET+$0A2F ; X pointe la troisième colonne
	LBSR H9_R1_6

; Pixels à rafraichir après affichage de murs lattéraux 
H12_2:
	LDY #H12_DATA_PIX ; Y pointe les données
	LDX #SCROFFSET+$0A7E ; Partie gauche
	LDA ,X
	ORA #%00000111
	STA ,X
	ABX
	LBSR H6_R1_3

	LDX #SCROFFSET+$0BBD
	LBSR H6_R1_4
	ABX
	LDA #$FF
	STA ,X
	ABX
	STA ,X

	LDX #SCROFFSET+$0A85 ; Partie droite
	LDA ,X
	ORA #%11100000
	STA ,X
	ABX
	LBSR H6_R1_3

	LDX #SCROFFSET+$0BC6
	LBSR H6_R1_4
	ABX
	LDA #$FF
	STA ,X
	ABX
	STA ,X
	RTS

; Rétablissement des pixels pour LISTE0
H12_REST:
	INC	$E7C3		; Sélection vidéo forme

	LDY #H12_DATA_PIX ; Y pointe les données
	LDX #SCROFFSET+$0AA6 ; Partie gauche
	LBSR H6_R2_3

	LDX #SCROFFSET+$0BBD
	LBSR H6_R2_4

	LDX #SCROFFSET+$0AAD ; Partie droite
	LBSR H6_R2_3

	LDX #SCROFFSET+$0BC6
	LBSR H6_R2_4

	LBRA VIDEOC_A	; Sélection video couleur + fin

; Data
H12_DATA:
	FCB $F1			; 2ème colonne
	FCB $D3
	FCB $95
	FCB $19
	FCB $11
	FCB $11
	FCB $23
	FCB $45
	FCB $FF
	FCB $FF

	FCB $8F			; 9ème colonne 
	FCB $CB
	FCB $A9
	FCB $98
	FCB $88
	FCB $88
	FCB $C4
	FCB $A2
	FCB $FF
	FCB $FF

H10_DATA:
	FCB $00,$04		; 3ème colonne
	FCB $10,$00
	FCB $01,$40
	FCB $00,$04
	FCB $08,$00
	FCB $00,$40

; H12_DATA_PIX (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H13 (superposé au sol de G13)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H13:
	LBSR G13_2		; Affichage du plafond.

	LDY #H13_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0A35 ; X pointe la 1ère colonne
	LBSR DISPLAY_YX_6	; Lignes 1 à 6
	LDX #SCROFFSET+$0A36 ; X pointe la 2ème colonne
	LBRA DISPLAY_YX_14	; Lignes 1 à 14

; Data
H13_DATA:
	FCB $FF
	FCB $FF
	FCB $F8
	FCB $FC
	FCB $FE
	FCB $FF

	FCB $FF
	FCB $FF
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $FF
	FCB $C0
	FCB $E0
	FCB $F0
	FCB $F8
	FCB $FF
	FCB $FE
	FCB $FF

;------------------------------------------------------------------------------
; Trou dans le sol H14 (superposé au sol de G14)
; Le drapeau est maintenu pour adapter les couleurs des ennemis en lévitation
; au dessus du trou.
;------------------------------------------------------------------------------
; Drapeau d'affichage
H14D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
H14:
	LBSR G14_2		; Affichage du plafond.

	LDX #SCROFFSET+$0A37 ; X pointe la première colonne
	LDY #H14_DATA	; Y pointe les données du trou
	LBRA H9_R1_3

; H14_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H15 (superposé au sol de G15)
; Le drapeau est maintenu pour adapter les couleurs des ennemis en lévitation
; au dessus du trou.
;------------------------------------------------------------------------------
; Drapeau d'affichage
H15D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
H15:
	LBSR G15_2		; Affichage du plafond.

	LDX #SCROFFSET+$0A3A ; X pointe la première colonne
	LDY #H15_DATA	; Y pointe les données du trou
	LBSR H9_R1_1	; Lignes 1 à 16
	LBRA DISPLAY_YX_16	; 2ème colonne, lignes 1 à 16

; Data
H15_DATA:
	FCB $80,$02

	FCB $FF
	FCB $FF
	FCB $0F
	FCB $09
	FCB $08
	FCB $08
	FCB $F8
	FCB $0E
	FCB $09
	FCB $08
	FCB $08
	FCB $F8
	FCB $0E
	FCB $09
	FCB $FF
	FCB $FF

;------------------------------------------------------------------------------
; Trou dans le sol H16 (superposé au sol de G16)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H16:
	LBSR G16_2		; Affichage du plafond.

	LDX #SCROFFSET+$08E8 ; X pointe la première colonne
	LDY #H16_DATA	; Y pointe les données du trou
	LBRA DISPLAY_YX_8

; H16_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H17 (superposé au sol de G17)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H17:
	LBSR G17_2		; Affichage du plafond.

	LDX #SCROFFSET+$08E9 ; X pointe le sol
	LDY #H17_DATA	; Y pointe les données du trou
	LBRA DISPLAY_YX_8

; H17_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H18B (superposé au sol de G18B)
; Drapeau d'affichage inutile.
; ATTENTION : LE TROU H18B DOIT ETRE SUPERPOSE A G18
;------------------------------------------------------------------------------
; Routine de tuile codée
H18B:
	LDX #SCROFFSET+$0912 ; X pointe le sol
	LDA #$AA
	STA ,X			; Ligne 2
	ABX
	LDA #$5F
	STA ,X			; Ligne 3
	ABX
	LDA ,X
	ANDA #%00111111
	ORA  #%10000000
	STA ,X			; Ligne 4
	RTS

;------------------------------------------------------------------------------
; Trou dans le sol H18 (superposé au sol de G18)
; Inutile de maintenir le drapeau pour les adaptations de couleurs des ennemis.
; ATTENTION : LE TROU H18 DOIT ETRE SUPERPOSE A G18
;------------------------------------------------------------------------------
; Routine de tuile codée
H18:
	LDX #SCROFFSET+$0962 ; X pointe la 1ère colonne
	LDY #H18_DATA	; Y pointe les données du trou
	LDA ,X
	ANDA #%11111110
	STA ,X
	ABX
	LBSR DISPLAY_YX_3

	LDX #SCROFFSET+$0913 ; X pointe la 2ème colonne
	LBSR DISPLAY_YX_6

	LDX #SCROFFSET+$0914 ; X pointe la 3ème colonne
	LBRA DISPLAY_YX_6

; Data
H18_DATA:
	FCB $F5			; H18 colonne 1
	FCB $AB
	FCB $55

	FCB $FD			; H18 colonne 2
	FCB $D6
	FCB $AD
	FCB $57
	FCB $BD
	FCB $56

	FCB $55			; H18 colonne 3
	FCB $AE
	FCB $55
	FCB $FF
	FCB $55
	FCB $EA

;------------------------------------------------------------------------------
; Trou dans le sol H20 (superposé au sol de G20)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H20:
	LBSR G20_2		; Affichage du plafond.

	LDY #H20_DATA
	LDX #SCROFFSET+$08EF
	LBRA DISPLAY_YX_6

H20_DATA:
	FCB $FF
	FCB %10101111
	FCB %01011111
	FCB %10111111
	FCB $FF
	FCB $FF

;------------------------------------------------------------------------------
; Trou dans le sol H21 (superposé au sol de G21)
; Le drapeau est maintenu pour de meilleures performances lors des déplacements
; de monstres.
;------------------------------------------------------------------------------
; Drapeau d'affichage
H21D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
H21:
	LBSR G21_2		; Affichage du plafond.

	LDY #H21_DATA		; Y pointe les données
	LDX #SCROFFSET+$09DF ; Colonne 1
	LBSR DISPLAY_YX_2
	LDX #SCROFFSET+$08F0 ; Colonne 2
	LBSR DISPLAY_YX_8
	LDX #SCROFFSET+$08F1 ; Colonne 3
	LEAY -8,Y
	LBSR DISPLAY_YX_8
	LDX #SCROFFSET+$08F2 ; Colonne 4
	LEAY -8,Y
	LBSR DISPLAY_YX_8
	LDX #SCROFFSET+$08F3 ; Colonne 5
	LEAY -8,Y
	LBSR DISPLAY_YX_8
	LDX #SCROFFSET+$09E4 ; Colonne 6
	LBSR DISPLAY_YX_2

H21_2:
	LDY #H21_DATA_PIX	; Y pointe les données
	LDX #SCROFFSET+$093F ; X pointe la 1ère colonne
	LBSR H6_R1_4

	LDX #SCROFFSET+$0944 ; X pointe la 6ème colonne
	LBRA H6_R1_4

; Rétablissement des pixels pour LISTE0
H21_REST:
	INC	$E7C3		; Sélection vidéo forme

	LDY #H21_DATA_PIX ; Y pointe les données
	LDX #SCROFFSET+$093F ; X pointe la partie gauche
	LBSR H6_R2_4

	LDX #SCROFFSET+$0944 ; X pointe la partie droite
	LBSR H6_R2_4

	LBRA VIDEOC_A	; Sélection video couleur + fin

; Data
H21_DATA:
	FCB $D5		; Colonne 1
	FCB $FF

	FCB $FF		; Colonnes 2 à 5
	FCB $55
	FCB $AB
	FCB $55
	FCB $FF
	FCB $55
	FCB $BA
	FCB $FF

	FCB $AB		; Colonne 6
	FCB $FF

; H21_DATA_PIX (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H22 (superposé au sol de G22)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H22:
	LBSR G22_2		; Affichage du plafond.

	LDY #H22_DATA
	LDX #SCROFFSET+$08F4
	LBRA DISPLAY_YX_6

H22_DATA:
	FCB $FF
	FCB %11110101
	FCB %11111010
	FCB %11111101
	FCB $FF
	FCB $FF

;------------------------------------------------------------------------------
; Trou dans le sol H19 (superposé au sol de G19)
; Inutile de maintenir le drapeau pour les adaptations de couleurs des ennemis.
;------------------------------------------------------------------------------
; Routine de tuile codée
H19:
	LBSR G19_2		; Affichage du plafond.

	LDY #H19_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$08ED ; X pointe la 1ère colonne
	BRA H23_2

; H19_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H23 (superposé au sol de G23)
; Inutile de maintenir le drapeau pour les adaptations de couleurs des ennemis.
;------------------------------------------------------------------------------
; Routine de tuile codée
H23:
	LBSR G23_2		; Affichage du plafond.

	LDY #H23_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$08F5 ; X pointe la 1ère colonne
H23_2:
	LBSR DISPLAY_YX_8
	LEAX -319,X
	LEAY 32,Y		; Y pointe les données suivantes dans l'interface
	LBRA DISPLAY_YX_8

; H23_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H24 (superposé au sol de G24)
; Inutile de maintenir le drapeau pour les adaptations de couleurs des ennemis.
; ATTENTION : LE TROU H24 DOIT ETRE SUPERPOSE A G24
;------------------------------------------------------------------------------
; Routine de tuile codée
H24:
	LDX #SCROFFSET+$091F ; X pointe la 1ère colonne
	LDY #H24_DATA	; Y pointe les données du trou
	LBSR DISPLAY_YX_6	; 6 lignes à afficher
	LEAX -239,X		; Colonne suivante
	LBSR DISPLAY_YX_6	; 6 lignes à afficher
	LDX #SCROFFSET+$0971
	LDA ,X
	ANDA #%01111111
	STA ,X
	ABX
	LBRA DISPLAY_YX_3

; H24_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H24B (superposé au sol de G24B)
; Drapeau d'affichage inutile.
; ATTENTION : LE TROU H24B DOIT ETRE SUPERPOSE A G24B
;------------------------------------------------------------------------------
; Routine de tuile codée
H24B:
	LDY #H24B_DATA
	LDX #SCROFFSET+$0921 ; X pointe le sol
	LBRA H6_R1_3

H24B_DATA:
	FCB %01010101
	FCB %11111010
	FCB %11111101

;------------------------------------------------------------------------------
; Trou dans le sol H25 (superposé au sol de G25)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H25:
	LBSR G25_2		; Affichage du plafond.

	LDX #SCROFFSET+$08FA ; X pointe le sol
	LDY #H25_DATA	; Y pointe les données du trou
	LBRA DISPLAY_YX_8

; H25_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le sol H26 (superposé au sol de G26)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
H26:
	LBSR G26_2		; Affichage du plafond.

	LDX #SCROFFSET+$08FB ; X pointe le sol
	LDY #H26_DATA	; Y pointe les données du trou
	LBRA DISPLAY_YX_8

; H26_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le plafond HC1 (superposé au plafond de G1)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH1:
	LBSR G1_1		; Affichage du sol.

	LDY #CH1_DATA
	LDX #SCROFFSET+$0050 ; X pointe le plafond
	LBSR DISPLAY_YX_4
	LDA #$FF
	LBRA DISPLAY_2A_2

CH1_DATA:
	FCB $FF
	FCB %00111111
	FCB %00001111
	FCB %00000011

;------------------------------------------------------------------------------
; Trou dans le plafond CH2 (superposé au plafond de G2)
; Le drapeau est maintenu pour les rotations en lévitation en dessous du trou.
;------------------------------------------------------------------------------
; Drapeau d'affichage
CH2D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
CH2:
	LBSR G2_1		; Affichage du sol.

; Partie gauche du trou
	LDY #CH2_DATA	; Y pointe les données du trou
	LDX #SCROFFSET	; X pointe la 1ème colonne
	LDA ,Y+
	STA ,X
	ABX
	LDA ,Y+
	STA ,X
	LEAX -39,X		; X pointe la 2ème colonne.
	LBSR DISPLAY_YX_6

; Partie droite du trou
	LDX #SCROFFSET+$0012 ; X pointe la 19ème colonne
	LBSR DISPLAY_YX_6
	LDX #SCROFFSET+$0013 ; X pointe la 20ème colonne
	LDA ,Y+
	STA ,X
	ABX
	LDA ,Y+
	STA ,X

; Partie centrale du trou
	LDX #SCROFFSET+$0002 ; X pointe la première colonne
	LDB	#25			; Offset de saut de ligne = 25 octets
	LBSR H2_R1_6	; Lignes 1 à 6
	LDD #$FF18		; A = gris. B = 24.
	LBSR G2_R1_2x16	; 2 lignes de 16 octets gris
	LDB	#40			; Offset pour les lignes suivante
	RTS

; Data
CH2_DATA:
	FCB $F0			; Partie gauche
	FCB $FC
	FCB $01
	FCB $01
	FCB $01
	FCB $C1
	FCB $F1
	FCB $FD
	FCB $80			; Partie droite
	FCB $80
	FCB $80
	FCB $83
	FCB $8F
	FCB $BF
	FCB $0F
	FCB $3F

;------------------------------------------------------------------------------
; Trou dans le plafond HC3 (superposé au plafond de G3)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH3:
	LBSR G3_1		; Affichage du sol.

	LDY #CH3_DATA
	LDX #SCROFFSET+$0063 ; X pointe le plafond
	LBSR DISPLAY_YX_4
	LEAX -1,X
	LDA #$FF
	LBRA DISPLAY_2A_2

CH3_DATA:
	FCB $FF
	FCB %11111100
	FCB %11110000
	FCB %11000000

;------------------------------------------------------------------------------
; Trou dans le plafond CH4 (superposé au plafond de G4)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH4:
	LBSR G4_1		; Affichage du sol.

	LDY #CH4_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0140 ; X pointe la première colonne
	BSR CH4_R1_2	; Affichage des deux colonnes
	LDX #SCROFFSET+$0169
	LDA #$01		; Rectification de la deuxième colonne
	STA ,X
	RTS

; Sous-routines d'affichage de blocs 8x10
CH4_R1_10:
	BSR CH4_R1_2
	BSR CH4_R1_2
	BSR CH4_R1_2
	BSR CH4_R1_2
CH4_R1_2:
	BSR CH4_R1_1
CH4_R1_1:
	LDA #$FF
	STA	,X			; Ligne 1
	ABX
	LDA ,Y+
	STA	,X			; Ligne 2
	ABX
	STA	,X			; Ligne 3
	ABX
	STA	,X			; Ligne 4
	ABX
	LDA #$FF
	STA	,X			; Ligne 5
	ABX
	LDA ,Y+
	STA	,X			; Ligne 6
	ABX
	STA	,X			; Ligne 7
	ABX
	STA	,X			; Ligne 8
	ABX
	STA	,X			; Ligne 9
	ABX
	STA	,X			; Ligne 10
	ABX
	STA	,X			; Ligne 11
	ABX
	LDA #$FF
	STA	,X			; Ligne 12
	LEAX -439,X
	RTS

;------------------------------------------------------------------------------
; Trou dans le plafond CH11 (superposé au plafond de G11)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH11:
	LBSR G11_1		; Affichage du sol.

	LDY #CH11_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0375 ; X pointe la première colonne
	BRA CH5_1

; CH11_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le plafond CH5 (superposé au plafond de G5)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH5:
	LBSR G5_1		; Affichage du sol.

	LDY #CH5_DATA
	LDX #SCROFFSET+$0192 ; X pointe la première colonne
	LBSR DISPLAY_YX_10

	LDX #SCROFFSET+$0233 ; X pointe la 2ème colonne
CH5_1:
	LBSR DISPLAY_YX_6
	LEAX -79,X			 ; X pointe la 3ème colonne
	LBRA DISPLAY_YX_2

; CH5_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le plafond CH6 (superposé au plafond de G6)
; Le drapeau est maintenu pour de meilleures performances lors des déplacements
; de monstres.
;------------------------------------------------------------------------------
; Drapeau d'affichage
CH6D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
CH6:
	LBSR G6_1		; Affichage du sol.

; Partie gauche du trou
	LDY #CH6_DATA
	LDX #SCROFFSET+$0142 ; X pointe la 1ère colonne
	LBSR DISPLAY_YX_2
	LDX #SCROFFSET+$0143 ; X pointe la 2ème colonne
	LBSR DISPLAY_YX_6
	LDX #SCROFFSET+$0144 ; X pointe la 3ème colonne
	LBSR DISPLAY_YX_10

; Partie droite du trou
	LDX #SCROFFSET+$014F ; X pointe la 14ème colonne
	LBSR DISPLAY_YX_10	; 1ère colonne
	LDX #SCROFFSET+$0150 ; X pointe la 15ème colonne
	LBSR DISPLAY_YX_6	; 2ème colonne
	LDX #SCROFFSET+$0151 ; X pointe la 16ème colonne
	LBSR DISPLAY_YX_2

; Partie centrale du trou
	LDX #SCROFFSET+$0145 ; X pointe la 4ème colonne
	LBSR CH4_R1_10

; Pixels à rafraichir après affichage de murs lattéraux 
CH6_2:
	LDX #SCROFFSET+$0192 ; X pointe la 1ère colonne
	LDA ,X
	ANDA #%11111110
	STA ,X

	LDX #SCROFFSET+$0233 ; X pointe la 2ème colonne
	LDA ,X
	ANDA #%11111110
	STA ,X

	LDX #SCROFFSET+$0240 ; X pointe la 15ème colonne
	LDA ,X
	ANDA #%01111111
	STA ,X

	LDX #SCROFFSET+$01A1 ; X pointe la 16ème colonne
	LDA ,X
	ANDA #%01111111
	STA ,X

	RTS

; Rétablissement des pixels pour LISTE0
CH6_REST:
	INC	$E7C3		; Sélection vidéo forme

	LDX #SCROFFSET+$0192 ; X pointe la 1ère colonne
	LDA ,X
	ORA #%00000001
	STA ,X

	LDX #SCROFFSET+$0233 ; X pointe la 2ème colonne
	LDA ,X
	ORA #%00000001
	STA ,X

	LDX #SCROFFSET+$0240 ; X pointe la 15ème colonne
	LDA ,X
	ORA #%10000000
	STA ,X

	LDX #SCROFFSET+$01A1 ; X pointe la 16ème colonne
	LDA ,X
	ORA #%10000000
	STA ,X

	LBRA VIDEOC_A	; Sélection video couleur + fin

; Data
CH6_DATA:
	FCB $FF			; Colonne 1
	FCB $F8

	FCB $FF			; Colonne 2
	FCB $00
	FCB $00
	FCB $80
	FCB $E0
	FCB $F8

	FCB $FF			; Colonne 3
	FCB $71
	FCB $49
	FCB $47
	FCB $41
	FCB $41
	FCB $41
	FCB $C1
	FCB $E1
	FCB $F9

	FCB $FF			; Colonne 14
	FCB $8E
	FCB $92
	FCB $E2
	FCB $82
	FCB $82
	FCB $82
	FCB $83
	FCB $87
	FCB $9F

	FCB $FF			; Colonne 15
	FCB $00
	FCB $00
	FCB $01
	FCB $07
	FCB $1F

	FCB $FF			; Colonne 16
	FCB $1F

	FCB $00,$00		; Partie centrale
	FCB $40,$00
H4_DATA:
	FCB $00,$10
	FCB $04,$00
	FCB $00,$01
	FCB $00,$00
	FCB $40,$00
	FCB $00,$08
	FCB $20,$00
	FCB $00,$00

;------------------------------------------------------------------------------
; Trou dans le plafond CH13 (superposé au plafond de G13)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH13:
	LBSR G13_1		; Affichage du sol.

	LDY #CH13_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$037E ; X pointe la 2ème colonne
	BRA CH7_1

; CH13_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le plafond CH7 (superposé au plafond de G7)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH7:
	LBSR G7_1		; Affichage du sol.

	LDY #CH7_DATA
	LDX #SCROFFSET+$01A1 ; X pointe la 3ème colonne
	LBSR DISPLAY_YX_10

	LDX #SCROFFSET+$0240 ; X pointe la 2ème colonne
CH7_1:
	LBSR DISPLAY_YX_6
	LEAX -81,X			 ; X pointe la 3ème colonne
	LBRA DISPLAY_YX_2

; CH7_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le plafond CH8 (superposé au plafond de G8)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH8:
	LBSR G8_1		; Affichage du sol.

	LDY #CH8_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0152 ; X pointe la première colonne
	LBSR CH4_R1_2	; Affichage des deux colonnes
	LDX #SCROFFSET+$017A ; X pointe de nouveau la première colonne
	LDA #$80		; Rectification de la première colonne
	STA ,X
	RTS

; Data
CH8_DATA:
	FCB $00,$20
	FCB $08,$00

;------------------------------------------------------------------------------
; Trou dans le plafond CH9 (superposé au plafond de G9)
; Le drapeau est maintenu pour adapter les couleurs des ennemis en dessous.
;------------------------------------------------------------------------------
; Drapeau d'affichage
CH9D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
CH9:
	LBSR G9_1		; Affichage du sol.

	LDY #CH9_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0320 ; X pointe la première colonne
	BSR CH9_R1_2	; Affichage des deux colonnes
	LDX #SCROFFSET+$0438 ; X pointe la 2ème colonne
	LDA #$F0		; Rectification du dernier octet de la première colonne
	STA ,X
	RTS

; Sous-routines d'affichage de blocs 8x8
CH9_R1_6:
	BSR CH9_R1_1
	BSR CH9_R1_1
	BSR CH9_R1_1
CH9_R1_3:
	BSR CH9_R1_1
CH9_R1_2:
	BSR CH9_R1_1
CH9_R1_1:
	LDA #$FF
	STA ,X			; Ligne 1
	ABX
	LDA ,Y+
	STA	,X			; Ligne 2
	ABX
	STA	,X			; Ligne 3
	ABX
	LDA #$FF
	STA ,X			; Ligne 4
	ABX
	LDA ,Y+
	STA	,X			; Ligne 5
	ABX
	STA	,X			; Ligne 6
	ABX
	STA	,X			; Ligne 7
	ABX
	STA	,X			; Ligne 8
	LEAX -279,X
	RTS

; Data
CH9_DATA:
	FCB $10,$10
	FCB $40,$01

;------------------------------------------------------------------------------
; Trou dans le plafond CH10 (superposé au plafond de G10)
; Le drapeau est maintenu pour adapter les couleurs des ennemis en dessous.
;------------------------------------------------------------------------------
; Drapeau d'affichage
CH10D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
CH10:
	LBSR G10_1		; Affichage du sol.

	LDY #CH10_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0322 ; X pointe la première colonne
	BRA CH9_R1_3	; Affichage des trois colonnes

;------------------------------------------------------------------------------
; Trou dans le plafond CH12 (superposé au plafond de G12)
; Le drapeau est maintenu pour de meilleures performances lors des déplacements
; de monstres.
;------------------------------------------------------------------------------
; Drapeau d'affichage
CH12D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
CH12:
	LBSR G12_1		; Affichage du sol.

	LDY #CH12_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0325 ; X pointe la 1ère colonne
	LBSR DISPLAY_YX_2
	LDX #SCROFFSET+$0326 ; X pointe la 2ème colonne
	LBSR DISPLAY_YX_6

	LDX #SCROFFSET+$032D ; X pointe la 9ème colonne
	LBSR DISPLAY_YX_6
	LDX #SCROFFSET+$032E ; X pointe la 10ème colonne
	LBSR DISPLAY_YX_2

	LDX #SCROFFSET+$0327 ; X pointe la 3ème colonne
	LBSR CH9_R1_6

; Pixels à rafraichir après affichage de murs lattéraux 
CH12_2:
	LDX #SCROFFSET+$0375 ; X pointe la 1ère colonne
	LDA ,X
	ORA  #%00001100
	ANDA #%11111100
	STA ,X

	LDX #SCROFFSET+$0416 ; X pointe la 2ème colonne
	LDA ,X
	ORA  #%00001101
	ANDA #%11111101
	STA ,X

	LDX #SCROFFSET+$041D ; X pointe la 9ème colonne
	LDA ,X
	ORA  #%10110000
	ANDA #%10111111
	STA ,X

	LDX #SCROFFSET+$037E ; X pointe la 10ème colonne
	LDA ,X
	ORA  #%00110000
	ANDA #%00111111
	STA ,X
	RTS

; Rétablissement des pixels pour LISTE0
CH12_REST:
	INC	$E7C3		; Sélection vidéo forme

	LDX #SCROFFSET+$0375 ; X pointe la 1ère colonne
	LDA ,X
	ORA #%00000011
	STA ,X

	LDX #SCROFFSET+$0416 ; X pointe la 2ème colonne
	LDA ,X
	ORA #%00000010
	STA ,X

	LDX #SCROFFSET+$041D ; X pointe la 9ème colonne
	LDA ,X
	ORA #%01000000
	STA ,X

	LDX #SCROFFSET+$037E ; X pointe la 10ème colonne
	LDA ,X
	ORA #%11000000
	STA ,X

	LBRA VIDEOC_A	; Sélection video couleur + fin

; Data
CH12_DATA:
	FCB $FF			; Colonne 1
	FCB $F0

	FCB $FF			; Colonne 2
	FCB $39
	FCB $27
	FCB $21
	FCB $E1
	FCB $F1

	FCB $FF			; Colonne 9
	FCB $9C
	FCB $E4
	FCB $84
	FCB $87
	FCB $8F

	FCB $FF			; Colonne 10
	FCB $0F

CH10_DATA:
	FCB $04,$00		; Colonne 3
	FCB $00,$10
	FCB $40,$01
	FCB $04,$00
	FCB $00,$08
	FCB $40,$00

;------------------------------------------------------------------------------
; Trou dans le plafond CH14 (superposé au plafond de G14)
; Le drapeau est maintenu pour adapter les couleurs des ennemis en dessous.
;------------------------------------------------------------------------------
; Drapeau d'affichage
CH14D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
CH14:
	LBSR G14_1		; Affichage du sol.

	LDY #CH14_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$032F ; X pointe la première colonne
	LBRA CH9_R1_3	; Affichage des trois colonnes

; Data
CH14_DATA:
	FCB $02,$80
	FCB $00,$08
	FCB $20,$00

;------------------------------------------------------------------------------
; Trou dans le plafond CH15 (superposé au plafond de G15)
; Le drapeau est maintenu pour adapter les couleurs des ennemis en dessous.
;------------------------------------------------------------------------------
; Drapeau d'affichage
CH15D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
CH15:
	LBSR G15_1		; Affichage du sol.

	LDY #CH15_DATA	; Y pointe les données du trou
	LDX #SCROFFSET+$0332 ; X pointe la première colonne
	LBSR CH9_R1_2	; Affichage des deux colonnes
	LDX #SCROFFSET+$044B ; X pointe la deuxième colonne
	LDA #$0F		; Rectification du dernier octet de la deuxième colonne
	STA ,X
	RTS

; Data
CH15_DATA:
	FCB $02,$80
	FCB $08,$08

;------------------------------------------------------------------------------
; Trou dans le plafond CH16 (superposé au plafond de G16)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH16:
	LBSR G16_1		; Affichage du sol.

	LDX #SCROFFSET+$0460 ; X pointe le plafond
	LDY #CH16_DATA
	LBRA DISPLAY_YX_4

CH16_DATA:
	FCB $FF
	FCB $5D
	FCB $AA
	FCB $5D

;------------------------------------------------------------------------------
; Trou dans le plafond CH17 (superposé au plafond de G17)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH17:
	LBSR G17_1		; Affichage du sol.

	LDX #SCROFFSET+$0461 ; X pointe le plafond
	LDY #CH17_DATA
	LBRA DISPLAY_YX_4

CH17_DATA:
	FCB $FF
	FCB $7F
	FCB $AB
	FCB $5D

;------------------------------------------------------------------------------
; Trou dans le plafond CH18B (superposé au plafond de G18)
; Drapeau d'affichage inutile.
; ATTENTION : LE TROU CH18B DOIT ETRE SUPERPOSE A G18
;------------------------------------------------------------------------------
; Routine de tuile codée
CH18B:
	LDX #SCROFFSET+$04DA ; X pointe le plafond
	LDA ,X
	ANDA #%01010111
	STA ,X
	RTS

;------------------------------------------------------------------------------
; Trou dans le plafond CH18 (superposé au plafond de G18)
; Inutile de maintenir le drapeau pour les adaptations de couleurs des ennemis.
; ATTENTION : LE TROU H18 DOIT ETRE SUPERPOSE A G18
;------------------------------------------------------------------------------
; Routine de tuile codée
CH18:
	LDX #SCROFFSET+$048A ; X pointe la première colonne
	LDA #$AB
	STA ,X+
	LDA #$55
	STA ,X+
	STA ,X
	ABX
	LDA #$AE
	STA ,X
	STA ,-X
	LDA #$FD
	STA ,-X
	ABX
	LDA #$F5
	LEAX 1,X
	STA ,X+
	LDA #$55
	STA ,X
	RTS

;------------------------------------------------------------------------------
; Trou dans le plafond CH24 (superposé au plafond de G24)
; Inutile de maintenir le drapeau pour les adaptations de couleurs des ennemis.
; ATTENTION : LE TROU H24 DOIT ETRE SUPERPOSE A G24
;------------------------------------------------------------------------------
; Routine de tuile codée
CH24:
	LDX #SCROFFSET+$0497 ; X pointe la première colonne
	LDA #$AA
	STA ,X+
	STA ,X
	ABX
	LDA #$75
	STA ,X
	STA ,-X
	ABX
	LDA #$AA
	STA ,X+
	LDA #$AF
	STA ,X

	LDX #SCROFFSET+$0499 ; X pointe la première colonne
	LDA #$D5
	STA ,X
	ABX
	LDA #$BF
	STA ,X
	RTS

;------------------------------------------------------------------------------
; Trou dans le plafond CH23 (superposé au plafond de G23)
; Inutile de maintenir le drapeau pour les adaptations de couleurs des ennemis.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH23:
	LBSR G23_1		; Affichage du sol.

	LDX #SCROFFSET+$046D ; X pointe la première colonne
	LDY #CH23_DATA
	BRA CH19_1

; CH23_DATA (voir les constantes).

;------------------------------------------------------------------------------
; Trou dans le plafond CH19 (superposé au plafond de G19)
; Inutile de maintenir le drapeau pour les adaptations de couleurs des ennemis.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH19:
	LBSR G19_1		; Affichage du sol.

	LDY #CH19_DATA
	LDX #SCROFFSET+$0465 ; X pointe la première colonne
CH19_1:
	LBSR DISPLAY_YX_4
	LEAX -159,X
	LEAY -4,Y
	LBRA DISPLAY_YX_4

CH19_DATA:
	FCB $FF
	FCB $55
	FCB $AE
	FCB $55

;------------------------------------------------------------------------------
; Trou dans le plafond CH21 (superposé au plafond de G21)
; Le drapeau est maintenu pour de meilleures performances lors des déplacements
; de monstres.
;------------------------------------------------------------------------------
; Drapeau d'affichage
CH21D	FCB	$00		; 00 = Pas affiché, 01 = Affiché

; Routine de tuile codée
CH21:
	LBSR G21_1		; Affichage du sol.

; Partie centrale du trou
	LDY #CH21_DATA
	LDX #SCROFFSET+$0468 ; X pointe la 2ème colonne
	BSR CH19_1
	LEAX -159,X
	LEAY -4,Y
	BSR CH19_1

; Partie gauche du trou
	LDX #SCROFFSET+$0467 ; X pointe la 1ème colonne
	LDA #$FF
	STA ,X
	ABX
	LDA #$E5
	STA ,X

; Partie droite du trou
	LDX #SCROFFSET+$046C ; X pointe la 6ème colonne
	LDA #$FF
	STA ,X
	ABX
	LDA #$A7
	STA ,X

; Pixels à rafraichir après affichage de murs lattéraux 
CH21_2:
	LDX #SCROFFSET+$04B7 ; X pointe la première colonne
	LDA ,X
	ANDA #%11111011
	ORA  #%00001011
	STA ,X
	ABX
	LDA ,X
	ANDA #%11111101
	ORA  #%00000001
	STA ,X

	LDX #SCROFFSET+$04BC ; X pointe la 6ème colonne
	LDA ,X
	ANDA #%01011111
	ORA  #%01010000
	STA ,X
	ABX
	LDA ,X
	ANDA #%10111111
	ORA  #%10000000
	STA ,X
	RTS

; Rétablissement des pixels pour LISTE0
CH21_REST:
	INC	$E7C3		; Sélection vidéo forme

	LDX #SCROFFSET+$04B7 ; X pointe la première colonne
	LDA ,X
	ORA  #%00001111
	STA ,X
	ABX
	LDA ,X
	ORA  #%00000011
	STA ,X

	LDX #SCROFFSET+$04BC ; X pointe la 6ème colonne
	LDA ,X
	ORA  #%11110000
	STA ,X
	ABX
	LDA ,X
	ORA  #%11000000
	STA ,X

	LBRA VIDEOC_A	; Sélection video couleur + fin

CH21_DATA:
	FCB $FF
	FCB $55
	FCB $AB
	FCB $55

;------------------------------------------------------------------------------
; Trou dans le plafond CH20 (superposé au plafond de G20)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH20:
	LBSR G20_1		; Affichage du sol.

	LDX #SCROFFSET+$04B7 ; X pointe le plafond
	LDA #%10111111
	STA ,X
	ABX
	LDA #%01001111
	STA ,X
	RTS

;------------------------------------------------------------------------------
; Trou dans le plafond CH22 (superposé au plafond de G22)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH22:
	LBSR G22_1		; Affichage du sol.

	LDX #SCROFFSET+$04BC ; X pointe le plafond
	LDA #%11111101
	STA ,X
	ABX
	LDA #%11110010
	STA ,X
	RTS

;------------------------------------------------------------------------------
; Trou dans le plafond CH24B (superposé au plafond de G24)
; Drapeau d'affichage inutile.
; ATTENTION : LE TROU H24B DOIT ETRE SUPERPOSE A G24
;------------------------------------------------------------------------------
; Routine de tuile codée
CH24B:
	LDX #SCROFFSET+$04E9 ; X pointe le plafond
	LDA ,X
	ANDA #%11101010
	STA ,X
	RTS

;------------------------------------------------------------------------------
; Trou dans le plafond CH25 (superposé au plafond de G25)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH25:
	LBSR G25_1		; Affichage du sol.

	LDX #SCROFFSET+$0472 ; X pointe le plafond
	LDY #CH25_DATA
	LBRA DISPLAY_YX_4

CH25_DATA:
	FCB $FF
	FCB $FE
	FCB $D5
	FCB $BA

;------------------------------------------------------------------------------
; Trou dans le plafond CH26 (superposé au plafond de G26)
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
CH26:
	LBSR G26_1		; Affichage du sol.

	LDX #SCROFFSET+$0473 ; X pointe le plafond
	LDY #CH26_DATA
	LBRA DISPLAY_YX_4

CH26_DATA:
	FCB $FF
	FCB $BA
	FCB $55
	FCB $BA

;------------------------------------------------------------------------------
; Echelle descendante L15D en secteur G15.
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Sous-routine de restauration des couleurs.
L15D_REST:
	LDX #SCROFFSET+$0A3A ; X pointe l'échelle à l'écran.
	LDA #c87		; Fond gris/blanc
	LBRA DISPLAY_2A_14	; 14 lignes à restaurer.

; Routine de tuile codée
L15D:
	LDX #SCROFFSET+$0A3A ; X pointe l'échelle à l'écran.
	BRA L12D_0

;------------------------------------------------------------------------------
; Echelle descendante L12D en secteur G12.
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Sous-routine de restauration des couleurs.
L12D_REST:
	LDX #SCROFFSET+$0A30 ; X pointe l'échelle à l'écran.
	LDA #c87		; Fond gris/blanc
	LBRA DISPLAY_2A_14	; 14 lignes à restaurer.

; Routine de tuile codée
L12D:
	LDX #SCROFFSET+$0A30 ; X pointe l'échelle à l'écran.

L12D_0:
	LBSR VIDEOC_A	; Sélection video couleur.
	PSHS X
	LDY #L12D_DATA
	LBSR L12U_R2_14
	PULS X
	INC $E7C3		; Sélection video forme

L12D_1:
	LDY #L12U_DATA2+2
	LBSR DISPLAY_2YX_8
	LDY #L12U_DATA2
	LBRA DISPLAY_2YX_6

;------------------------------------------------------------------------------
; Echelle montante L15U en secteur G15.
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Sous-routine de restauration des couleurs.
L15U_REST:
	LDX #SCROFFSET+$035A ; X pointe l'échelle à l'écran.
	BRA L12U_REST_0

; Routine de tuile codée
L15U:
	LDX #SCROFFSET+$035A ; X pointe l'échelle à l'écran.
	BRA L12U_0

;------------------------------------------------------------------------------
; Echelle montante L12U en secteur G12.
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Sous-routine de restauration des couleurs.
L12U_REST:
	LDX #SCROFFSET+$0350 ; X pointe l'échelle à l'écran.
L12U_REST_0:
	LDA #c87		; Fond gris/blanc
	LBSR DISPLAY_2A_48	; 57 lignes à restaurer.
	LBRA DISPLAY_2A_9

; Routine de tuile codée
L12U:
	LDX #SCROFFSET+$0350 ; X pointe l'échelle à l'écran.

L12U_0:
	LBSR VIDEOC_A	; Sélection video couleur.
	PSHS X
	BSR L12U_2
	PULS X
	INC $E7C3		; Sélection video forme

L12U_1:
	LDY #L12U_DATA3
	LBSR DISPLAY_2YX_7
	LDY #L12U_DATA2
	LBSR DISPLAY_2YX_9
	LDY #L12U_DATA2
	LBSR DISPLAY_2YX_9
	LDY #L12U_DATA2
	LBSR DISPLAY_2YX_9
	LDY #L12U_DATA2
	LBSR DISPLAY_2YX_9
	LDY #L12U_DATA2
	LBSR DISPLAY_2YX_9
	LDY #L12U_DATA3
	LBRA DISPLAY_2YX_5

L12U_2:
	LDY #L12D_DATA2
	BSR L12U_R2_5
	BSR L12U_R1_4
	LDY #L12U_DATA1
	BSR L12U_R2_3
	LDA #cF8
	LBSR DISPLAY_2A_6
	LDY #L12U_DATA1
	BSR L12U_R2_3
	LDA #cF8
	LBSR DISPLAY_2A_3
	LDA #c18
	STA ,X
	STA 1,X
	RTS

L12U_R1_4:
	BSR L12U_R1
	BSR L12U_R1
	BSR L12U_R1
L12U_R1:
	LDY #L12U_DATA1
	BSR L12U_R2_3
	LDA #cF7
	LBRA DISPLAY_2A_6

L12U_R2_14:
	BSR L12U_R2_4
	BSR L12U_R2_5
L12U_R2_5:
	LDA ,Y+
	STA ,X
	STA 1,X
	ABX
L12U_R2_4:
	LDA ,Y+
	STA ,X
	STA 1,X
	ABX
L12U_R2_3:
	LDA ,Y+
	STA ,X
	STA 1,X
	ABX
L12U_R2_2:
	LDA ,Y+
	STA ,X
	STA 1,X
	ABX
L12U_R2_1:
	LDA ,Y+
	STA ,X
	STA 1,X
	ABX
	RTS

;------------------------------------------------------------------------------
; Echelle decendante L02D en secteur G2.
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
L02D:
	CLR >G6D		; G6 marqué comme étant à réafficher.
	CLR >H2D		; H2 marqué comme étant à réafficher.

	LDX #SCROFFSET+$0DC9 ; X pointe l'échelle à l'écran.
	LDY #L06D_DATA1	; Y pointe des données du haut de l'échelle.
	LBSR L06UR4_0	; Dessin du haut de l'échelle.
	LBSR L06UR3		; 1 motif d'échelle L06UR3.
	LBSR L06UR1		; 1 motif de haut d'échelle L06UR1.
	LEAX -39,X		; X pointe l'échelon suivant.
	LBSR L06UR2		; 1 motif d'échelon L06UR2.
	LDX #SCROFFSET+$12A1 ; X pointe le bas de l'échelle.
	LBSR L06UR1		; 1 motif de haut d'échelle L06UR1.
	LEAX -39,X		; X pointe l'échelon suivant.
	LBSR L06UR2		; 1 motif d'échelon L06UR2.
	LBSR L06D_1		; 1 motif de bas d'échelle L06D_1.
	LDX #SCROFFSET+$12A1 ; X pointe de nouveau le bas de l'échelle.
	LDA #$FF
	STA ,X			; Trait noir.
	LDX #SCROFFSET+$12A4
	STA ,X			; Trait noir.
	LDX #SCROFFSET+$11D9 ; X pointe les attaches.
	LDY #L02D_DATA	; Y pointe les données des attaches.
	LBSR L06UR1_0	; Dessin des attaches.
	LDX #SCROFFSET+$10EE ; X pointe le fond à droite.
	LDA #$80		; Trait vertical.
	LBSR DISPLAY_A_11
	LBSR VIDEOC_A	; Sélection video couleur.
	BSR L02D_R1		; Couleurs des fonds
	INC $E7C3		; Sélection video forme + dessin des formes.

L02D_R1:
	LDX #SCROFFSET+$11B0
	LDA ,Y+
	LBSR DISPLAY_A_5
	LEAX -158,X
	LDA ,Y+
	LBSR DISPLAY_A_4
	LEAX -159,X
	LDA ,Y+
	LBSR DISPLAY_A_4
	LEAX -198,X
	LDA ,Y+
	LBRA DISPLAY_A_5

; Sous-routine de restauration des couleurs de motifs d'échelle
 ; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
L02D_REST:
	LDX #SCROFFSET+$0D00 ; X pointe l'échelle + 5 lignes au-dessus
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LDB #35
	LBSR G2_R1_48x6
	LDB #40
	RTS

;------------------------------------------------------------------------------
; Echelle descendante L06D en secteur G6.
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
L06D:
	LDX #SCROFFSET+$0CD7 ; X point l'échelle à l'écran.
	LDY #L06D_DATA1	; Y pointe des données du haut de l'échelle.
	LBSR L06UR4_0	; Dessin du haut de l'échelle.
	LBSR L06UR3		; 1 motif d'échelle L06UR3.
L06D_1:
	LDY #L06UR1_DATA+2 ; Y pointe les données du bas de l'échelle.
	LBRA L06UR4_0	; Dessin du bas de l'échelle.

; Sous-routine de restauration des couleurs de l'échelle
 ; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
L06D_REST:
	LDX #SCROFFSET+$0CD7 ; X point l'échelle à l'écran.
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LDB #37
	LBSR G2_R1_16x4
	LBSR G2_R1_4x4
	LDB #40
	RTS

;------------------------------------------------------------------------------
; Echelle montante L02U en secteur G2.
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
L02U:
	CLR >G6D		; G6 marqué comme étant à réafficher.
	CLR >CH2D		; H2 marqué comme étant à réafficher.

	LDX #SCROFFSET+9 ; X point l'échelle à l'écran.
	BSR L06UR3_8	; 8 x motif d'échelle L06UR3.
	BRA L06UR4		; Bas de l'échelle

; Sous-routine de restauration des couleurs de l'échelle
 ; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
L02U_REST:
	LDX #SCROFFSET+9 ; X point l'échelle à l'écran.
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LBSR G2_R1_80x4	; Restauration des couleurs.
	LBSR G2_R1_32x4
	LBSR G2_R1_3x4
	LDB #40
	RTS

;------------------------------------------------------------------------------
; Echelle montante L06U en secteur G6.
; Drapeau d'affichage inutile.
;------------------------------------------------------------------------------
; Routine de tuile codée
L06U:
	LDX #SCROFFSET+$016F ; X point l'échelle à l'écran.
	LBSR L06UR1		; Haut de l'échelle.
	BSR L06UR3_6	; 6 x motif d'échelle L06UR3 + dessin du bas de l'échelle.

; Sous-routine du bas de l'échelle L06UR4
L06UR4:
	LDY #L06UR4_DATA ; Y pointe des données de L06UR4

L06UR4_0:
	LBSR VIDEOC_A	; Sélection video couleur.
	BSR L06UR4_1	; Dessin des couleurs de L06UR4.
	LEAX -120,X		; X pointe de nouveau le montant gauche.
	INC $E7C3		; Sélection video forme puis dessin des formes de L06UR4.

L06UR4_1:
	LBSR DISPLAY_YX_3 ; Montant gauche, lignes 1 à 3.
	LEAX -117,X		; X pointe le montant droit.
	LEAY -3,Y
L06UR4_2:
	LBSR DISPLAY_YX_3 ; Montant droit, lignes 1 à 3.
	LEAX -3,X		; X pointe la ligne suivante
	RTS

; Sous-routine de dessin du motif d'échelle L06UR3
L06UR3_8:
	BSR L06UR3_2
L06UR3_6:
	BSR L06UR3_2
	BSR L06UR3_2
L06UR3_2:
	BSR L06UR1
	LEAX -39,X
	BSR L06UR2
	BSR L06UR1
L06UR3:
	BSR L06UR1		; Partie haute de L06UR3 = L06UR1.
	LEAX -39,X		; X pointe l'échelon.
	BSR L06UR2		; Echelon central.
	BRA L06UR1		; Partie basse de L06UR3 = L06UR1.

; Sous-routine de dessin de l'échelon L06UR2
L06UR2:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDY #L06UR2_DATA ; Y pointe des données de L06UR2
	LDA #c00		; Couleurs = Encre noire (0) sur fond noir (0)
	BSR L06UR2_1	; Dessin des couleurs de L06UR2.
	LEAX -199,X		; X pointe de nouveau l'échelon central.
	INC $E7C3		; Sélection video forme puis dessin des formes de L06UR2.

L06UR2_1:
	STA ,X+			; Ligne 1
	STA ,X
	LEAX 38,X		; X pointe la ligne 2
	LBSR BSAVEN_4	; Ligne 2
	LEAX 36,X
	LBSR BSAVEN_4	; Ligne 3
	LEAX 36,X
	LBSR BSAVEN_4	; Ligne 4
	LEAX 36,X
	LBSR BSAVEN_4	; Ligne 5
	LEAX 36,X
	RTS

; Sous-routine du haut de l'échelle L06UR1
L06UR1:
	LDY #L06UR1_DATA ; Y pointe des données de L06UR1.
L06UR1_0:
	LBSR VIDEOC_A	; Sélection video couleur.
	BSR L06UR1_1	; Dessin des couleurs.
	LEAX -200,X		; X pointe de nouveau L06UR1.
	INC $E7C3		; Sélection video forme.

L06UR1_1:
	LBSR DISPLAY_YX_5 ; Montant gauche, lignes 1 à 5.
	LEAX -197,X		; X pointe le montant droit.
	LEAY -5,Y
L06UR1_2:
	LBSR DISPLAY_YX_5 ; Montant droit, lignes 1 à 5.
	LEAX -3,X		; X pointe le dessous de L06UR1
	RTS

; Sous-routine de restauration des couleurs de l'échelle
 ; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
L06U_REST:
	LDX #SCROFFSET+$016F ; X point l'échelle à l'écran.
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LBSR G2_R1_80x4	; Restauration des couleurs.
	LBSR G2_R1_16x4
	LDB #40
	RTS

;------------------------------------------------------------------------------
; Données des échelles
;------------------------------------------------------------------------------
; Données de L06UR1
L06UR1_DATA:
	FCB c0F,c0F,c0F,c0F,c0F
	FCB $81,$81,$81,$81,$81

; Données de L06UR2
L06UR2_DATA:
	FCB c0F,c0F,c0F,c0F
	FCB c0F,c0F,c0F,c0F
	FCB c0F,c01,c01,c0F
	FCB c0F,c00,c00,c0F

	FCB $83,$00,$00,$C1
	FCB $82,$00,$00,$41
	FCB $83,$00,$00,$C1
	FCB $81,$00,$00,$81

; Données de restauration des couleurs de L06UR2
L06UR2_DATA2:
	FCB $87,$87,$87,$87
	FCB $87,$87,$87,$87
	FCB $87,$87,$87,$87
	FCB $87,$87,$87,$87

; Données de L06UR4
L06UR4_DATA:
	FCB c0F,c01,c08
	FCB $81,$81,$7E

; Données du haut de l'échelle de L06D
L06D_DATA1:
	FCB c08,c03,c00
	FCB $7E,$81,$00

; Données des attaches de L02D
L02D_DATA:
	FCB c08,c08,c08,c08,c08
	FCB $7E,$00,$18,$18,$81

	FCB c07,c07,c07,c07
	FCB $01,$80,$01,$80

; Données de L12U et L15U
L12U_DATA1:
	FCB cF0
	FCB cF0
	FCB cF1

L12U_DATA2:
	FCB $F0,$0F
	FCB $F0,$0F
L12U_DATA3:
	FCB $F0,$0F
	FCB $F0,$0F
	FCB $F0,$0F
	FCB $F0,$0F
	FCB $F0,$0F
	FCB $F0,$0F
	FCB $EF,$F7

; Données de L12D et L15D
L12D_DATA:
	FCB c38
	FCB cF8
	FCB cF7
	FCB cF7
	FCB cF7
	FCB cF7
	FCB cF0
	FCB cF0
	FCB cF1
L12D_DATA2:
	FCB cF7
	FCB cF7
	FCB cF8
	FCB cF7
	FCB cF7

;------------------------------------------------------------------------------
; Montants de porte DP1.
; Dessine seulement les montants de porte, sans serrure ni bouton.
; L'élément ne nécessite pas de drapeau d'affichage.
; L'affichage de DP1 nécessite la réinitialisation des objets dans la zone de W2.
;------------------------------------------------------------------------------
; Routine de tuile codée
DP1:
	CLR >W2D		; W2 marqué comme non affiché.
	LBSR MASK_W2	; Tous les éléments de décors dans la zone de W2 sont à réfficher.

	LDA #$80		; Montant gauche, motif vertical de la colonne 1.
	STA >VARDB1
	LDA #$09		; Montant gauche, motif vertical de la colonne 2.
	STA >VARDB2

	LDX #SCROFFSET+$020C ; X pointe la 2ème colonne du montant gauche.
	LDY #DP1_DATA	; Y pointe les données de colonne.
	BSR DP1_R4		; Dessin de la colonne

	LDX #SCROFFSET+$020B ; X pointe la 1ère colonne du montant gauche.
	BSR DP1_1		; Dessin de la colonne

	LDA #$01		; Montant gauche, motif vertical de la colonne 2.
	STA >VARDB1
	LDA #$90		; Montant gauche, motif vertical de la colonne 1.
	STA >VARDB2

	LDX #SCROFFSET+$0217 ; X pointe la 1ère colonne du montant droit.
	BSR DP1_R4		; Dessin de la colonne.

	LDX #SCROFFSET+$0218 ; X pointe la 2ème colonne.

DP1_1:
	LDA #$FF
	STA ,X
	ABX
	BSR DP1_R1		; + 20 lignes de motif + 1 ligne grise.
	BSR DP1_R2		; + 19 lignes de motif + 1 ligne grise.
	BSR DP1_R2		; + 19 lignes de motif + 1 ligne grise.

DP1_R1:				; 20 lignes de motif + ligne gris $FF
	LDA >VARDB1		; A = Motif vertical
	STA	,X
	ABX

DP1_R2:				; 19 lignes de motif + ligne griss $FF
	LDA >VARDB1		; A = Motif vertical

DP1_R3:
	LBSR DISPLAY_A_19
	LDA #$FF		; 1 ligne grise $FF
	STA ,X
	ABX
	RTS

DP1_R4:
	LBSR DISPLAY_YX_2	; Lignes 1 à 2
	BSR DP1_R5		; Lignes 3 à 22
	BSR DP1_R5		; Lignes 23 à 42
	BSR DP1_R5		; Lignes 43 à 62
	BSR DP1_R5		; Lignes 63 à 82
	LDA #$FF		; Ligne 83
	STA ,X
	RTS

DP1_R5:				; 17 lignes de motif $09 + 3 lignes de données.
	LDA >VARDB2		; A = Motif vertical
	LBSR DISPLAY_A_17	; 17 lignes de motif.
	LBRA DISPLAY_YX_3	; + 3 lignes de données.

;------------------------------------------------------------------------------
; Montants de porte DP2 (mur et montants vus de côté).
; L'élément ne nécessite pas de drapeau d'affichage.
; L'affichage de DP2 écrase G2 et W2 et entraine leur réinitialisation.
;------------------------------------------------------------------------------
; Routine de tuile codée
DP2:
	CLR >G2D		; G2 marqué comme à réafficher.
	CLR >W2D		; W2 marqué comme à réafficher.
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a dans la zone de W2.

	LBSR VIDEOC_A	; Sélection video couleur.
	LDX #SCROFFSET+9 ; X pointe le creux de porte.
	LDA #c00		; Couleurs = Encre noire (0) sur fond noir (0)
	LBSR DISPLAY_2A_64	; 105 lignes noires sur fond noir.
	LBSR DISPLAY_2A_32
	LBSR DISPLAY_2A_9
	LDA #c80		; Couleurs = Encre grise (8) sur fond noir (0)
	LBSR DISPLAY_2A_5	; 5 lignes grises sur fond noir.
	INC $E7C3		; Sélection video forme
	LDX #SCROFFSET+$1071 ; X pointe le sol du creux de porte.
	LDY #DP2_DATA2
	LBSR DISPLAY_2YX_5	; Dessin du sol du creux de porte.
	LDX #SCROFFSET+7 ; X pointe le montant gauche.
	BSR DP2_R2		; Dessin du montant gauche.
	LDX #SCROFFSET+11 ; X pointe le montant droit + dessin du montant droit.

DP2_R2:
	BSR DP2_R2_1
DP2_R2_1:
	LDY #DP2_DATA
	LBSR DISPLAY_2YX_14	; 14 lignes $80,$01 
	LDY #DP2_DATA+2
	LBSR DISPLAY_2YX_14	; + 13 lignes $80,$01 + 1 ligne $FF,$FF
	LDY #DP2_DATA
	LBSR DISPLAY_2YX_14	; + 14 lignes $80,$01 
	LDY #DP2_DATA+2
	LBRA DISPLAY_2YX_14	; + 13 lignes $80,$01 + 1 ligne $FF,$FF

; Routine de restauration des couleurs du creux de porte
 ; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
DP2_REST:
	LDX #SCROFFSET+9 ; X pointe le creux de porte.
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LBSR DISPLAY_2A_64	; 110 lignes à restaurer.
	LBSR DISPLAY_2A_32
	LBRA DISPLAY_2A_14

;------------------------------------------------------------------------------
; Montants de porte DP3.
; L'élément ne nécessite pas de drapeau d'affichage.
; La barre noire doit toujours être affichée dans le buffer. Mais dans le cas
; de la tuile codée, elle doit être affichée en liste 3 et le montant DP3 en
; liste 4, car l'échelle montante doit être affichée par dessus.
;------------------------------------------------------------------------------
; Routine adaptée au buffer, pour l'ouverture des portes.
DP3B:
	LDB #10
	LDX #BUFFERC	; X pointe le buffer couleur, ligne 1.
	LDA #c00		; Couleurs = Encre noire (0) sur fond noir (0).
	LBSR G2_R1_20	; 20 octets $00 = deux lignes noires.

	LDX #BUFFERF+20	; X pointe le buffer de forme, ligne 3.
	BRA DP3_1		; Dessin des deux colonnes dans le buffer de forme.

; Routine de tuile codée
DP3:
	LDX #SCROFFSET+$02AD ; X pointe la première colonne à l'écran.

DP3_1:
	LDY #DP3_DATA	; Y pointe les données du montant gauche.
	PSHS X
	BSR DP3_R1		; Dessin du montant gauche.
	PULS X
	LEAX 9,X		; X pointe le montant droit + dessin du montant.

DP3_R1:
	LDA ,Y+			; Ligne 3
	STA ,X
	ABX
	BSR DP3_R2_17	; Lignes 4 à 20
	LEAY 2,Y
	BSR DP3_R2_1	; Ligne 21
	LEAY 2,Y
	BSR DP3_R2_15	; Lignes 22 à 36
	LEAY 2,Y
	BSR DP3_R2_1	; Ligne 37
	LEAY 2,Y
	BSR DP3_R2_1	; Ligne 38
	LEAY -4,Y
	BSR DP3_R2_16	; Lignes 39 à 54
	LEAY 2,Y
	BSR DP3_R2_1	; Ligne 55
	LEAY 2,Y
	BSR DP3_R2_1	; Ligne 56
	LEAY 2,Y
	BSR DP3_R2_15	; Lignes 57 à 71
	LEAY 2,Y
	LDA ,Y+
	STA ,X			; Ligne 72
	ABX
	STA ,X			; Ligne 73
	RTS

DP3_R2_17:
	BSR DP3_R2_1
DP3_R2_16:
	BSR DP3_R2_1
DP3_R2_15:
	BSR DP3_R2_3
DP3_R2_12:
	BSR DP3_R2_6
DP3_R2_6:
	BSR DP3_R2_3
DP3_R2_3:
	LDA ,X
	ANDA ,Y
	ORA 1,Y
	STA ,X
	ABX
DP3_R2_2:
	LDA ,X
	ANDA ,Y
	ORA 1,Y
	STA ,X
	ABX
DP3_R2_1:
	LDA ,X
	ANDA ,Y
	ORA 1,Y
	STA ,X
	ABX
	RTS

; Routine de restauration des couleurs.
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
DP3_REST:
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LDX #SCROFFSET+$025D ; X pointe le trou de la porte
	LBSR G2_R1_2x10	; 2 lignes de 10 octets.
	LDB #40			; Pour les sauts de lignes.
	RTS

;------------------------------------------------------------------------------
; Barre noire complémentaire à la tuile codée du montant DP3.
; L'élément ne nécessite pas de drapeau d'affichage.
; La barre noire doit toujours être affichée dans le buffer. Mais dans le cas
; de la tuile codée, elle doit être affichée en liste 3 et le montant DP3 en
; liste 4, car l'échelle montante doit être affichée par dessus.
;------------------------------------------------------------------------------
DP3H:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDX #SCROFFSET+$025D ; X pointe le trou de la porte à l'écran.
	LDA #c00		; Couleurs = Encre noire (0) sur fond noir (0).
	LBSR G2_R1_2x10	; Deux lignes noires.
	LDB #40			; Pour les sauts de ligne.
	INC $E7C3		; Sélection video forme.
	RTS

;------------------------------------------------------------------------------
; Serrure jaune DL1.
; L'élément ne nécessite pas de drapeau d'affichage.
; DL_REST doit être utilisée pour DL1, DL2, DL3 et DL4.
;
; Tous les éléments de décors derrière DP1 doivent être réaffichés après la
; restauration des couleurs des serrures, d'où là réinitialisation de tous les
; drapeaux dans la zone de mur W2.
;------------------------------------------------------------------------------
; Routine de restauration des couleurs, commune à DL1, DL2, DL3 et DL4.
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
DL_REST:
	LDX #SCROFFSET+$0628 ; X pointe la serrure ou le bounton
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LBRA DISPLAY_A_11	; 11 lignes à restaurer.

; Routine de tuile codée
DL1:
	LDA #c30		; Couleurs de serrure = jaune vif (3) sur fond noir (0).

; Partie commune à D04, D08 et D04H
DL1_1:
	LBSR VIDEOC_B	; Sélection video couleur
	LDX #SCROFFSET+$0628 ; X pointe la serrure
	LDB #40			; Pour les sauts de lignes.
	LBSR DISPLAY_A_11	; Initialisation des couleurs de le serrure.
	INC $E7C3		; Sélection video forme
	LDX #SCROFFSET+$0628 ; X pointe de nouveau la serrure
	LDY #DL_DATA	; Y pointe les données de la serrure
	LBRA DISPLAY_YX_11	; Dessin de la serrure.

;------------------------------------------------------------------------------
; Serrure bleue DL2.
; L'élément ne nécessite pas de drapeau d'affichage.
; DL_REST doit être utilisée pour DL1, DL2, DL3 et DL4.
;------------------------------------------------------------------------------
; Routine de tuile codée
DL2:
	LDA #cC0		; Couleurs de serrure = bleu (12) sur fond noir (0).
	BRA DL1_1

;------------------------------------------------------------------------------
; Serrure rouge DL3.
; L'élément ne nécessite pas de drapeau d'affichage.
; DL_REST doit être utilisée pour DL1, DL2, DL3 et DL4.
;------------------------------------------------------------------------------
; Routine de tuile codée
DL3:
	LDA #c10		; Couleurs de serrure = rouge (1) sur fond noir (0).
	BRA DL1_1

;------------------------------------------------------------------------------
; Bouton DL4.
; L'élément ne nécessite pas de drapeau d'affichage.
; DL_REST doit être utilisée pour DL1, DL2, DL3 et DL4.
;------------------------------------------------------------------------------
; Routine de tuile codée pour le bouton en position OFF.
DL4_OFF:
	LDA #cF0		; Couleurs de serrure = orange (15) sur fond noir (0).
	BRA DL4_ON_1

; Routine de tuile codée pour le bouton en position ON.
DL4_ON:
	LDA #c10		; Couleurs de serrure = rouge (1) sur fond noir (0).

DL4_ON_1:
	LBSR VIDEOC_B	; Sélection video couleur
	LDX #SCROFFSET+$0678 ; X pointe le bouton
	LDB #40
	LBSR DISPLAY_A_7	; Initialisation des couleurs de le serrure.
	INC $E7C3		; Sélection video forme.
	LDY #DL4OFF_DATA ; Y pointe les données du bouton.
	LDX #SCROFFSET+$0678 ; X pointe de nouveau le bouton.
	LBRA DISPLAY_YX_7	; Dessin de la serrure.

;------------------------------------------------------------------------------
; Porte D06 (porte entière en secteur G6).
; L'élément ne nécessite pas de drapeau d'affichage.
;------------------------------------------------------------------------------
; Routine adaptée au buffer, pour l'ouverture des portes.
D06B:
	LDB #10
	LDX #BUFFERC	; X pointe la colonne 1 du buffer de couleur.
	BSR D08B		; Préparation des colonnes 1 et 2.
	LDX #BUFFERC+2	; X pointe la colonne 3 du buffer de couleur.
	BSR D08B		; Préparation des colonnes 3 et 4.
	LDX #BUFFERC+4	; X pointe la colonne 3 du buffer de couleur.
	BSR D08B		; Préparation des colonnes 5 et 6.
	LDX #BUFFERC+6	; X pointe la colonne 3 du buffer de couleur.
	BSR D08B		; Préparation des colonnes 7 et 8.
	LDX #BUFFERC+8	; X pointe la colonne 3 du buffer de couleur.
	BRA D08B		; Préparation des colonnes 9 et 10.

; Routine de tuile codée
D06:
	LDX #SCROFFSET+$025D ; X pointe la porte à l'écran.
	BSR D08_1
	LDX #SCROFFSET+$025F
	BSR D08_1
	LDX #SCROFFSET+$0261
	BSR D08_1
	LDX #SCROFFSET+$0263
	BSR D08_1
	LDX #SCROFFSET+$0265
	BRA D08_1

; Routine de restauration des couleurs de la porte
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
D06_REST:
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LDX #SCROFFSET+$025D ; X pointe la porte à l'écran.
	LBSR DISPLAY_2A_76
	LDX #SCROFFSET+$025F
	LBSR DISPLAY_2A_76
	LDX #SCROFFSET+$0261
	LBSR DISPLAY_2A_76
	LDX #SCROFFSET+$0263
	LBSR DISPLAY_2A_76
	LDX #SCROFFSET+$0265
	LBRA DISPLAY_2A_76

;------------------------------------------------------------------------------
; Porte D04 (bout de porte en secteur G4).
; L'élément ne nécessite pas de drapeau d'affichage.
;------------------------------------------------------------------------------
; Routine de tuile codée
D04:
	LDX #SCROFFSET+$0258 ; X pointe la porte à l'écran.
	BRA D08_1		; D04 = D08

; Routine de restauration des couleurs de la porte
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
D04_REST:
	LDX #SCROFFSET+$0258 ; X pointe la porte à l'écran.
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LBRA DISPLAY_2A_76	; 76 lignes à restaurer.

;------------------------------------------------------------------------------
; Porte D08 (bout de porte en secteur G8).
; L'élément ne nécessite pas de drapeau d'affichage.
;------------------------------------------------------------------------------
; Routine de restauration des couleurs de la porte
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
D08_REST:
	LDX #SCROFFSET+$026A ; X pointe la porte à l'écran.
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	LBRA DISPLAY_2A_76	; 76 lignes à restaurer.

; Routine adaptée au buffer, pour l'ouverture des portes.
D08B:
	LDY #D04_DATA	; Y pointe les données de couleurs puis de formes.
	BSR D08_R1		; Préparation des couleurs dans le buffer.
	LEAX 8,X		; X pointe le buffer de forme.
	BRA D08_R1		; Préparation des formes dans le buffer.

; Routine de tuile codée
D08:
	LDX #SCROFFSET+$026A ; X pointe la porte à l'écran.

D08_1:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDY #D04_DATA	; Y pointe les données de couleurs puis de formes.
	BSR D08_R1
	INC $E7C3		; Sélection video forme.
	LEAX -3040,X	; X pointe de nouveau la porte à l'écran.

D08_R1:
	LDA ,Y+
	STA ,X			; Ligne 1
	STA 1,X
	ABX
	LDA ,Y+
	LBSR DISPLAY_2A_64	; Lignes 2 à 65
	LBSR DISPLAY_2A_4	; Lignes 66 à 69
	LBRA DISPLAY_2YX_7	; Lignes 70 à 76

;------------------------------------------------------------------------------
; Porte D04H (trou de porte en secteur G4).
; L'élément ne nécessite pas de drapeau d'affichage.
;------------------------------------------------------------------------------
; Routine de tuile codée
D04H:
	LDX #SCROFFSET+$0258 ; X pointe le trou de la porte à l'écran.
	BRA D08H_1		; D04H = D08H

; Routine de restauration des couleurs de la porte
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
D04H_REST:
	CLR >G4D		; G4 marqué comme à réafficher.
	LDX #SCROFFSET+$0258 ; X pointe le trou de la porte à l'écran.
	BRA D08H_REST1	; D04H_REST = D08H_REST

;------------------------------------------------------------------------------
; Porte D08H (trou de porte en secteur G8).
; L'élément ne nécessite pas de drapeau d'affichage.
;------------------------------------------------------------------------------
; Routine de tuile codée
D08H:
	LDX #SCROFFSET+$026A ; X pointe la porte à l'écran.

D08H_1:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDA #c00		; Couleurs = Encre noire (0) sur fond noir (0)
	BSR D08H_REST2
	INC $E7C3		; Sélection video forme.
	RTS

; Routine de restauration des couleurs de la porte
; La mémoire vidéo couleur doit être sélectionnée avant l'appel de la routine.
D08H_REST:
	CLR >G8D		; G8 marqué comme à réafficher.
	LDX #SCROFFSET+$026A ; X pointe la porte à l'écran.

D08H_REST1:
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
D08H_REST2:
	STA ,X
	STA 1,X
	ABX
	STA ,X
	STA 1,X
	RTS

;------------------------------------------------------------------------------
; Animation de l'ouverture progressive d'une porte.
; La routine identifie les élements derrière la porte et remplie les buffers de
; couleur BUFFERC et de forme BUFFERF. Puis la routine anime la montée de la
; porte, avec dévoilement progressif des décors conutenus dans le buffer.
;------------------------------------------------------------------------------
; --- IDENTIFICATION DES CASES ---
DOPEN:
	LDX >SQRADDR	; X pointe la case courante G2 dans la map,
	LBSR PAS_AV		; puis la case G6.
	LDA ,X			; A = contenu de la case G6.
	ORA #%10000100	; Contenu marqué comme vu + porte considérée ouverte.
	STA ,X			; Case G6 mise à jour.
	STA >VARDB1		; Contenu sauvegardé dans VARDB1 pour l'ouverture.

	LBSR PAS_AV		; X pointe la case G12.
	LDA ,X			; A = contenu de la case G12.
	ORA #%10000000	; Contenu marqué comme vu.
	STA ,X			; Case G12 mise à jour.
	STA >VARDB2		; Contenu sauvegardé dans VARDB2 pour l'ouverture.

	LBSR PAS_GA		; X pointe la case G11.
	LDA ,X			; A = contenu de la case G11.
	ORA #%10000000	; Contenu marqué comme vu.
	STA ,X			; Case G11 mise à jour.
	STA >VARDB3		; Contenu sauvegardé dans VARDB3 pour l'ouverture.

	LBSR PAS_AV		; X pointe la case G19.
	LBSR PAS_DR		; Puis la case G21.
	LDA ,X			; A = contenu de la case G21.
	ORA #%10000000	; Contenu marqué comme vu.
	STA ,X			; Case G21 mise à jour.
	STA >VARDB5		; Contenu sauvegardé dans VARDB5 pour l'ouverture.

	LBSR PAS_DR		; X pointe la case G23.
	LBSR PAS_AR		; Puis la case G13.
	LDA ,X			; A = contenu de la case G13.
	ORA #%10000000	; Contenu marqué comme vu.
	STA ,X			; Case G13 mise à jour.
	STA >VARDB7		; Contenu sauvegardé dans VARDB7 pour l'ouverture.

; --- COMPRESSION DE LA MAP ET ANIMATION DU BOUTON ---
	LBSR MAPCOMP	; Compression et sauvegarde de la map courante.

	LDA >VARDB1		; A = contenu de la case G6.
	LBSR DCLOSE_R2_0 ; Clic de serrure ou animation du bouton.

; --- PREPARATION DU BUFFER ---
	LDD #GAME_RTS	; Adresse de restauration des couleurs en G12 par défaut
	STD >VARDW5		; et en l'absence de la liste 0, écrasée par le buffer.

	LDX #BUFFERC	; X pointe le buffer de couleur.
	LDA	>MAPCOULC	; Couleurs sol/mur courantes.
	CLRB			; Pas de saut dans l'utilisation des routines G2_R1.
	LBSR G2_R1_36x20 ; 760 octets à initialiser
	LBSR G2_R1_2x20

	LDX #BUFFERF	; X pointe le buffer de forme.
	LDA #$FF		; Forme = fond gris.
	LBSR G2_R1_36x20 ; 760 octets à initialiser (38x20)
	LBSR G2_R1_2x20

; --- ANALYSE DE LA CASE G11 ---
DOPEN11:
	LDA >VARDB3		; A = contenu de la case G11.
	ANDA #%01110000	; Suppression du flag de découverte et du contenu.
	CMPA #%01110000	; Mur ou obstacle %111? 
	BNE DOPEN11_G	; Non, sol => DOPEN11_G.

; Mur ou obstacle. 
DOPEN11_111:
	LBSR W38B		; Ajout du mur W38B dans le buffer.
	BRA DOPEN13		; Etape suivante => DOPEN13

; Sol vide.
DOPEN11_G:
	LBSR W12B		; Ajout de W12B dans le buffer. Sol déjà affiché.

; --- ANALYSE DE LA CASE G13 ---
DOPEN13:
	LDA >VARDB7		; A = contenu de la case G13.
	ANDA #%01110000	; Suppression du flag de découverte et du contenu.
	CMPA #%01110000	; Mur ou obstacle %111? 
	BNE DOPEN13_G	; Non, sol => DOPEN13_G.

; Mur ou obstacle. 
DOPEN13_111:
	LBSR W48B		; Ajout du mur W48B dans le buffer.
	BRA DOPEN12		; Etape suivante => DOPEN12

; Sol vide.
DOPEN13_G:
	LBSR W14B		; Ajout de W14B dans le buffer. Sol déjà affiché.

; --- ANALYSE DE LA CASE G12 ---
DOPEN12:
	LDA >VARDB2		; A = contenu de la case G12.
	ANDA #%01110000	; Suppression du flag de découverte et du contenu.

	CMPA #%00100000
	BCS DOPEN12_000 ; Sol simple %000 ou %001 => DOPEN12_000

	CMPA #%01000000	; Sol simple occupé ou occupable %100? 
	BEQ DOPEN12_100 ; Oui => DOPEN12_100.
	BRA DOPEN12_G	; Non, obstacles, trous et échelles ignorés => DOPEN12_G.

; Sol %000 ou %001, vide ou avec coffre
DOPEN12_000:
	LDA >VARDB2		; A = contenu de la case G12.
	ANDA #%00001111	; A = contenu de la case.
	BEQ DOPEN12_G	; Case vide = sol simple => DOPEN12_G.

	LBSR CHEST12B	; Dessin du coffre dans le buffer.
	BRA DOPEN12_G

; Sol simple occupé ou occupable par un ennemi.
; EVITER LES MONSTRES COLORES DERRIERE LA PORTE SAUF MIMIC.
DOPEN12_100:
	LDB >VARDB2		; A = contenu de la case G12.
	ANDB #%00001111	; B = contenu de la case.
	BEQ DOPEN12_G	; Case vide = sol simple => DOPEN12_G.

	LDX #E0X_12D	; X pointe la déclaration des ennemis pour le buffer de porte.
	DECB
	LSLB			; B <= 2(B-1)
	ABX				; X pointe l'adresse de la tuile de l'ennemi.
	LDY ,X			; Y = adresse de la tuile de l'ennemi.
	STY >DOPEN12_100_M+1 ; Modification du saut suivant.

	LBSR W13B		; Ajout d'un mur de fond W13B dans le buffer.

DOPEN12_100_M:
	JSR LISTE4RTS	; Affichage de l'ennemi (LISTE4RTS automodifié).
	BRA DOPENFIN

; Sol vide.
DOPEN12_G:
	LBSR W13B		; Ajout de W13B dans le buffer. Sol déjà affiché.

; --- FIN D'ANALYSE ET AFFICHAGE DE L'OUVERTURE DE LA PORTE ---
DOPENFIN:
	LBSR DP3B		; Ajout du montant de porte DP3B dans le buffer.

; R00 à R33
	LDY #SCROFFSET+$0D25 ; Y pointe le bas de porte à l'écran.
	LDX #BUFFERC+740 ; X pointe le buffer de couleur, ligne 75.
	LDB #34			; 34 pas à afficher.
	BSR DOPEN_R0	; Affichage des pas R00 à R33.

; R34
	LDY #SCROFFSET+$02D5 ; Y pointe le haut de la porte.
	LDB #5
	BSR DOPEN_R1_1	; Déplacement des 5 dernières lignes du bas de porte.
	LDX #SCROFFSET+$034D
	LDY #BUFFERC+60 ; Y pointe le buffer de couleur, ligne 7.
	LBSR DOPEN_R3	; Affichage du dessous de porte.
	LBSR SON_PORTE	; Son de porte

; R35
	LDY #SCROFFSET+$02D5 ; Y pointe le haut de la porte.
	LDB #3
	LBSR DOPEN_R1_1	; Déplacement des 3 dernières lignes du bas de porte.
	LDX #SCROFFSET+$02FD
	LDY #BUFFERC+40 ; Y pointe le buffer de couleur, ligne 5.
	LBSR DOPEN_R3	; Affichage du dessous de porte.
	LBSR SON_PORTE	; Son de porte

; R36
	LBSR VIDEOC_A	; Sélection video couleur.
	LDX #SCROFFSET+$025D ; X pointe le trou de la porte à l'écran.
	LDA #c00		; Couleurs = Encre noire (0) sur fond noir (0).
	LBSR G2_R1_2x10	; Deux lignes noires.
	INC $E7C3		; Sélection video forme.
	LDY #BUFFERC+20 ; Y pointe le buffer de couleur, ligne 3.
	LBSR DOPEN_R3	; Affichage du dessous de porte.

; --- PREPARATION DE LISTE 0, DECOMPRESSION DE LA MAP ET FIN ---
	LDX #LISTE0		; X pointe la pré-liste de rétablissement LISTE0.
	STX >PLISTE0	; PLISTE0 pointe la liste 0.
	LDD #DP3_REST	; D = adresse de rétablissement des couleurs de DP3
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	LDD >VARDW5		; D = adresse de rétablissement des couleurs des objets ou RTS.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	LBRA DCLOSE_FIN2 ; => Fin de remplissage et décompression de la map.

; --- SOUS-ROUTINES ---
; Affichage des pas R00 à R33.
DOPEN_R0:
	PSHS B
	PSHS Y,X

	PSHS X			; Sauvegarde du pointeur sur le buffer couleur.
	BSR DOPEN_R1	; Affichage du bas de porte.
	PULS Y			; Y pointe le buffer à recopier.
	BSR DOPEN_R3	; Affiche de deux lignes sous le bas de porte.

	PULS X,Y
	LEAX -20,X		; X pointe deux lignes de buffer plus haut.
	LEAY -80,Y		; Y pointe deux lignes écran plus haut.

	LBSR SON_PORTE
	PULS B
	DECB			; Pas suivant
	BNE DOPEN_R0
	RTS

; Déplacement du bas de porte deux lignes plus haut. 
; Y = position du bas de porte à l'écran.
DOPEN_R1:
	LDB #7			; 7 lignes à recopier par défaut.
DOPEN_R1_1:
	PSHS B,Y

	LBSR VIDEOC_A	; Sélection video couleur.
	BSR DOPEN_R2	; Recopie des couleurs du bas de porte.

	PULS Y,B

	INC $E7C3		; Sélection video forme, puis recopie des formes.

DOPEN_R2:
	LEAX -80,Y		; X pointe deux lignes au-dessus de Y.
DOPEN_R2_1:
	LBSR BSAVEN_10	; Recopie de 10 octets, ligne par ligne.
	LEAX 30,X
	LEAY 30,Y
	DECB
	BNE DOPEN_R2_1
	RTS

; Recopie des données de buffer vers l'écran, sous le bas de porte.
; X = position du dessous de porte. Y = position dans le buffer couleur.
DOPEN_R3:
	LBSR VIDEOC_A	; Sélection video couleur.
	BSR DOPEN_R4	; Affichage de deux lignes de couleurs.
	LEAX -80,X		; X pointe de nouveau le dessous de porte.
	LEAY 748,Y		; Y pointe les données de forme = + 768 - 20.
	INC $E7C3		; Sélection video forme, puis recopie des formes.

DOPEN_R4:
	LBSR BSAVEN_10	; Affichage de 2 lignes de couleur.
	LEAX 30,X
	LBSR BSAVEN_10
	LEAX 30,X
	RTS

;------------------------------------------------------------------------------
; Animation de la fermeture progressive d'une porte.
;------------------------------------------------------------------------------
; Affichage des pas R03 à R36
DCLOSE_R1:
	LDB #34			; 34 pas à dessiner.
DCLOSE_R1_1:
	PSHS B

	BSR DCLOSE_R0	; Dessin d'un pas
	LEAX -280,X		; X - 7 lignes.

	LBSR SON_PORTE	; Son de porte

	PULS B
	DECB
	BNE DCLOSE_R1_1
	RTS

; Affichage d'un pas. Y pointe la porte dans le buffer.
DCLOSE_R0:
	LDB #9			; 9 lignes à recopier par défaut.
	LDY #BUFFERC+670 ; Y pointe le buffer de couleur, ligne 68.
DCLOSE_R0_1:
	PSHS X,Y,B

	LBSR VIDEOC_A	; Sélection video couleur.
	BSR DCLOSE_R0_2	; Recopie des couleurs du bas de porte.

	PULS B,Y,X
	LEAY 768,Y		; Y pointe les données de forme de la porte.

	INC $E7C3		; Sélection video forme, puis recopie des formes.

DCLOSE_R0_2:
	LBSR BSAVEN_10	; Affichage d'une ligne de couleur ou de forme.
	LEAX 30,X
	DECB
	BNE DCLOSE_R0_2
	RTS

; Gestion des boutons
DCLOSE_R2:
	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LBSR PAS_AV		; Puis X pointe G6.

	LDA ,X			; A = code de la case.
	ANDA #%11111011 ; Porte considérée comme fermée.
	STA ,X

DCLOSE_R2_0:
	ANDA #%00000011	; A = type de serrure.
	CMPA #%00000011	; Porte à bouton?
	BEQ DCLOSE_R2_2	; Oui => DCLOSE_R2_2.

	; Ajouter la vérification que le joueur a la bonne clé.

	LDY #SON_CLE_D 	; Son de clé.
	LBSR MUS

DCLOSE_R2_1:
	LDB #30			; Tempo
	LBRA TEMPO

DCLOSE_R2_2:
	LBSR DL4_ON		; Affichage du bouton en position ON.
	LDY #SON_BOUTON_D
	LBSR MUS		; + son
	LDB #30			; Tempo
	LBSR TEMPO
	LBRA DL4_OFF	; Affichage du bouton en position OFF.

; --- PREPARATION ET FERMETURE DE LA PORTE ---
DCLOSE:
	LBSR DCLOSE_R2	; X pointe la case G6 + animation des boutons.
	LBSR MAPCOMP	; Compression et sauvegarde de la map courante.
	LBSR D06B		; Préparation de la porte dans le buffer.

; R00:
	LDX #SCROFFSET+$0285 ; X pointe le haut de la porte à l'écran.
	LDY #BUFFERC+730 ; Y pointe le buffer de couleur, ligne 74.
	LDB #3			; 3 lignes à dessiner.
	LBSR DCLOSE_R0_1 ; Dessin du bas de porte.
	LBSR SON_PORTE	; Son de porte

; R01:
	LDX #SCROFFSET+$0285 ; X pointe le haut de la porte à l'écran.
	LDY #BUFFERC+710 ; Y pointe le buffer de couleur, ligne 72.
	LDB #5			; 5 lignes à dessiner.
	LBSR DCLOSE_R0_1 ; Dessin du bas de porte.
	LBSR SON_PORTE	; Son de porte

; R02:
	LDX #SCROFFSET+$0285 ; X pointe le haut de la porte à l'écran.
	LDY #BUFFERC+690 ; Y pointe le buffer de couleur, ligne 70.
	LDB #7			; 7 lignes à dessiner.
	LBSR DCLOSE_R0_1 ; Dessin du bas de porte.
	LBSR SON_PORTE	; Son de porte

; R03 à R36:
	LDX #SCROFFSET+$0285 ; X pointe le haut de la porte à l'écran.
	LBSR DCLOSE_R1	; Affichage des pas.

; --- PREPARATION DE LISTE 0, DECOMPRESSION DE LA MAP ET FIN ---
DCLOSE_FIN:
	LDX #LISTE0		; X pointe la pré-liste de rétablissement LISTE0.
	STX >PLISTE0	; PLISTE0 pointe la liste 0.
	LDD #D06_REST	; D = adresse de rétablissement des couleurs.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.

DCLOSE_FIN2:
	LDD #DL_REST	; D = adresse de rétablissement des couleurs des serrures.
	LBSR LISTE0_SAV2 ; Adresse empilée dans LISTE0 sans condition.
	LDA #$39		; A = code machine de l'opérande RTS
	LDX >PLISTE0	; X = adresse de pointage d'appel dans LISTE0
	STA ,X			; Cloture de la liste d'appel 0 avec un RTS
	CLR >STATEF		; Réinitialisation des flags d'état.
	LBSR SET00_R1	; Réinitialisation de la liste 4.
	LBSR DONJON_GAUCHE_R0 ; Compensation de tempo pour l'invulnérabilité et la lévitation.
	LBSR MAPDECOMP	; Décompression de la map courante.
	LBSR DLISTE_EN	; Rétablissement de la liste des ennemis de la map.
	LBRA SET_FIN_0	; Détection des attaques hors champs et fin.

;------------------------------------------------------------------------------
; Données des portes
;------------------------------------------------------------------------------
; Données du montant de porte DP1
DP1_DATA:
	FCB $FF			; 1		Montant gauche
	FCB $0F			; 2

	FCB $09			; 20
	FCB $09			; 21
	FCB $FF			; 22

	FCB $09			; 40
	FCB $0F			; 41
	FCB $F9			; 42

	FCB $0B			; 60
	FCB $0D			; 61
	FCB $F9			; 62

	FCB $0B			; 80
	FCB $0F			; 81
	FCB $0F			; 82

	FCB $FF			; 1		Montant droit
	FCB $F0			; 2

	FCB $90			; 20
	FCB $90			; 21
	FCB $FF			; 22

	FCB $90			; 40
	FCB $F0			; 41
	FCB $9F			; 42

	FCB $D0			; 60
	FCB $B0			; 61
	FCB $9F			; 62

	FCB $D0			; 80
	FCB $F0			; 81
	FCB $F0			; 82

; Données du montant de porte DP2
DP2_DATA:
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $80,$01
	FCB $FF,$FF

DP2_DATA2:
	FCB $44,$44
	FCB $11,$11
	FCB $44,$44
	FCB $AA,$AA
	FCB $55,$55

; Données du montant de porte DP3
DP3_DATA:
	FCB $3F			; Colonne gauche
	FCB $07,$28
	FCB $07,$F8
	FCB $07,$28
	FCB $07,$38
	FCB $07,$E8
	FCB $07,$28
	FCB $3F

	FCB $FC			; Colonne droite
	FCB $E0,$14
	FCB $E0,$1F
	FCB $E0,$14
	FCB $E0,$1C
	FCB $E0,$17
	FCB $E0,$14
	FCB $FC

; Données des serrures de portes DL1, DL2 et DL3
DL_DATA:
	FCB $00
	FCB $7E
	FCB $66
	FCB $42
	FCB $42
	FCB $66
	FCB $46
	FCB $66
	FCB $46
	FCB $7E
	FCB $00

; Données du bouton de porte DL4 position OFF
DL4OFF_DATA:
	FCB $00
	FCB $3C
	FCB $7E
	FCB $7E
	FCB $7E
	FCB $3C
	FCB $00

; Données des bouts de porte D04 et D08
D04_DATA:
	FCB c00
	FCB c1F
	FCB c00,c00
	FCB cEE,cEE
	FCB c7E,c7E
	FCB c7E,c0E
	FCB cEE,c0E
	FCB cEE,cEE
	FCB c00,c00

	FCB $00
	FCB $08
	FCB $00,$00
	FCB $00,$00
	FCB $01,$80
	FCB $01,$40
	FCB $00,$C0
	FCB $00,$00
	FCB $00,$00

;------------------------------------------------------------------------------
; Téléporteur TEL06 (téléporteur entier en secteur G6).
; L'élément ne nécessite pas de drapeau d'affichage.
; D06_REST sert aussi à restaurer les couleurs du téléporteur.
;------------------------------------------------------------------------------
; Routine de rotation des couleurs.
TEL06_ROT:
	LBSR TEL06_ROT_R0 ; Rotation de couleurs.

	LDA >VARDB1		; Delai = 0?
	BEQ TEL06_ROT_1 ; Oui = affichage => TEL06_ROT_1
	RTS				; Sinon, fin.

TEL06_ROT_1:
	LDX #SCROFFSET+$02AE ; X pointe la zone de téléporteur.
	LDA ,Y
	LBSR G2_R1_8x8
	BSR TEL06_ROT_R2
	BSR TEL06_ROT_R3
	BSR TEL06_ROT_R4
	BSR TEL06_ROT_R3
	BSR TEL06_ROT_R2
	LDA ,Y
	LBSR G2_R1_8x8
	LDB #40

	INC $E7C3		; Sélection video forme.
	RTS

TEL06_ROT_R2:
	BSR TEL06_ROT_R2_2
	BSR TEL06_ROT_R2_2
	BSR TEL06_ROT_R2_2
TEL06_ROT_R2_2:
	BSR TEL06_ROT_R2_1
TEL06_ROT_R2_1:
	LDA ,Y
	STA ,X+
	LDA 1,Y
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	LDA ,Y
	STA ,X+
	ABX
	RTS

TEL06_ROT_R3:
	BSR TEL06_ROT_R3_2
	BSR TEL06_ROT_R3_2
	BSR TEL06_ROT_R3_2
TEL06_ROT_R3_2:
	BSR TEL06_ROT_R3_1
TEL06_ROT_R3_1:
	LDA ,Y
	STA ,X+
	LDA 1,Y
	STA ,X+
	LDA 2,Y
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	LDA 1,Y
	STA ,X+
	LDA ,Y
	STA ,X+
	ABX
	RTS

TEL06_ROT_R4:
	BSR TEL06_ROT_R4_8
	BSR TEL06_ROT_R4_8
TEL06_ROT_R4_8:
	BSR TEL06_ROT_R4_2
	BSR TEL06_ROT_R4_2
	BSR TEL06_ROT_R4_2
TEL06_ROT_R4_2:
	BSR TEL06_ROT_R4_1
TEL06_ROT_R4_1:
	LDA ,Y
	STA ,X+
	LDA 1,Y
	STA ,X+
	LDA 2,Y
	STA ,X+
	LDA 3,Y
	STA ,X+
	STA ,X+
	LDA 2,Y
	STA ,X+
	LDA 1,Y
	STA ,X+
	LDA ,Y
	STA ,X+
	ABX
	RTS

; Routine de rotation de couleur, commune à TEL06, TEL04 et TEL08
TEL06_ROT_R0:
	CLR >VARDB1
	LDA >TEL_DELAY ; A = délai de rotation.
	DECA			; Delai = delai - 1
	BEQ TEL06_ROT_R0_0 ; Délai = 0 => TEL06_ROT_R0_0

	STA >TEL_DELAY ; Sinon, sauvegarde du délai de rotation,
	STA >VARDB1
	RTS				; et fin.

TEL06_ROT_R0_0:
	LDA #TELTIMER
	STA >TEL_DELAY ; Réinitialisation du délai de rotation.

	LDA >TEL_ROT_NBR ; A = numéro de rotation courant.
	ADDA #4			; A = A+4
	CMPA #24		; A < 24?
	BCS TEL06_ROT_R0_1 ; Oui => TEL06_ROT_R0_1

	CLRA			; Sinon A = 0

TEL06_ROT_R0_1:
	STA >TEL_ROT_NBR ; Sauvegarde du numéro de rotation.
	LDY #TEL06_ROT_DATA	 ; Y pointe les couleurs à afficher.
	LEAY A,Y		; Y = Y+A
	LDB #40			; B = 40 pour les sauts de ligne.
	LBRA VIDEOC_A	; Sélection video couleur et fin.

; Routine de tuile codée pour un premier affichage.
TEL06:
	CLR >TEL_ROT_NBR ; Rotation de couleurs n°0.
	LDA #1
	STA >TEL_DELAY ; Délai = 1 pour déclencher la première rotation.
	LBSR TEL06_ROT	; Premier affichage des couleurs puis du téléporteur.

; Affichage du téléporteur.
TEL06_TEL:
	LBSR TEL06_SQR	; Affichage de la zone de téléportation puis colonnes.

; Affichage des colonnes du téléporteur.
TEL06_COL:
	LDX #SCROFFSET+$0285 ; X pointe la colonne de gauche à l'écran.
	BSR TEL06_COL1	; Affichage de la colonne gauche.

	LDX #SCROFFSET+$028E ; X pointe la colonne de droite à l'écran.
					; + Affichage de la colonne droite.
TEL06_COL1:
	BSR TEL06_COL2	; Haut de colonne.
	BSR TEL06_COL3	; 1er bloc.
	BSR TEL06_COL3	; 2ème bloc.
	BSR TEL06_COL3	; 3ème bloc.
	BSR TEL06_COL3	; 4ème bloc + bas de colonne.

TEL06_COL2:			; Haut ou bas de colonne.
	LBSR VIDEOC_A	; Sélection video couleur.
	LDA #c80		; Encre grise sur fond noir.
	STA ,X			; Couleur de ligne.
	INC $E7C3		; Sélection video forme.
	LDA #$81		; Haut ou bas de colonne.
	STA ,X			; Forme de ligne.
	ABX
	RTS

TEL06_COL3:			; Affichage d'un bloc 1x18
	LBSR VIDEOC_A	; Sélection video couleur.
	LDY #TEL06_DATA1 ; Y pointe les couleurs puis les formes.
	BSR TEL06_COL4	; 18 lignes de couleur.
	INC $E7C3		; Sélection video forme.
	LEAX -720,X		; X pointe de nouveau le bloc.

TEL06_COL4:
	LDA ,Y+			; 18 lignes de forme.
	STA ,X
	ABX
	LDA ,Y+
	STA ,X
	ABX
	LBRA DISPLAY_YX_16

; Affichage des formes de la zone de téléportation.
TEL06_SQR:
	LDX #SCROFFSET+$02AE ; 1ère colonne de blocs 8x8
	LDY #TEL06_F1
	BSR TEL06_SQR_R1

	LDX #SCROFFSET+$02B5 ; 8ème colonne de blocs 8x8
	LDY #TEL06_F4
	BSR TEL06_SQR_R1

	LDX #SCROFFSET+$02AF ; 2ème colonne de blocs 8x8
	LDY #TEL06_F1
	BSR TEL06_SQR_R2

	LDX #SCROFFSET+$02B4 ; 7ème colonne de blocs 8x8
	LDY #TEL06_F4
	BSR TEL06_SQR_R2

	LDX #SCROFFSET+$02B0 ; 3ème colonne de blocs 8x8
	LDY #TEL06_F1
	BSR TEL06_SQR_R3

	LDX #SCROFFSET+$02B3 ; 6ème colonne de blocs 8x8
	LDY #TEL06_F4
	BSR TEL06_SQR_R3

	LDX #SCROFFSET+$02B1 ; 4ème colonne de blocs 8x8
	LDY #TEL06_F1
	BSR TEL06_SQR_R4

	LDX #SCROFFSET+$02B2 ; 5ème colonne de blocs 8x8
	LDY #TEL06_F4
	BSR TEL06_SQR_R4

	LDX #SCROFFSET+$0761 ; Centre complété.
	LDY #TEL06_F9
	LBSR DP3_R2_12
	LDX #SCROFFSET+$0762
	LEAY 2,Y
	LBRA DP3_R2_12

; Routine pour les colonnes 1 et 8
TEL06_SQR_R1:
	BSR TEL06_SQR_R0_1
	LEAY 4,Y
	BSR TEL06_SQR_R0_7
	LEAY 4,Y
	BRA TEL06_SQR_R0_1

; Routine pour les colonnes 2 et 7
TEL06_SQR_R2:
	PSHS Y
	LDY #TEL06_F8
	BSR TEL06_SQR_R0_1
	PULS Y
	BSR TEL06_SQR_R0_1
	LEAY 4,Y
	BSR TEL06_SQR_R0_5
	LEAY 4,Y
	BSR TEL06_SQR_R0_1
	LDY #TEL06_F7
	BRA TEL06_SQR_R0_1

; Routine pour les colonnes 3 et 6
TEL06_SQR_R3:
	PSHS Y
	LDY #TEL06_F8
	BSR TEL06_SQR_R0_2
	PULS Y
	BSR TEL06_SQR_R0_1
	LEAY 4,Y
	BSR TEL06_SQR_R0_3
	LEAY 4,Y
	BSR TEL06_SQR_R0_1
	LDY #TEL06_F7
	BRA TEL06_SQR_R0_2

; Routine pour les colonnes 4 et 5
TEL06_SQR_R4:
	PSHS Y
	LDY #TEL06_F8
	BSR TEL06_SQR_R0_3
	PULS Y
	BSR TEL06_SQR_R0_1
	LEAY 4,Y
	BSR TEL06_SQR_R0_1
	LEAY 4,Y
	BSR TEL06_SQR_R0_1
	LDY #TEL06_F7
	BRA TEL06_SQR_R0_3

; Routines de blocs 8x8
TEL06_SQR_R0_7:
	BSR TEL06_SQR_R0_1
	BSR TEL06_SQR_R0_1
TEL06_SQR_R0_5:
	BSR TEL06_SQR_R0_1
	BSR TEL06_SQR_R0_1
TEL06_SQR_R0_3:
	BSR TEL06_SQR_R0_1
TEL06_SQR_R0_2:
	BSR TEL06_SQR_R0_1
TEL06_SQR_R0_1:
	LBSR DISPLAY_YX_8
	LEAY -8,Y
	RTS

;------------------------------------------------------------------------------
; Téléporteur TEL04 (bout de téléporteur en secteur G4).
; L'élément ne nécessite pas de drapeau d'affichage.
; D04_REST sert aussi à restaurer les couleurs du téléporteur.
;------------------------------------------------------------------------------
; Routine de tuile codée pour un premier affichage.
TEL04:
	CLR >TEL_ROT_NBR ; Rotation de couleurs n°0.
	LDA #1
	STA >TEL_DELAY ; Délai = 1 pour déclencher la première rotation.
	BSR TEL04_ROT	; Premier affichage des couleurs puis du téléporteur.

	LDX #SCROFFSET+$02A8 ; X pointe la colonne 1.
	LDY #TEL06_F4	; Forme de la colonne 1.
	LBSR TEL06_SQR_R2

	LDX #SCROFFSET+$02A9 ; X pointe la colonne 2.
	LDY #TEL06_F4	; Forme de la colonne 2.
	LBRA TEL06_SQR_R1

; Routine de rotation des couleurs.
TEL04_ROT:
	LBSR TEL06_ROT_R0 ; Rotation de couleurs.

	LDA >VARDB1		; Delai = 0?
	BEQ TEL04_ROT_1 ; Oui = affichage => TEL04_ROT_1
	RTS				; Sinon, fin.

TEL04_ROT_1:
	LDX #SCROFFSET+$02A8 ; X pointe la colonne 1.
	LDA ,Y			; Y pointe la première couleur de rotation.
	LBSR DISPLAY_A_8	; 8 lignes à colorer.
	LDA 1,Y			; Y pointe la deuxième couleur de rotation.
	LBSR DISPLAY_A_32	; 56 lignes à colorer.
	LBSR DISPLAY_A_24
	LDA ,Y			; Y pointe la première couleur de rotation.
	LBSR DISPLAY_A_8	; 8 lignes à colorer.

	LDX #SCROFFSET+$02A9 ; X pointe la colonne 2.
	LBSR DISPLAY_A_64	; 72 lignes à colorer.
	LBSR DISPLAY_A_8

	INC $E7C3		; Sélection video forme.
	RTS

;------------------------------------------------------------------------------
; Téléporteur TEL08 (bout de téléporteur en secteur G8).
; L'élément ne nécessite pas de drapeau d'affichage.
; D08_REST sert aussi à restaurer les couleurs du téléporteur.
;------------------------------------------------------------------------------
; Routine de tuile codée pour un premier affichage.
TEL08:
	CLR >TEL_ROT_NBR ; Rotation de couleurs n°0.
	LDA #1
	STA >TEL_DELAY	; Délai = 1 pour déclencher la première rotation.
	BSR TEL08_ROT	; Premier affichage des couleurs puis du téléporteur.

	LDX #SCROFFSET+$02BA ; X pointe la colonne 1.
	LDY #TEL06_F1	; Forme de la colonne 1.
	LBSR TEL06_SQR_R1

	LDX #SCROFFSET+$02BB ; X pointe la colonne 2.
	LDY #TEL06_F1	; Forme de la colonne 2.
	LBRA TEL06_SQR_R2

; Routine de rotation des couleurs.
TEL08_ROT:
	LBSR TEL06_ROT_R0 ; Rotation de couleurs.

	LDA >VARDB1		; Delai = 0?
	BEQ TEL08_ROT_1 ; Oui = affichage => TEL08_ROT_1
	RTS				; Sinon, fin.

TEL08_ROT_1:
	LDX #SCROFFSET+$02BA ; X pointe la colonne 1.
	LDA ,Y			; Y pointe la première couleur de rotation.
	LBSR DISPLAY_A_64	; 72 lignes à colorer.
	LBSR DISPLAY_A_8

	LDX #SCROFFSET+$02BB ; X pointe la colonne 2.
	LBSR DISPLAY_A_8	; 8 lignes à colorer.
	LDA 1,Y			; Y pointe la deuxième couleur de rotation.
	LBSR DISPLAY_A_32	; 56 lignes à colorer.
	LBSR DISPLAY_A_24
	LDA ,Y			; Y pointe la première couleur de rotation.
	LBSR DISPLAY_A_8	; 8 lignes à colorer.

	INC $E7C3		; Sélection video forme.
	RTS

;------------------------------------------------------------------------------
; Données des téléporteurs
;------------------------------------------------------------------------------
; Variables spécifiques pour la rotation des couleurs.
TEL_ROT_NBR		FCB $00	; Numéro de rotation
TEL_DELAY		FCB $00	; Délai de rotation pour TEL04

; Données des morceaux de colonnes.
TEL06_DATA1:
	FCB c10,cF0,cB0,cF0,c10,cB0,cF0,c10,cF0,cB0,cF0,cB0,cF0,c10,cF0,cB0,cF0,c10
	FCB $12,$A0,$60,$19,$04,$08,$68,$91,$14,$08,$48,$84,$08,$10,$22,$61,$94,$08

; Formes
TEL06_F1:
	FCB $0A
	FCB $00
	FCB $25
	FCB $08
TEL06_F2:
	FCB $22
	FCB $09
	FCB $22
	FCB $09
TEL06_F3:
	FCB $22
	FCB $09
	FCB $22
	FCB $09
	FCB $20
	FCB $0A
	FCB $20
	FCB $15
TEL06_F4:
	FCB $A8
	FCB $04
	FCB $50
	FCB $04
TEL06_F5:
	FCB $90
	FCB $44
	FCB $90
	FCB $44
TEL06_F6:
	FCB $90
	FCB $44
	FCB $90
	FCB $44
	FCB $10
	FCB $A4
	FCB $00
	FCB $50
TEL06_F7:
	FCB $FF
	FCB $FF
	FCB $AA
	FCB $55
	FCB $00
TEL06_F8:
	FCB $AA
	FCB $00
	FCB $55
	FCB $00
	FCB $AA
	FCB $55
	FCB $FF
	FCB $FF
TEL06_F9:
	FCB $FE
	FCB $01
	FCB $7F
	FCB $80

; Couleurs de rotation
TEL06_ROT_DATA:
	FCB c6E,cC6,c4C,c04	; Rotation 1
	FCB cE7,c6E,cC6,c4C	; Rotation 2
	FCB c70,cE7,c6E,cC6	; Rotation 3
	FCB c04,c70,cE7,c6E	; Rotation 4
	FCB c4C,c04,c70,cE7	; Rotation 5
	FCB cC6,c4C,c04,c70	; Rotation 6

;------------------------------------------------------------------------------
; Coffre CHEST06 : routine d'affichage du coffre au sol en secteur 6
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST06:
	CLR >G6D		; G6 marqué comme à réafficher.
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts (évite de le coder pour le mimic).
	LDX #SCROFFSET+$0D28 ; X pointe le coffre à l'écran en secteur 6
	LDY #CHEST06_DATA ; Y pointe les données de couleur
	LBSR DISPLAY_YX_16
	LEAX -639,X
	LEAY -16,Y
	LBSR DISPLAY_YX_16
	LEAX -639,X
	LEAY -16,Y
	LBSR DISPLAY_YX_16
	LEAX -639,X
	LEAY -16,Y
	LBSR DISPLAY_YX_16

	INC $E7C3		; Sélection vidéo forme.
	LDX #SCROFFSET+$0D28 ; X pointe le coffre à l'écran en secteur 6
	LBSR DISPLAY_2YX_16 ; Colonnes 1 et 2
	LEAX -638,X
	LBRA DISPLAY_2YX_16	; Colonne 3 et 4

;------------------------------------------------------------------------------
; Coffre CHEST12 : routine d'affichage du coffre au sol en secteur 12
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
; Routine adaptée au buffer, pour l'ouverture des portes.  
CHEST12B:
	LDB #10
	LDX #BUFFERC+524 ; X pointe le coffre dans le buffer de couleur.
	LDY #CHEST09_DATA ; Y pointe les données de couleur
	LBSR DISPLAY_YX_11 ; 1x11 octets.
	LEAX -109,X
	LEAY -11,Y
	LBSR DISPLAY_YX_11 ; 1x11 octets.
	LEAX -109,X
	LEAY -11,Y
	LBSR DISPLAY_YX_11 ; 1x11 octets.

	LDX #BUFFERF+524 ; X pointe le coffre dans le buffer de forme.
	LBSR DISPLAY_YX_11 ; 1x11 octets.
	LEAX -109,X
	LBSR DISPLAY_YX_11 ; 1x11 octets.
	LEAX -109,X
	LEAY -22,Y
	LBSR DISPLAY_YX_11 ; 1x11 octets.

	LDD #REST12B 	; Pour le rétablissement des couleurs dans DOPEN
	STD >VARDW5
	RTS

CHEST12:
	CLR >G12D		; G12 marqué comme à réafficher.
	LDX #SCROFFSET+$0A81 ; X pointe le coffre à l'écran en secteur 12

	BSR CHEST10_2
	LEAX -439,X
	BRA CHEST10_0

;------------------------------------------------------------------------------
; Coffre CHEST09 : routine d'affichage du coffre au sol en secteur 9
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST09:
	CLR >G9D		; G9 marqué comme à réafficher.
	LDX #SCROFFSET+$0A79 ; X pointe le coffre à l'écran en secteur 9
	BRA CHEST10_2

;------------------------------------------------------------------------------
; Coffre CHEST10 : routine d'affichage du coffre au sol en secteur 10
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST10:
	CLR >G10D		; G10 marqué comme à réafficher.
	LDX #SCROFFSET+$0A7A ; X pointe le coffre à l'écran en secteur 10

CHEST10_0:
	BSR CHEST10_1
	LEAX -439,X		; X pointe la dernière colonne

CHEST10_2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts (évite de le coder pour le mimic).
	LDY #CHEST09_DATA ; Y pointe les données de couleur
	LBSR DISPLAY_YX_11 ; 1x11 octets.

	INC $E7C3		; Sélection vidéo forme.
	LEAX -440,X		; X pointe de nouveau le coffre
	LBRA DISPLAY_YX_11 ; 1x11 octets.

CHEST10_1:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDY #CHEST09_DATA ; Y pointe les données de couleur
	LBSR DISPLAY_YX_11 ; 1x11 octets.

	INC $E7C3		; Sélection vidéo forme.
	LDY #CHEST10_DATA ; Y pointe les données de forme
	LEAX -440,X		; X pointe de nouveau le coffre
	LBRA DISPLAY_YX_11 ; 1x11 octets.

;------------------------------------------------------------------------------
; Coffre CHEST14 : routine d'affichage du coffre au sol en secteur 14
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST14:
	CLR >G14D		; G14 marqué comme à réafficher.
	LDX #SCROFFSET+$0A88 ; X pointe le coffre à l'écran en secteur 14
	BSR CHEST10_2
	LEAX -439,X
	BRA CHEST10_1

;------------------------------------------------------------------------------
; Coffre CHEST15 : routine d'affichage du coffre au sol en secteur 15
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST15:
	CLR >G15D		; G15 marqué comme à réafficher.
	LDX #SCROFFSET+$0A8A ; X pointe le coffre à l'écran en secteur 15
	BRA CHEST10_2

;------------------------------------------------------------------------------
; Coffre CHEST23 : routine d'affichage du coffre au sol en secteur 23
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST23:
	CLR >G23D		; G23 marqué comme à réafficher.
	LDX #SCROFFSET+$08F6 ; X pointe le coffre à l'écran en secteur 23
	BRA CHEST18_1

;------------------------------------------------------------------------------
; Coffre CHEST18 : routine d'affichage du coffre au sol en secteur 18
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST18:
	CLR >G18D		; G18 marqué comme à réafficher.
	LDX #SCROFFSET+$08EC ; X pointe le coffre à l'écran en secteur 18

CHEST18_1:
	LDY #CHEST18_DATA ; Y pointe les données de couleur

CHEST18_2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts (évite de le coder pour le mimic).
	LBSR DISPLAY_YX_7 ; 1x7 octets.
	LEAX -280,X		; X pointe de nouveau le coffre
	INC $E7C3		; Sélection vidéo forme.
	LBRA DISPLAY_YX_7 ; 1x7 octets.

;------------------------------------------------------------------------------
; Coffre CHEST21 : routine d'affichage du coffre au sol en secteur 21
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST21:
	CLR >G21D		; G21 marqué comme à réafficher.
	LDX #SCROFFSET+$08F1 ; X pointe le coffre à l'écran en secteur 21
	BSR CHEST18_1
	LEAX -279,X
	BRA CHEST19_1

;------------------------------------------------------------------------------
; Coffre CHEST24 : routine d'affichage du coffre au sol en secteur 24
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST24:
	CLR >G24D		; G24 marqué comme à réafficher.
	LDX #SCROFFSET+$08F7 ; X pointe le coffre à l'écran en secteur 24
	BRA CHEST19_1

;------------------------------------------------------------------------------
; Coffre CHEST19 : routine d'affichage du coffre au sol en secteur 19
; Cette routine sert aussi pour le Mimic.
;------------------------------------------------------------------------------
CHEST19:
	CLR >G19D		; G19 marqué comme à réafficher.
	LDX #SCROFFSET+$08ED ; X pointe le coffre à l'écran en secteur 19

CHEST19_1:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts (évite de le coder pour le mimic).
	LDY #CHEST18_DATA ; Y pointe les données de couleur
	LBSR DISPLAY_YX_7 ; 1x7 octets.

	INC $E7C3		; Sélection vidéo forme.
	LEAX -280,X		; X pointe de nouveau le coffre
	LDY #CHEST19_DATA ; Y pointe les données de forme
	LBRA DISPLAY_YX_7 ; 1x7 octets.

;------------------------------------------------------------------------------
; Données des coffres.
;------------------------------------------------------------------------------
; Données du coffre en secteur 06
CHEST06_DATA:
	FCB c7F			; Couleurs colonnes 1 à 4
	FCB cB1
	FCB cBF
	FCB c3F
	FCB c31
	FCB c33
	FCB c3F
	FCB c3F
	FCB c31
	FCB cBF
	FCB cBF
	FCB cB1
	FCB cBF
	FCB c3F
	FCB c31
	FCB c3B

	FCB $C0,$C0		; Forme colonnes 1 et 2
	FCB $C0,$C0
	FCB $C0,$C0
	FCB $C0,$C0
	FCB $E1,$E0
	FCB $FF,$FF
	FCB $E1,$E3
	FCB $C0,$C3
	FCB $C0,$C3
	FCB $C0,$C0
	FCB $C0,$C0
	FCB $C0,$C0
	FCB $C0,$C0
	FCB $C0,$C0
	FCB $E0,$C0
	FCB $F1,$F0

	FCB $03,$03		; Forme colonnes 3 et 4
	FCB $03,$03
	FCB $03,$03
	FCB $03,$03
	FCB $07,$87
	FCB $FF,$FF
	FCB $C7,$87
	FCB $C3,$03
	FCB $C3,$03
	FCB $03,$03
	FCB $03,$03
	FCB $03,$03
	FCB $03,$03
	FCB $03,$03
	FCB $03,$07
	FCB $0F,$8F

; Données du coffre en secteurs 09, 10, 12, 14 et 15
CHEST09_DATA:
	FCB c71		; Couleurs pour toutes les colonnes
	FCB cBF
	FCB c31
	FCB c33
	FCB c3F
	FCB c31
	FCB cBF
	FCB cB1
	FCB cBF
	FCB c31
	FCB c3B

	FCB $C3		; Formes colonnes 1 et 3
	FCB $C3
	FCB $C3
	FCB $FF
	FCB $C3
	FCB $C3
	FCB $C3
	FCB $C3
	FCB $C3
	FCB $C3
	FCB $E7

; Données du coffre en secteurs 10, 12 et 14
CHEST10_DATA:
	FCB $00		; Formes colonne 2
	FCB $00
	FCB $00
	FCB $FF
	FCB $18
	FCB $18
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $81

; Données du coffre en secteurs 18, 21 et 24
CHEST18_DATA:
	FCB c71		; Couleurs pour toutes les colonnes
	FCB cBF
	FCB c33
	FCB c31
	FCB cBF
	FCB c31
	FCB c3B

	FCB $84		; Formes colonne 1
	FCB $84
	FCB $FF
	FCB $85
	FCB $84
	FCB $84
	FCB $CE

; Données du coffre en secteurs 19, 21 et 25
CHEST19_DATA:
	FCB $21		; Formes colonne 2
	FCB $21
	FCB $FF
	FCB $A1
	FCB $21
	FCB $21
	FCB $73

;------------------------------------------------------------------------------
; Bannière Baphomet (ornement 1) en secteur 04.
; La réstauration des couleurs se fait avec D04_REST.
;------------------------------------------------------------------------------
BAN04:
	LDX #SCROFFSET+$0258 ; X pointe la bannière à l'écran.

; Routine commune avec BAN06
BAN04_0:
	LDY #BAN04_DATA	; Y pointe les données de le bannière.
	BRA BAN08_1

;------------------------------------------------------------------------------
; Bannière Baphomet (ornement 1) en secteur 08.
; La réstauration des couleurs se fait avec D08_REST.
;------------------------------------------------------------------------------
BAN08:
	LDX #SCROFFSET+$026A ; X pointe la bannière à l'écran.

; Routine commune avec BAN06
BAN08_0:
	LDY #BAN08_DATA		; Y pointe les données de le bannière.

; Routine commune avec BAN04
BAN08_1:
	LBSR VIDEOC_A		; Sélection vidéo couleur.
	LDD #c1128			; A = rouge sur fond rouge. B = 40 pour les sauts de ligne.
	STA ,X				; Ligne 1
	STA 1,X
	ABX
	LDA #c00			; A = noir sur fond noir
	LBSR DISPLAY_2A_2	; Lignes 2 et 3
	LDA #c08			; A = noir sur fond gris
	LBSR DISPLAY_2A_16	; Lignes 4 à 19
	LDA #c00			; A = noir sur fond noir
	LBSR DISPLAY_2A_13	; Lignes 20 à 32
	LDA #c01			; A = noir sur fond rouge
	LBSR DISPLAY_2A_8	; Lignes 33 à 40
	LDA #c00			; A = noir sur fond noir
	LBSR DISPLAY_2A_16	; Lignes 41 à 56
	LDA #c01			; A = noir sur fond rouge
	LBSR DISPLAY_2A_10	; Lignes 57 à 66
	LDA #c00			; A = noir sur fond noir
	LBSR DISPLAY_2A_9	; Lignes 67 à 75
	LDA #c11			; A = rouge sur fond rouge
	STA ,X				; Ligne 76
	STA 1,X

	INC $E7C3			; Sélection vidéo forme.
	LEAX -2880,X		; X pointe la ligne 4
	LBSR DISPLAY_2YX_16 ; Lignes 4 à 19
	LEAX 520,X			; X pointe la ligne 33
	LBSR DISPLAY_2YX_8	; Lignes 33 à 40
	LEAX 640,X			; X pointe la ligne 57
	LDY #BAN08_DATA1	; Y pointe les données du 6
	LBRA DISPLAY_2YX_10	; Lignes 57 à 66

;------------------------------------------------------------------------------
; Bannière Baphomet (ornement 1) en secteur 06.
; La réstauration des couleurs se fait avec D06_REST.
;------------------------------------------------------------------------------
BAN06:
	LDX #SCROFFSET+$0265 ; X pointe les colonnes 1 et 2
	BSR BAN04_0			; Dessin des colonnes 1 et 2.

	LDX #SCROFFSET+$025D ; X pointe les colonnes 9 et 10
	BSR BAN08_0			; Dessin des colonnes 9 et 10 + vidéo forme.

	LBSR VIDEOC_A		; Sélection vidéo couleur.
	LDX #SCROFFSET+$0261 ; X pointe les colonnes 5 et 6
	LDA #c11			; A = rouge sur fond rouge.
	STA ,X				; Ligne 1
	STA 1,X
	ABX
	LDA #c00			; A = noir sur fond noir
	LBSR DISPLAY_2A_5	; Lignes 2 à 6
	LDA #c01			; A = noir sur fond rouge
	LBSR DISPLAY_2A_10	; Lignes 7 à 16
	LDA #c00			; A = noir sur fond noir
	LBSR DISPLAY_2A_5	; Lignes 17 à 21
	LDA #c01			; A = noir sur fond rouge
	LBSR DISPLAY_2A_16	; Lignes 22 à 37
	LBSR DISPLAY_2A_5	; Lignes 38 à 42
	LDA #c13			; A = rouge sur fond jaune vif.
	LBSR DISPLAY_2A_4	; Lignes 43 à 46
	LDA #c11			; A = rouge sur fond rouge.
	LBSR DISPLAY_2A_10	; Lignes 47 à 56
	LDA #c01			; A = noir sur fond rouge
	LBSR DISPLAY_2A_6	; Lignes 57 à 62
	LDA #c11			; A = rouge sur fond rouge.
	LBSR DISPLAY_2A_6	; Lignes 63 à 68
	LDA #c01			; A = noir sur fond rouge
	LBSR DISPLAY_2A_8	; Lignes 69 à 76

	INC $E7C3			; Sélection vidéo forme.
	LDX #SCROFFSET+$0351 ; X pointe les colonnes 5 et 6, ligne 7
	LDY #BAN08_DATA1	; Y pointe les données du 6
	LBSR DISPLAY_2YX_10	; Dessin du 6.
	LEAX 200,X			; X pointe la ligne 22
	LBSR DISPLAY_2YX_16	; Lignes 22 à 37
	LBSR DISPLAY_2YX_9	; Lignes 38 à 46
	LEAX 400,X			; X pointe la ligne 57
	LBSR DISPLAY_2YX_6	; Lignes 57 à 62
	LEAX 240,X			; X pointe la ligne 69
	LBSR DISPLAY_2YX_8	; Lignes 69 à 76

	LBSR VIDEOC_A		; Sélection vidéo couleur.
	LDX #SCROFFSET+$025F ; X pointe les colonnes 3 et 4
	BSR BAN06_R2		; Lignes 47 à 76
	LDX #SCROFFSET+$0263 ; X pointe les colonnes 7 et 8
	BSR BAN06_R3		; Lignes 47 à 76

	INC $E7C3			; Sélection vidéo forme.
	LDX #SCROFFSET+$043F ; X pointe les colonnes 3 et 4, ligne 13
	BSR BAN06_R0		; Lignes 13 à 46
	LEAX 1,X
	LBSR TEL06_COL4		; Lignes 47 à 64
	LDX #SCROFFSET+$0443 ; X pointe les colonnes 7 et 8, ligne 13
	BSR BAN06_R0		; Lignes 13 à 46
	LBRA TEL06_COL4		; Lignes 47 à 64

BAN06_R0:
	LBSR DISPLAY_2YX_16	; Lignes 13 à 28
	LBSR DISPLAY_2YX_4	; Lignes 29 à 32
	LEAX 320,X
	LBRA DISPLAY_2YX_6	; Lignes 41 à 46

BAN06_R1:
	LDA #c11			; A = rouge sur fond rouge.
	STA ,X				; Ligne 1
	STA 1,X
	ABX
	LDA #c00			; A = noir sur fond noir
	LBSR DISPLAY_2A_11	; Lignes 2 à 12
	LDA #c08			; A = noir sur fond gris
	LBSR DISPLAY_2A_10	; Lignes 13 à 22
	LDA ,Y+
	LBSR DISPLAY_A_6	; Colonne 3, lignes 23 à 28
	LDA ,Y+
	LBSR DISPLAY_A_4	; Colonne 3, lignes 29 à 32
	LEAX -399,X
	LDA ,Y+
	LBSR DISPLAY_A_6	; Colonne 4, lignes 23 à 28
	LDA ,Y+
	LBSR DISPLAY_A_4	; Colonne 4, lignes 29 à 32
	LEAX -1,X
	LDA #c11			; A = rouge sur fond rouge.
	LBSR DISPLAY_2A_8	; Lignes 33 à 40
	LDA ,Y+
	LBSR DISPLAY_A_6	; Colonne 3, lignes 41 à 46
	LEAX -239,X
	LDA ,Y+
	LBSR DISPLAY_A_6	; Colonne 4, lignes 41 à 46
	LEAX -1,X
	LDA #c00			; A = noir sur fond noir
	LBSR DISPLAY_2A_16	; Lignes 47 à 62
	LBSR DISPLAY_2A_13	; Lignes 63 à 75
	LDA #c11			; A = rouge sur fond rouge.
	STA ,X				; Ligne 76
	STA 1,X
	RTS

BAN06_R2:
	BSR BAN06_R1		; Lignes 1 à 76
	LEAX -1159,X
	BRA BAN06_R4

BAN06_R3:
	BSR BAN06_R1		; Lignes 1 à 76
	LEAX -1160,X

BAN06_R4:
	LDA #c01			; A = noir sur fond rouge
	LBSR DISPLAY_A_16	; Lignes 47 à 62
	LBSR DISPLAY_A_2	; Lignes 63 et 64
	RTS

;------------------------------------------------------------------------------
; Données de la bannière Baphomet (ornement 1)
;------------------------------------------------------------------------------
BAN04_DATA:
	FCB $FF,$DF		; Lignes 4 à 19
	FCB $FF,$9F
	FCB $FF,$1F
	FCB $FE,$1F
	FCB $FD,$1F
	FCB $F8,$FF
	FCB $F0,$3F
	FCB $E8,$7F
	FCB $86,$FF
	FCB $81,$FF
	FCB $63,$FF
	FCB $1F,$FF
	FCB $0F,$FF
	FCB $1F,$FF
	FCB $FF,$FF
	FCB $7F,$FF

	FCB $7F,$FF		; Lignes 33 à 40
	FCB $07,$FF
	FCB $01,$FF
	FCB $00,$7F
	FCB $00,$1F
	FCB $00,$0F
	FCB $0F,$FF
	FCB $3F,$FF

BAN08_DATA:
	FCB $FB,$FF		; Lignes 4 à 19
	FCB $F9,$FF
	FCB $F8,$FF
	FCB $F8,$7F
	FCB $F8,$BF
	FCB $FF,$1F
	FCB $FC,$0F
	FCB $FE,$17
	FCB $FF,$61
	FCB $FF,$81
	FCB $FF,$C6
	FCB $FF,$F8
	FCB $FF,$F0
	FCB $FF,$F8
	FCB $FF,$FF
	FCB $FF,$FE

	FCB $FF,$FE		; Lignes 33 à 40
	FCB $FF,$E0
	FCB $FF,$80
	FCB $FE,$00
	FCB $F8,$00
	FCB $F0,$00
	FCB $FF,$F0
	FCB $FF,$FC

BAN08_DATA1:		; Données du '6'
	FCB $FE,$1F		; Lignes 58 à 67
	FCB $FC,$FF
	FCB $F9,$FF
	FCB $F9,$FF
	FCB $F8,$1F
	FCB $F8,$CF
	FCB $F9,$CF
	FCB $F9,$CF
	FCB $F9,$CF
	FCB $FC,$1F

BAN06_DATA:			; Formes des colonnes 5 et 6
	FCB $03,$C0		; Lignes 22 à 46
	FCB $00,$00
	FCB $00,$00
	FCB $00,$00
	FCB $00,$00
	FCB $60,$06
	FCB $58,$1A
	FCB $26,$64
	FCB $21,$84
	FCB $16,$68
	FCB $18,$18
	FCB $68,$16
	FCB $88,$11
	FCB $FF,$FF
	FCB $04,$20
	FCB $02,$40
	FCB $02,$40
	FCB $01,$80
	FCB $00,$00
	FCB $00,$00
	FCB $00,$00
	FCB $7F,$FE
	FCB $3F,$FC
	FCB $1F,$F8
	FCB $1F,$F8

	FCB $3C,$3C		; Lignes 57 à 62
	FCB $7E,$7E
	FCB $67,$E6
	FCB $63,$C6
	FCB $7F,$FE
	FCB $3F,$FC

	FCB $40,$02		; Lignes 69 à 76
	FCB $40,$02
	FCB $E8,$17
	FCB $EC,$37
	FCB $EE,$77
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $00,$00

	FCB c08,c01		; Couleurs des colonnes 3 et 4
	FCB c81,c11
	FCB c01,c13

	FCB c81,c11		; Couleurs des colonnes 7 et 8
	FCB c08,c01
	FCB c13,c01

	FCB $7F,$FF		; Formes des colonnes 3 et 4, lignes 13 à 32
	FCB $1F,$FF
	FCB $17,$FF
	FCB $21,$FF
	FCB $C1,$7F
	FCB $02,$1F
	FCB $04,$0F
	FCB $18,$17
	FCB $E0,$23
	FCB $80,$C3
	FCB $C1,$FC
	FCB $E6,$F0
	FCB $F8,$C0
	FCB $F0,$80
	FCB $F0,$00
	FCB $F8,$00
	FCB $F8,$00
	FCB $E0,$00
	FCB $C0,$00
	FCB $80,$00

	FCB $04,$E1		; Formes des colonnes 3 et 4, lignes 41 à 64
	FCB $FC,$E0
	FCB $FC,$E0
	FCB $FC,$F0
	FCB $FE,$F8
	FCB $FE,$FC
	FCB 	$00
	FCB 	$00
	FCB 	$80
	FCB 	$C0
	FCB 	$E0
	FCB 	$F0
	FCB 	$F0
	FCB 	$F8
	FCB 	$F8
	FCB 	$F8
	FCB 	$FC
	FCB 	$FC
	FCB 	$FC
	FCB 	$FC
	FCB 	$FC
	FCB 	$FC
	FCB 	$FC
	FCB 	$FE

	FCB $FF,$FE		; Formes des colonnes 7 et 8, lignes 13 à 32
	FCB $FF,$F8
	FCB $FF,$E8
	FCB $FF,$84
	FCB $FE,$83
	FCB $F8,$40
	FCB $F0,$20
	FCB $E8,$18
	FCB $C4,$07
	FCB $C3,$01
	FCB $3F,$83
	FCB $0F,$67
	FCB $03,$1F
	FCB $01,$0F
	FCB $00,$0F
	FCB $00,$1F
	FCB $00,$1F
	FCB $00,$07
	FCB $00,$03
	FCB $00,$01

	FCB $87,$20		; Formes des colonnes 7 et 8, lignes 41 à 64
	FCB $07,$3F
	FCB $07,$3F
	FCB $0F,$3F
	FCB $1F,$7F
	FCB $3F,$7F
	FCB $00
	FCB $00
	FCB $01
	FCB $03
	FCB $07
	FCB $0F
	FCB $0F
	FCB $1F
	FCB $1F
	FCB $1F
	FCB $3F
	FCB $3F
	FCB $3F
	FCB $3F
	FCB $3F
	FCB $3F
	FCB $3F
	FCB $7F

;------------------------------------------------------------------------------
; Têtes sur des piques (ornement 2) en secteur 04.
; La réstauration des couleurs se fait avec D04_REST.
;------------------------------------------------------------------------------
ORN04:
	LDX #SCROFFSET+$0320 ; X pointe la pique en secteur 4
	BRA ORN06_R1

;------------------------------------------------------------------------------
; Têtes sur des piques (ornement 2) en secteur 04.
; La réstauration des couleurs se fait avec D04_REST.
;------------------------------------------------------------------------------
ORN08:
	LDX #SCROFFSET+$0332 ; X pointe la pique en secteur 8
	BRA ORN06_R1

;------------------------------------------------------------------------------
; Têtes sur des piques (ornement 2) en secteur 04.
; La réstauration des couleurs se fait avec D04_REST.
;------------------------------------------------------------------------------
ORN06:
	LDX #SCROFFSET+$0325 ; X pointe la 1ère pique
	BSR ORN06_R1
	LDX #SCROFFSET+$0327 ; X pointe la 2ème pique
	BSR ORN06_R1
	LDX #SCROFFSET+$0329 ; X pointe la 3ème pique
	BSR ORN06_R1
	LDX #SCROFFSET+$032B ; X pointe la 4ème pique
	BSR ORN06_R1
	LDX #SCROFFSET+$032D ; X pointe la 5ème pique

; Routine commune = 3 têtes sur une pique. X pointe la pique à l'écran.
ORN06_R1:
	LBSR VIDEOC_A		; Sélection vidéo couleur.
	LDB #40				; B = 40 pour les sauts de ligne.
	LDY #ORN06_DATA		; Y pointe les couleurs des piques.
	LBSR DISPLAY_2YX_15	; Lignes 1 à 15.
	LEAY -30,Y			; Y pointe de nouveau les couleurs des piques.
	LBSR DISPLAY_2YX_15	; Lignes 16 à 30.
	LEAY -30,Y			; Y pointe de nouveau les couleurs des piques.
	LBSR DISPLAY_2YX_15	; Lignes 31 à 45.
	LEAY -30,Y			; Y pointe de nouveau les couleurs des piques.
	LBSR DISPLAY_2YX_15	; Lignes 46 à 60.
	LBSR DISPLAY_YX_11	; Lignes 47 à 71.

	INC $E7C3			; Sélection vidéo forme.
	LEAX -2840,X		; X pointe de nouveau le haut de la pique
	LBSR DISPLAY_2YX_15	; Lignes 1 à 15.
	LBSR DISPLAY_2YX_15	; Lignes 16 à 30.
	LEAY -60,Y			; Y pointe de nouveau les formes de tête.
	LBSR DISPLAY_2YX_15	; Lignes 31 à 45.
	LBSR DISPLAY_2YX_15	; Lignes 46 à 60.
	LBRA DISPLAY_YX_11	; Lignes 61 à 71.

;------------------------------------------------------------------------------
; Données des têtes sur les piques (ornement 2)
;------------------------------------------------------------------------------
ORN06_DATA:
	FCB c81,c88		; Couleurs des têtes
	FCB c71,c77
	FCB c71,c77
	FCB c70,c77
	FCB c70,c07
	FCB c0D,c07
	FCB c0D,c07
	FCB c0D,c07
	FCB c0D,c07
	FCB c0D,c07
	FCB c0D,c07
	FCB c0D,c07
	FCB c0D,c07
	FCB c07,c07
	FCB c71,c77

	FCB c81			; Couleurs du socle
	FCB c81
	FCB c81
	FCB c8F
	FCB c8F
	FCB c8F
	FCB c8F
	FCB c1F
	FCB c1F
	FCB c11
	FCB c00

	FCB $E7,$FF		; Formes tête 1 et 3
	FCB $E7,$FF
	FCB $E7,$FF
	FCB $C0,$FF
	FCB $80,$80
	FCB $EA,$80
	FCB $C0,$80
	FCB $B3,$80
	FCB $80,$80
	FCB $8C,$80
	FCB $80,$80
	FCB $9D,$80
	FCB $C3,$80
	FCB $BD,$00
	FCB $E7,$FF

	FCB $E7,$FF		; Formes tête 2 et 4
	FCB $E7,$FF
	FCB $E7,$FF
	FCB $81,$FF
	FCB $00,$00
	FCB $AB,$80
	FCB $81,$80
	FCB $E6,$80
	FCB $80,$80
	FCB $98,$80
	FCB $80,$80
	FCB $DC,$80
	FCB $E1,$80
	FCB $5E,$80
	FCB $E7,$FF

	FCB $E7			; Formes du socle
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $FF
	FCB $FF

;------------------------------------------------------------------------------
; Routines de restauration des couleurs pour les coffres et les ennemis
; La mémoire vidéo couleur doit être activée et B doit être égal à 40.
;------------------------------------------------------------------------------

; --- SECTEUR G06 ----
; Grands ennemis (spectres, cerbères, troopers)
REST06:
	BSR REST06B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST06A:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$02B0 ; X pointe le plafond en G6.
	LDB #36			; B = 36 pour les sauts de ligne.
	LBSR G2_R1_64x5	; 64 lignes à réinitialiser.
	LDB #40
	RTS

; Coffres et les petits ennemis au sol (araignées, blobs)
REST06B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
REST06B2:
	LDX #SCROFFSET+$0CB0 ; X pointe le sol en G6.
	LDB #36			; B = 36 pour les sauts de ligne.
	LBSR G2_R1_16x5	; 23 lignes à réinitialiser.
	LBSR G2_R1_7x5
	LDB #40
	RTS

; --- SECTEUR G15 ----
; Grands ennemis (spectres, cerbères, troopers)
REST15:
	BSR REST15B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST15A:
	LDX #SCROFFSET+$03D2 ; X pointe le plafond en G15.
	BRA REST09A1

; Coffres et les petits ennemis au sol (araignées, blobs)
REST15B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$0A3A ; X pointe le sol en G15.
	LBRA DISPLAY_A_15 ; 15 lignes à réinitialiser

; --- SECTEUR G09 ----
; Grands ennemis (spectres, cerbères, troopers)
REST09:
	BSR REST09B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST09A:
	LDX #SCROFFSET+$03C1 ; X pointe le plafond en G9.
REST09A1:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LBSR DISPLAY_A_32 ; 41 lignes à réinitialiser
	LBRA DISPLAY_A_9

; Coffres et les petits ennemis au sol (araignées, blobs)
REST09B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$0A29 ; X pointe le sol en G9.
	LBRA DISPLAY_A_15 ; 15 lignes à réinitialiser

; --- SECTEUR G12 ----
; Grands ennemis (spectres, cerbères, troopers)
REST12:
	BSR REST12B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST12A:
	LDX #SCROFFSET+$03C9 ; X pointe le plafond en G12, colonne 1.
	BSR REST10A1
	LDX #SCROFFSET+$03CB ; X pointe le plafond en G12, colonne 3
	BRA REST09A1

; Coffres et les petits ennemis au sol (araignées, blobs)
REST12B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$0A31 ; X pointe le sol en G12, colonne 1.
	LBSR DISPLAY_2A_15 ; 15 lignes à réinitialiser
	LDX #SCROFFSET+$0A33 ; X pointe le sol en G12, colonne 3
	LBRA DISPLAY_A_15 ; 15 lignes à réinitialiser

; --- SECTEUR G14 ----
; Grands ennemis (spectres, cerbères, troopers)
REST14:
	BSR REST14B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST14A:
	LDX #SCROFFSET+$03D0 ; X pointe le plafond en G14.
	BRA REST10A1

; Coffres et les petits ennemis au sol (araignées, blobs)
REST14B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$0A38 ; X pointe le sol en G14.
	LBRA DISPLAY_2A_15 ; 15 lignes à réinitialiser

; --- SECTEUR G10 ----
 ; Grands ennemis (spectres, cerbères, troopers)
REST10:
	BSR REST10B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST10A:
	LDX #SCROFFSET+$03C2 ; X pointe le plafond en G10.
REST10A1:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LBSR DISPLAY_2A_32 ; 41 lignes à réinitialiser
	LBRA DISPLAY_2A_9

; Coffres et les petits ennemis au sol (araignées, blobs)
REST10B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$0A2A ; X pointe le sol en G10.
	LBRA DISPLAY_2A_15 ; 15 lignes à réinitialiser

; --- SECTEUR G19 ----
; Grands ennemis (spectres, cerbères, troopers)
REST19:
	BSR REST19B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST19A:
	LDX #SCROFFSET+$0465 ; X pointe le plafond en G19.
	BRA REST18A2

; Coffres et les petits ennemis au sol (araignées, blobs)
REST19B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$08ED ; X pointe le sol en G19.
	LBRA DISPLAY_A_7 ; 7 lignes à réinitialiser

; --- SECTEUR G18 ----
; Grands ennemis (spectres, cerbères, troopers)
REST18:
	BSR REST18B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST18A:
	LDX #SCROFFSET+$0464 ; X pointe le plafond en G18.
REST18A2:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LBSR DISPLAY_A_16 ; 29 lignes à réinitialiser
	LBRA DISPLAY_A_13

; Coffres et les petits ennemis au sol (araignées, blobs)
REST18B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$08EC ; X pointe le sol en G18.
	LBRA DISPLAY_A_7 ; 7 lignes à réinitialiser

; --- SECTEUR G23 ----
; Grands ennemis (spectres, cerbères, troopers)
REST23:
	BSR REST23B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST23A:
	LDX #SCROFFSET+$046E ; X pointe le plafond en G23.
	BRA REST18A2

; Coffres et les petits ennemis au sol (araignées, blobs)
REST23B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$08F6 ; X pointe le sol en G23.
	LBRA DISPLAY_A_7 ; 7 lignes à réinitialiser

; --- SECTEUR G24 ----
; Grands ennemis (spectres, cerbères, troopers)
REST24:
	BSR REST24B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST24A:
	LDX #SCROFFSET+$046F ; X pointe le plafond en G24.
	BRA REST18A2

; Coffres et les petits ennemis au sol (araignées, blobs)
REST24B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$08F7 ; X pointe le sol en G24.
	LBRA DISPLAY_A_7 ; 7 lignes à réinitialiser

; --- SECTEUR G21 ----
; Grands ennemis (spectres, cerbères, troopers)
REST21:
	BSR REST21B

; Ennemis intermédiaires flottants (fantomes, Méduse)
REST21A:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$0469 ; X pointe le plafond en G21.
	LBSR DISPLAY_2A_16 ; 29 lignes à réinitialiser
	LBRA DISPLAY_2A_13

; Coffres et les petits ennemis au sol (araignées, blobs)
REST21B:
	LDA >MAPCOULC	; A = couleurs de map courantes.
	LDX #SCROFFSET+$08F1 ; X pointe le sol en G21, colonne 1
	LBSR DISPLAY_2A_7 ; 7 lignes à réinitialiser
	LDX #SCROFFSET+$08F3 ; X pointe le sol en G21, colonne 3
	LBRA DISPLAY_A_7 ; 7 lignes à réinitialiser

;******************************************************************************
;******************************************************************************
;*                        ROUTINES DE GESTION DU JEU                          *
;******************************************************************************
;******************************************************************************

;------------------------------------------------------------------------------
; Lecture du clavier
;------------------------------------------------------------------------------
; Attention, le nombre de cycles est différent selon le modèle,
; ce qui a un impact sur le jeu :
; MO5  : 8373 cycles
; MO6  : 9381 cycles
; TO7/70 : 5441 cycles
; TO9  : 91 cycles
; TO8  : 228 cycles
; TO8D : 220 cycles
; TO9+ : 215 cycles
; Pour le TO7/70, il faut ajouter une TEMPO de 2931 cycles ($01A1)
; Pour les autres TO, il faut ajouter une TEMPO de 8139 cycles ($0489)
CLAVIER:
	LDD #$0489	; 8139 cycles
	BSR TEMPO1
	JSR $E806
	RTS

;------------------------------------------------------------------------------
; Attente de touche
;------------------------------------------------------------------------------
TOUCHE:
	JSR $E806
	TSTB
	BEQ TOUCHE 		; Attente de touche.
	RTS

;------------------------------------------------------------------------------
; Temporisation paramétrable
; B = tempo en 50èmes de seconde
;------------------------------------------------------------------------------
TEMPO:
	TFR B,A
	LSLA
	LDB #$FF
TEMPO1:
	SUBD #1
	BNE TEMPO1
	RTS

;------------------------------------------------------------------------------
; Sous-routines d'affichage de la fenêtre de jeu.
;------------------------------------------------------------------------------
; Remplit la fenêtre de donjon en encre noir sur fond noir.
FEN_NOIR:
	LDA #c00		; Couleurs = Encre noire (0) sur fond noir (0)
	BRA FEN_COUL2

; Remplit la fenêtre de donjon avec les couleurs sol/mur courantes.
FEN_COUL:
	LDA >MAPCOULC	; Couleurs sol/mur courantes.

FEN_COUL2:
	LBSR VIDEOC_B	; Sélection video couleur
	LBSR G2_R1_131x20 ; Remplissage de la fenetre de jeu.
	LDB #40			; Pour les sauts de ligne.
	INC	$E7C3		; Sélection vidéo forme.
	RTS

; Efface les données de forme de la fenêtre de donjon.
FEN_EFFACE:			; Efface les données de forme de la fenêtre de donjon.
	CLRA			; Pas de forme = couleur de fond.

FEN_EFFACE2:
	LDB	$E7C3		; Sélection video forme.
	ORB #%00000001
	STB	$E7C3

	LBSR G2_R1_131x20 ; Remplissage de la fenetre de jeu.
	LDB #40			; Pour les sauts de ligne.
	RTS

; Affichage de la carte.
FEN_MAP:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDB #24			; Pour les sauts de ligne.
	LDX #SCROFFSET+$2A ; X pointe la carte.
	LDA #c11		; 1ère ligne rouge sur fond rouge.
	LBSR G2_R1_16
	LDA #c7F		; 128 lignes blanche sur fond orange.
	LBSR G2_R1_128x16
	LDA #c11		; Dernière ligne rouge sur fond rouge.
	LBSR G2_R1_16
	LDB #40			; Pour les sauts de ligne.
	LDY #FEN_MAP_DATA ; Y pointe les données des rouleaux.
	LDX #SCROFFSET+1 ; Dessin du premier rouleau.
	BSR FEN_MAP_R2
	LDX #SCROFFSET+$12 ; Dessin du deuxième rouleau

; Sous-routine pour les colonnes de la map.
FEN_MAP_R1:
	LBSR VIDEOC_A	; Sélection video couleur.

; Mise en place des couleurs.
FEN_MAP_R2:
	BSR FEN_MAP_R3
	INC	$E7C3		; Sélection vidéo forme.

; Mise en place des formes.
FEN_MAP_R3:
	LDA ,Y+			; 1
	STA ,X
	ABX
	LDA ,Y+			; 2
	STA ,X
	ABX
	LDA ,Y+
	LBSR DISPLAY_A_128 ; 3 à 130
	LDA ,Y+			; 131
	STA ,X
	LEAX -120,X
	LDA ,Y+			; 128
	STA ,X
	LEAX -5080,X
	RTS

; Données d'affichage de la map.
FEN_MAP_DATA:
	FCB c10,c1F,c1F,c10,c1F
	FCB $78,$87,$84,$7F,$FC
FEN_MAP_DATA_F2:
	FCB c10,c1F,c1F,c10,c1F
	FCB $1E,$E1,$21,$FE,$3F

;------------------------------------------------------------------------------
; Sous-routine d'affichage de la minimap.
;------------------------------------------------------------------------------
; Calcul d'adresse de la minimap.
DMINIMAP:
	LDD >SQRADDR	; D = adresse de la case courante dans la map.
	CMPD #$6180		; Adresse < $6180?
	BCC DMINIMAP1	; Non => DMINIMAP1

	ANDB #%00011111	; Oui => adresse fixée de &6160 à $617F.
	ORB  #%01100000

DMINIMAP1:
	CMPD #$6480		; Adresse < $6480?
	BCS DMINIMAP2	; Oui => DMINIMAP2

	ANDB #%00011111	; Non => adresse fixée de &6480 à $649F.
	ORB  #%10000000

DMINIMAP2:
	SUBD #$0060		; Adresse minimap = adresse - 3 lignes de 32 cases.
	STD >MINIMAP	; Adresse minimap sauvegardée.

	ANDB #%00011111	; B = coordonnée X de la case courante.
	CMPB #4			; Coordonnée X < 4?
	BCC DMINIMAP3	; Non => DMINIMAP3

	LDB #3			; Oui, coordonnée X fixée à 3.
	BRA DMINIMAP4	; => DMINIMAP4

DMINIMAP3:
	CMPB #27		; Coordonnée X < 27?
	BCS DMINIMAP4	; Oui => DMINIMAP4

	LDB #27			; Non, coordonnée X fixée à 27.

DMINIMAP4:
	SUBB #3			; Coordonnée X minimap = coordonnée X - 3.
	LDA >MINIMAP+1	; A = poids faible de l'adresse de la minimap.
	ANDA #%11100000	; A <= A - coordonnée X.
	PSHS B
	ORA ,S+			; A <= A + coordonnée X de la minimap.
	STA >MINIMAP+1	; Adresse de la minimap sauvegardée.

	LDU >MINIMAP	; U pointe l'adresse de la minimap.
	LDX #SCRMINIMAP ; X pointe le haut à gauche de la minimap à l'écran.
	LDA #7			; 7 lignes à afficher.

; Affichage des cases de la minimap.
DMINIMAP5:
	LDB #4			; 4 duos de cases par ligne de map.
	BSR DMAP_1		; Affichage d'une ligne de map.
	LEAX 156,X		; X pointe la ligne suivante à l'écran.
	LEAU 24,U		; U pointe la case de la ligne suivante.
	DECA			; Nombre de lignes à afficher - 1.
	BNE DMINIMAP5	; Reboucle tant que la map n'est pas complètement analysée.

; Affichage de la flèche.
	LBSR DMAP_R2	; Préparation de l'affichage de la flèche.
	LDY #VARDW2		; Y pointe le bloc VARDW2-VARDW3 avec la flèche.
	LDB #40			; Pour les sauts de ligne.
	LBRA DISPLAY_YX_4 ; Dessin du bloc avec la flèche et fin.

;------------------------------------------------------------------------------
; Sous-routine d'affichage de la map du niveau courant.
;------------------------------------------------------------------------------
DMAP:
	LBSR FEN_NOIR	; Remplissage de la fenêtre en noir.

	LDU #MAPADDR	; U pointe l'adresse de la map.
	LDX #SCROFFSET+$0052 ; X pointe le haut à gauche de la carte à l'écran.
	LDA #32			; 32 lignes à afficher.

; Affichage des cases de la map.
DMAP_0:
	LDB #16			; 16 duos de cases par ligne de map.
	BSR DMAP_1		; Affichage d'une ligne de map.
	LEAX 144,X		; X pointe la ligne suivante à l'écran.
	DECA			; Nombre de lignes à afficher - 1.
	BNE DMAP_0		; Reboucle tant que la map n'est pas complètement analysée.

	LBRA DMAP_3		; Affichage de la carte et clignotement de la flèche.

; Affichage d'une ligne de B duos de cases.
DMAP_1:
	PSHS A			; Sauvegarde du bombre de lignes à afficher.
DMAP_2:
	PSHS B			; Sauvegarde du nombre de boucle en cours.

	LDB #40			; Pour les sauts de ligne dans les tuiles.
	CLRA			; A = 0 indique la case de gauche.
	BSR DMAP_R1		; Analyse de la case de gauche.
	LDA ,Y+			; Affichage de la case de gauche.
	ANDA #%11110000
	STA ,X
	ABX
	LDA ,Y+
	ANDA #%11110000
	STA ,X
	ABX
	LDA ,Y+
	ANDA #%11110000
	STA ,X
	ABX
	LDA ,Y+
	ANDA #%11110000
	STA ,X
	LEAX -120,X

	LDA #1			; A = 1 indique la case de droite.
	BSR DMAP_R1		; Analyse puis affichage de la case de droite.
	LDA ,Y+			; Affichage de la case de droite.
	ANDA #%00001111
	ORA ,X
	STA ,X
	ABX
	LDA ,Y+
	ANDA #%00001111
	ORA ,X
	STA ,X
	ABX
	LDA ,Y+
	ANDA #%00001111
	ORA ,X
	STA ,X
	ABX
	LDA ,Y+
	ANDA #%00001111
	ORA ,X
	STA ,X
	LEAX -119,X

	PULS B
	DECB
	BNE DMAP_2		; Reboucle tant que la ligne n'est pas terminée

	PULS A			; Restauration du nombre de lignes à afficher.
	RTS

; Analyse de la case courante et positionnement de Y sur la tuile correspondante.
DMAP_R1A:
	STA >VARDB2		; Sauvegarde de l'indicateur de case gauche/droite.
	STX >VARDW1		; Mémorisation de la coordonnée écran X de la case.
	BRA DMAP_R1_0

DMAP_R1:
	CMPU >SQRADDR	; U pointe-t-il la case courante du perso dans la map?
	BEQ DMAP_R1A	; Oui => DMAP_R1A

DMAP_R1_0:
	PULU A			; A = code de la case courante, puis U pointe la case suivante.

	ASLA			; Carry = bit 7 (indicateur de case découverte).
	BCS DMAP_R1_1 	; bit 7 = 1 = case découverte => DMAP_R1_1.

	LDY #DMAP_D1 	; Y pointe la tuile de case non découverte.
	RTS				; Case non découverte => RTS.

DMAP_R1_1:
	LSRA			; Bit 7 à 0.

	CMPA #%01111000 ; Mur simple?
	BEQ DMAP_R1_111W ; Oui => DMAP_R1_111W
	BCC DMAP_R1_111O ; Non, ornement ou mur déplaçable => DMAP_R1_111O

	STA >VARDB1		; Sauvegarde du code de case.

	ANDA #%01110000	; A = type de case.
	CMPA #%00100000	; Echelles?
	BCS DMAP_R1_000 ; Non, sol %000 ou %001 => DMAP_R1_000
	BEQ DMAP_R1_010	; Oui => DMAP_R1_010

	CMPA #%01000000	; Sol simple %100?
	BEQ DMAP_R1_000	; Oui => DMAP_R1_000
	BCS DMAP_R1_011	; Non, téléporteur %011 => DMAP_R1_011

	CMPA #%01100000	; Trou dans le plafond %110?
	BEQ DMAP_R1_000 ; Oui = sol sur la carte => DMAP_R1_000
	BCS DMAP_R1_101 ; Non, trou dans le sol %101 => DMAP_R1_101.

; Murs ou obstacles
DMAP_R1_111:
	LDA >VARDB1		; A = code de la case.
	ANDA #%00001111	; A = contenu de la case.
	CMPA #%00000100 ; Porte ouverte?
	BCC DMAP_R1_000 ; Oui = sol => DMAP_R1_000

	LDA ,U			; A = case suivante.
	ANDA #%01111111	; A = type de case.
	CMPA #%01111000 ; Mur simple?
	BEQ DMAP_R1_111H ; Oui => DMAP_R1_111H

	LDY #DMAP_D8	; Y pointe la tuile de porte fermée verticale.
	RTS

DMAP_R1_111H:
	LDY #DMAP_D7	; Y pointe la tuile de porte fermée horizontale.
	RTS

DMAP_R1_111O:
	CMPA #%01111011 ; Mur déplaçable?
	BCS DMAP_R1_000 ; Non, ornement = sol sur la map => DMAP_R1_000

DMAP_R1_111W:
	LDY #DMAP_D2 	; Y pointe la tuile de mur.
	RTS

; Sol %000, %001, %100, trou dans le plafond, porte ouverte, ornement.
DMAP_R1_000:
	LDY #DMAP_D3 	; Y pointe la tuile de sol.
	RTS				; Sinon case non découverte => RTS

; Echelles
DMAP_R1_010:
	LDA >VARDB1		; A = code de la case.
	ANDA #%00001111	; A = contenu de la case.
	BNE DMAP_R1_010M ; Echelle montante => DMAP_R1_010M

	LDY #DMAP_D4	; Y pointe la tuile d'échelle descendante.
	RTS

; Echelle montante
DMAP_R1_010M:
	LDY #DMAP_D5	; Y pointe la tuile d'échelle montante.
	RTS

; Téléporteurs
DMAP_R1_011:
	LDA >VARDB1		; A = code de la case.
	ANDA #%00001111	; A = contenu de la case.
	CMPA #%00001000	; Destination de téléporteur?
	BCC DMAP_R1_000	; Oui = sol => DMAP_R1_000

	LDY #DMAP_D9	; Y pointe la tuile de téléporteur.
	RTS

; Trou dans le sol %101
DMAP_R1_101:
	LDY #DMAP_D6	; Y pointe la tuile de trou dans le sol.
DMAP_R1_RTS:
	RTS

; Affichage de la carte et clignotement de la flèche.
DMAP_3:
	LBSR FEN_MAP	; Affichage du parchemin de la carte.
	LBSR DMAP_TXT	; Affichage des textes le long de la carte.
	BSR DMAP_R2		; Préparation de l'affichage de la flèche.

; Clignottement de la flèche
DMAP_4:
	LDY #VARDW2		; Y pointe le bloc VARDW2-VARDW3 avec la flèche.
	BSR DMAP_R0		; Affichage et tempo.

	LDA >VARDB1		; Touche appuyée?
	BNE DMAP_R1_RTS	; Oui = fin => RTS.

	LDY #VARDW4		; Y pointe le bloc VARDW4-VARDW5 sans la flèche.
	BSR DMAP_R0		; Affichage et tempo.

	LDA >VARDB1		; Touche appuyée?
	BEQ DMAP_4		; Non = rebouclage => DMAP_4.
	BRA DMAP_R1_RTS	; Oui = fin => RTS.

; Affichage et tempo
DMAP_R0:
	LDB #40			; Pour les sauts de ligne.
	LBSR DISPLAY_YX_4 ; Dessin du bloc avec ou sans flèche.
	LEAX -160,X		; X pointe de nouveau le bloc à l'écran.
	LDA #40			; Tempo d'affichage.
	STA >VARDB2

DMAP_R0_1:
	JSR $E806		; Lecture clavier
	TSTB          
	BNE DMAP_R0_2	; Touche active => DMAP_R0_2
	DEC >VARDB2
	BNE DMAP_R0_1	; Rebouclage tant que la tempo n'est pas terminée.
	RTS

DMAP_R0_2:
	COM >VARDB1		; VARDB1 complémenté pour indiquer l'appui d'une touche.
	RTS

; Préparation de l'affichage de la flèche.
DMAP_R2:
	LDU #DMAP_ARROW	; U pointe les tuiles de flèche.
	LDA >ORIENT		; A = orientation
	LSRA
	LSRA			; A = A/4
	LEAU A,U		; U pointe la tuile de flèche dans l'orientation actuelle.

	LDX >VARDW1		; X pointe la coordonnée écran de la case courante.
	LDY #VARDW2		; Y pointe VARDW2 pour une sauvegarde du bloc 1x4 octets.
	LDB #4			; 4 octets à recopier et à modifier.

; Préparation du clignotement de la flèche avec le fond de la map.
DMAP_R2A:
	LDA >VARDB2		; A = indicateur de case gauche/droite pour la flèche.
	BNE DMAP_R2B	; Flèche en case de droite => DMAP_R2B. Sinon case de gauche.

	LDA ,X			; Préparation de la flèche en case de gauche.
	STA 4,Y
	ANDA #%00001111
	STA ,Y
	LDA ,U+
	ANDA #%11110000
	BRA DMAP_R2C

DMAP_R2B:
	LDA ,X			; Préparation de la flèche en case de droite.
	STA 4,Y
	ANDA #%11110000
	STA ,Y
	LDA ,U+
	ANDA #%00001111

DMAP_R2C:
	ORA ,Y
	STA ,Y+
	LEAX 40,X
	DECB
	BNE DMAP_R2A

	LEAX -160,X		; X pointe de nouveau le bloc à l'écran.
	CLR >VARDB1
	RTS

; Affichage des textes le long de la carte
DMAP_TXT:
	LDA >PACKNUM	; A = n° de pack de map.
	CMPA #2
	BCS DMAP_TXT1	; Pack 1 ou 2 => DMAP_TXT1.

	LDX #SCROFFSET+$0438
	LDU #DMAP_M3	; Pack 3 = Affichage de "PORTAIL"
	LDB #7
	BRA DMAP_TXT_R1_1

DMAP_TXT1:
	LDX #CHARS_COUL2
	STX >CHARS_COUL	; Sélection du dégradé de bleu.
	LDX #CHARS_T1
	STX >CHARS_TAB	; Table 1 par défaut.

	LDX #SCROFFSET+$0438
	LDU #DMAP_M0
	BSR DMAP_TXT_R1	; Affichage du mot "TOUR "

	LDA >PACKNUM	; A = n° de pack de map = tour courante.
	LDB #5
	MUL
	LEAU D,U		; U pointe l'orientation de la tour courante.
	BSR DMAP_TXT_R1	; Affichage de l'orientation de la tour.

	LDX #SCROFFSET+$044B
	LDU #DMAP_M5
	LDB #7
	BSR DMAP_TXT_R1_1 ; Affichage du mot "NIVEAU "

	LDY #CHARS_T2
	STY >CHARS_TAB	; Sélection de la table 2.
	LDA >MAPNUM		; A = n° de map courant = niveau - 1.
	INCA
	LBRA PRINTC_0	; Affichage du n° de niveau.

; Affichage d'un mot vertical de B caractères pointé par U.
DMAP_TXT_R1:
	LDB #5
DMAP_TXT_R1_1:
	PSHS B
	LDA ,U+
	LBSR PRINTC_0
	LEAX 279,X
	PULS B
	DECB
	BNE DMAP_TXT_R1_1
	RTS

; Données de la flèche de position dans la map.
DMAP_ARROW:
	FCB $99,$00,$99,$99	; Flèche Nord, case gauche.
	FCB $DD,$00,$00,$DD	; Flèche Est, case gauche.
	FCB $99,$99,$00,$99	; Flèche Sud, case gauche.
	FCB $BB,$00,$00,$BB	; Flèche Ouest, case gauche.

; Données des tuiles de cases.
DMAP_D1 FCB $00,$00,$00,$00	; Case non découverte.
DMAP_D2	FCB $AA,$55,$AA,$55	; Mur.
DMAP_D3	FCB $FF,$FF,$FF,$FF	; Sol.
DMAP_D4	FCB $FF,$66,$00,$66	; Echelle descendante.
DMAP_D5	FCB $66,$00,$66,$FF	; Echelle montante.
DMAP_D6	FCB $FF,$99,$99,$FF	; Trous dans le sol.
DMAP_D7	FCB $FF,$00,$00,$FF	; Porte fermée horizontale.
DMAP_D8	FCB $99,$99,$99,$99	; Porte fermée verticale.
DMAP_D9	FCB $99,$66,$66,$99	; Téléporteur.

; Messages à afficher dans la map
DMAP_M0	FCB 19,14,20,17,26			; "TOUR "
DMAP_M1	FCB 14,20,04,18,19			; "OUEST"
DMAP_M2	FCB 04,18,19,26,26			; "EST  "
DMAP_M3	FCB 15,14,17,19,00,08,11	; "PORTAIL"
DMAP_M5	FCB 13,08,21,04,00,20,26	; "NIVEAU "

;------------------------------------------------------------------------------
; AFF_SCORE : affichage des scores à la fin de chaque tour.
;
; Les types de scores sont les suivants:
; 1 - Ennemis.
; 2 - Secrets.
; 3 - Items.
; 4 - Ornements.
;------------------------------------------------------------------------------
AFF_SCORE:
	LBSR FEN_NOIR	; Remplissage de la fenêtre en noir.
	LDX #SCROFFSET+$02A9 ; X pointe les messages de score à l'écran.
	LDU #AFF_SCOREM	; U pointe les messages de score.
	LBSR PRINTM_R1	; Affichage des messages sans ornements.

	LDX #SCROFFSET+$071A ; X pointe les scores des ennemis à l'écran.
	LDA >SCORE_E2	; A = nombre d'ennemis à tuer
	LDB >SCORE_E1	; B = nombre d'ennemis tués
	BSR AFF_SCORE_R1 ; Affichage du score

	LDX #SCROFFSET+$0A62 ; X pointe les scores des secrets à l'écran.
	LDA >SCORE_S2	; A = nombre de secrets à trouver
	LDB >SCORE_S1	; B = nombre de secrets trouvés
	BSR AFF_SCORE_R1 ; Affichage du score

	LDX #SCROFFSET+$0DAA ; X pointe les scores des items à l'écran.
	LDA >SCORE_I2	; A = nombre d'items à trouver
	LDB >SCORE_I1	; B = nombre d'items trouvés
	BSR AFF_SCORE_R1 ; Affichage du score

	LDX #SCROFFSET+$10F2 ; X pointe les scores des ornements à l'écran.
	LDA >SCORE_O2	; A = nombre d'ornements à détruire
	LDB >SCORE_O1	; B = nombre d'ornemnts détruits + affichage du score

; Affichage des scores = B & '/' & A en partant de la fin
AFF_SCORE_R1:
	PSHS B			; Sauvegarde du score effectué.

	BSR AFF_SCORE_R2 ; Affichage du score à effectuer.
	LDA #12			; A = caractère '/' (CHARS_TAB pointe déjà CHARS_T2).
	LBSR PRINTC_0	; Affichage du slash.
	LEAX -2,X		; X pointe le score effectué à l'écran.

	PULS A			; A = score effectué + affichage

; Affichage des nombes. A = nombre à afficher (0-255)
AFF_SCORE_R2:
	CMPA #10		; A inférieur à 10?
	BCC AFF_SCORE_R2_10 ; Non => AFF_SCORE_R2_10

	LBSR PRINTN1	; Affichage de A sur un chiffre
	LEAX -2,X		; X pointe l'octet avant.
	RTS

AFF_SCORE_R2_10:
	CMPA #100		; A inférieur à 100?
	BCC AFF_SCORE_R2_100 ; Non => AFF_SCORE_R2_100

	LEAX -1,X		; X pointe le nombre à deux chiffres à l'écran.
	LBSR PRINTN2	; Affichage du nombre.
	LEAX -3,X		; X pointe l'octet avant.
	RTS

AFF_SCORE_R2_100:
	LEAX -2,X		; X pointe le nombre à trois chiffres à l'écran.
	CMPA #200		; A inférieur à 200?
	BCC AFF_SCORE_R2_200 ; Non => AFF_SCORE_R2_200

	SUBA #100		; A = dizaines et unités.
	STA >VARDB1
	LDA #1			; Centaines = 1
	BRA AFF_SCORE_R2_200A

AFF_SCORE_R2_200:
	SUBA #200		; A = dizaines et unités.
	STA >VARDB1
	LDA #2			; Centaines = 2

AFF_SCORE_R2_200A:
	LBSR PRINTN1	; Affichage des centaines
	LDA >VARDB1
	LBSR PRINTN2	; Affichage des dizaines et des unités
	LEAX -4,X		; X pointe l'octet avant.
	RTS

; Messages de score
AFF_SCOREM:
	FDB $D382,$4904,$9A0A,$D026,$9910,$6CFE,$7FFC	; OBJECTIF ATTEINT!
	FDB $D6BC
	FDB $D6BC
	FDB $D6BC
	FDB $235A,$2310,$96BC	; ENNEMIS
	FDB $D6BC
	FDB $D6BC
	FDB $9104,$8926,$96BC	; SECRETS
	FDB $D6BC
	FDB $D6BC
	FDB $44C8,$64BC			; ITEMS
	FDB $D6BC
	FDB $D6BC
	FDB $745A,$2308,$6CE5	; ORNEMENTS

;------------------------------------------------------------------------------
; AFF_INVK : affichage des clés dans l'inventaire.
;
; Les clés acquises sont affichées et les clés non acquises sont "éteintes".
;
; Liste des clés :
; 1 - Clé jaune.
; 2 - Clé bleue.
; 3 - Clé rouge.
;------------------------------------------------------------------------------
AFF_INVK:
	LDX #$43B7	; X pointe la clé jaune dans l'inventaire.
	LDB >INVK1	; B = acquisition de la clé jaune.
	LDA #c03	; A = noir sur fond jaune.
	BSR AFF_INVK_R1 ; Extinction ou affichage de la clé jaune.

	LDX #$43BA	; X pointe la clé bleue dans l'inventaire.
	LDB >INVK2	; B = acquisition de la clé bleue.
	LDA #c0C	; A = noir sur fond bleu.
	BSR AFF_INVK_R1 ; Extinction ou affichage de la clé bleue.

	LDX #$43BD	; X pointe la clé rouge dans l'inventaire.
	LDB >INVK3	; B = acquisition de la clé rouge.
	LDA #c01	; A = noir sur fond rouge + affichage de la clé rouge.

; Affichage ou extinction des icônes monochromes.
AFF_INVK_R1:
	LSRB			; Clé acquise?
	BCS AFF_INVK_R2 ; Oui = affichage => AFF_INVK_R2.

	LDA #c00		; Sinon extinction. A = noir sur fond noir.

AFF_INVK_R2:
	LBSR VIDEOC_B	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	LBSR DISPLAY_2A_13 ; Extinction ou colorisation de l'icône.
	INC $E7C3		; Sélection vidéo forme.
	RTS

;------------------------------------------------------------------------------
; AFF_INVS : affichage du sort courant dans le livre de sort.
;
; Note : les données sont déclarées dans l'interface, adresse $1B32 de l'écran
; de forme.
;
; Liste des sorts :
; 0 - Régénération (sort par défaut).
; 1 - Boule de feu.
; 2 - Boule de givre.
; 3 - Antimatière.
;------------------------------------------------------------------------------
; Routine commune avec PRINTO.
AFF_INVS:
	LDY #AFF_INVS_DATA ; Y pointe les données des sorts à afficher
	LDA >INVS_COUR	; A = numéro du sort courant.
	ASLA			; 2A
	ASLA			; 4A
	ASLA			; 8A
	LEAY A,Y		; Y pointe les données du sort courant.

	LBSR VIDEOC_A	; Sélection vidéo couleur
	LDB #37			; Pour les sauts de ligne.
	LDX #$4FC3		; 4ème ligne du livre.
	LDA ,Y+
	LBSR G2_R1_4x4
	LDX #$521B		; 7ème ligne du livre.
	LDA ,Y+
	LBSR G2_R1_4x4
	LDX #$52E3		; 8ème ligne du livre.
	LDA ,Y+
	LBSR G2_R1_4x4
	LDX #$53AB		; 9ème ligne du livre.
	LDA ,Y+
	LBSR G2_R1_4x4

	LDX #$4F20		; X pointe l'icone
	LDA ,Y+			; A = couleurs de l'icone.
	LDB #40			; Pour les sauts de ligne.
	LBSR DISPLAY_2A_13 ; 2x13 octets de couleur.

	INC	$E7C3		; Sélection vidéo forme.
	LEAX 200,X		; X pointe la barre graph
	LDA ,Y+			; Affichage de la barre.
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X

AFF_INVS1:
	LDX ,Y			; X pointe les données de l'icone à recopier.
AFF_INVS2:
	LDY #LISTE1		; Y pointe la liste 1 comme buffer de sauvegarde.
	LBSR BSAVE2_13	; Sauvegarde des données de forme.
	LDY #LISTE1		; Y pointe de nouveau la liste 1.
	LDX #$4F20		; X pointe l'icone.
	LBRA DISPLAY_2YX_13 ; Affichage des formes et fin.

; Régénération (sort par défaut).
AFF_INVS_DATA:
	FCB cF7,cF7,cF7,cF7	; Lignes 4,7,8 et 9 pleines.
	FCB c71				; Sort blanc sur fond rouge.
	FCB $F0				; Barre graph 25%.
	FDB $4D17			; Localisation des données de forme.

; Boule de feu.
	FCB c77,c77,cF7,cF7	; Lignes 4 et 7 vides. Lignes 8 et 9 pleines.
	FCB c7F				; Sort blanc sur fond orange.
	FCB $F0				; Barre graph 25%.
	FDB $4D19			; Localisation des données de forme.

; Boule de givre.
	FCB cF7,c77,c77,c77	; Ligne 4 pleine. Lignes 7,8 et 9 vides.
	FCB c7C				; Sort blanc sur fond bleu.
	FCB $FC				; Barre graph 37.5%.
	FDB $528F			; Localisation des données de forme.

; Antimatière.
	FCB c77,cF7,cF7,c77	; Lignes 4 et 9 vides. Lignes 7 et 8 pleines.
	FCB c70				; Sort blanc sur fond noir.
	FCB $FF				; Barre graph 50%.
	FDB $5291			; Localisation des données de forme.

;------------------------------------------------------------------------------
; AFF_BAR : affichage des barres de vie, de bouclier et de mana.
;
; Toutes les barres ont des valeurs comprises en 0 et 40, soient l'équivalent
; des pixels affichables en ligne.
;------------------------------------------------------------------------------
AFF_BAR:
	LBSR VIDEOF	; Sélection vidéo forme par sécurité

	LDX #$5DE3	; X pointe la barre de PV
	LDA >VARPL_PV ; A = nombre de PV du joueur
	BSR AFF_BAR_R1 ; Mise à jour de la barre de vie.

	LDX #$5DEA	; X pointe la barre de bouclier
	LDA >VARPL_BOUC ; A = quantité de bouclier du joueur
	BSR AFF_BAR_R1 ; Mise à jour de la barre de bouclier.

	LDX #$5DF1	; X pointe la barre de mana
	LDA >VARPL_MANA ; A = quantité de mana du joueur + mise à jour.

; Affichage d'une barre. X pointe l'écran. A = niveau.
AFF_BAR_R1:
	LDB #$FF		; Pour les barres pleines.
	CMPA #40		; A = 40?
	BEQ AFF_BAR_R2_5 ; Oui => AFF_BAR_R2_5

	CMPA #32		; 40 > A >= 32?
	BCC AFF_BAR_R1_32 ; Oui => AFF_BAR_R1_32

	CMPA #24		; 32 > A >= 24?
	BCC AFF_BAR_R1_24 ; Oui => AFF_BAR_R1_24

	CMPA #16		; 24 > A >= 16?
	BCC AFF_BAR_R1_16 ; Oui => AFF_BAR_R1_16

	CMPA #8			; 16 > A >= 8?
	BCC AFF_BAR_R1_8 ; Oui => AFF_BAR_R1_8. Sinon A < 8

	BSR AFF_BAR_R2_0 ; + dessin de la case en fonction de A
	CLRB
	BRA AFF_BAR_R2_4 ; + dessin de 4 cases vides.

AFF_BAR_R1_32:
	SUBA #32		; A - 32
	BSR AFF_BAR_R2_4 ; Dessin de 4 cases pleines
	BRA AFF_BAR_R2_0 ; + dessin de la case en fonction de A

AFF_BAR_R1_24:
	SUBA #24		; A - 24
	BSR AFF_BAR_R2_3 ; Dessin de 3 cases pleines
	BSR AFF_BAR_R2_0 ; + dessin de la case en fonction de A
	CLRB
	BRA AFF_BAR_R2_1 ; + dessin d'une case vide.

AFF_BAR_R1_16:
	SUBA #16		; A - 16
	BSR AFF_BAR_R2_2 ; Dessin de 2 cases pleines
	BSR AFF_BAR_R2_0 ; + dessin de la case en fonction de A
	CLRB
	BRA AFF_BAR_R2_2 ; + dessin de 2 cases vides.

AFF_BAR_R1_8:
	SUBA #8			; A - 8
	BSR AFF_BAR_R2_1 ; Dessin d'une case pleine
	BSR AFF_BAR_R2_0 ; + dessin de la case en fonction de A
	CLRB
	BRA AFF_BAR_R2_3 ; + dessin de 3 cases vides.

AFF_BAR_R2_0:
	LDY #AFF_BARRE_DATA
	LDB A,Y
	BRA AFF_BAR_R2_1

AFF_BAR_R2_5:
	BSR AFF_BAR_R2_1
AFF_BAR_R2_4:
	BSR AFF_BAR_R2_1
AFF_BAR_R2_3:
	BSR AFF_BAR_R2_1
AFF_BAR_R2_2:
	BSR AFF_BAR_R2_1
AFF_BAR_R2_1:
	STB ,X
	LEAX 40,X
	STB ,X
	LEAX 40,X
	STB ,X
	LEAX 40,X
	STB ,X
	LEAX -119,X
	RTS

AFF_BARRE_DATA:
	FCB $00		; 0
	FCB $80		; 1
	FCB $C0		; 2
	FCB $E0		; 3
	FCB $F0		; 4
	FCB $F8		; 5
	FCB $FC		; 6
	FCB $FE		; 7

;------------------------------------------------------------------------------
; AFF_INVW : affichage de l'arme courante avec ses munitions dans l'inventaire.
;
; Liste des armes :
; 0 - Epée (tour 1) ou tronçonneuse (tour 2).
; 1 - Arbalette légère à un carreau.
; 2 - Arbalette lourde à trois carreau.
; 3 - Revolver.
; 4 - Pistolet mitrailleur.
; 5 - Pistolet plasma.
; 6 - Fusil d'assaut plasma.
;
; Liste des munitions :
; 1 - Carreaux d'arbalète.
; 2 - Cartouches 9mm.
; 3 - Cartouches plasma.
;------------------------------------------------------------------------------
AFF_INVW:
	LDA >INVW_COUR	; A = numéro d'arme courante.
	BNE AFF_INVW_1	; A <> Epée => AFF_INVW_1

; Affichage de l'arme 0 (épée, tronçonneuse ou creuset).
AFF_INVW_0:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDX #$5BD3		; X pointe l'emplacement des munitions.
	LDD #cFF25		; A = orange sur fond orange. B = 37 pour les sauts.
	LBSR G2_R1_7x4	; Remplissage de la zone de couleurs.

	INC $E7C3		; Sélection vidéo forme.
	LDB #40			; B = 40 pour les sauts de ligne.
	LDY #LISTE1		; Y pointe la liste 1 comme buffer de sauvegarde.

	LDX #$5929
	LBSR BSAVE2_13	; Sauvegarde des colonnes de couleur cachées 1 et 2.
	LDX #$592F
	LBSR BSAVE2_13	; Sauvegarde des colonnes de couleur cachées 3 et 4.
	LDX #$56FB
	LBSR BSAVE2_13	; Sauvegarde des colonnes de formes cachées 1 et 2.
	LDX #$56FD
	LBSR BSAVE2_13	; Sauvegarde des colonnes de formes cachées 3 et 4.

	LDX #$592B		; X pointe l'emplacement des armes.
	LDY #LISTE1		; Y pointe à nouveau la liste 1
	BRA AFF_INVW_R1_1 ; Affichage de l'épée.

; Affichage des armes avec la quantité de munitions.
AFF_INVW_1:
	LDA >INVW_COUR	; A = numéro d'arme courante.
	LDX #$592B		; X pointe l'emplacement des armes.
	BSR AFF_INVW_R1	; Affichage de l'arme.

	LDA >INVW_COUR	; A = numéro d'arme courante.
	LDX #$5BD3		; X pointe l'emplacement des munitions.
	BSR AFF_INVW_R2	; Affichage du type de munition courante.

	LDA >INVW_COUR	; A = numéro d'arme courante.
	DECA
	LSRA			; A = (N° d'arme - 1) MOD 2
	LDX #INVW_MUN1	; X pointe les munitions dans l'inventaire.
	LEAX A,X		; X pointe les munitions courantes.
	LDA ,X			; A = nombre de munitions courantes.

AFF_INVW_2:
	LDX #$5BD5		; X pointe le nombre de munitions à l'écran.
	LBRA PRINTN2	; Affichage du nombre de munitions.

; Routine d'affichage des armes 1 à 6.
AFF_INVW_R1:
	LDY #AFF_INVW_DATA1	; Y pointe les bitmaps des armes 1 à 6
	DECA			; N° d'arme - 1
	LDB #104		; Taille des bitmaps
	MUL				; D = (n° d'arme - 1) x taille des bitmaps
	LEAY D,Y		; Y pointe le bitmap de l'arme à afficher.

AFF_INVW_R1_1:
	LDB #40			; Pour les sauts de ligne.
	LBSR VIDEOC_A
	LBSR DISPLAY_2YX_13 ; Affichage des couleurs.
	LEAX -518,X
	LBSR DISPLAY_2YX_13
	LEAX -522,X			; X pointe de nouveau l'arme.
	INC $E7C3			; Sélection vidéo forme.
	LBSR DISPLAY_2YX_13 ; Affichage des formes.
	LEAX -518,X
	LBRA DISPLAY_2YX_13

; Routine d'affichage des munitions 1 à 3.
AFF_INVW_R2:
	DECA
	LSRA			; A = (N° d'arme - 1) MOD 2

AFF_INVW_R2_1:
	LDB #14			; B = Taille des bitmaps
	MUL				; D = (N° d'arme / 2) x taille des bitmaps
	LDY #AFF_INVW_MUN_DATA1	; Y pointe les bitmaps des munitions 1 à 3
	LEAY D,Y		; Y pointe le bitmap de la munition à afficher.
	LDB #40			; Pour les sauts de ligne.
	LBRA CHEST18_2	; Affichage de la munition.

; Remmplacement de l'épée par la tronçonneuse pour la tour 2
AFF_INVW_0B:
	LDY #AFF_INVW_DATA0B ; Y pointe les données de la tronçonneuse

AFF_INVW_0B1:
	LBSR VIDEOF		; Sélection vidéo forme
	LDB #40			; B = 40 pour les sauts de ligne.

	LDX #$5929
	LBSR DISPLAY_2YX_13	; Modification des colonnes de couleur cachées 1 et 2.
	LDX #$592F
	LBSR DISPLAY_2YX_13	; Modification des colonnes de couleur cachées 3 et 4.
	LDX #$56FB
	LBSR DISPLAY_2YX_13	; Modification des colonnes de formes cachées 1 et 2.
	LDX #$56FD
	LBSR DISPLAY_2YX_13	; Modification des colonnes de formes cachées 3 et 4.
	LBSR AFF_INVW_0	; Affichage de l'arme dans l'interface.

	LDA #cFF		; A = orange sur fond orange
	LBSR PRINTO_R5	; Affichage d'un message d'objet vide
	LBRA PRINTO_R2	; Recopie de l'icone d'arme dans le message.

; Tronçonneuse (remplace l'épée dans la tour 2)
AFF_INVW_DATA0B:
	FCB cFF,cF0		; Couleurs colonne 1 et 2
	FCB cFF,cF0
	FCB cFF,cF0
	FCB cFF,cF0
	FCB cFF,c0F
	FCB cF0,c10
	FCB cF0,c10
	FCB cF0,c10
	FCB cF0,c10
	FCB c0F,c11
	FCB c0F,c10
	FCB c00,c11
	FCB cF0,c00

	FCB c0F,cFF		; Couleurs colonne 3 et 4
	FCB c0F,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB c0F,cFF
	FCB c08,c80
	FCB c08,c88
	FCB c08,c80
	FCB c08,c88
	FCB c08,c80
	FCB cFF,cFF

	FCB $FF,$FE		; Formes colonnes 1 et 2
	FCB $FF,$FC
	FCB $FF,$F8
	FCB $FF,$F1
	FCB $FF,$FE
	FCB $FC,$F2
	FCB $E0,$93
	FCB $C0,$F1
	FCB $92,$99
	FCB $C1,$FF
	FCB $C1,$9F
	FCB $FF,$FF
	FCB $80,$FF

	FCB $80,$FF		; Formes colonne 3 et 4
	FCB $80,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $80,$FF
	FCB $D5,$AA
	FCB $80,$FF
	FCB $80,$FE
	FCB $80,$FF
	FCB $D5,$AA
	FCB $FF,$FF

; Arbalette légère
AFF_INVW_DATA1:
	FCB cFF,cFF		; Couleurs colonne 1 et 2
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cF1,c1E
	FCB cF1,c1E
	FCB cF1,c11
	FCB cF1,c00
	FCB cF1,cFE
	FCB cF1,cFE
	FCB cFF,cFF
	FCB cFF,cFF

	FCB cF7,cEF		; Couleurs colonne 3 et 4
	FCB cF7,cFE
	FCB cF7,cFE
	FCB cF7,cFE
	FCB cF7,cFE
	FCB c71,c11
	FCB c73,c36		; c30 pour pointe noire
	FCB c71,c11
	FCB c07,c0E
	FCB c07,cFE
	FCB cF7,cFE
	FCB cF7,cFE
	FCB cF7,cEF

	FCB $FF,$FF		; Formes colonnes 1 et 2
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FE,$FE
	FCB $F8,$FC
	FCB $F0,$FF
	FCB $E0,$FF
	FCB $E0,$F8
	FCB $E1,$C3
	FCB $FF,$FF
	FCB $FF,$FF

	FCB $FE,$F0		; Formes colonne 3 et 4
	FCB $FD,$C3
	FCB $FB,$F1
	FCB $F7,$F8
	FCB $EF,$F8
	FCB $FC,$FF
	FCB $C0,$FC
	FCB $FC,$FF
	FCB $EF,$F8
	FCB $F7,$F8
	FCB $FB,$F1
	FCB $FD,$C3
	FCB $FE,$F0

; Arbalette lourde
AFF_INVW_DATA2:
	FCB cFF,cFF		; Couleurs colonne 1 et 2
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cF1,c1E
	FCB cF1,c1E
	FCB cF1,c11
	FCB c10,c0E
	FCB c10,c0E
	FCB c1F,cE0
	FCB cFE,cEF
	FCB cFF,cF1

	FCB cF7,cEF		; Couleurs colonne 3 et 4
	FCB cF7,cFE
	FCB cF7,cFE
	FCB c7F,cFE
	FCB c73,c36
	FCB c71,c11
	FCB c73,c36		; c30 pour pointe noire
	FCB c71,c11
	FCB c73,c36
	FCB c70,c0E
	FCB c07,cFE
	FCB cF7,cFE
	FCB cF7,cEF

	FCB $FF,$FF		; Formes colonne 1 et 2
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $F0,$FD
	FCB $C0,$F8
	FCB $80,$FF
	FCB $FE,$F8
	FCB $F8,$F8
	FCB $F0,$E2
	FCB $F8,$82
	FCB $FF,$F9

	FCB $FC,$F0		; Formes colonne 3 et 4
	FCB $F3,$C3
	FCB $CF,$F1
	FCB $FC,$F8
	FCB $C0,$FC
	FCB $FC,$FF
	FCB $C0,$FC
	FCB $FC,$FF
	FCB $C0,$FC
	FCB $FC,$F8
	FCB $CF,$F1
	FCB $F3,$C3
	FCB $FC,$F0

; Revolver
AFF_INVW_DATA3:
	FCB cFF,cFF		; Couleurs colonne 1 et 2
	FCB cFF,cFF
	FCB cFF,cF0
	FCB cF0,c08
	FCB cF0,c08
	FCB cF1,c08
	FCB cF1,c08
	FCB cF1,c0F
	FCB cF1,cF0
	FCB cF1,cF0
	FCB cF1,cF0
	FCB cF1,cFF
	FCB cF1,cFF

	FCB cFF,cF0		; Couleurs colonne 3 et 4
	FCB cFF,cF0
	FCB c00,c00
	FCB c88,c80
	FCB c00,c00
	FCB c80,cFF
	FCB c0F,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF

	FCB $FF,$FF		; Formes colonne 1 et 2
	FCB $FF,$FF
	FCB $FF,$80
	FCB $FC,$9E
	FCB $FE,$83
	FCB $FC,$9E
	FCB $F8,$83
	FCB $F0,$FE
	FCB $F0,$9B
	FCB $E0,$AB
	FCB $E0,$C7
	FCB $E0,$FF
	FCB $E0,$FF

	FCB $FF,$FD		; Formes colonne 3 et 4
	FCB $FF,$F1
	FCB $FF,$FF
	FCB $FF,$FE
	FCB $FF,$FF
	FCB $F0,$FF
	FCB $F0,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF

; Pistolet mitrailleur
AFF_INVW_DATA4:
	FCB cFF,cFF		; Couleurs colonne 1 et 2
	FCB cF0,c00
	FCB c08,c80
	FCB c08,c08
	FCB c08,c80
	FCB c00,c80
	FCB cF0,c00
	FCB cF0,c0F
	FCB c00,cFF
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF
	FCB cFF,cFF

	FCB cFF,cF0		; Couleurs colonne 3 et 4
	FCB c00,c00
	FCB c08,c08
	FCB c88,c00
	FCB c00,c0F
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF

	FCB $FF,$FF		; Formes colonne 1 et 2
	FCB $80,$FF
	FCB $92,$FD
	FCB $9F,$FE
	FCB $A0,$FC
	FCB $FF,$FC
	FCB $C1,$FF
	FCB $83,$80
	FCB $FF,$FF
	FCB $F8,$FF
	FCB $F0,$FF
	FCB $E0,$FF
	FCB $FF,$FF

	FCB $FF,$F9		; Formes colonne 3 et 4
	FCB $FF,$FF
	FCB $AA,$81
	FCB $FF,$FF
	FCB $FF,$80
	FCB $F8,$FF
	FCB $F8,$FF
	FCB $F8,$FF
	FCB $F0,$FF
	FCB $F0,$FF
	FCB $F0,$FF
	FCB $F0,$FF
	FCB $F0,$FF

; Pistolet plasma
AFF_INVW_DATA5:
	FCB cFF,cF0		; Couleurs colonne 1 et 2
	FCB cF0,c00
	FCB cF0,c02
	FCB cF0,c02
	FCB cF0,c02
	FCB cF0,c00
	FCB cF0,c0F
	FCB cF0,c0F
	FCB cF0,c0F
	FCB cF0,c0F
	FCB cF0,c0F
	FCB cF0,c0F
	FCB cF0,c0F

	FCB cFF,cF0		; Couleurs colonne 3 et 4
	FCB c00,c00
	FCB c02,c02
	FCB c02,c20
	FCB c02,c20
	FCB c00,c00
	FCB c00,c0F
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF
	FCB cFF,cFF

	FCB $FF,$C7		; Formes colonne 1 et 2
	FCB $FC,$FF
	FCB $F8,$C3
	FCB $F0,$81
	FCB $E0,$C3
	FCB $C0,$FF
	FCB $C0,$F1
	FCB $C0,$F1
	FCB $C0,$C2
	FCB $C0,$FC
	FCB $C0,$80
	FCB $C0,$80
	FCB $C0,$80

	FCB $FF,$81		; Formes colonne 3 et 4
	FCB $FF,$FF
	FCB $F9,$99
	FCB $F3,$CC
	FCB $E6,$98
	FCB $FF,$FF
	FCB $FF,$FE
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $FF,$FF

; Fusil plasma
AFF_INVW_DATA6:
	FCB cFF,cF0		; Couleurs colonne 1 et 2
	FCB cFF,cF0
	FCB cFF,cF0
	FCB cF0,c00
	FCB c00,c00
	FCB c0F,c00
	FCB c0F,c00
	FCB c0F,c00
	FCB c0F,c00
	FCB c0F,c0F
	FCB c0F,cF0
	FCB c0F,cFF
	FCB c0F,cFF

	FCB c0F,cFF		; Couleurs colonne 3 et 4
	FCB c0F,cFF
	FCB c0F,cF0
	FCB c00,c00
	FCB c20,c20
	FCB c00,c00
	FCB c20,c20
	FCB c00,c00
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF
	FCB c0F,cFF

	FCB $FF,$80		; Formes colonne 1 et 2
	FCB $FF,$80
	FCB $FF,$F0
	FCB $FE,$FF
	FCB $FF,$FF
	FCB $81,$FF
	FCB $81,$FF
	FCB $83,$FF
	FCB $87,$FF
	FCB $8C,$E6
	FCB $98,$83
	FCB $B0,$FF
	FCB $E0,$FF

	FCB $F8,$FF		; Formes colonne 3 et 4
	FCB $F0,$FF
	FCB $80,$E1
	FCB $FF,$FF
	FCB $EE,$EE
	FCB $FF,$FF
	FCB $EE,$EE
	FCB $FF,$FF
	FCB $FE,$FF
	FCB $FE,$FF
	FCB $FE,$FF
	FCB $FE,$FF
	FCB $FE,$FF

; Carreaux d'arbalète
AFF_INVW_MUN_DATA1:
	FCB c7F		; Couleurs
	FCB c36		; c30 pour pointe noire
	FCB c7F
	FCB cFF
	FCB c7F
	FCB c36		; c30 pour pointe noire
	FCB c7F

	FCB $C0		; Formes
	FCB $FC
	FCB $C0
	FCB $FF
	FCB $C0
	FCB $FC
	FCB $C0

; Cartouches 9mm
AFF_INVW_MUN_DATA2:
	FCB c8F		; Couleurs
	FCB c8F
	FCB c8F
	FCB cBF
	FCB cBF
	FCB cBF
	FCB c3F

	FCB $42		; Formes
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7

; Cartouches plasma
AFF_INVW_MUN_DATA3:
	FCB c0F		; Couleurs
	FCB c2F
	FCB c2F
	FCB c2F
	FCB c2F
	FCB c2F
	FCB c0F

	FCB $E7		; Formes
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7
	FCB $E7

;------------------------------------------------------------------------------
; AFF_INVO : affichage des objets dans l'inventaire.
;
; Liste des objets :
; 1 - Item d'invulérabilité temporaire.
; 2 - Item de lévitation temporaire.
; 3 - Potion de vie 100%.
; 4 - Bouclier 100%.
; 5 - Potion de mana 100%.
;------------------------------------------------------------------------------
AFF_INVO:
	LDY #AFF_INVO1	; Y pointe les données de couleur de l'icône 1.
	LDA >INVW_OBJ1	; A = quantité.
	BSR AFF_INVO_R1	; Extinction ou affichage de l'icône et de sa quantité.

	LDY #AFF_INVO2	; Y pointe les données de couleur de l'icône 2.
	LDA >INVW_OBJ2	; A = quantité.
	BSR AFF_INVO_R1	; Extinction ou affichage de l'icône et de sa quantité.

	LDY #AFF_INVO3	; Y pointe les données de couleur de l'icône 3.
	LDA >INVW_OBJ3	; A = quantité.
	BSR AFF_INVO_R1	; Extinction ou affichage de l'icône et de sa quantité.

	LDY #AFF_INVO4	; Y pointe les données de couleur de l'icône 4.
	LDA >INVW_OBJ4	; A = quantité.
	BSR AFF_INVO_R1	; Extinction ou affichage de l'icône et de sa quantité.

	LDY #AFF_INVO5	; Y pointe les données de couleur de l'icône 5.
	LDA >INVW_OBJ5	; A = quantité.

; Affichage ou extinction des icônes multicolores.
AFF_INVO_R1:
	LDX ,Y++		; X = adresse écran de l'icone.
	LBSR VIDEOC_B	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.

	CMPA #0			; Quantité = 0?
	BEQ AFF_INVO_R1_1 ; Oui => AFF_INVO_R1_1

	PSHS A
	LBSR L12U_R2_4	; Couleurs lignes 1 à 4
	LBSR DISPLAY_2A_2 ; lignes 5 à 6
	LDA ,Y+
	LBSR DISPLAY_2A_6 ; lignes 7 à 12
	LBSR L12U_R2_1	; Ligne 13
	LEAX 1,X
	PULS A			; A = quantité.
	LBRA PRINTN1	; Affichage de la quantité + video forme.

AFF_INVO_R1_1:
	LDA #c00
	LBSR DISPLAY_2A_13 ; Extinction de l'icône.
	LEAX 1,X
	LBSR DISPLAY_A_7 ; Extinction du chiffre de quantité.
	INC $E7C3
	RTS

; Données des icônes 
AFF_INVO1:
	FDB $5791				; Objet 1
	FCB c00,c06,c06,c06,c06,c00
AFF_INVO2:
	FDB $5793				; Objet 2
	FCB c00,c03,c03,c03,c03,c00
AFF_INVO3:
	FDB $5AD8				; Objet 3
	FCB c00,c0F,c07,c0D,c01,c00
AFF_INVO4:
	FDB $5ADA				; Objet 4
	FCB c00,c04,c04,c04,c04,c00
AFF_INVO5:
	FDB $5ADC				; Objet 5
	FCB c00,c0F,c07,c0E,c0C,c00

;------------------------------------------------------------------------------
; DEPLEN = déplacement des ennemis autour du perso. 
; La zone de déplacement se limite à la celle de la minimap. Les ennemis ne se
; déplacent pas au-delà de cette zone.
;------------------------------------------------------------------------------
DEPLEN:
	CLR	>VARDB1		; Initialisation du nombre d'ennemis détectés.
	CLR	>VARDB4		; Initialisation du nombre de mouvements détectés.
	LDX >MINIMAP	; X pointe l'adresse de la minimap.
	LDU #LISTE2		; U pointe la LISTE2 pour lister les ennemis détectés
	LDD #$0708		; 7 lignes de 8 colonnes à scanner
	STD >VARDB2		; VARDB2 = 7 lignes. VARDB3 = 8 colonnes

DEPLEN_0:
	LDA ,X			; A = code de la case courante.
	ANDA #%01110000	; A = type de case
	CMPA #%01000000	; Sol occupé ou occupable par l'ennemi?
	BCS DEPLEN_0_1	; Non, case interdite aux ennemis => DEPLEN_0_1

	CMPA #%01110000	; Obstacle?
	BEQ DEPLEN_0_1	; Oui => DEPLEN_0_1

	LDA ,X			; A = code de la case courante.
	ANDA #%00000111	; A = contenu du sol %100 ou des trous %101 ou %110
	BEQ DEPLEN_0_1	; Case vide => DEPLEN_0_1. Sinon numéro d'ennemi

	STX ,U++		; U   = Empilement de l'adresse de l'ennemi
	STA ,U+			; U+2 = Empilement du numéro d'ennemi
	LDA #7
	SUBA >VARDB2
	STA ,U+			; U+3 = Empilement du numéro de ligne de l'ennemi
	LDA #8
	SUBA >VARDB3
	STA ,U+			; U+4 = Empilement du numéro de colonne de l'ennemi

	INC	>VARDB1		; Nombre d'ennemis détectés + 1

DEPLEN_0_1:
	LEAX 1,X		; X pointe la colonne suivante
	DEC >VARDB3		; Nombre de colonnes à scanner - 1
	BNE DEPLEN_0	; Nombre >0 => DEPLEN_0

	LEAX 24,X		; X pointe la ligne suivante
	LDA #8
	STA >VARDB3		; 8 nouvelles colonnes à scanner
	DEC >VARDB2		; Nombre de lignes à scanner - 1
	BNE DEPLEN_0	; Nombre >0 => DEPLEN_0

	LDA	>VARDB1		; A = nombre d'ennemis détectés
	BNE DEPLEN_1	; A > 0 => DEPLEN_1
	RTS				; Sinon fin d'analyse.

DEPLEN_1:
	LDD >SQRADDR
	SUBD >MINIMAP	; D = adresse case perso - adresse minimap
	PSHS B
	ANDB #%00011111
	STB >VARDB2		; VARDB2 = numéro de colonne perso
	PULS B
	LSRB
	LSRB
	LSRB
	LSRB
	LSRB
	STB >VARDB3		; VARDB3 = numéro de ligne perso

	LDU #LISTE2		; U pointe la LISTE2 des ennemis détectés

DEPLEN_2_L:
	LDX ,U			; X = adresse de l'ennemi courant
	LDA 3,U			; A = numéro de ligne de l'ennemi courant
	CMPA >VARDB3	; ligne ennemi > ligne perso?
	BEQ DEPLEN_2_C	; Non, égales = analyse en colonne => DEPLEN_2_C
	BCS DEPLEN_2_L2	; Non, ligne ennemi < ligne perso => DEPLEN_2_L2

DEPLEN_2_L1:		; ligne ennemi > ligne perso
	LEAY -32,X		; Y = Adresse de l'ennemi - 32 = adresse case au dessus
	BRA DEPLEN_2_L3

DEPLEN_2_L2:		; ligne ennemi < ligne perso
	LEAY 32,X		; Y = Adresse de l'ennemi + 32 = adresse case en-dessous

DEPLEN_2_L3:
	BSR DEPLEN_TEST	; Test de la case de destination
	BEQ DEPLEN_3	; Déplacement accepté => DEPLEN_3. Sinon test en X.

DEPLEN_2_C:
	LDB 4,U			; B = numéro de colonne de l'ennemi courant
	CMPB >VARDB2	; colonne ennemi > colonne perso?
	BEQ DEPLEN_4	; Non, égales => déplacement annulé car déjà refusé en ligne => DEPLEN_4
	BCS DEPLEN_2_C2	; Non, colonne ennemi < colonne perso => DEPLEN_2_C2

DEPLEN_2_C1:		; colonne ennemi > colonne perso
	LEAY -1,X		; Y = Adresse de l'ennemi - 1 = adresse case à gauche
	BRA DEPLEN_2_C3

DEPLEN_2_C2:		; colonne ennemi < colonne perso
	LEAY 1,X		; Y = Adresse de l'ennemi + 1 = adresse case à droite

DEPLEN_2_C3:
	BSR DEPLEN_TEST	; Test de la case de destination
	BNE DEPLEN_4	; Déplacement refusé => DEPLEN_4. Sinon gestion du déplacement.

DEPLEN_3:
	CMPY >SQRADDR	; Coordonnées ennemi = coordonnées perso? 
	BEQ DEPLEN_4	; Oui = déplacement annulé => DEPLEN_4

	LDX ,U			; X = adresse de l'ennemi courant
	LDA ,X			; A = code de la case de l'ennemi.
	ANDA #%11110000	; Case vidée de son contenu.
	STA ,X

	LDA ,Y			; A = code de la case de destination.
	ORA 2,U			; Ajout du numéro de l'ennemi.
	STA ,Y

	TFR Y,D			; D = adresse de la case de destination
	LDY #LISTE_EN-3	; Y pointe la liste des ennemis.

DEPLEN_3_1:
	LEAY 3,Y
	CMPX ,Y			; Adresse de déplacement = adresse courante dans LISTEN?
	BNE DEPLEN_3_1	; Non = rebouclage
	STD ,Y			; Oui = modification de l'adresse de l'ennemi dans LISTE_EN
	INC >VARDB4		; Mouvement détecté + 1

DEPLEN_4:
	LEAU 5,U		; U pointe l'ennemi à analyser suivant
	LDA	>VARDB1		; A = nombre d'ennemis détectés
	DECA
	STA	>VARDB1
	BNE DEPLEN_2_L	; Rebouclage s'il reste des ennemis à analyser
	RTS

; Test de la case de déplacement de l'ennemi. A = 0 = test OK, sinon test NOK.
DEPLEN_TEST:
	LDA ,Y			; A = code de la case à tester
	ANDA #%01110000	; A = type de case
	CMPA #%01110000	; Obstacle?
	BEQ DEPLEN_TEST_NOK ; Oui => DEPLEN_TEST_NOK, même pour les portes ouvertes

	CMPA #%01000000	; Sol occupé ou occupable par l'ennemi?
	BCS DEPLEN_TEST_NOK ; Non, case interdite aux ennemis => DEPLEN_TEST_NOK

	LDA ,Y			; A = code de la case à tester
	ANDA #%00000111	; A = contenu de la case.
	BNE DEPLEN_TEST_NOK ; A <> 0 = case occupée => DEPLEN_TEST_NOK

	LDA ,Y			; A = code de la case à tester
	ANDA #%01110000	; A = type de case
	CMPA #%01010000	; Trou dans le sol?
	BNE DEPLEN_TEST_OK ; Non = case autorisée à tous les ennemis => DEPLEN_TEST_OK

	LDX #DEN_FLAG0	; X pointe les flags des ennemis
	LDA 2,U			; A = n° d'ennemi
	LDA A,X			; A = flags de l'ennemi.
	ANDA #%00000010	; A = flag de lévitation
	BEQ DEPLEN_TEST_NOK ; Non lévitant => DEPLEN_TEST_NOK. Sinon = OK

DEPLEN_TEST_OK:
	CLRA
	RTS

DEPLEN_TEST_NOK:
	LDA #$FF
	RTS

;------------------------------------------------------------------------------
; DLISTE_EN = remplissage de DLISTE_EN
; Identification des enemis dans la map courante = adresse + points de vie (PV)
;------------------------------------------------------------------------------
DLISTE_EN:
	LDX #MAPADDR+32	; X pointe l'adresse de la 2ème ligne de la map.
	LDY #LISTE_EN	; Y pointe LISTE_EN.
	LDU #DEN_PV00	; U pointe la liste des PV des ennemis.
	LDB #50			; 50 ennemis max à identifier.

DLISTE_EN_1:
	LDA ,X			; A = code de case courante.
	ANDA #%01110000	; A = type de case
	CMPA #%01110000	; Obstacle?
	BEQ DLISTE_EN_2	; Oui => DLISTE_EN_2

	CMPA #%01000000	; Sol occupé ou occupable par l'ennemi?
	BCS DLISTE_EN_2	; Non, case interdite aux ennemis => DLISTE_EN_2

	LDA ,X			; A = code de case courante.
	ANDA #%00000111	; A = contenu de la case.
	BEQ DLISTE_EN_2 ; A = 0 = case vide => DLISTE_EN_2

	LDA A,U			; A = PV de l'ennemi.
	STX ,Y++		; Stockage de l'adresse de l'ennemi dans LISTE_EN
	STA ,Y+			; Stockage du nombre de PV de l'ennemi dans LISTE_EN
	DECB			; Nombre d'ennemis à identifier - 1.
	BEQ DLISTE_EN_4 ; Si B = 0 => DLISTE_EN_4

DLISTE_EN_2:
	LEAX 1,X		; X pointe la case suivante.
	CMPX #MAPADDR+$3E0 ; Dernière case à analyser?
	BNE DLISTE_EN_1	; Non => DLISTE_EN_1

	LDA #$FF		; Liste à compléter avec des $FF
DLISTE_EN_3:		; B x 3 x $FF
	STA ,Y+
	STA ,Y+
	STA ,Y+
	DECB
	BNE DLISTE_EN_3

DLISTE_EN_4:
	LDA #$FF
	STA ,Y+			; Dernier octet de la liste = $FF
	RTS

;------------------------------------------------------------------------------
; BOUSSOLE = routine d'affichage de la boussole.
;------------------------------------------------------------------------------
BOUSSOLE:
	LDB #40			; Pour les sauts de ligne.
	LDA >ORIENT		; A = Orientation actuelle.
	BEQ BOUSSOLEN	; Nord => BOUSSOLEN

	CMPA #$20		; Sud?
	BEQ BOUSSOLES	; Oui => BOUSSOLES
	BCS BOUSSOLEE	; Non, Est => BOUSSOLEE. Sinon Ouest.

; Flèche orientation Ouest
BOUSSOLEO:
	LDY #BOUSSOLEO_DATA
	BRA BOUSSOLEE2

; Flèche orientation Est
BOUSSOLEE:
	LDY #BOUSSOLEE_DATA
BOUSSOLEE2:
	LDX #$490C
	LBSR DISPLAY_YX_5
	LEAX -198,X
	LBSR DISPLAY_YX_5
	LEAX -441,X
	LDY #BOUSSOLEO_DATA+10
	CLRA
	LBSR DISPLAY_A_6
	LBSR DISPLAY_YX_5
	CLRA
	LBRA DISPLAY_A_6

; Flèche orientation Sud
BOUSSOLES:
	LDY #BOUSSOLES_DATA
	BRA BOUSSOLEN2

; Flèche orientation Nord
BOUSSOLEN:
	LDY #BOUSSOLEN_DATA
BOUSSOLEN2:
	LDX #$481D
	LBSR DISPLAY_YX_16
	LDA ,Y+
	STA ,X
	LEAX -401,X
	LDA #$40
	LBSR DISPLAY_A_5
	LEAX -198,X
	LDA #$01
	LBRA DISPLAY_A_5

BOUSSOLEN_DATA:
	FCB $08,$1C,$2A,$08,$08,$08,$08,$1C,$36,$1C,$08,$08,$08,$08,$08,$14,$22
BOUSSOLES_DATA:
	FCB $22,$14,$08,$08,$08,$08,$08,$1C,$36,$1C,$08,$08,$08,$08,$2A,$1C,$08
BOUSSOLEO_DATA:
	FCB $42,$44,$4F,$44,$42,$09,$11,$E1,$11,$09
	FCB $08,$1C,$F7,$1C,$08
BOUSSOLEE_DATA:
	FCB $48,$44,$43,$44,$48,$21,$11,$F9,$11,$21

;------------------------------------------------------------------------------
; MAPCOMP = routine de compression de la map courante.
;------------------------------------------------------------------------------
MAPCOMP:
	LDX #PACKMAP	; Y pointe le pack de maps courant.
	LDY #MAPADDR	; Y pointe l'adresse de la map décompressée.
	LDA >MAPNUM		; A = n° de map.
	BEQ MAPCOMP_2	; Map n°0 => MAPCOMP_2.

MAPCOMP_1:
	LEAX 400,X		; X pointe la map compressée suivante.
	DECA
	BNE MAPCOMP_1

MAPCOMP_2:
	LBSR VIDEOF		; Sélection vidéo forme.

MAPCOMP_R1:
	LDA ,Y+			; A = caractère courant de la map à analyser.

MAPCOMP_R1A:
	CLRB			; Initialisation du code binaire de compression.

	LDU #TABCOMP_D0 ; U pointe les données pour les cases non découvertes.
	CMPA #$40		; A = sol occupable vide non découvert $40?
	BEQ MAPCOMP_R2B	; Oui => MAPCOMP_R2B.
	CMPA #$78		; A = mur simple non découvert $78?
	BEQ MAPCOMP_R2A	; Oui => MAPCOMP_R2A.

	LEAU 3,U		; U pointe les données pour les cases découvertes.
	CMPA #$C0		; A = sol occupable vide découvert $C0?
	BEQ MAPCOMP_R2B	; Oui => MAPCOMP_R2B.
	CMPA #$F8		; A = mur simple découvert $F8?
	BEQ MAPCOMP_R2A	; Oui => MAPCOMP_R2A.

	CMPY #MAPADDR+1024 ; Fin de map atteinte?
	BCC MAPCOMP_R2C	; Oui => MAPCOMP_R2C.

	STA ,X+			; Non, stockage du caractère courant sans compression.
	BRA MAPCOMP_R1	; Rebouclage.

MAPCOMP_R2A:
	ORB #%00010000	; Code binaire mis à jour avec un mur en position 1.

MAPCOMP_R2B:
	STA ,X+			; Sauvegarde temporaire du caractère courant.

	LDA ,Y+			; A = caractère suivant.
	CMPA 1,U		; A = case de sol $40 ou $C0?
	BEQ MAPCOMP_R3B	; Oui => MAPCOMP_R3B.
	CMPA 2,U		; A = case de mur $78 ou $F8?
	BEQ MAPCOMP_R3A	; Oui => MAPCOMP_R3A.

	CMPY #MAPADDR+1024 ; Fin de map atteinte?
	BCS MAPCOMP_R1A	; Non, sauvegarde confirmée et analyse du caractère suivant.

MAPCOMP_R2C:
	RTS				; Oui, sauvegarde confirmée et fin de compression.

MAPCOMP_R3A:
	ORB #%00001000	; Code binaire mis à jour avec un mur en position 2.

MAPCOMP_R3B:
	LDA ,Y+			; A = caractère suivant.
	CMPA 1,U		; A = case de sol $40 ou $C0?
	BEQ MAPCOMP_R4B	; Oui => MAPCOMP_R4B.
	CMPA 2,U		; A = case de mur $78 ou $F8?
	BEQ MAPCOMP_R4A	; Oui => MAPCOMP_R4A.

MAPCOMP_R3C:
	PSHS U			; Sauvegarde du pointage sur les données MAPCOMP_Dx.
	LDU #TABCOMP	; U pointe la table de compression.
	LEAU B,U		; U pointe le code de compression courant.
	LDB ,U			; B = code de compression sans offset.
	PULS U
	ADDB ,U			; B = code de compression avec offset.
	STB -1,X		; Sauvegarde du code de compression.

	CMPY #MAPADDR+1024 ; Fin de map atteinte?
	BCS MAPCOMP_R1A	; Non => analyse du caractère suivant.
	RTS				; Oui = Fin

MAPCOMP_R4A:
	ORB #%00000100	; Code binaire mis à jour avec un mur en position 3.

MAPCOMP_R4B:
	ADDB #%00100000	; Incrément du nombre de codes dans la séquence.

	LDA ,Y+			; A = caractère suivant.
	CMPA 1,U		; A = case de sol $40 ou $C0?
	BEQ MAPCOMP_R5	; Oui => MAPCOMP_R5.
	CMPA 2,U		; A = case de mur $78 ou $F8?
	BNE MAPCOMP_R3C	; Non => MAPCOMP_R3C.

	ORB #%00000010	; Code binaire mis à jour avec un mur en position 4.

MAPCOMP_R5:
	ADDB #%00100000	; Incrément du nombre de codes dans la séquence.

	LDA ,Y+			; A = caractère suivant.
	CMPA 1,U		; A = case de sol $40 ou $C0?
	BEQ MAPCOMP_R6	; Oui => MAPCOMP_R6.
	CMPA 2,U		; A = case de mur $78 ou $F8?
	BNE MAPCOMP_R3C	; Non => MAPCOMP_R3C.

	ORB #%00000001	; Code binaire mis à jour avec un mur en position 5.

MAPCOMP_R6:
	ADDB #%00100000	; Incrément du nombre de codes dans la séquence.
	LDA ,Y+			; A = caractère suivant.
	BRA MAPCOMP_R3C ; Sauvegarde du code de compression et rebouclge.

TABCOMP_D0	FCB $00,$40,$78
TABCOMP_D1	FCB $80,$C0,$F8

;------------------------------------------------------------------------------
; MAPDECOMP = routine de décompression de la map courante.
;------------------------------------------------------------------------------
MAPDECOMP:
	LDY #PACKMAP	; Y pointe le pack de maps courant.
	LDX #MAPADDR	; X pointe l'adresse de la map décompressée.
	LDA >MAPNUM		; A = n° de map.
	BEQ MAPDECOMP_2	; Map n°0 => MAPDECOMP_2.

MAPDECOMP_1:
	LEAY 400,Y		; Y pointe la map compressée suivante.
	DECA
	BNE MAPDECOMP_1

MAPDECOMP_2:
	LBSR VIDEOC_A	; Sélection video couleur pour la table de compression.

MAPDECOMP_R1:
	LDU #TABCOMP	; U pointe la table de décompression.

	LDA ,Y+			; A = code courant à analyser.
	PSHS A			; Sauvegarde du code avec le flag de découverte.
	ANDA #%01111111	; A = offest du code de décompression.
	LEAU A,U		; U pointe le code de décompression.
	LDB ,U			; B = code de décompression.
	PULS A			; Restauration du code courant.

	CMPB #1			; Code non compressé?
	BNE MAPDECOMP_R3 ; Non, compressé => MAPDECOMP_R3.

	STA ,X+			; Recopie du code courant non compressé.
	CMPX #MAPADDR+1024 ; Fin de map atteinte?
	BCS MAPDECOMP_R1 ; Non, rebouclage => MAPDECOMP_R1

	INC $E7C3		; Sélection vidéo forme.
	RTS				; Fin de décompression.

MAPDECOMP_R3:
	LDU #TABCOMP_D0 ; U pointe les données pour les cases non découvertes.
	CMPA #128		; Code courant < 128?
	BCS MAPDECOMP_R4 ; Oui => MAPDECOMP_R4
	LEAU 3,U		; Sinon U pointe les données pour les cases découvertes.

MAPDECOMP_R4:
	STB >VARDB1		; Sauvegarde du code de décompression.
	ANDB #%01100000	; Isolation du nombre de codes à décompresser.
	ADDB #%01000000	; +2.

	LDA #%00010000	; Masque d'analyse du code de compression.
	STA >VARDB2		; Sauvegarde du masque.

MAPDECOMP_R5:
	LDA >VARDB1		; A = code de décompression.
	ANDA >VARDB2	; Masquage du bit de séquence courant.
	BNE MAPDECOMP_R6 ; Bit = 1 => MAPDECOMP_R6

	LDA 1,U			; Code de case = &40 ou &C0.
	BRA MAPDECOMP_R7

MAPDECOMP_R6:
	LDA 2,U			; Code de case = &78 ou &F8.

MAPDECOMP_R7:
	STA ,X+			; Copie du case courant dans la map.
	LSR >VARDB2		; Décalage à droite du masque.
	SUBB #%00100000	; Nombre de codes à décompresser - 1.
	BNE MAPDECOMP_R5 ; Nombre > 0 => MAPDECOMP_R5

	CMPX #MAPADDR+1024 ; Fin de map atteinte?
	BCS MAPDECOMP_R1 ; Non, rebouclage => MAPDECOMP_R1

	INC $E7C3		; Sélection vidéo forme.
	RTS				; Fin de décompression.

;------------------------------------------------------------------------------
; SON_PORTE : son de porte. Pour améliorer la fluidité de la porte, MUS n'est
; pas utilisée.
;------------------------------------------------------------------------------
SON_PORTE:
	LDB #SI
	JSR $E81E
	LDB #DO
	JSR $E81E
	RTS

;------------------------------------------------------------------------------
; SON_CHUTE : sons de chute dans les trous
;
; ENTREE:
; VARDW1 doit pointer l'adresse des sons à jouer.
;------------------------------------------------------------------------------
SON_CHUTE:
	LDY >VARDW1		; Y pointe la position courante.
SON_CHUTE1:
	BSR MUS			; Joue le son courant.
	STY >VARDW1		; Sauvegarde de la position suivante.
	RTS

;------------------------------------------------------------------------------
; MUSA : routine de lecture de sons pour les attaques hors champs.
;
; ENTREES:
; Y pointe la partition à jouer.
;------------------------------------------------------------------------------
MUSA:
	BSR MUS
	LDB #10			; Tempo pour le maintien de la tâche à l'écran.
	LBRA TEMPO

;------------------------------------------------------------------------------
; MUS : routine de lecture de sons et de musiques.
;
; ENTREES:
; Y pointe la partition à jouer.
;------------------------------------------------------------------------------
; Boucle de lecture des valeurs.
MUS:
	LDB ,Y+			; B = valeur courante de la partition.
	CMPB #O1		; Note?
	BCC MUS1		; Non => MUS1

					; Oui, B = valeur de note
	JSR $E81E		; Envoie le code de la note à jouer
	BRA MUS			; Lit la suite de la partition

MUS1:
	CMPB #L1		; Octave Ox?
	BCC MUS2		; Non => MUS2

	SUBB #13		; Oui, B = position dans les données OCTAVE
	LDX #MUS_OCTAVE	; X pointe les valeurs d'octaves réelles
	ABX
	LDB ,X			; B = valeur d'octave
	STB >$6037		; Variable OCTAVE mise à jour dans le moniteur.
	BRA MUS			; Lit la suite de la partition

MUS2:
	CMPB #A0		; Durée Lx?
	BCC MUS3		; Non => MUS3

	SUBB #18		; Oui, B = position dans les données DUREE
	LDX #MUS_DUREE	; X pointe les durées réelles
	ABX
	LDB ,X			; B = durée
	STB >$6034		; Variable DUREE mise à jour dans le moniteur.
	BRA MUS			; Lit la suite de la partition

MUS3:
	CMPB #T1		; Attaque Ax?
	BCC MUS4		; Non => MUS4

	SUBB #34		; Oui, B = valeur d'attaque
	STB >$6035		; Variable TIMBRE mise à jour dans le moniteur.
	BRA MUS			; Lit la suite de la partition

MUS4:
	CMPB #FIN		; FIN de partition?
	BEQ MUS_FIN		; Oui, fin

	SUBB #144		; Non, B = valeur de tempo
	STB >$6032		; Variable TEMPO mise à jour dans le moniteur.
	BRA MUS			; Lit la suite de la partition

MUS_FIN:
	RTS				; Fin de routine.

;------------------------------------------------------------------------------
; Données pour les sons et musiques
;------------------------------------------------------------------------------
; Données de la routine MUS pour les octaves et les durées.
MUS_OCTAVE	FCB 16,8,4,2,1
MUS_DUREE	FCB 1,2,3,4,5,6,8,9,12,16,18,24,36,48,72,96

; Divers sons.
SON_TELEPORT_D:
	FCB O4,A5,T6,L4,DO,MI,SO,SI,O5,DO,MI,SO,SI,FIN
SON_CHUTE_D: 
	FCB O5,A0,T1,L2,SI,FIN
	FCB LA,FIN
	FCB SO,FIN
	FCB FA,FIN
	FCB MI,FIN
	FCB RE,FIN
	FCB DO,FIN
	FCB O4,SI,FIN
	FCB LA,FIN
	FCB SO,FIN
	FCB FA,FIN
	FCB MI,FIN
	FCB RE,FIN
	FCB DO,FIN
SON_CHUTE2_D:
	FCB O2,A2,T3,L9,DO,P,FIN ; 7
SON_PAS_D:
	FCB O1,A0,T1,L1,MI,FIN ; 6
SON_COUP1_D:
	FCB O4,A5,T2,L5,MI,RE,DO,P,FIN ; 9
SON_COUP2_D:
	FCB O4,A10,T2,L3,DO,P,MI,P,SI,P,SI,P,SI,P,FIN ; 15
SON_COUP3_D:
	FCB O3,A3,T3,L5,DO,SI,SI,P,FIN ; 9
SON_CROSSBOW_D:
	FCB A4,T2,L3,O5,MI,SI,P,FIN ; 8
SON_9MM_D:
	FCB A5,T2,L5,O4,MI,RE,P,FIN ; 8
SON_PLASMA_D:
	FCB A5,T5,L5,O3,SI,P,FIN ; 7
SON_ATKPLS_D:
	FCB O2,A4,T3,L3,DO,O3,DO,O4,DO,P,FIN ; 11
SON_BOUTON_D:
	FCB A4,T3,L2,O5,SI,DO,A3,T5,L3,O1,FIN ; 11
SON_CLE_D:
	FCB A10,T2,L2,O5,SI,A3,T5,L3,O1,FIN ; 11
SON_SELECT1_D:
	FCB A10,T2,L3,O5,DO,FIN ; 6
SON_SELECT2_D:
	FCB A10,T2,L3,O4,DO,FIN ; 6
SON_COFFRE_D:
	FCB A4,T4,L9,O1,SI,MI,P,FIN ; 8
SON_MURE_D:
	FCB A10,T7,L9,O1,DO,RE,P,FIN ; 8
SON_ORN12_D:
	FCB A0,T3,L5,O3,SI,DO,P,FIN ; 8
SON_REGEN_D:
	FCB A1,T7,L5,O3,DO,FA,SI,O4,MI,LA,P,FIN ; 12

;------------------------------------------------------------------------------
; PRINTO : SOUS-ROUTINE D'AFFICHAGE D'UNE BOITE DE DIALOGUE AVEC UN OBJET
;
; Cette routine affiche une boite de dialogue quand le joueur passe au-dessus
; d'un coffre. Le contenu du coffre est alors révélé sous forme graphique dans
; la boite de dialogue. 
;
; Liste des objets à afficher :
; - Carreaux d'arbalette.
; - Cartouches 9mm.
; - Munitions plasma.
; - Arbalette légère.
; - Arbalette lourde.
; - Révolver 9mm.
; - Pistolet mitrailleur 9mm.
; - Pistolet à plasma.
; - Fusil à plasma.
; - Clé jaune.
; - Clé bleue.
; - Clé rouge.
; - Potion de vie 100%.
; - Potion de mana 100%.
; - Bouclier 100%
; - Item de lévitation temporaire.
; - Item d'invulnérabilité temporaire.
; - Parchemin de sort de boule de feu.
; - Parchemin de sort d'éclair électrique.
; - Parchemin de sort de sphère d'antimatière.
;------------------------------------------------------------------------------
; Sélection de la couleur de fond du message en fonction du type d'icône.
PRINTO:
	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LDA ,X			; A = code de la case courante.
	STA >VARDB7		; Code sauvegardé.

	LBSR MAPCOMP	; Compression et sauvegarde de la map courante.
	LBSR PRINTO_R3	; Sauvegarde du fond de la fenêtre.

	LDA #cFF		; A = orange sur fond orange
	LDB >VARDB7		; B = code la case courante.
	ANDB #%01110000	; B = type de case.
	BEQ PRINTO_1	; Sol simple vide ou avec arme %000 => PRINTO_1

	LDA #c00		; A = noir sur fond noir.
	LDB >VARDB7		; B = code la case courante.
	ANDB #%00001111	; B = contenu de de case.
	CMPB #%00001001	; Parchemin?
	BCS PRINTO_1	; Non objet sur fond noir => PRINTO_1.

	LDA #c77		; A = blanc sur fond blanc.

; Affichage de la fenêtre vide.
PRINTO_1:
	LBSR PRINTO_R5

; Gestion des objets découverts.
	LDA >VARDB7		; A = code la case courante.
	ANDA #%01110000	; A = type de case.
	BNE PRINTO_001_O ; Sol simple vide ou avec objet %001 => PRINTO_001_O. Sinon arme ou munition.

	LDA >VARDB7		; A = code la case courante.
	ANDA #%00001111	; A = contenu de de case.
	CMPA #%00000100	; Arme?
	BCC PRINTO_000_W ; Oui => PRINTO_000_W. Sinon gestion des munitions.

; ----- Gestion des munitions -----
	DECA			; Offset pour l'affichage du type de munition.
	BSR PRINTO_000_1 ; Ajout de 10 munitions dans l'inventaire.

	LDX #SCROFFSET+$0698 ; X pointe la munition dans le message.
	LBSR AFF_INVW_R2_1 ; Affichage de la munition
	LDX #SCROFFSET+$069A ; X pointe la quantité de munition dans le message.
	LDA #10			; Quantité à afficher = 10
	LBSR PRINTN2	; Affichage de la quantité.
	LBSR AFF_INVW	; Mise à jour de l'affichage de l'arme courante.
	LBRA PRINTO_END

PRINTO_000_1:
	LDX #INVW_MUN1	; X pointe les munitions
	LEAX A,X		; Puis les munitions actuelles.
	LDB ,X			; A = quantité de munitions actuelles
	ADDB #10		; quantité + 10
	CMPB #100		; quantité >= 100? 
	BCS PRINTO_000_2 ; Non => PRINTO_000_2
	LDB #99			; Sinon quantité limitée à 99.
PRINTO_000_2:
	STB ,X			; Mise à jour de la quantité de munitions actuelles.
	RTS

; ----- Gestion des armes -----
PRINTO_000_W:
	SUBA #3			; A = n° d'arme acquise.
	STA >INVW_COUR	; = numéro d'arme courante.
	LDX #INVW_0		; X pointe les acquisitions d'arme.
	LEAX A,X		; Puis l'arme courante.
	INC ,X			; Arme acquise.
	DECA
	LSRA			; A = (N° d'arme - 1) MOD 2 = n° de munition.
	BSR PRINTO_000_1 ; Ajout de 10 munitions dans l'inventaire.
	LBSR AFF_INVW	; Afichage de l'arme courante et de ses munitions dans l'inventaire.
	LBSR PRINTO_R2	; Recopie de l'arme dans le message.
	LBRA PRINTO_END	; Fin => PRINTO_END

; ----- Gestion des objets au sol -----
PRINTO_001_O:
	LDB #1			; Pour les acquisitions.

	LDA >VARDB7		; A = code la case courante.
	ANDA #%00001111	; A = contenu de de case.
	CMPA #%00000100	; Clé?
	BCS PRINTO_001_K ; Oui => PRINTO_001_K

	CMPA #%00001001	; Parchemins?
	BCC PRINTO_001_P ; Oui => PRINTO_001_P

; ----- Gestion des objets de recharge et de pouvoir -----
PRINTO_001_0100:
	SUBA #4			; A = code d'objet.
	LDX #PRINTO_D	; X pointe les données de conversion.
	LEAX A,X
	LDA ,X			; A = n° d'objet.
	LDX #INVW_OBJ1	; X pointe les quantités d'objets
	LEAX A,X		; Puis la quantité de l'objet acquis
	LDB ,X			; B = quantité
	INCB			; Quantité + 1
	CMPB #10		; Quantité = 10?
	BCS PRINTO_001_0100_1 ; Non => PRINTO_001_0100_1

	DECB			; Sinon B = 9

PRINTO_001_0100_1:
	STB ,X			; Quantité mémorisée.

	PSHS A
	LBSR AFF_INVO	; Mise à jour de l'affichage des objets.
	PULS A

	LSLA			; 2A
	LSLA			; 4A
	LSLA			; 8A
	LDY #AFF_INVO1	; Y pointe les données des icones.
	LEAY A,Y		; Puis les données de l'icone courant.
	LDX ,Y			; X pointe l'icone à l'écran.
	BRA PRINTO_001_P1 ; Recopie de l'icône dans le message et fin.

; ----- Gestion des clés -----
PRINTO_001_K:
	DECA		; A = n° de clé - 1
	LDX #INVK1	; X pointe les acquisitions des clés
	LEAX A,X	; Puis la clé courante.
	STB ,X		; Clé acquise.

	PSHS A
	LBSR AFF_INVK	; Mise à jour de l'affichage des clés.
	PULS A

	LDX #$43B7	; X pointe la clé jaune dans l'inventaire.
	LEAX A,X
	LEAX A,X
	LEAX A,X	; Puis la clé acquise.
	BRA PRINTO_001_P1 ; Recopie de l'icône dans le message et fin.

; ----- Gestion des parchemins -----
PRINTO_001_P:
	SUBA #8			; A = n° de sort.
	STA >INVS_COUR	; = n° du sort courant.

	LDX #INVS0		; X pointe les variables de sort.
	LEAX A,X		; Puis la variable du sort.
	STB ,X			; Activation du sort.

	LBSR AFF_INVS	; Affichage du sort courant dans l'inventaire.

	LDX #$4F20		; X et Y pointent l'icône.
PRINTO_001_P1:
	LDY #SCROFFSET+$0621
	BSR PRINTO_R1	; Recopie de l'icône dans le message et fin.

; ----- Fin d'affichage -----
PRINTO_END:
	LDY #SON_COFFRE_D ; Son d'ouverture du coffre.
	LBSR MUS
	LBSR TOUCHE		; Attente de touche.
	LBSR PRINTO_R4	; Restauration du fond de la fenêtre.
	LBSR MAPDECOMP	; Décompression de la map.
	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LDA #%10000000	; Case %000 vide découverte.
	STA ,X
	RTS

; Recopie d'une icone d'arme
PRINTO_R2:
	LDX #$592B			; X et Y pointe la partie gauche de l'arme.
	LDY #SCROFFSET+$0620
	BSR PRINTO_R1

	LDX #$592D			; X et Y pointe la partie droite de l'arme.
	LDY #SCROFFSET+$0622

; Recopie d'une icone affichée dans le message. X point l'icone et Y la destination.
PRINTO_R1:
	STX >VARDW1		; Adresse de l'icone sauvegardée.
	STY >VARDW2		; Adresse de destination sauvegardée.

	LBSR VIDEOC_A	; Sélection video couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	BSR PRINTO_R1_1	; sauvegarde des couleurs.

	INC $E7C3		; Sélection vidéo forme.
	LDX >VARDW1		; X pointe l'adresse de l'icone + sauvegarde des formes.

PRINTO_R1_1:
	LDY #LISTE1		; Y pointe la liste 1 comme buffer de sauvegarde.
	LBSR BSAVE2_13	; Sauvegarde des colonnes 1 et 2.
	LDY #LISTE1		; Y pointe de nouveau la liste 1
	LDX >VARDW2		; X pointe l'adresse de destination
	LBRA DISPLAY_2YX_13 ; Affichage des couleurs dans le message.

; Sauvegarde du fond de la fenêtre
PRINTO_R3:
	LDY #BUFFER		; Y pointe le buffer de fond.
	LDB #40			; Pour les sauts de ligne.

	LBSR VIDEOC_A	; Sélection video couleur
	BSR PRINTO_R3_1	; Sauvegarde du fond de couleur.
	INC $E7C3		; Sélection vidéo forme et sauvegarde du fond de forme.
PRINTO_R3_1:
	LDX #SCROFFSET+$04B7 ; X pointe la zone de fenêtre, colonne 1
	LBSR BSAVE2_32
	LDX #SCROFFSET+$04B9 ; X pointe la zone de fenêtre, colonne 3
	LBSR BSAVE2_32
	LDX #SCROFFSET+$04BB ; X pointe la zone de fenêtre, colonne 5
	LBRA BSAVE2_32

; Restauration du fond de la fenêtre
PRINTO_R4:
	LDY #BUFFER		; Y pointe le buffer de fond.
	LDB #40			; Pour les sauts de ligne.

	LBSR VIDEOC_A	; Sélection video couleur
	BSR PRINTO_R4_1	; Restauration du fond de couleur.
	INC $E7C3		; Sélection vidéo forme et restauration du fond de forme.
PRINTO_R4_1:
	LDX #SCROFFSET+$04B7 ; X pointe la zone de fenêtre, colonne 1
	LBSR DISPLAY_2YX_32
	LDX #SCROFFSET+$04B9 ; X pointe la zone de fenêtre, colonne 3
	LBSR DISPLAY_2YX_32
	LDX #SCROFFSET+$04BB ; X pointe la zone de fenêtre, colonne 5
	LBRA DISPLAY_2YX_32

; Affichage d'une fenêtre vide. Réutilisé par AFF_INVW_0B1
PRINTO_R5:
	LBSR VIDEOC_B	; Sélection video couleur
	LDX #SCROFFSET+$05CF ; X pointe la fenêtre intérieure.
	LDB #35			; B = 35 pour les sauts de ligne
	LBSR G2_R1_16x6	; 17 lignes à remplir en fonction des couleurs de A.
	LBSR G2_R1_1x6

	LDX #SCROFFSET+$04B7
	LDU #MES_CHAIN2
	LBSR PRINTM_R0_1	 ; Affichage des chaînes du haut.

	LDX #SCROFFSET+$0877
	LDU #MES_CHAIN2
	LBRA PRINTM_R0_1	 ; Affichage des chaînes du bas.

; Données de conversion code map -> objet
PRINTO_D:
	FCB 2,4,3,1,0

;------------------------------------------------------------------------------
; PRINTM : SOUS-ROUTINE D'AFFICHAGE D'UN MESSAGE
;
; Cette routine affiche une fenêtre et un texte compressé, composé de mots de 
; 16 bits contennant trois caractères de 5 bits et un bit de fin de message.
; Le caractère 30 indique un retour à la ligne, et le 31 un changement de table
; de caractères.
;
; 7654321076543210
; |___||___||___|+-- 1 = fin de message.
;   |    |    +----- 3ème caractère.
;   |    +---------- 2ème caractère.
;   +--------------- 1er caractère.
;
; Entrées:
; X pointe le message à l'écran.
; U pointe le message à afficher.
;
; Sortie:
; X pointe l'écran en dessous la fenêtre de message.
;------------------------------------------------------------------------------
; MESSAGES AVEC ORNEMENTS ET DEMANDE D'APPUI SUR A
PRINTM:
	STX >VARDW1		; Sauvegarde de l'adresse de la fenêtre de texte.
	STU >VARDW2		; Sauvegarde de l'adresse du message à afficher
	BSR PRINTM_R0	; Affichage de la 1ère chaine d'ornements
	BSR PRINTM_R1_1	; Affichage du message sans ornement
	LDU #MESSAGEMA	; U pointe le message d'appui sur A
	BSR PRINTM_R1	; Affichage du message sans ornement
	BSR PRINTM_R0	; Affichage de la deuxième chaine d'ornements

PRINTM_1:
	LBSR TOUCHE		; Attente de touche
	CMPB #TOUCHE_A	; Touche "A"?
	BNE PRINTM_1 	; Non => PRINTM1
	RTS

; Affichage des chaines d'ornement
PRINTM_R0:
	LDU #MES_CHAIN	; U pointe la chaine d'ornement du message.

PRINTM_R0_1:		; Partie réutilisée par PRINTO.
	LBSR PRINTC_T2	; CHARS_TAB pointe la table 2.
	LDY #CHARS_COUL3
	STY >CHARS_COUL	; CHARS_COUL pointe la palette 3.
	BRA PRINTM_R2

; MESSAGES SANS ORNEMENTS
PRINTM_R1:
	STX >VARDW1		; Sauvegarde de l'adresse de la fenêtre de texte.
	STU >VARDW2		; Sauvegarde de l'adresse du message à afficher

PRINTM_R1_1:
	LBSR PRINTC_T1	; CHARS_TAB pointe la table 1. 
	LDY #CHARS_COUL1
	STY >CHARS_COUL	; CHARS_COUL pointe la palette de jaune.
	LDU >VARDW2		; U pointe le message à afficher.

; Lecture des paires d'octet
PRINTM_R2:
	LDA ,U			; A = premier octet.
	LSRA
	LSRA
	LSRA			; A = code du premier caractère.
	BSR PRINTC		; Affichage du premier caractère.

	LDA ,U+			; A = le premier octet.
	ANDA #%00000111	; Isolation des 3 bits de poids fort du deuxième code.
	LDB ,U			; B = deuxième octet.
	ASLB
	ROLA
	ASLB
	ROLA			; A = code du deuxième caractère.
	BSR PRINTC		; Affichage du deuxième caractère.

	LDA ,U+			; A = deuxième octet.
	LSRA
	BCS PRINTM_R3	; Si bit 0 du deuxième octet = 1, => PRINTM_R3
	ANDA #%00011111	; A = code du troisième caractère.
	BSR PRINTC		; Affichage du troisième caractère.
	BRA PRINTM_R2	; Rebouclage.

PRINTM_R3:
	ANDA #%00011111	; A = code du troisième caractère.
	BRA PRINTC		; Affichage du troisième caractère et fin.

;------------------------------------------------------------------------------
; PRINTC : SOUS-ROUTINE D'AFFICHAGE D'UN CARACTERE GRAPHIQUE.
;
; La routine affiche un caractère graphique en masque inversé.
; Le caractère 30 indique un retour à la ligne. Le caractère 31 indique un 
; changement de table, entre CHAR_T1 et CHAR_T2.
;
; Entrées:
; A = code du caractère à afficher.
; X pointe le caractère à l'écran.
; CHARS_PAL pointe la palette courante.
; CHARS_TAB pointe la table de caractères courante.
;
; Sortie:
; X pointe le caractère suivant à l'écran.
;------------------------------------------------------------------------------
PRINTC:
	CMPA #30		; Code 30?
	BEQ PRINTC_1	; Oui => PRINTC_1
	BCC PRINTC_2	; Non, code 31 => PRINTC_2. Sinon affichage du caractère.

PRINTC_0:
	PSHS A			; Sinon, sauvegarde du code de caractère à afficher.
	LBSR VIDEOC_A	; Sélection video couleur.
	LDD #c0028		; A = noir sur fond noir, B = 40 pour les sauts de ligne.
	STA ,X			; 1 ligne = noir sur fond noir.
	ABX
	LDY >CHARS_COUL	; Y pointe les couleurs courantes.
	LBSR DISPLAY_YX_5 ; Initialisation des couleurs du caractère.
	LDA #c00		; A = noir sur fond noir
	STA ,X			; Dernière ligne = noir sur fond noir.
	LEAX -200,X		; X pointe la forme du caractère à l'écran.
	INC $E7C3		; Sélection vidéo forme
	PULS A			; Restauration du code de caractère à afficher.
	LDY >CHARS_TAB	; Y pointe l'adresse de la table courante.
	LDB #5
	MUL				; D = 5 * code
	LEAY D,Y		; Y pointe la tuile de forme du caractère.
	LDB #40			; Pour les sauts de ligne.
	LBSR DISPLAY_YX_5 ; Affichage des formes du caractère.
	LEAX -239,X		; X pointe le caractère suivant à l'écran.
PRINTC_RTS:
	RTS

; Code 30 = retour à la ligne.
PRINTC_1:
	LDX >VARDW1		; Retour à la ligne.
	LEAX 280,X
	STX >VARDW1
	RTS

; Code 31 = changement de table de caractères.
PRINTC_2:
	LDY >CHARS_TAB	; Y = adresse de la table courante.
	CMPY #CHARS_T1	; Table 1?
	BEQ PRINTC_T2	; Oui => PRINTC_T2

PRINTC_T1:
	LDY #CHARS_T1	; Y = adresse de la table 1.
	STY >CHARS_TAB	; Adresse sauvegardée.
	RTS

PRINTC_3:
	LDY #CHARS_COUL1 ; Pointage la palette de jaune par défaut.
	STY >CHARS_COUL

PRINTC_T2:
	LDY #CHARS_T2	; Y = adresse de la table 2.
	STY >CHARS_TAB	; Adresse sauvegardée.
	RTS

;------------------------------------------------------------------------------
; PRINTN1 : SOUS-ROUTINE D'AFFICHAGE D'UN CHIFFRE.
;
; La routine affiche un chiffre de 0 à 9.
;
; Entrées:
; A = chiffre à afficher.
; X pointe le chiffre à l'écran.
; CHARS_PAL pointe la palette courante.
;
; Sortie:
; X pointe le caractère suivant à l'écran.
;------------------------------------------------------------------------------
PRINTN1:
	BSR PRINTC_3	; Palette jaune + pointage de la table 2
	BRA PRINTC_0	; Affichage du chiffre

;------------------------------------------------------------------------------
; PRINTN2 : SOUS-ROUTINE D'AFFICHAGE D'UN NOMBRE A DEUX CHIFFRES.
;
; La routine affiche un nombre de 00 à 99 sur deux caractères.
;
; Entrées:
; A = nombre à afficher.
; X pointe le nombre à l'écran.
; CHARS_PAL pointe la palette courante.
;
; Sortie:
; X pointe le caractère suivant à l'écran.
;------------------------------------------------------------------------------
PRINTN2:
	BSR PRINTC_3	; Palette jaune + pointage de la table 2

PRINTN2_0:
	CLRB			; Dizaines = 0

PRINTN2_1:
	CMPA #10		; A < 10?
	BCS PRINTN2_2	; Oui => PRINTN2_2
	SUBA #10		; A = A - 10
	INCB			; Dizaines + 1
	BRA PRINTN2_1

PRINTN2_2:
	PSHS A
	TFR B,A
	BSR PRINTC_0	; Affichage des dizaine.
	PULS A
	BRA PRINTC_0	; Affichage des unités.

;------------------------------------------------------------------------------
; DONNEES DE TEXTE
;------------------------------------------------------------------------------
; Couleurs
CHARS_COUL	FDB CHARS_COUL1	; Adresse des couleurs courantes.
CHARS_COUL1	FCB c07,c0B,c03,c03,c0F	; Dégradé de jaune.
CHARS_COUL2	FCB c07,c0E,c06,c06,c0C	; Dégradé de bleu.
CHARS_COUL3	FCB c0E,c0E,c0E,c0E,c0E	; Noir sur fond bleu ciel pour les chaines.

; Sélection de table de caractère.
CHARS_TAB	FDB CHARS_T1	; Adresse de la table courante (CHARS_T1 ou CHARS_T2).

; Caractères de la table 1. Les caractères 30 et 31 sont des codes de controle.
CHARS_T1:
	FCB $C3,$99,$81,$99,$99	; 00 = A
	FCB $83,$99,$83,$99,$83	; 01 = B
	FCB $C1,$9F,$9F,$9F,$C1	; 02 = C
	FCB $83,$99,$99,$99,$83	; 03 = D
	FCB $81,$9F,$87,$9F,$81 ; 04 = E
	FCB $81,$9F,$87,$9F,$9F	; 05 = F
	FCB $C1,$9F,$91,$99,$C3	; 06 = G
	FCB $99,$99,$81,$99,$99	; 07 = H
	FCB $C3,$E7,$E7,$E7,$C3	; 08 = I
	FCB $F9,$F9,$F9,$99,$C3 ; 09 = J
	FCB $99,$93,$87,$93,$99	; 10 = K
	FCB $9F,$9F,$9F,$9F,$81	; 11 = L
	FCB $9C,$88,$80,$94,$9C	; 12 = M
	FCB $99,$89,$81,$91,$99	; 13 = N
	FCB $C3,$99,$99,$99,$C3	; 14 = O
	FCB $83,$99,$83,$9F,$9F	; 15 = P
	FCB $C3,$99,$99,$93,$C9	; 16 = Q
	FCB $83,$99,$81,$93,$99	; 17 = R
	FCB $C1,$9F,$C3,$F9,$83	; 18 = S
	FCB $81,$E7,$E7,$E7,$E7	; 19 = T
	FCB $99,$99,$99,$99,$C1	; 20 = U
	FCB $99,$99,$99,$DB,$E7	; 21 = V
	FCB $9C,$94,$80,$88,$9C	; 22 = W
	FCB $99,$C3,$E7,$C3,$99	; 23 = X
	FCB $99,$99,$C3,$E7,$E7	; 24 = Y
	FCB $81,$F3,$E7,$CF,$81	; 25 = Z
	FCB $FF,$FF,$FF,$FF,$FF ; 26 = espace
	FCB $FF,$FF,$FF,$E7,$E7 ; 27 = .
	FCB $FF,$FF,$E7,$E7,$CF	; 28 = ,
	FCB $E7,$CF,$FF,$FF,$FF	; 29 = '

; Caractères de la table 2. Les codes 30 et 31 sont des caractères de controle.
CHARS_T2:
	FCB $C3,$99,$91,$89,$C3	; 00 = 0
	FCB $E7,$C7,$E7,$E7,$C3	; 01 = 1
	FCB $83,$F9,$E3,$9F,$81	; 02 = 2
	FCB $83,$F9,$E3,$F9,$83	; 03 = 3
	FCB $99,$99,$81,$F9,$F9	; 04 = 4
	FCB $81,$9F,$83,$F9,$83	; 05 = 5
	FCB $C3,$9F,$83,$99,$C3	; 06 = 6
	FCB $81,$F9,$F3,$E7,$E7	; 07 = 7
	FCB $C3,$99,$C3,$99,$C3	; 08 = 8
	FCB $C3,$99,$C1,$F9,$C3	; 09 = 9
	FCB $FF,$E7,$FF,$E7,$FF	; 10 = :
	FCB $FF,$FF,$81,$FF,$FF	; 11 = -
	FCB $F9,$F3,$E7,$CF,$9F	; 12 = /
	FCB $B9,$F3,$E7,$CF,$9D	; 13 = %
	FCB $C3,$99,$F3,$FF,$E7	; 14 = ?
	FCB $E7,$E7,$E7,$FF,$E7	; 15 = !
	FCB $81,$BD,$A1,$A9,$81	; 16 = rivet.
	FCB $C3,$BD,$18,$BD,$C3	; 17 = chainon.

; Chaine d'ornement pour les messages.
MES_CHAIN:
	FDB $8462,$8C62,$8C62,$8C62,$8C62,$8C62,$8C3D ; Rivet + 18 chainons + rivet
MES_CHAIN2:
	FDB $8462,$8C61	; Rivet + 4 chainons + rivet

MESSAGEFT:	; Message de fin de tour.
	FDB $92C0,$C122,$E6A6,$A680,$96A6,$A134,$593C ; SLAYER, TU AS TUE LE
	FDB $3022,$1A08,$6EF4,$1748,$9810,$9E96,$A23C ; GARDIEN. C'ETAIT LUI
	FDB $5834,$93A8,$8888,$D0FA,$2348,$8990,$26FC ; LA SOURCE D'ENERGIE.
	FDB $A834,$A922,$9696,$269E,$8B84,$3810,$6EBC ; VA VERS LE PROCHAIN
	FDB $7052,$20A6,$4174,$901A,$969E,$2446,$893C ; OBJECTIF SANS PERDRE
	FDB $1934,$9918,$7CB6,$D6B4,$D6B4,$D6B4,$D6BD ; DE TEMPS.

MESSAGEMJ:	; Message de mort du joueur
	FDB $92C0,$C122,$E6A6,$A680,$969E,$2450,$DEBC ; SLAYER, TU AS PERI.
	FDB $6010,$96A6,$06A6,$008E,$269A,$E924,$9EBC ; MAIS TA TACHE N'EST
	FDB $7824,$D11A,$13A2,$2680,$11C8,$A908,$DEBC ; PAS ENCORE ACHEVEE.
	FDB $D6A2,$23C0,$8CB4,$0534,$1398,$0826,$D6BD ;   REPARS AU COMBAT

MESSAGEFIN:	; Message de fin du niveau portail.
	FDB $0A08,$6E92,$7508,$D496,$0608,$8EF4,$583C ; BIEN JOUE SLAYER.
	FDB $AB90,$2688,$94F4,$5A02,$8936,$D6B4,$D6BD ; LA VOIE EST LIBRE.

MESSAGEMA:
	FDB $D6B4,$D6B4,$D6B4,$D6B4,$D6B4,$D6B4,$D6BC
	FDB $D6B4,$D01E,$7D10,$26A4,$A474,$06B4,$D6BD ;     APPUIE SUR A

;------------------------------------------------------------------------------
; Routine de sélection du type d'attaque.
;
; Cette routine sélectionne ATKPL_W (attaque armée) ou ATKPL_S (attaque de type
; boule d'énergie), selon le type d'attaque contenu dans ATKPL_TYPE.
;------------------------------------------------------------------------------
; Point d'entrée pour les attaques confirmées.
ATKPL0:
	STA >VARDB6		; N° d'ennemi sauvegardé.
	ASLA			; A = 2*(n° d'ennemi)
	LDX A,Y			; X = adresse écran de destination.
	STX >VARDW5		; Adresse sauvegardée pour BLOOD06 ou ATKPL_S

	LDY #DEN_COUL00 ; Y pointe les couleurs de la tâche de sang
	LDA >VARDB6		; A = n° d'ennemi
	LDA A,Y			; A = couleurs de la tâche de sang de l'ennemi.
	STA >VARDB8		; Couleurs sauvegardées pour BLOOD06

; Point d'entrée pour les attaques dans le vide.
ATKPL:
	LDA >ATKPL_TYPE	; A = type d'attaque
	LBNE ATKPL_S	; Type 1 = sort => ATKPL_S. Sinon type arme.

;------------------------------------------------------------------------------
; Routine d'affichage d'une attaque armée par le joueur.
;
; Cette routine est appelée par DONJON_FEU. Elle anime les attaques armées par
; le joueur, en fonction de l'arme dans l'inventaire. Elle retourne le nombre 
; de points d'attaque de l'arme courante, ou 0 si l'attaque est annulée.
;
; ENTREES:
; VARDW5 = adresse de destination de l'animation.
; VARDB6 = n° d'ennemi, ou 0 si attaque dans le vide. 
;------------------------------------------------------------------------------
ATKPL_W:
	LDA >INVW_COUR	; A = n° d'arme courante
	LBEQ ATKPL_W0	; Arme 0 = épée => ATKPL_W0

	CMPA #2			; Arme 2 = arbalète lourde?
	LBEQ ATKPL_W2	; Oui => ATKPL_W2
	LBCS ATKPL_W1	; Non, arbalète simple => ATKPL_W1

	CMPA #4			; Arme 4 = pistolet mitrailleur?
	LBEQ ATKPL_W4	; Oui => ATKPL_W4
	LBCS ATKPL_W3	; Non, revolver => ATKPL_W3

	CMPA #5			; Arme 5 = pistolet plasma?
	BEQ ATKPL_W5	; Oui => ATKPL_W5. Sinon fusil plasma.

; Gestion de l'arme 6 (fusil d'assault plasma)
ATKPL_W6:
	LDA >INVW_MUN3	; A = quantité de cartouches disponibles.
	CMPA #3			; A >= 3 cartouches?
	BCC ATKPL_W6_1	; Oui => ATKPL_W6_1
	CLRA			; Sinon attaque annulée, PA = 0
	RTS

ATKPL_W6_1:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	LDY #LISTE1		; Y pointe la liste 1 comme buffer de sauvegarde.
	LDX #SCROFFSET+$1072 ; X pointe le fond du tir plasma
	LBSR BSAVE2_24	; Sauvegarde du fond

	LDX #SCROFFSET+$1072 ; X pointe de nouveau le fond du tir plasma
	LDA #c22		; A = vert fluo sur fond vert fluo.
	LBSR DISPLAY_A_6 ; Affichage du tir
	ABX
	LBSR DISPLAY_A_7
	ABX
	LBSR DISPLAY_A_8

	BSR ATKPL_W6_R1 ; Bruit de la rafale.
	LBSR ATKPL_R1_1	; Compensations de tempo

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDY #LISTE1		; Y pointe la liste 1 comme buffer de sauvegarde.
	LDX #SCROFFSET+$1072 ; X pointe le fond du tir plasma
	LDB #40			; B = 40 pour les sauts de ligne.
	LBSR DISPLAY_2YX_16 ; Restitution du fond
	LBSR DISPLAY_2YX_8

	INC $E7C3		; Sélection vidéo forme.
	LDA >PA_W6		; A = nombre de points d'attaque.
	RTS

ATKPL_W6_R1:
	BSR ATKPL_W6_R2
	BSR ATKPL_W6_R2
ATKPL_W6_R2:
	DEC >INVW_MUN3	; Munition - 1
	LDA >INVW_MUN3	; A = nombre de munitions.
	LBSR AFF_INVW_2 ; Mise à jour de l'affichage du nombre de munitions.
	LDY #SON_PLASMA_D ; Bruit du plasma.
	LBRA MUS

; Gestion de l'arme 5 (pistolet plasma)
ATKPL_W5:
	LDA >INVW_MUN3	; A = quantité de cartouches disponibles.
	BNE ATKPL_W5_1	; A <> 0 => ATKPL_W5_1
	CLRA			; Sinon attaque annulée, PA = 0
	RTS

ATKPL_W5_1:
	DECA			; Munitions - 1
	STA >INVW_MUN3	; Mise à jour de l'inventaire
	LBSR AFF_INVW_2 ; Mise à jour de l'affichage du nombre de munitions.

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	LDY #LISTE1		; Y pointe la liste 1 comme buffer de sauvegarde.
	LDX #SCROFFSET+$118A ; X pointe le fond du tir plasma
	LBSR BSAVE2_16	; Sauvegarde du fond

	LDX #SCROFFSET+$118A ; X pointe de nouveau le fond du tir plasma
	LDA #c22		; A = vert fluo sur fond vert fluo.
	LBSR DISPLAY_A_16 ; Affichage du tir

	LDY #SON_PLASMA_D ; Bruit du plasma.
	BSR ATKPL_R1	; Mus + compensations de tempo
	LDB #10			; Tempo de maintien du sprite à l'écran.
	LBSR TEMPO

	LDY #LISTE1		; Y pointe la liste 1 comme buffer de sauvegarde.
	LDX #SCROFFSET+$118A ; X pointe le fond du tir plasma
	LDB #40			; B = 40 pour les sauts de ligne.
	LBSR DISPLAY_2YX_16 ; Restitution du fond

	INC $E7C3		; Sélection vidéo forme.
	LDA >PA_W5		; A = nombre de points d'attaque.
	RTS

; Gestion de l'arme 4 (pistolet mitrailleur)
ATKPL_W4:
	LDA >INVW_MUN2	; A = quantité de cartouches disponibles.
	CMPA #3			; A >= 3 cartouches?
	BCC ATKPL_W4_1	; Oui => ATKPL_W4_1
	CLRA			; Sinon attaque annulée, PA = 0
	RTS

ATKPL_W4_1:
	BSR ATKPL_W3_2	; Affichage d'un tir + son
	BSR ATKPL_W3_2	; Affichage d'un tir + son
	BSR ATKPL_W3_2	; Affichage d'un tir + son
	LDA >PA_W4		; A = nombre de points d'attaque.
	RTS

; Mus + Compensations de tempo.
ATKPL_R1:
	LBSR MUS
ATKPL_R1_1:
	LDA #PLATKTIMER
	STA >ATKPL_TEMP	; Recharge de la tempo d'attaque du joueur
	LBRA DONJON_GAUCHE_R1 ; Compensation de la tempo d'attaque des monstres.

; Gestion de l'arme 3 (revolver)
ATKPL_W3:
	LDA >INVW_MUN2	; A = quantité de cartouches disponibles.
	BNE ATKPL_W3_1	; A <> 0 => ATKPL_W3_1
	CLRA			; Sinon attaque annulée, PA = 0
	RTS

ATKPL_W3_1:
	BSR ATKPL_W3_2	; Affichage d'un tir + son
	LDA >PA_W3		; A = nombre de points d'attaque.
	RTS

ATKPL_W3_2:
	DEC >INVW_MUN2	; Munition - 1
	LDA >INVW_MUN2	; A = nombre de munitions.
	LBSR AFF_INVW_2 ; Mise à jour de l'affichage du nombre de munitions.

	LDX #SCROFFSET+$12CA ; X pointe le fond du tir
	LDY #ATKPL_W3_3	; Y pointe l'appel du tir + son
	LBRA BSPRITE16	; Affichage du tir

ATKPL_W3_3:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LBSR ATKPL_W1_R2 ; Identification des couleurs de fond de flame
	LDX >VARDW6 	; X pointe le fond du tir
	LDA #c30		; A = jaune sur fond gris ou blanc
	EORA >VARDB1
	LBSR DISPLAY_A_6
	LDA #cF3		; A = orange sur fond jaune
	LBSR DISPLAY_A_5

	INC	$E7C3		; Sélection vidéo forme.
	LDX >VARDW6 	; X pointe le fond du tir
	LDY #ATKPL_W3D	; Y pointe les données du tir
	LBSR DISPLAY_YX_11 ; Affichage du tir

	LDY #SON_9MM_D	; Bruit du 9mm.
	BSR ATKPL_R1	; Mus + compensations de tempo
	LDB #10			; Tempo de maintien du sprite à l'écran.
	LBRA TEMPO

; Gestion de l'arme 2 (arbalète lourde)
ATKPL_W2:
	LDA >INVW_MUN1	; A = quantité de carreaux disponibles.
	CMPA #3			; A >= 3 carreaux?
	BCC ATKPL_W2_1
	CLRA			; Sinon attaque annulée, PA = 0
	RTS

ATKPL_W2_1:
	SUBA #3			; Quantité - 3
	STA >INVW_MUN1	; Mise à jour de l'inventaire
	LBSR AFF_INVW_2 ; Mise à jour de l'affichage du nombre de munitions.
	LDX #SCROFFSET+$1189 ; X pointe les carreaux à l'écran.
	LDY #ATKPL_W2_R1 ; Y pointe la routine d'affichage.
	LBSR BSPRITE16	; Affichage du carreau + son + compensation de tempos.
	LDA >PA_W2		; A = nombre de points d'attaque.
	RTS

; Gestion de l'arme 1 (arbalète légère)
ATKPL_W1:
	LDA >INVW_MUN1	; A = quantité de carreaux disponibles.
	BNE ATKPL_W1_1	; A <> 0 => ATKPL_W1_1
	CLRA			; Sinon attaque annulée, PA = 0
	RTS

ATKPL_W1_1:
	DECA			; Quantité - 1
	STA >INVW_MUN1	; Mise à jour de l'inventaire
	LBSR AFF_INVW_2 ; Mise à jour de l'affichage du nombre de munitions.
	LDX #SCROFFSET+$1189 ; X pointe le carreau à l'écran.
	LDY #ATKPL_W1_R1 ; Y pointe la routine d'affichage.
	LBSR BSPRITE16	; Affichage du carreau + son + compensation de tempos.
	LDA >PA_W1		; A = nombre de points d'attaque.
	RTS

; Gestion de l'arme 0 (épée, tronçonneuse ou creuset)
ATKPL_W0:
	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LBSR PAS_AV		; Puis la case G6 devant.
	LDA ,X			; A = code de la case G6.
	ANDA #%01110000 ; A = type de case
	CMPA #%01110000	; Mur ou obstacle?
	BEQ ATKPL_W0_2  ; Oui = pas d'ennemi devant => ATKPL_W0_2

	CMPA #%01000000	; Sol simple occupé ou occupable %100?
	BCS ATKPL_W0_2 	; Non, sol interdit, échelles ou téléporteur => ATKPL_W0_2

	LDA ,X			; A = code de la case G6.
	ANDA #%00001111 ; A = contenu de la case.
	BEQ ATKPL_W0_2 	; Pas d'ennemi => ATKPL_W0_2

	LDY #DEN_A0600	; Y pointe l'adresse écran de la tâche de sang en secteur 06
	ASLA			; A = 2*(n° d'ennemi)
	LDX A,Y			; X = adresse écran de la tâche de sang
	LEAX 4,X		; X = adresse écran du coup de lame.
	BRA ATKPL_W0_3	; => ATKPL_W0_3

ATKPL_W0_2:
	LDX #SCROFFSET+$0A0D ; X pointe l'adresse écran du coup de lame dans le vide.

ATKPL_W0_3:
	PSHS X			; Adresse écran sauvegardée

	LDA >PACKNUM	; A = n° de pack
	BEQ ATKPL_W0_3B	; Pack 0 (tour 1) = épée => ATKPL_W0_3B

	CMPA #1			; Pack 1 (tour 2)?
	BEQ ATKPL_W0_3A	; Oui = tronçonneuse => ATKPL_W0_3A

	LDY #SON_COUP3_D ; Sinon Pack 3 => Y pointe le son du coup du creuset
	LDD #c11FF		; A = rouge sur fond rouge. B = orange sur fond orange.
	BRA ATKPL_W0_5

ATKPL_W0_3A:
	LDY #SON_COUP2_D ; Y pointe le son du coup de tronçonneuse
	BRA ATKPL_W0_4

ATKPL_W0_3B:
	LDY #SON_COUP1_D ; Y pointe le son du coup d'épée

ATKPL_W0_4:
	LDD #c6677		; A = turquoise sur fond turquoise. B = blanc sur fond blanc

ATKPL_W0_5:
	STD >VARDB1		; VARDB1 = A, VARDB2 = B
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	BSR ATKPL_W0_R2 ; Sauvegarde des couleurs de fond et affichage du coup de lame.

	LBSR ATKPL_R1	; Mus + compensations de tempo
	LDB #20			; Tempo de maintien du coup à l'écran.
	LBSR TEMPO

	PULS X			; X pointe de nouveau le coup à l'écran.
	BSR ATKPL_W0_R1 ; Restauration des couleurs de fond du coup de lame.

	INC	$E7C3		; Sélection vidéo forme.
	LDA >PA_W0		; A = nombre de points d'attaque.
	RTS

ATKPL_W0_R1:
	LDB #40			; B = 40 pour les sauts de ligne.
	LDY #LISTE1		; Y pointe la liste 1 pour le buffer de fond.
	BSR ATKPL_W0_R1A
	BSR ATKPL_W0_R1A
	BSR ATKPL_W0_R1A
ATKPL_W0_R1A:
	BSR ATKPL_W0_R1B
ATKPL_W0_R1B:
	LDA ,Y+			; Restauration de l'octet de fond.
	STA ,X
	ABX
	LDA ,Y+			; Restauration de l'octet de fond.
	STA ,X
	ABX
	LDA ,Y+			; Restauration de l'octet de fond.
	STA ,X
	LEAX -41,X		; Colonne à gauche, une ligne plus basse.
	RTS

ATKPL_W0_R2:
	LDU #LISTE1		; U pointe la liste 1 pour le buffer de fond.
	LDB #40			; B = 40 pour les sauts de ligne.
	BSR ATKPL_W0_R2A
	BSR ATKPL_W0_R2A
	BSR ATKPL_W0_R2A
ATKPL_W0_R2A:
	BSR ATKPL_W0_R2B
ATKPL_W0_R2B:
	LDA ,X			; Sauvegarde de l'octet de fond
	STA ,U+
	LDA >VARDB1		; A = couleur 1
	STA ,X
	ABX
	LDA ,X			; Sauvegarde de l'octet de fond
	STA ,U+
	LDA >VARDB2		; A = couleur 2
	STA ,X
	ABX
	LDA ,X			; Sauvegarde de l'octet de fond
	STA ,U+
	LDA >VARDB1		; A = couleur 1
	STA ,X
	LEAX -41,X		; Colonne à gauche, une ligne plus basse.
	RTS

; Routine d'affichage d'un carreau d'arbalette
ATKPL_W1_R1:
	BSR ATKPL_W1_R2	; Identification des couleurs de fond.

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDX >VARDW6		; X pointe le carreau à l'écran
	LDA #c60		; A = turquoise sur fond noir.
	EORA >VARDB1		; A = Turquoise sur fond de mur (trou) ou de sol.
	LBSR DISPLAY_A_3 ; Lignes 1 à 3
	LDA #c30		; A = jaune vif sur fond noir
	EORA >VARDB1		; A = Jaune vif sur fond de mur (trou) ou de sol.
	LBSR DISPLAY_A_4 ; Lignes 4 à 7
	LDA #c30		; A = jaune vif sur fond noir
	EORA >VARDB2		; A = Jaune vif sur fond de sol.
	STA	,X			; Ligne 8
	ABX
	LDA #c30		; A = jaune vif sur fond noir
	EORA >VARDB1		; A = Jaune vif sur fond de mur (trou) ou de sol.
	LBSR DISPLAY_A_4 ; Lignes 9 à 12
	LDA #c37		; A = jaune vif sur fond blanc
	LBSR DISPLAY_A_4 ; Lignes 13 à 16

	INC	$E7C3		; Sélection vidéo forme.
	LEAX -640,X		; X pointe de nouveau le carreau
	LDA #$18
	STA ,X
	ABX
	LDA #$3C
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #$18
	LBSR DISPLAY_A_13 ; Lignes 4 à 16

	LDY #SON_CROSSBOW_D ; Bruit d'un tir.
	LBSR ATKPL_R1	; Mus + compensations de tempo
	LDB #30			; Tempo de maintien du sprite à l'écran.
	LBRA TEMPO

; Routine d'identification des couleurs de fond du carreau
ATKPL_W1_R2:
	LDA >MAPCOULC	; A = Couleurs sol/mur de map courantes.
	ANDA #%00000111	; A = noir sur fond de mur courant.
	STA >VARDB1		; VARDB1 = couleur de mur courante
	LDA >MAPCOULC
	LSLA
	ANDA #%10000000	; A = noir sur sol courant.
	EORA #%10000000
	STA >VARDB2		; VARDB2 = couleur de sol courante

	LDX >SQRADDR	; X pointe la case courante G2 dans la map.
	LDB ,X			; B = code de la case courante.
	ANDB #%01110000	; B = type de la case
	CMPB #%01010000	; Trou dans le sol occupable %101?
	BEQ ATKPL_W1_R2A ; Oui => ATKPL_W1_R2A

	STA >VARDB1		; Sinon VARDB1 = VARDB2 = couleur de sol courante

ATKPL_W1_R2A:
	LDB #40			; B = 40 pour les sauts de ligne.
	RTS

; Routine d'affichage de trois carreaux d'arbalette
ATKPL_W2_R1:
	BSR ATKPL_W1_R2	; Identification des couleurs de fond.

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDX >VARDW6		; X pointe les carreaux à l'écran
	LDA #c60		; A = turquoise sur fond noir.
	EORA >VARDB1		; A = Turquoise sur fond de mur (trou) ou de sol.
	LBSR DISPLAY_2A_3 ; Lignes 1 à 3
	LDA #c30		; A = jaune vif sur fond noir
	EORA >VARDB1		; A = Jaune vif sur fond de mur (trou) ou de sol.
	LBSR DISPLAY_2A_4 ; Lignes 4 à 7
	LDA #c30		; A = jaune vif sur fond noir
	EORA >VARDB2		; A = Jaune vif sur fond de sol.
	STA	,X			; Ligne 8
	STA 1,X
	ABX
	LDA #c30		; A = jaune vif sur fond noir
	EORA >VARDB1		; A = Jaune vif sur fond de mur (trou) ou de sol.
	LBSR DISPLAY_2A_4 ; Lignes 9 à 12
	LDA #c37		; A = jaune vif sur fond blanc
	LBSR DISPLAY_2A_4 ; Lignes 13 à 16

	INC	$E7C3		; Sélection vidéo forme.
	LEAX -640,X		; X pointe la colonne 1
	LDA #$31		; Affichage de la colonne 1
	STA ,X
	ABX
	LDA #$7B
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #$31
	LBSR DISPLAY_A_13
	LEAX -639,X		; X pointe la colonne 2
	LDA #$8C		; Affichage de la colonne 2
	STA ,X
	ABX
	LDA #$DE
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #$8C
	LBSR DISPLAY_A_13

	LDY #SON_CROSSBOW_D ; Bruit d'un tir.
	LBSR ATKPL_R1	; Mus + compensations de tempo
	LDB #30			; Tempo de maintien du sprite à l'écran.
	LBRA TEMPO

; Données
ATKPL_W3D:
	FCB $18
	FCB $18
	FCB $3C
	FCB $3C
	FCB $7E
	FCB $7E
	FCB $18
	FCB $18
	FCB $3C
	FCB $3C
	FCB $3C

;------------------------------------------------------------------------------
; Routine d'affichage d'un sort d'attaque par le joueur.
;
; Cette routine est appelée par DONJON_B. Elle anime les sorts d'attaque par le 
; joueur, en fonction de celui sélectionné dans l'inventaire. Elle retourne le 
; nombre de points d'attaques. Le sort de régénération n'est pas traité ici.
;
; ENTREES : 
; VARDW5 = adresse de destination de l'animation.
; VARDB6 = n° d'ennemi, ou 0 si attaque dans le vide. 
;------------------------------------------------------------------------------
ATKPL_S:
	LDA >INVS_COUR	; A = n° de sort courant (1, 2 ou 3).
	CMPA #2			; Sort 2 = boule de givre?
	BEQ ATKPL_S2	; Oui => ATKPL_W2
	BCS ATKPL_S1	; Non, boule de feu => ATKPL_S1. Sinon antimatière

; Gestion du sort 3 (antimatière)
ATKPL_S3:
	LDA >VARPL_MANA	; A = niveau de mana du joueur
	CMPA #MANA_S3	; >= 20 points de mana?
	BCC ATKPL_S3_1	; Oui => ATKPL_S3_1
	CLRA			; Sinon attaque annulée, PA = 0
	RTS

ATKPL_S3_1:
	SUBA #MANA_S3	; -20 points de mana
	STA >VARPL_MANA
	LDD #ATKPL_S1_D3 ; D = adresse des couleurs.
	BSR	ATKPL_R2	; Animation de la boule + compensations de tempo
	LDA >PA_S3		; A = nombre de points d'attaque.
	RTS

; Gestion du sort 2 (boule de givre)
ATKPL_S2:
	LDA >VARPL_MANA	; A = niveau de mana du joueur
	CMPA #MANA_S2	; >= 15 points de mana?
	BCC ATKPL_S2_1	; Oui => ATKPL_S2_1
	CLRA			; Sinon attaque annulée, PA = 0
	RTS

ATKPL_S2_1:
	SUBA #MANA_S2	; -15 points de mana
	STA >VARPL_MANA
	LDD #ATKPL_S1_D2 ; D = adresse des couleurs.
	BSR	ATKPL_R2	; Animation de la boule + compensations de tempo
	LDA >PA_S2		; A = nombre de points d'attaque.
	RTS

; Gestion du sort 1 (boule de feu)
ATKPL_S1:
	LDA >VARPL_MANA	; A = niveau de mana du joueur
	CMPA #MANA_S1	; >= 10 points de mana?
	BCC ATKPL_S1_1	; Oui => ATKPL_S1_1

ATKPL_S1_0:
	CLRA			; Sinon attaque annulée, PA = 0
	RTS

ATKPL_S1_1:
	SUBA #MANA_S1	; -10 points de mana
	STA >VARPL_MANA
	LDD #ATKPL_S1_D1 ; D = adresse des couleurs.
	BSR	ATKPL_R2	; Animation de la boule + compensations de tempo

	LDA >VARDB6		; Attaque dans le vide?
	BEQ ATKPL_S1_0	; Oui => ATKPL_S1_0

	LDX #DEN_FLAG0	; X pointe les flags des ennemis du pack courant
	LDA A,X			; A = flags de l'ennemi courant
	ANDA #%00001000	; Ennemi immune au feu?
	BNE ATKPL_S1_0	; Oui = attaque annulée => ATKPL_S1_0

	LDA >PA_S1		; Sinon A = nombre de points d'attaque.
	RTS

; Routine d'affichage des sorts de boule d'énergie. X pointe les couleurs.
ATKPL_R2:
	STD >VARDW2		; VARDW2 = adresse des couleurs
	LBSR AFF_BAR	; Mise à jour des barres d'énergie dans l'interface

	LDX #SCROFFSET+$0CB4 ; X pointe la grosse boule d'énegie à l'écran.
	BSR ATKEN_S2_R1	; Affichage de la grosse boule.
	LDY #SON_ATKPLS_D
	LBSR MUS		; Bruitage de l'attaque.
	BSR ATKEN_S2_R2 ; Restitution du fond

	LDX >VARDW5		; X pointe la petite boule à l'écran.
	LDY #BLOOD12_R2	; Y pointe la routine de tempo pour la petite boule d'énergie.
	LBSR ATKEN_S1_R0 ; Affichage de la petite boule d'énergie.

	LDA #PLATKTIMER	; Recharge de la tempo d'attaque du joueur
	STA >ATKPL_TEMP
	LBRA DONJON_GAUCHE_R1 ; Compensation de la tempo d'attaque des monstres.

;------------------------------------------------------------------------------
; ATKEN_S: Routine d'affichage d'une attaque ennemie par boule d'énergie.
;
; ENTREES:
; X pointe l'adresse écran de la petite boule.
; Y pointe le son.
; U pointe les données de couleurs.
;------------------------------------------------------------------------------
ATKEN_S:
	STY >VARDW1		; Sauvegarde du son pour le bruitage de l'attaque.
	STU >VARDW2		; Sauvegarde de l'adresse des couleurs.
	LDY #ATKEN_S1_R3 ; Y pointe la routine de son pour la petite boule d'énergie.
	LBSR ATKEN_S1_R0 ; Dessin de la petite boule avec bruitage.

	LDX #SCROFFSET+$034F ; X pointe l'adresse écran de la grosse boule.
	BSR ATKEN_S2_R1	; Affichage de la grosse boule.
	LDB #50
	LBSR TEMPO		; Tempo puis restitution du fond.

; Restitution du fond de la grosse boule d'énergie.
ATKEN_S2_R2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; Pour les sauts de ligne.
	LDX >VARDW4		; X pointe la boule à l'écran.
	LDY #BUFFER		; Y pointe le buffer de fond.
	LBSR DISPLAY_2YX_48	; Restauration des colonnes 1 et 2.
	LEAX -1918,X
	LBSR DISPLAY_2YX_48	; Restauration des colonnes 3 et 4.
	LEAX -1918,X
	LBSR DISPLAY_2YX_48	; Restauration des colonnes 5 et 6.
	LBRA MAPDECOMP	; Restauration de la map courante + fin.

; Dessin de la grosse boule d'énergie. X pointe la boule à l'écran.
ATKEN_S2_R1:
	STX >VARDW4		; Sauvegarde de l'adresse écran

	LBSR MAPCOMP	; Compression et sauvegarde de la map courante.
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; Pour les sauts de ligne.
	LDX >VARDW4		; X pointe la boule à l'écran.
	LDY #BUFFER		; Y pointe le buffer de fond.
	LBSR BSAVE2_48	; Sauvegarde des colonnes 1 et 2.
	LEAX -1918,X
	LBSR BSAVE2_48	; Sauvegarde des colonnes 3 et 4.
	LEAX -1918,X
	LBSR BSAVE2_48	; Sauvegarde des colonnes 5 et 6.

ATKEN_S2_R1A:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; Pour les sauts de ligne.
	LDX >VARDW4		; X pointe la boule à l'écran.
	LEAX 320,X		; Puis la colonne 1.
	LDU >VARDW2		; U pointe les couleurs.
	LDA ,U
	LBSR DISPLAY_A_32	; Colonne 1
	LEAX -1275,X
	LBSR DISPLAY_A_32	; Colonne 6
	LEAX -1604,X
	LDA ,U
	LBSR DISPLAY_A_16	; Colonne 2
	LDA 1,U
	LBSR DISPLAY_A_16
	LDA ,U
	LBSR DISPLAY_A_16
	LEAX -1919,X
	LDA ,U
	LBSR DISPLAY_2A_8	; Colonnes 3 et 4
	LDA 1,U
	LBSR DISPLAY_2A_8
	LDA 2,U
	LBSR DISPLAY_2A_16
	LDA 1,U
	LBSR DISPLAY_2A_8
	LDA ,U
	LBSR DISPLAY_2A_8
	LEAX -1918,X
	LDA ,U
	LBSR DISPLAY_A_16	; Colonne 5
	LDA 1,U
	LBSR DISPLAY_A_16
	LDA ,U
	LBRA DISPLAY_A_16

; Affichage de la petite boule d'énergie.
; X pointe la boule à l'écran. Y pointe la routine de tempo ou de son.
ATKEN_S1_R0:
	STY >ATKEN_S1_R2+1 ; Adresse automodifiée pour la tempo ou le son de l'attaque.
	LDY #ATKEN_S1_R1 ; Y pointe la routine d'affichage.
	LBRA BSPRITE16	; Affichage de la tâche et fin.

; Routine d'affichage de la petite boule d'énergie.
ATKEN_S1_R1:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDU >VARDW2		; U pointe les couleurs.
	LDA 3,U
	LBSR DISPLAY_2A_4
	LDA 4,U
	LBSR DISPLAY_2A_8
	LDA 3,U
	LBSR DISPLAY_2A_4

	INC $E7C3		; Sélection vidéo forme.
	LEAX -640,X		; X pointe de nouveau la boule à l'écran.
	LDY #L12U_DATA2 ; 8x $F0,$0F
	LBSR DISPLAY_2YX_8
	LEAY -16,Y
	LBSR DISPLAY_2YX_8

ATKEN_S1_R2:
	JMP BLOOD12_R2	; Appel automodifiable pour une tempo ou un son.

; Routine de son pour la petite boule d'énergie.
ATKEN_S1_R3:
	LDY >VARDW1
	LBRA MUS		; Bruitage de l'attaque.

;------------------------------------------------------------------------------
; Données des sorts de boules élémentaires.
;------------------------------------------------------------------------------
; Orange/orange, jaune vif/jaune vif, blanc/blanc (boules de feu)
ATKPL_S1_D1:
	FCB cFF,c33,c77,cF3,c37

; Turquoise/turquoise, bleu ciel/bleu ciel, blanc/blanc (boules de givre)
ATKPL_S1_D2:
	FCB c66,cEE,c77,c6E,cE7

; Noir/noir, blanc/blanc, noir/noir (sphère d'antimatière)
ATKPL_S1_D3:
	FCB c00,c77,c00,c07,c70

;******************************************************************************
;******************************************************************************
;*                   AUTRES ROUTINES GENERALES D'AFFICHAGE                    *
;******************************************************************************
;******************************************************************************

;------------------------------------------------------------------------------
; Routine d'affichage d'une tâche de sang 16x16 pour les ennemis en case G06.
;
; Entrées:
; - X = adresse écran de la tâche de sang.
; - VARDB8 = couleur de la tâche de sang.
;------------------------------------------------------------------------------
; Routine appelée par DONJON_FEU
BLOOD06:
	LDY #BLOOD12_R2	; Y pointe la tempo.

; Routine appelée par SET_STATE_HIT. 
; X pointe la tache à l'écran. Y pointe le son de l'attaque ennemie.
BLOOD06_2:
	STY >BLOOD06_R2+1 ; Adresse automodifiée pour la tempo ou le son de l'attaque.
	LDY #BLOOD06_R1	; Y pointe la routine d'affichage.
	LBRA BSPRITE16	; Affichage de la tâche et fin.

; Routine d'affichage de la tâche de sang.
BLOOD06_R1:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDA >VARDB8		; A = couleurs de la tâche de sang.
	LBSR DISPLAY_2A_16 ; Etablissement des couleurs de la tâche.

	INC	$E7C3		; Sélection vidéo forme.
	LEAX -640,X		; X pointe de nouveau la tâche à l'écran.
	LDY #BLOOD06_DATA ; Y pointe les données de forme de la tâche.
	LBSR DISPLAY_2YX_16	; Affichage de la tâche.

BLOOD06_R2:
	JMP BLOOD12_R2	; Appel automodifiable pour une tempo ou un son.

;------------------------------------------------------------------------------
; Routine d'affichage d'une tâche de sang 8x8 pour les ennemis en cases G12 et 
; en G21.
;
; Entrées:
; - X = adresse écran de la tâche de sang.
; - VARDB8 = couleur de la tâche de sang.
;------------------------------------------------------------------------------
; Routine appelée par DONJON_FEU
BLOOD12:
	LDY #BLOOD12_R1	; Y pointe la routine d'affichage.
	LBRA BSPRITE16	; Affichage de la tâche et fin.

; Routine d'affichage de la tâche de sang.
BLOOD12_R1:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDA >VARDB8		; A = couleurs de la tâche de sang.
	LBSR DISPLAY_A_8 ; Etablissement des couleurs de la tâche.

	INC	$E7C3		; Sélection vidéo forme.
	LEAX -320,X		; X pointe de nouveau la tâche à l'écran.
	LDY #BLOOD12_DATA ; Y pointe les données de forme de la tâche.
	LBSR DISPLAY_YX_8 ; Affichage de la tâche.

BLOOD12_R2:
	LDB #50			; Tempo à réajuster
	LBRA TEMPO

;------------------------------------------------------------------------------
; Données des tâches de sang.
;------------------------------------------------------------------------------
BLOOD06_DATA:
	FCB $39,$9C
	FCB $1D,$B8
	FCB $CF,$F3
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $7F,$FE
	FCB $3F,$FC
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $3F,$FC
	FCB $7F,$FE
	FCB $FF,$FF
	FCB $FF,$FF
	FCB $CF,$F3
	FCB $1D,$B8
	FCB $39,$9C

BLOOD12_DATA:
	FCB $A5
	FCB $7E
	FCB $FF
	FCB $7E
	FCB $7E
	FCB $FF
	FCB $7E
	FCB $A5

;------------------------------------------------------------------------------
; Chargement INIT/PACK pour ED2 par OlivierP-To8
; Juillet 2024
;
; Ce code doit être inclus à ED2.asm avec les données de pistes/secteurs renseignées.
; Le registre DP n'est pas utilisé au cas où il serait différent de $60.
; Voir BootMOTO.asm pour ReadSector_ avec utilisation du registre DP.
;
; ENTREE :
; A = numéro du pack (0 pour la tour Ouest, 1 pour tour Est, 2 pour le portail
; ou 3 pour l'outro).
;------------------------------------------------------------------------------

PACK_LOAD
    ldy #PACK1.DAT      ; infos piste / secteur début / secteur fin
Pack_dats               ; pointe vers le pack passé en paramètre
	ldb #12
	mul                 ; AB = 12 * n° de pack
	leay d,y            ; y pointe les paramètres du pack

Pack_init
    ldd ,y++            ; AB = piste/secteur à lire

    ldx #INITADR        ; X = adresse où charger le secteur
    bsr ReadSector_     ; lecture INIT.DAT
    incb
    cmpb ,y             ; test du secteur suivant avec le secteur de fin
    bgt Pack_end        ; si on a lu le dernier secteur alors fin

    ldx #PACKADR
    bra Pack_loop

Pack_bloc               ; se positionne sur le prochain bloc de 2K (piste/sect.deb./sect.fin.)
    leay 1,y            ; Y pointe sur la piste et le premier secteur
    ldd ,y++            ; AB = piste/secteur à lire

Pack_loop
    bsr ReadSector_     ; lecture PACK.DAT
    leax 256,x          ; X = adresse où charger le secteur

    cmpx #$E000
    beq Pack_end        ; si on arrive à $E000 alors fin de chargement

    incb
    cmpb ,y             ; test du secteur avec le secteur de fin
    bgt Pack_bloc       ; si on a lu le dernier secteur alors on passe au bloc suivant
    bra Pack_loop

Pack_end
    rts

ReadSector_
    pshs a,b

    ; track in A
    sta DKTRK

    ; sector in B
    stb DKSEC

    ; buffer address
    stx DKBUF

    ; read sector command
    lda #$02
    sta DKOPC

    ; call ROM
    jsr DKCO

    puls a,b,pc
	;rts

; séries de 3 octets pour les données à charger organisées en bloc de 2 Ko : piste, secteur début, secteur fin
; les valeurs sont définies par l'outil fdfs :
; addED2Pack INIT1.DAT PACK1.DAT
;   lecture de INIT1.DAT (256 octets) OK
;   lecture de PACK1.DAT (6400 octets) OK
;   ajout bloc 2K ED2 : piste 23 secteur 09-16
;   ajout bloc 2K ED2 : piste 23 secteur 01-08
;   ajout bloc 2K ED2 : piste 22 secteur 09-16
;   ajout bloc 2K ED2 : piste 22 secteur 01-02

PACK1.DAT       ; 4 blocs pour un secteur de $2600 à $26FF et 25 secteurs de $8700 à $9FFF
    FCB 23,9,16
    FCB 23,1,8
    FCB 22,9,16
    FCB 22,1,2

PACK2.DAT       ; 4 blocs pour un secteur de $2600 à $26FF et 25 secteurs de $8700 à $9FFF
    FCB 21,9,16
    FCB 21,1,8
    FCB 19,9,16
    FCB 19,1,2

PACK3.DAT       ; 4 blocs pour un secteur de $2600 à $26FF et 25 secteurs de $8700 à $9FFF
    FCB 18,9,16
    FCB 18,1,8
    FCB 17,9,16
    FCB 17,1,2

ED2FIN.DAT      ; 1 bloc pour un secteur de $2600 à $26FF qui chargera la fin du jeu
    FCB 16,9,9

;------------------------------------------------------------------------------
; Routine de mise à jour de l'interface pour les initialisations.
;------------------------------------------------------------------------------
AFF_INTERFACE:
	LBSR VIDEOF		; Vidéo forme.
	LDX #$4727		; X pointe la minimap
	LDD #$0025		; A = remplissage plein. B = 37 pour les sauts de ligne.
	LBSR G2_R1_16x4	; Effacement de la minimap
	LBSR G2_R1_8x4
	LBSR G2_R1_4x4
	LDB #40			; B = 40 pour les sauts de ligne.
	LBSR AFF_INVW	; Affichage de l'arme courante.
	LBSR AFF_INVS	; Affichage du sort courant.
	LBSR AFF_BAR	; Affichage du niveau de vie et de bouclier.
	LBSR AFF_INVK	; Affichage des clés.
	LBRA AFF_INVO	; Affichage des objets de l'inventaire.

;******************************************************************************
;******************************************************************************
;*                               PACK D'ENNEMIS                               *
;******************************************************************************
;******************************************************************************

;	ORG $C710		; Pack à charger entre $C710 et $D9BF

	IFEQ PACKE-1
		INCLUDE PACKE1.asm	; A sélectionner pour la compilation du pack 1.
	ENDC
	IFEQ PACKE-2
		INCLUDE PACKE2.asm	; A sélectionner pour la compilation du pack 2.
	ENDC
	IFEQ PACKE-3
		INCLUDE PACKE3.asm	; A sélectionner pour la compilation du pack 3.
	ENDC

;******************************************************************************
;******************************************************************************
;*                               PACK DE MAPS                                 *
;******************************************************************************
;******************************************************************************

	ORG $D9C0		; Pack à charger entre $D9C0 et $DEFF

; Les packs de map PACKM1.BIN, PACKM2.BIN et PACKM3.BIN sont générés à l'aide
; du fichier EXCEL PACKMAPS.xlsm

	IFEQ PACKM-1
		INCLUDEBIN ../src/PACKM1.bin	; A sélectionner pour la compilation du pack 1.
	ENDC
	IFEQ PACKM-2
		INCLUDEBIN ../src/PACKM2.bin	; A sélectionner pour la compilation du pack 2.
	ENDC
	IFEQ PACKM-3
		INCLUDEBIN PACKM3TO.bin			; A sélectionner pour la compilation du pack 3.
	ENDC

; =============================================================================
; EVIL DUNGEONS II - DUNGEON CRAWLER POUR MO5 - PACK D'ENNEMIS DE LA TOUR 2.
; Par Christophe PETIT
;
; Ce fichier contient les monstres de la tour 2, avec leurs déclarations, leurs
; sprites et leurs attaques. Il doit être inclu à la fin de ED2.asm avec la
; directive "INCLUDE .\PACKE2.asm", afin d'être compilé. C'est ED2PACK2.vbs qui
; se charge de la compilation et de l'extraction du fichier PACKE2.BIN à partir
; du code compilé ED2PACK2.BIN.
;
; Liste des ennemis du pack:
; E00 : Boss = trooper rouge (modification de E05).
; E01 : Mimique (immitation de coffre).
; E02 : Cerbère.
; E03 : Méduse.
; E04 : Blob.
; E05 : Trooper bleu.
; =============================================================================

; Adresse $8710
E0X_G06:	; Adresses des ennemis et de leur routine de restauration en G06
	FDB CHEST06
	FDB REST06B		; Restauration pour petits ennemis au sol.
	FDB E02_G06
	FDB REST06		; Restauration pour grands ennemis.
	FDB E03_G06
	FDB REST06A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G06
	FDB REST06B		; Restauration pour petits ennemis au sol.
	FDB E05_G06
	FDB REST06		; Restauration pour grands ennemis.	

; Adresse $8724
E0X_G09:	; Adresses des ennemis et de leur routine de restauration en G09
	FDB CHEST09
	FDB REST09B		; Restauration pour petits ennemis au sol.
	FDB E02_G09
	FDB REST09		; Restauration pour grands ennemis.
	FDB E03_G09
	FDB REST09A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G09
	FDB REST09B		; Restauration pour petits ennemis au sol.
	FDB E05_G09
	FDB REST09		; Restauration pour grands ennemis.	

; Adresse $8738
E0X_G10:	; Adresses des ennemis et de leur routine de restauration en G10
	FDB CHEST10
	FDB REST10B		; Restauration pour petits ennemis au sol.
	FDB E02_G10
	FDB REST10		; Restauration pour grands ennemis.
	FDB E03_G10
	FDB REST10A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G10
	FDB REST10B		; Restauration pour petits ennemis au sol.
	FDB E05_G10
	FDB REST10		; Restauration pour grands ennemis.		

; Adresse $874C	
E0X_G12:	; Adresses des ennemis et de leur routine de restauration en G12
	FDB CHEST12
	FDB REST12B		; Restauration pour petits ennemis au sol.
	FDB E02_G12
	FDB REST12		; Restauration pour grands ennemis.
	FDB E03_G12
	FDB REST12A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G12
	FDB REST12B		; Restauration pour petits ennemis au sol.
	FDB E05_G12
	FDB REST12		; Restauration pour grands ennemis.	

; Adresse $8760	
E0X_G14:	; Adresses des ennemis et de leur routine de restauration en G14
	FDB CHEST14
	FDB REST14B		; Restauration pour petits ennemis au sol.
	FDB E02_G14
	FDB REST14		; Restauration pour grands ennemis.
	FDB E03_G14
	FDB REST14A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G14
	FDB REST14B		; Restauration pour petits ennemis au sol.
	FDB E05_G14
	FDB REST14		; Restauration pour grands ennemis.	

; Adresse $8774	
E0X_G15:	; Adresses des ennemis et de leur routine de restauration en G15
	FDB CHEST15
	FDB REST15B		; Restauration pour petits ennemis au sol.
	FDB E02_G15
	FDB REST15		; Restauration pour grands ennemis.
	FDB E03_G15
	FDB REST15A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G15
	FDB REST15B		; Restauration pour petits ennemis au sol.
	FDB E05_G15
	FDB REST15		; Restauration pour grands ennemis.	

; Adresse $8788
E0X_G18:	; Adresses des ennemis et de leur routine de restauration en G18
	FDB CHEST18
	FDB REST18B		; Restauration pour petits ennemis au sol.
	FDB E02_G18
	FDB REST18		; Restauration pour grands ennemis.
	FDB E03_G18
	FDB REST18A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G18
	FDB REST18B		; Restauration pour petits ennemis au sol.
	FDB E05_G18
	FDB REST18		; Restauration pour grands ennemis.	

; Adresse $879C	
E0X_G19:	; Adresses des ennemis et de leur routine de restauration en G19
	FDB CHEST19
	FDB REST19B		; Restauration pour petits ennemis au sol.
	FDB E02_G19
	FDB REST19		; Restauration pour grands ennemis.
	FDB E03_G19
	FDB REST19A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G19
	FDB REST19B		; Restauration pour petits ennemis au sol.
	FDB E05_G19
	FDB REST19B		; Restauration pour le pied gauche du trooper seulement.

; Adresse $87B0	
E0X_G21:	; Adresses des ennemis et de leur routine de restauration en G21
	FDB CHEST21
	FDB REST21B		; Restauration pour petits ennemis au sol.
	FDB E02_G21
	FDB REST21		; Restauration pour grands ennemis.
	FDB E03_G21
	FDB REST21A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G21
	FDB REST21B		; Restauration pour petits ennemis au sol.
	FDB E05_G21
	FDB REST21		; Restauration pour grands ennemis.	

; Adresse $87C4	
E0X_G23:	; Adresses des ennemis et de leur routine de restauration en G23
	FDB CHEST23
	FDB REST23B		; Restauration pour petits ennemis au sol.
	FDB E02_G23
	FDB REST23		; Restauration pour grands ennemis.
	FDB E03_G23
	FDB REST23A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G23
	FDB REST23B		; Restauration pour petits ennemis au sol.
	FDB E05_G23
	FDB REST23		; Restauration pour grands ennemis.	

; Adresse $87D8	
E0X_G24:	; Adresses des ennemis et de leur routine de restauration en G24
	FDB CHEST24
	FDB REST24B		; Restauration pour petits ennemis au sol.
	FDB E02_G24
	FDB REST24		; Restauration pour grands ennemis.
	FDB E03_G24
	FDB REST24A		; Restauration pour ennemis intermédiaires flottants.
	FDB E04_G24
	FDB REST24B		; Restauration pour petits ennemis au sol.
	FDB E05_G24
	FDB REST24B		; Restauration pour le pied gauche du trooper seulement.	

; Adresse $87EC	
E0X_ATK:	; Déclaration des routines d'attaques
	FDB E01_G06_ATKA
	FDB E02_G06_ATKA
	FDB E03_G06_ATKA
	FDB E04_G06_ATKA
	FDB E05_G06_ATKA

; Adresse $87F6	
E0X_12D:	; Déclaration des ennemis en secteur G12 pour les portes fermées
	FDB CHEST12B
	FDB GAME_RTS
	FDB GAME_RTS
	FDB GAME_RTS
	FDB GAME_RTS

;------------------------------------------------------------------------------
; Données des ennemis. 
;------------------------------------------------------------------------------

; Adresse $8800
DEN_FLAG0	FCB %10000001	; Combat distant, non lévitant, mouvant, non immune, toute direction, boss.
DEN_FLAG1	FCB %00000000	; Combat rapproché, non lévitant, mouvant, non immune, toute direction, normal.
DEN_FLAG2	FCB %00001000	; Combat rapproché, non lévitant, mouvant, immune au feu, toute direction, normal.
DEN_FLAG3	FCB %01000011	; Combat distant, lévitant, mouvant, non imumne, frontal uniquement, normal.
DEN_FLAG4	FCB %00000000	; Combat rapproché, non lévitant, mouvant, non immune, toute direction, normal.
DEN_FLAG5	FCB %00000001	; Combat distant, non lévitant, mouvant, non immune, toute direction, normal.
;                |||||||+ 0 = Combat rapproché, 1 = combat distant.
;                ||||||+- 0 = Non lévitant, 1 = lévitant.
;                |||||+-- 0 = Mouvant, 1 = immobile.
;                ||||+--- 0 = Non immune au feu, 1 = immune.
;                |||+---- 0 = Non immune à la glace, 1 = immune (non utilisé dans cette version).
;                ||+----- 0 = Non immune à l'antimatière, 1 = immune (non utilisé dans cette version).
;                |+------ 0 = Toute direction, 1 = frontal uniquement.
;                +------- 0 = Monstre normal. 1 = boss

; Points d'attaque (PA).
DEN_PA00	FCB	14			; (Boss)
DEN_PA01	FCB	7			; (Mimique)
DEN_PA02	FCB	10			; (Cerbère)
DEN_PA03	FCB	10			; (Méduse)
DEN_PA04	FCB	8			; (Blob)
DEN_PA05	FCB	10			; (Trooper bleu)

; Points de vie (PV).
DEN_PV00	FCB	80			; (Boss)
DEN_PV01	FCB	10			; (Mimique)
DEN_PV02	FCB	20			; (Cerbère)
DEN_PV03	FCB	20			; (Méduse)
DEN_PV04	FCB	20			; (Blob)
DEN_PV05	FCB	15			; (Trooper bleu)

; Couleurs de la tâche de sang (COUL).
DEN_COUL00	FCB $50			; magenta (5) sur fond noir (0).
DEN_COUL01	FCB $1B			; rouge (1) sur fond jaune paille (11).
DEN_COUL02	FCB $10			; rouge (1) sur fond noir (0).
DEN_COUL03	FCB $12			; rouge (1) sur fond vert vif (2).
DEN_COUL04	FCB $1D			; rouge (1) sur fond rose (13).
DEN_COUL05	FCB $10			; rouge (1) sur fond noir (0).

; Adresse écran de la tâche de sang en secteur 06
DEN_A0600	FDB SCROFFSET+$055A	; (Boss).
DEN_A0601	FDB SCROFFSET+$0D29	; (Mimique).
DEN_A0602	FDB SCROFFSET+$082A	; (Cerbère)
DEN_A0603	FDB SCROFFSET+$064A	; (Méduse)
DEN_A0604	FDB SCROFFSET+$0D2A	; (Blob)
DEN_A0605	FDB SCROFFSET+$055A	; (Trooper bleu)

; Adresse écran de la tâche de sang en secteur 12
DEN_A1200	FDB SCROFFSET+$0582	; (Boss).
DEN_A1201	FDB SCROFFSET+$0AAA	; (Mimique).
DEN_A1202	FDB SCROFFSET+$082A	; (Cerbère)
DEN_A1203	FDB SCROFFSET+$064A	; (Méduse)
DEN_A1204	FDB SCROFFSET+$0AAA	; (Blob)
DEN_A1205	FDB SCROFFSET+$0582	; (Trooper bleu)

; Adresse écran de la tâche de sang en secteur 21
DEN_A2100	FDB SCROFFSET+$0622	; (Boss).
DEN_A2101	FDB SCROFFSET+$08CA	; (Mimique).
DEN_A2102	FDB SCROFFSET+$06EA	; (Cerbère)
DEN_A2103	FDB SCROFFSET+$064A	; (Méduse)
DEN_A2104	FDB SCROFFSET+$08CA	; (Blob)
DEN_A2105	FDB SCROFFSET+$0622	; (Trooper bleu)

;------------------------------------------------------------------------------
; INIBOSS : Procédure d'initialisation du Boss de fin.
; Transforme un trooper bleu en trooper vert.
;------------------------------------------------------------------------------
INIBOSS:			; Adresse $8800
	LDA #$01		; A = noir sur fond rouge
	STA >E05COUL	; Couleur d'uniforme de E05 modifiée
	
	LDA >DEN_FLAG0
	STA >DEN_FLAG5	; Flags de E05 = flags du boss
	LDA >DEN_PA00
	STA >DEN_PA05	; PA E05 = PA du boss
	LDA >DEN_PV00
	STA >DEN_PV05	; PV E05 = PV du boss
	LDA >DEN_COUL00
	STA >DEN_COUL05	; Tâche de sang E05 = tâche de sang du boss

	RTS

E05COUL	FCB $04		; Couleur E05 normale = noir sur fond bleu

;------------------------------------------------------------------------------
; E01_G06_ATK : Mimique en case G6, position d'attaque.
; E01_G06_ATKA sert aux attaques hors champ et E01_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E01_G06_ATKA:
	LDY #E01_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUS

E01_G06_ATK:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LBSR REST06B	; Restauration des couleurs de fond du coffre en G6
	INC $A7C0		; Sélection vidéo forme.	
	LDA #$FF		; A = formes pleines.
	LBSR REST06B2	; Restauration des formes de fond du coffre en G6

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	BSR E01_G06_ATK_R0 ; Initialisation des couleurs de l'attaque.
	BSR E01_G06_ATK_R1 ; Formes générales de l'attaque.
	LDX #SCROFFSET+$06E9
	LDY #E01_G06_D4		; Y pointe les formes de la langue.
	LBSR DISPLAY_2YX_16	; Affichage de la langue
	LBSR DISPLAY_2YX_6

	BSR E01_G06_ATKA ; Bruitage de l'attaque.
	LDB #40			; Tempo
	LBSR TEMPO		
	CLR >G12D		; Sol G12 marqué comme non affichés. Pas de trous ici.
	CLR >W6D		; W6 marqué comme non affiché.	
	LBSR MASK_W6	; Ainsi que tout ce qu'il y a derrière.

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDA	>MAPCOULC	; A = couleurs mur/sol courantes.
	LDB #24			; Pour les sauts de ligne.
	LDX #SCROFFSET+$0465
	LBSR G2_R1_32x10 ; 48 lignes à réinitialiser.
	LBSR G2_R1_16x10
	
	INC $A7C0		; Sélection vidéo forme.
	LDA #$39		; A = code machine de l'opérande RTS.
	STA >LISTE0		; LISTE0 initialisée avec un RTS (aucun pré-affichage).
	LBRA SET00		; Réaffichage des décors.	

; Couleurs
E01_G06_ATK_R0:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	LDX #SCROFFSET+$0465 ; X pointe l'attaque du mimique à l'écran.	
	LDY #E01_G06_D0	; Y pointe les couleurs	
	BSR E01_G06_ATK_R0A ; Colonnes 1 et 2
	BSR E01_G06_ATK_R0A ; Colonnes 3 et 4
	BSR E01_G06_ATK_R0A ; Colonnes 5 et 6
	BSR E01_G06_ATK_R0A ; Colonnes 7 et 8
E01_G06_ATK_R0A:	 ; Colonnes 9 et 10
	LBSR L12U_R2_14 ; Lignes 1 à 14
	LBSR DISPLAY_2A_16 ; Lignes 15 à 30
	STA ,X
	STA 1,X			; Ligne 31
	ABX
	LBSR L12U_R2_14 ; Lignes 32 à 45
	LDA ,Y
	STA ,X			; Ligne 46
	STA 1,X	
	LEAX -1798,X	; X pointe les deux colonnes suivantes.
	LEAY -28,Y		; Y pointe de nouveau les couleurs.		
	RTS

; Formes générales
E01_G06_ATK_R1:
	INC $A7C0		; Sélection vidéo forme
	LDX #SCROFFSET+$0465 ; X pointe l'attaque du mimique à l'écran.
	BSR E01_G06_ATK_R2A	; Colonnes 1, 2 et 3
	LDY #E01_G06_D1
	BSR E01_G06_ATK_R2C	; Colonne 4
	LDY #E01_G06_D2	
	BSR E01_G06_ATK_R2C	; Colonne 5
	BSR E01_G06_ATK_R2B	; Colonnes 6,7 + 8, 9, 10
E01_G06_ATK_R2A:	
	LDY #E01_G06_D1	
	BSR E01_G06_ATK_R2C
E01_G06_ATK_R2B:	
	LDY #E01_G06_D2
	BSR E01_G06_ATK_R2C
	LDY #E01_G06_D3
E01_G06_ATK_R2C:
	LDA ,Y+
	LBSR DISPLAY_A_5	; Lignes 1 à 5
	LBSR DISPLAY_YX_8	; Lignes 6 à 13
	CLRA
	LBSR DISPLAY_A_18	; Lignes 14 à 31
	LBSR DISPLAY_YX_5	; Lignes 32 à 36
	LDA ,Y+
	LBSR DISPLAY_A_8	; Lignes 37 à 44
	LDA ,Y
	STA	,X				; Ligne 45
	ABX
	STA	,X				; Ligne 46
	LEAX -1799,X		; Colonne suivante
	RTS

;------------------------------------------------------------------------------
; DONNEES DU MIMIQUE
;------------------------------------------------------------------------------
E01_G06_SON_DATA:
	FCB O4,A4,T3,L5,DO,FA,SI,O5,RE,P,FIN

E01_G06_D0:
	FCB $7F			; Couleurs des colonnes
	FCB $7F
	FCB $B1
	FCB $BF
	FCB $3F
	FCB $3F
	FCB $31
	FCB $3F
	FCB $33
	FCB $33
	FCB $07
	FCB $07
	FCB $07
	FCB $50
	FCB $07
	FCB $07
	FCB $07
	FCB $33
	FCB $3F
	FCB $31
	FCB $BF
	FCB $BF
	FCB $BF
	FCB $B1
	FCB $BF
	FCB $BF
	FCB $3F
	FCB $31
	FCB $3B

E01_G06_D1:
	FCB $E0		; Formes des colonnes 1, 4 et 8
	FCB $F0
	FCB $F8
	FCB $F8
	FCB $FF
	FCB $FF
	FCB $81
	FCB $C3
	FCB $E7
	FCB $E7
	FCB $C3
	FCB $81
	FCB $FF
	FCB $F8
	FCB $E0
	FCB $F8

E01_G06_D2:
	FCB $00		; Formes des colonnes 2, 5, 6, 8
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $81
	FCB $C3
	FCB $E7
	FCB $E7
	FCB $C3
	FCB $81
	FCB $00
	FCB $00
	FCB $00
	FCB $00

E01_G06_D3:
	FCB $07		; Formes des colonnes 3, 7, 10
	FCB $0F
	FCB $1F
	FCB $1F
	FCB $FF
	FCB $FF
	FCB $81
	FCB $C3
	FCB $E7
	FCB $E7
	FCB $C3
	FCB $81
	FCB $FF
	FCB $1F
	FCB $07
	FCB $1F

E01_G06_D4:		; Formes de la langue et de la serrure
	FCB $3F,$E0
	FCB $7F,$F8
	FCB $FF,$FC
	FCB $FF,$FE
	FCB $FF,$FE
	FCB $7F,$FF
	FCB $1F,$FF
	FCB $07,$FF
	FCB $03,$FE
	FCB $03,$FC
	FCB $03,$F8
	FCB $07,$F0
	FCB $0F,$C0
	FCB $1F,$00
	FCB $00,$00
	FCB $E7,$E7
	FCB $C3,$C3
	FCB $81,$81
	FCB $FF,$FF
	FCB $07,$E0
	FCB $07,$E0
	FCB $07,$E0

;------------------------------------------------------------------------------
; E02_G06_ATK : Cerbère en case G6, animation de l'attaque
; E02_G06_ATKA sert aux attaques hors champ et E02_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E02_G06_ATKA:
	LDY #E02_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUS

E02_G06_ATK:
	LDU #ATKPL_S1_D1	; U pointe les couleurs de la boule de feu.
	LDX #SCROFFSET+$0992 ; X pointe la 1ère boule d'énergie.
	LDY #E02_G06_SON_DATA ; Y pointe le bruitage
	LBRA ATKEN_S		; Affichage de l'attaque + fin.

;------------------------------------------------------------------------------
; E02_G06 : Cerbère en case G6, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G06:
	LDB #$70		; B = blanc sur fond noir
	LDA >W6D		; Le mur W6 est-il affiché?
	BNE	E02_G06_1	; Si oui => E02_G06_1

	LDB #$80		; B = gris sur fond noir
	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E02_G06_1	; Si oui => E02_G06_1
	
	LDB #$18		; B = rouge sur fond gris.
	LDA >W24D		; Le mur W24 est-il affiché?
	BNE	E02_G06_0	; Si oui => E02_G06_0.

	LDB #$10		; Sinon fond B24 : B = rouge sur fond noir.	

E02_G06_0:
	STB >VARDB1
	LDB #$80		; B = gris sur fond noir.
	STB >VARDB3

	LDB #$17		; B = rouge sur fond blanc.
	LDA >W49D		; Le mur W49 est-il affiché?
	BNE E02_G06_2	; Si oui => E02_G06_2
	
	INCB			; B = $18 = rouge sur fond gris.
	LDA >W25D		; Le mur W25 est-il affiché?
	BNE E02_G06_2	; Si oui => E02_G06_2.

	LDB #$10		; Sinon fond B25 : B = rouge sur fond noir.
	BRA E02_G06_2

E02_G06_1:
	STB >VARDB3
	LDB #$17		; B = rouge sur fond blanc.
	STB >VARDB1	

; Couleurs du corps principal
E02_G06_2:
	STB >VARDB2
	CLR >G6D 		; Pour la restitution des décors.
	CLR >CH6D
	CLR >W6D
	LBSR MASK_W6B

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	LDX #SCROFFSET+$05FA ; X pointe la colonne 3
	LDA >VARDB1
	STA ,X				; 1
	ABX
	STA ,X				; 2
	ABX	
	LDY #E02_G06_DATA_C3 ; Y pointe les couleurs
	LDA ,Y+
	LBSR DISPLAY_A_8	; 3 à 8
	LBSR DISPLAY_YX_16	; 11 à 26
	LBSR DISPLAY_YX_5	; 27 à 31
	LDA ,Y+
	LBSR DISPLAY_A_16	; 32 à 47
	LDA ,Y+
	LBSR DISPLAY_A_13	; 48 à 60	
	LDA ,Y
	LBSR DISPLAY_A_4	; 61 à 64
	BSR E02_G06_R1		; Colonnes 1 et 5
	BSR E02_G06_R2		; Colonnes 2 et 4	

	INC $A7C0			; Sélection vidéo forme.
	LDY #E02_G06_DATA_F12 ; Y pointe les formes.
	LDX #SCROFFSET+$0671 ; X pointe la colonne 2
	LBSR DISPLAY_YX_7	; 4 à 10
	LEAX -1,X
	LBSR DISPLAY_2YX_48 ; 11 à 58
	LBSR DISPLAY_2YX_8  ; 59 à 66
	LDX #SCROFFSET+$05FA ; X pointe la colonne 3
	LBSR DISPLAY_YX_48	; 1 à 48
	LBSR DISPLAY_YX_16	; 49 à 64
	LDX #SCROFFSET+$0673 ; X pointe la colonne 4
	LBSR DISPLAY_YX_7	; 4 à 10
	LBSR DISPLAY_2YX_48 ; 11 à 58
	LBRA DISPLAY_2YX_8  ; 59 à 66	

E02_G06_R1:
	LDX #SCROFFSET+$0788 ; X pointe la colonne 1
	LDA >VARDB1
	BSR E02_G06_R1_1
	LDX #SCROFFSET+$078C ; X pointe la colonne 5
	LDA >VARDB2	
E02_G06_R1_1:
	LDY #E02_G06_DATA_C1 ; Y pointe les couleurs
	STA ,X				; 11
	ABX
	STA ,X				; 12
	ABX
	LBSR DISPLAY_YX_16	; 13 à 28	
	LBSR DISPLAY_YX_5	; 29 à 33
	LDA >VARDB3
	LBSR DISPLAY_A_9	; 34 à 42
	LDA ,Y+
	LBSR DISPLAY_A_11	; 43 à 53
	LBRA DISPLAY_YX_13	; 54 à 66	

E02_G06_R2:
	LDX #SCROFFSET+$0671 ; X pointe la colonne 2
	LDA #$10
	BSR E02_G06_R2_1
	LDX #SCROFFSET+$0673 ; X pointe la colonne 4
	LDA #$80
E02_G06_R2_1:
	PSHS A
	LDA >VARDB1
	LBSR DISPLAY_A_3	; 4 à 6
	LDA #$10
	STA ,X				; 7
	ABX
	STA ,X				; 8
	ABX
	PULS A
	LBSR DISPLAY_A_6	; 9 à 14	
	LDY #E02_G06_DATA_C2 ; Y pointe les couleurs
	LBSR DISPLAY_YX_16	; 15 à 30
	LBSR DISPLAY_YX_7	; 31 à 37
	LDA ,Y+
	LBSR DISPLAY_A_19	; 38 à 56
	LDA ,Y+
	LBSR DISPLAY_A_9	; 57 à 65
	LDA ,Y
	STA ,X
	RTS

;------------------------------------------------------------------------------
; E02_G14 : Cerbère en case G14, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G14:
	LDB #$17		; B = rouge sur fond blanc.
	BSR E02_G14_INI	; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0718 ; X pointe la colonne gauche
	LBSR E02_G09_2
	LDX #SCROFFSET+$06A1 ; X pointe la colonne du milieu
	LBRA E02_G10A	

; Routine commune avec E03_14
E02_G14_INI:
	LDA >W15D		; Le mur W15 est-il affiché?
	BNE	E02_G14_IN2 ; Si oui => E02_G14_IN2

	LDA >W43D		; Le mur W43 est-il affiché?
	BNE	E02_G14_IN2 ; Si oui => E02_G14_IN2

	INCB			; B = $x8 = fond gris.
	LDA >W28D		; Le mur W28 est-il affiché?
	BNE	E02_G14_IN2 ; Si oui => E02_G14_IN2

	ANDB #%11110000	; Sinon B28 : B = $x0 = fond noir.	

E02_G14_IN2:
	STB >VARDB1
	LBRA MASK_W7	; Pour la restauration des décors.

;------------------------------------------------------------------------------
; E02_G12 : Cerbère en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G12:
	LDB #$17		; B = rouge sur fond blanc.
	BSR E02_G12_INI	; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0711 ; X pointe la colonne gauche
	BSR E02_G09_2
	LDX #SCROFFSET+$069A ; X pointe la colonne du milieu
	LBSR E02_G10A
	LDX #SCROFFSET+$0713 ; X pointe la colonne de droite
	LBRA E02_G10B

; Routine commune avec E03_12
E02_G12_INI:
	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E02_G12_IN2	; Si oui => E02_G12_IN2

	INCB			; B = $x8 = fond gris.
	LDA >W24D		; Le mur W24 est-il affiché?
	BNE	E02_G12_IN2	; Si oui => E02_G12_IN2
	
	ANDB #%11110000	; Sinon B24 : B = $x0 = fond noir.

E02_G12_IN2:
	STB >VARDB1
	CLR >G12D	 	; Pour les restitutions de décors.
	CLR >H12D
	CLR >CH12D
	CLR >W13D
	LBRA MASK_W13B

;------------------------------------------------------------------------------
; E02_G09 : Cerbère en case G9, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G09:
	LDB #$17		; B = rouge sur fond blanc.
	BSR E02_G09_INI	; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0709 ; X pointe E02_G09

; Routine commune avec E02_G12 et E02_G14
E02_G09_2:
	BSR E02_G09_R1

; Routine commune avec E02_G10B
E02_G09_3:
	INC $A7C0			; Sélection vidéo forme.
	LEAX -1400,X		; X pointe de nouveau E02_G09.
	LBSR DISPLAY_YX_32	; Lignes 5 à 36
	LDA ,Y+
	STA ,X				; Ligne 37
	ABX	
	LDA ,Y
	STA ,X				; Ligne 38	
	RTS

; Routine commune avec E02_G10B
E02_G09_R1:
	LBSR VIDEOC_B		; Sélection vidéo couleur.
	LDB #40				; B = 40 pour les sauts de ligne.
	LDY #E02_G09_DATA	; Y pointe les données de couleur
	LDA >VARDB1	
	STA ,X				; Ligne 4
	ABX
	LBSR DISPLAY_YX_16	; Lignes 5 à 20
	LDA ,Y+
	STA ,X				; Ligne 21
	ABX
	LDA ,Y+
	LBSR DISPLAY_A_9	; Lignes 22 à 30
	LBRA DISPLAY_YX_8	; Lignes 31 à 38

; Routine commune avec E03_09
E02_G09_INI:
	LDA >W32D		; Le mur W32 est-il affiché?
	BNE	E02_G09_IN2	; Si oui => E02_G09_IN2

	LDA >W10D		; Le mur W10 est-il affiché?
	BNE	E02_G09_IN2	; Si oui => E02_G09_IN2

	INCB			; B = $x8 = fond gris.
	LDA >W19D		; Le mur W19 est-il affiché?
	BNE	E02_G09_IN2	; Si oui => E02_G09_IN2

	ANDB #%11110000	; Sinon B19 : B = $x0 = fond noir.

E02_G09_IN2:
	STB >VARDB1
	CLR >G9D		; Pour la restitution des décors.
	LBRA MASK_W4B	; MASK_W4B = CLR >W10D et tout ce qu'il y a derrière W10

;------------------------------------------------------------------------------
; E02_G10 : Cerbère en case G10, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G10:
	LDB #$17		; B = rouge sur fond blanc.
	BSR E02_G10_INI	; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0692 ; X pointe la colonne du milieu
	BSR E02_G10A	; Affichage
	LDX #SCROFFSET+$070B ; X pointe la colonne de droite + affichage

; Colonne de droite, commune avec E02_G12 et E02_G15
E02_G10B:
	BSR E02_G09_R1		; Affichage des couleurs
	LDY #E02_G10B_DATA	; Y pointe les données de forme
	LBRA E02_G09_3		; Affichage des formes.

; Colonne du milieu, commune avec E02_G12 et E02_G14
E02_G10A:
	LBSR VIDEOC_A		; Sélection vidéo couleur.
	LDB #40				; B = 40 pour les sauts de ligne.
	LDY #E02_G10A_DATA	; Y pointe les données de couleur
	LDA >VARDB1
	STA ,X				; Ligne 1
	ABX	
	LBSR DISPLAY_YX_16	; Lignes 2 à 17
	LDA ,Y+
	STA ,X				; Ligne 18
	ABX		
	LDA ,Y+
	LBSR DISPLAY_A_11	; Lignes 19 à 29
	LDA ,Y+
	LBSR DISPLAY_A_6	; Lignes 30 à 35
	LDA ,Y+
	STA ,X				; Ligne 36
	ABX
	STA ,X				; Ligne 37

	INC $A7C0			; Sélection vidéo forme.
	LEAX -1440,X		; X pointe de nouveau E02_G10A.	
	LBSR DISPLAY_YX_32	; Lignes 1 à 32
	LBRA DISPLAY_YX_5	; Lignes 33 à 37

; Routine commune avec E03_10
E02_G10_INI:
	LDA >W11D		; Le mur W11 est-il affiché?
	BNE	E02_G10_IN2	; Si oui => E02_G10_IN2

	LDA >W33D		; Le mur W33 est-il affiché?
	BNE	E02_G10_IN2	; Si oui => E02_G10_IN2

	INCB			; B = $x8 = fond gris.
	LDA >W20D		; Le mur W20 est-il affiché?
	BNE	E02_G10_IN2	; Si oui => E02_G10_IN2

	ANDB #%11110000	; Sinon B20 : B = $x0 = fond noir.

E02_G10_IN2:
	STB >VARDB1
	LBRA MASK_W5	; Pour la restauration des décors.

;------------------------------------------------------------------------------
; E02_G15 : Cerbère en case G15, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G15:
	LDB #$17		; B = rouge sur fond blanc.
	BSR E02_G15_INI	; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$071A ; X pointe E02_G15
	BRA E02_G10B

; Routine commune avec E03_15
E02_G15_INI:
	LDA >W16D		; Le mur W16 est-il affiché?
	BNE	E02_G15_IN2	; Si oui => E02_G15_IN2

	LDA >W42D		; Le mur W42 est-il affiché?
	BNE	E02_G15_IN2	; Si oui => E02_G15_IN2

	INCB			; B = $x8 = fond gris.
	LDA >W29D		; Le mur W29 est-il affiché?
	BNE	E02_G15_IN2	; Si oui => E02_G15_IN2

	ANDB #%11110000	; Sinon B29 : B = $x0 = fond noir.

E02_G15_IN2:
	STB >VARDB1
	CLR >G15D		; Pour la restitution des décors
	CLR >H15D
	CLR >CH15D
	CLR >W16D
	LBRA MASK_W16

;------------------------------------------------------------------------------
; E02_G24 : Cerbère en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G24:
	LDA #$18		; A = rouge sur fond gris.
	BSR E02_G24_INI	; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0627 ; X pointe E02_G24.
	BRA E02_G19_2

; Routine commune avec E03_24 et E05_24
E02_G24_INI:
	LDB >W27D		; Le mur W27 est-il affiché?
	BNE	E02_G24_IN2	; Si oui => E02_G24_IN2

	ANDA #%11110000	; Sinon B27 : A = $x0 = fond noir.

E02_G24_IN2:
	STA >VARDB1
	CLR >G24D		; Pour la restitution des décors
	CLR >W27D
	CLR >B27D
	CLR >B27DRD
	RTS

;------------------------------------------------------------------------------
; E02_G23 : Cerbère en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G23:
	LDA #$18		; A = rouge sur fond gris.
	BSR E02_G23_INI ; Identification des fonds + réinitialisation des décors. 

	LDX #SCROFFSET+$0626 ; X pointe E02_G23.
	BRA E02_G18_2

; Routine commune avec E03_23 et E05_23
E02_G23_INI:
	LDB >W26D		; Le mur W26 est-il affiché?
	BNE	E02_G23_IN2	; Si oui => E02_G23_IN2

	ANDA #%11110000	; Sinon B26 : A = $x0 = fond noir.

E02_G23_IN2:
	STA >VARDB1
	LBRA MASK_W14	; Pour la restauration des décors.

;------------------------------------------------------------------------------
; E02_G19 : Cerbère en case G19, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G19:
	LDA #$18		; A = rouge sur fond gris.
	BSR E02_G19_INI ; Identification des fonds + réinitialisation des décors. 
	
	LDX #SCROFFSET+$061D ; X pointe E02_G19.

; Routine commune avec E02_G21 et E02_G25
E02_G19_2:
	BSR E02_G18_R0
	LDY #E02_G19_DATA	; Y pointe les données de forme
	LBSR DISPLAY_YX_16	; Lignes 1 à 16
	LBRA DISPLAY_YX_9	; Lignes 17 à 25

; Routine commune avec E03_19 et E05_19
E02_G19_INI:
	LDB >W22D		; Le mur W22 est-il affiché?
	BNE	E02_G19_IN2	; Si oui => E02_G19_IN2

	ANDA #%11110000	; Sinon B22 : A = $x0 = fond noir.

E02_G19_IN2:
	STA >VARDB1
	LBRA MASK_W12	; Pour la restauration des décors.

;------------------------------------------------------------------------------
; E02_G18 : Cerbère en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G18:
	LDA #$18		; A = rouge sur fond gris.
	BSR E02_G18_INI ; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$061C ; X pointe E02_G18.

; Routine commune avec E02_G21 et E02_G24
E02_G18_2:
	BSR E02_G18_R0
	LBSR DISPLAY_YX_16	; Lignes 1 à 16
	LBRA DISPLAY_YX_9	; Lignes 17 à 25

E02_G18_R0:
	LDY #E02_G18_DATA	; Y pointe les données de couleur
	LBSR VIDEOC_B		; Sélection vidéo couleur.
	LDB #40				; B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_2	; Lignes 1 à 2
	LBSR DISPLAY_YX_16	; Lignes 3 à 18
	LBSR DISPLAY_YX_7	; Lignes 19 à 25
	LEAX -1000,X
	INC $A7C0			; Sélection vidéo forme.	
	RTS

; Routine commune avec E03_18 et E05_18
E02_G18_INI:
	LDB >W21D		; Le mur W21 est-il affiché?
	BNE	E02_G18_IN2	; Si oui => E02_G18_IN2

	ANDA #%11110000	; Sinon B21 : A = $x0 = fond noir.

E02_G18_IN2:
	STA >VARDB1
	CLR >G18D		; Pour la restauration des décors.
	CLR >W21D
	CLR >B21D
	CLR >B21GAD	
	RTS	

;------------------------------------------------------------------------------
; E02_G21 : Cerbère en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G21:
	LDA #$18		; A = rouge sur fond gris.
	BSR E02_G21_INI ; Identification des fonds + réinitialisation des décors.
	
	LDX #SCROFFSET+$0622 ; X pointe E02_G21 colonne 2.	
	BSR E02_G19_2
	LDA >VARDB1
	LDX #SCROFFSET+$0621 ; X pointe E02_G21 colonne 1.	
	BRA E02_G18_2

; Routine commune avec E03_21 et E05_21
E02_G21_INI:
	LDB >W24D		; Le mur W24 est-il affiché?
	BNE	E02_G21_IN2	; Si oui => E02_G21_IN2

	ANDA #%11110000	; Sinon B24 : A = $x0 = fond noir.

E02_G21_IN2:
	STA >VARDB1
	LBRA MASK_W13B	; Pour la restitution des décors.

;------------------------------------------------------------------------------
; DONNEES DES CERBERES
;------------------------------------------------------------------------------
E02_G06_SON_DATA:
	FCB O4,A5,T4,L3,DO,FA,SI,P,FIN

E02_G06_DATA_C3:
	FCB $1B		; Couleurs colonne 3

	FCB $01
	FCB $08
	FCB $80
	FCB $08
	FCB $10
	FCB $10
	FCB $08
	FCB $80
	FCB $01
	FCB $01
	FCB $08
	FCB $88
	FCB $80
	FCB $77
	FCB $07
	FCB $07
	FCB $01
	FCB $1D
	FCB $17
	FCB $07
	FCB $07

	FCB $80
	FCB $10
	FCB $18

E02_G06_DATA_C1:
	FCB $1B		; Couleurs communes colonnes 1 et 5
	FCB $1B
	FCB $1B
	FCB $1B
	FCB $10
	FCB $10
	FCB $10
	FCB $10
	FCB $10
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $10
	FCB $10
	FCB $80
	FCB $80
	FCB $80
	FCB $80

	FCB $81

	FCB $1B
	FCB $1B
	FCB $1B
	FCB $1B
	FCB $1B
	FCB $1B
	FCB $1B
	FCB $10
	FCB $10
	FCB $10
	FCB $10
	FCB $10
	FCB $81

E02_G06_DATA_C2:
	FCB $10
	FCB $10
	FCB $10
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $10
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $70
	FCB $70
	FCB $80
	FCB $70
	FCB $70

	FCB $80
	FCB $10
	FCB $18	

E02_G06_DATA_F12:
	FCB     $21		; Formes des colonnes 1 et 2
	FCB     $35
	FCB     $77
	FCB     $FD
	FCB     $F8
	FCB     $F8
	FCB     $F0
	FCB $18,$F0
	FCB $5D,$F0
	FCB $F7,$F0
	FCB $EB,$F0
	FCB $D9,$73
	FCB $DD,$63
	FCB $7F,$20
	FCB $7F,$08
	FCB $3E,$8D
	FCB $3E,$8D
	FCB $18,$05
	FCB $47,$C4
	FCB $5F,$A4
	FCB $43,$62
	FCB $5D,$E2
	FCB $63,$82
	FCB $40,$02
	FCB $1C,$10
	FCB $0C,$E2
	FCB $01,$52
	FCB $91,$F1
	FCB $90,$01
	FCB $88,$F0
	FCB $C0,$A8
	FCB $C0,$01
	FCB $E0,$A8
	FCB $E0,$F0
	FCB $F0,$01
	FCB $F0,$E3
	FCB $F8,$87
	FCB $FC,$0D
	FCB $FF,$7F
	FCB $FF,$7E
	FCB $FF,$7F
	FCB $FF,$7F
	FCB $FF,$7F
	FCB $FF,$BF
	FCB $EF,$BF
	FCB $EF,$BE
	FCB $EB,$BC
	FCB $CB,$BC
	FCB $C2,$BC
	FCB $80,$B8
	FCB $EF,$78
	FCB $EF,$78
	FCB $ED,$78
	FCB $E5,$72
	FCB $C1,$75
	FCB $CB,$72
	FCB $DF,$75
	FCB $FE,$F3
	FCB $FC,$97
	FCB $E1,$6F
	FCB $D5,$6F
	FCB $C0,$0F
	FCB $80,$FE

E02_G06_DATA_F3:
	FCB $24			; Formes colonne 3
	FCB $AE
	FCB $FB
	FCB $EB
	FCB $E3
	FCB $C9
	FCB $8D
	FCB $9D
	FCB $DF
	FCB $FF
	FCB $BD
	FCB $C3
	FCB $DB
	FCB $C3
	FCB $81
	FCB $81
	FCB $99
	FCB $99
	FCB $BD
	FCB $99
	FCB $E7
	FCB $FF
	FCB $81
	FCB $FF
	FCB $A5
	FCB $BD
	FCB $81
	FCB $C3
	FCB $BD
	FCB $BD
	FCB $81
	FCB $7E
	FCB $FF
	FCB $42
	FCB $28
	FCB $55
	FCB $AA
	FCB $FF
	FCB $F7
	FCB $FF
	FCB $F7
	FCB $FF
	FCB $B5
	FCB $52
	FCB $A5
	FCB $C3
	FCB $81
	FCB $18
	FCB $3C
	FCB $3C
	FCB $7E
	FCB $7E
	FCB $BA
	FCB $55
	FCB $AA
	FCB $55
	FCB $AA
	FCB $7F
	FCB $FF
	FCB $FF
	FCB $C1
	FCB $80
	FCB $00
	FCB $00

E02_G06_DATA_F45:
	FCB $90			; Formes des colonnes 4 et 5
	FCB $DA
	FCB $FB
	FCB $BD
	FCB $1D
	FCB $40
	FCB $62
	FCB $26,$A6
	FCB $C2,$EE
	FCB $26,$DB
	FCB $02,$AB
	FCB $C0,$B5
	FCB $80,$B7
	FCB $00,$FE
	FCB $10,$FE
	FCB $B1,$7C
	FCB $B1,$7C
	FCB $A0,$18
	FCB $23,$E2
	FCB $21,$FA
	FCB $46,$C2
	FCB $47,$BA
	FCB $41,$C6
	FCB $40,$02
	FCB $08,$38
	FCB $47,$30
	FCB $4A,$80
	FCB $8F,$89
	FCB $80,$09
	FCB $0F,$11
	FCB $15,$03
	FCB $80,$03
	FCB $15,$07
	FCB $0F,$07
	FCB $50,$0F
	FCB $CE,$0F
	FCB $A7,$1F
	FCB $F0,$3F
	FCB $BE,$FF
	FCB $7E,$FF
	FCB $FE,$FF
	FCB $FE,$FF
	FCB $FE,$FF
	FCB $FD,$FF
	FCB $FD,$EF
	FCB $7D,$EF
	FCB $3D,$CB
	FCB $3D,$CB
	FCB $3D,$41
	FCB $1D,$00
	FCB $1E,$F7
	FCB $1E,$D3
	FCB $1E,$D3
	FCB $0E,$83
	FCB $AE,$A5
	FCB $4E,$AD
	FCB $AE,$ED
	FCB $CF,$7F
	FCB $E9,$3F
	FCB $F6,$87
	FCB $F6,$AB
	FCB $F0,$03
	FCB $7F,$01

E02_G09_DATA:
	FCB $1B		; Couleurs
	FCB $1B
	FCB $10
	FCB $10
	FCB $10
	FCB $10
	FCB $00
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $10
	FCB $80
	FCB $80
	FCB $70
	FCB $80
	FCB $70
	FCB $80
	
	FCB $81
	FCB $1B
	FCB $1B
	FCB $1B
	FCB $10
	FCB $10
	FCB $10
	FCB $81

	FCB $6B		; Formes
	FCB $DD
	FCB $AB
	FCB $FF
	FCB $FB
	FCB $79
	FCB $38
	FCB $FF
	FCB $5C
	FCB $4A
	FCB $F4
	FCB $80
	FCB $31
	FCB $04
	FCB $4E
	FCB $0D
	FCB $20
	FCB $0D
	FCB $86
	FCB $E0
	FCB $F0
	FCB $FB
	FCB $FD
	FCB $FD
	FCB $FB
	FCB $FB
	FCB $FB
	FCB $91
	FCB $DB
	FCB $A9
	FCB $B7
	FCB $F0
	FCB $CA
	FCB $C0
	FCB $80

E02_G10A_DATA:
	FCB $1B		; Couleurs
	FCB $1B
	FCB $1B
	FCB $01
	FCB $01
	FCB $00
	FCB $08
	FCB $08
	FCB $01
	FCB $80
	FCB $80
	FCB $87
	FCB $07
	FCB $80
	FCB $81
	FCB $81
	FCB $87

	FCB $80
	FCB $01
	FCB $18

	FCB $5A		; Formes
	FCB $F7
	FCB $A9
	FCB $ED
	FCB $81
	FCB $C3
	FCB $FF
	FCB $C3
	FCB $E7
	FCB $99
	FCB $81
	FCB $DB
	FCB $C3
	FCB $DB
	FCB $81
	FCB $C3
	FCB $A5
	FCB $C3
	FCB $7E
	FCB $2A
	FCB $54
	FCB $2A
	FCB $77
	FCB $FF
	FCB $D5
	FCB $E7
	FCB $C3
	FCB $81
	FCB $81
	FCB $EB
	FCB $D7
	FCB $EB
	FCB $D7
	FCB $83
	FCB $01
	FCB $C3
	FCB $81

E02_G10B_DATA:
	FCB $6D		; Formes
	FCB $DB
	FCB $AD
	FCB $BF
	FCB $1F
	FCB $1E
	FCB $1C
	FCB $00
	FCB $3A
	FCB $52
	FCB $2F
	FCB $01
	FCB $8C
	FCB $20
	FCB $72
	FCB $B0
	FCB $04
	FCB $B0
	FCB $61
	FCB $07
	FCB $0F
	FCB $DF
	FCB $BF
	FCB $BF
	FCB $DF
	FCB $DF
	FCB $DF
	FCB $91
	FCB $DB
	FCB $95
	FCB $DD
	FCB $0F
	FCB $53
	FCB $03
	FCB $01

E02_G18_DATA:
	FCB $1B		; Couleurs
	FCB $10
	FCB $10
	FCB $10
	FCB $80
	FCB $80
	FCB $70
	FCB $10
	FCB $80
	FCB $80
	FCB $70
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $10
	FCB $1B
	FCB $1B
	FCB $10
	FCB $10
	FCB $18

	FCB $05		; Formes
	FCB $57
	FCB $AA
	FCB $FB
	FCB $F8
	FCB $6A
	FCB $03
	FCB $65
	FCB $02
	FCB $53
	FCB $87
	FCB $33
	FCB $28
	FCB $92
	FCB $C7
	FCB $ED
	FCB $EC
	FCB $E8
	FCB $E8
	FCB $EA
	FCB $B7
	FCB $6B
	FCB $C7
	FCB $87
	FCB $78

E02_G19_DATA:
	FCB $A0		; Formes
	FCB $F5
	FCB $5B
	FCB $DF
	FCB $0F
	FCB $46
	FCB $C0
	FCB $A6
	FCB $40
	FCB $CA
	FCB $E1
	FCB $CC
	FCB $14
	FCB $89
	FCB $E3
	FCB $B7
	FCB $37
	FCB $17
	FCB $17
	FCB $57
	FCB $EB
	FCB $F5
	FCB $E3
	FCB $E1
	FCB $1E

;------------------------------------------------------------------------------
; E03_G06_ATK : Méduse en case G6, animation de l'attaque
; E03_G06_ATKA sert aux attaques hors champ et E03_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E03_G06_ATKA:
	LDY #E03_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUS

E03_G06_ATK:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDD #$3328		; A = jaune vif / jaune vif. B = 40 pour les sauts de ligne
	LDX #SCROFFSET+$0649 ; X pointe l'oeil droit
 	LBSR DISPLAY_A_8 ; 8x8 pixels jaunes.
	LDX #SCROFFSET+$064B ; X pointe l'oeil gauche
 	LBSR DISPLAY_A_8 ; 8x8 pixels jaunes.

	BSR E03_G06_ATKA ; Bruitage de l'attaque

	LDX #E03_G06_ATKPL
	STX >VARDW2		; VARDW2 = couleurs des boules d'énergie.
	LDX #SCROFFSET+$034C
	STX >VARDW4		; VARDW4 = extérieur de l'oeil droit
	LBSR ATKEN_S2_R1A ; Affichage d'une grosse boule d'énergie
	LDX #SCROFFSET+$0353
	STX >VARDW4		; VARDW4 = extérieur de l'oeil gauche
	LBSR ATKEN_S2_R1A ; Affichage d'une grosse boule d'énergie

	LDB #30			; Tempo de maintien
	LBSR TEMPO	
	
	LDA #$33		; A = jaune vif / jaune vif.
	LBSR FEN_COUL2	; Remplissage de la fenêtre

; Partie réutilisée par E04_G06_ATK
E03_G06_ATK2:
	LDB #30			; Tempo de maintien
	LBSR TEMPO

	LDA #$39		; A = code machine de l'opérande RTS.
	STA >LISTE0		; LISTE0 initialisée avec un RTS (aucun pré-affichage).
	CLR >B18D		; B18 marqué comme à réafficher.
	CLR >B18GAD
	CLR >B19D		; B19 marqué comme à réafficher.
	CLR >B20D		; B20 marqué comme à réafficher.
	CLR >B21D		; B21 marqué comme à réafficher.
	CLR >B21GAD	
	CLR >B22D		; B22 marqué comme à réafficher.
	CLR >B23D		; B23 marqué comme à réafficher.
	LBSR MASK_W13D	; B24 marqué comme à réafficher.
	CLR >B25D		; B25 marqué comme à réafficher.
	CLR >B26D		; B26 marqué comme à réafficher.
	CLR >B27D		; B27 marqué comme à réafficher.
	CLR >B27DRD
	CLR >B28D		; B28 marqué comme à réafficher.
	CLR >B29D		; B29 marqué comme à réafficher.
	CLR >B30D		; B30 marqué comme à réafficher.
	CLR >B30DRD

	LBSR FEN_COUL	; Initialisation des couleurs sol/mur de la fenêtre de jeu.
	LBRA SET00		; Réaffichage des décors.

;------------------------------------------------------------------------------
; E03_G06 : Méduse en case G6, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G06:
	LDA >MAPCOULC	; A = Couleurs sol/mur de map courantes.
	LSRA
	LSRA
	LSRA
	LSRA
	STA >VARDB1
	STA >VARDB2		; VARDB1 = VARDB2 = noir sur fond de sol courant

	LDB >MAPCOULC
	ANDB #%00001111	; B = noir sur fond de mur courant.

	LDA >W6D		; Le mur W6 est-il affiché?
	BNE	E03_G06_1	; Si oui => E03_G06_1

	LDA >W13D		; Le mur W13 est-il affiché?
	BEQ E03_G06_2	; Non => E03_G06_2

	STB >VARDB2		; VARDB2 = noir sur fond de mur courant.
	BRA E03_G06_2	; VARDB1 = noir sur fond de sol courant.

E03_G06_1:
	STB >VARDB1
	STB >VARDB2		; VARDB1 = VARDB2 = noir sur fond de mur courant

E03_G06_2:
	CLR >W6D	 	; Pour les restitutions de décors.
	LBSR MASK_W6B

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	BSR E03_G06_R1	; Couleurs des colonnes 1 et 5
	BSR E03_G06_R2	; Couleurs des colonnes 2 et 4
	LDX #SCROFFSET+$0352 ; X pointe la colonne 3.
	LDA >VARDB1
	STA ,X				; Ligne 1
	ABX
	LDA #$02			; A = vert sur fond noir.
	LBSR DISPLAY_A_8	; Lignes 1 à 9
	LBSR DISPLAY_YX_32	; Lignes 10 à 41

	INC $A7C0			; Sélection vidéo forme.
	LDX #SCROFFSET+$0351 ; X pointe la colonne 2.
	LBSR DISPLAY_YX_8	; Lignes 1 à 8
	LEAX -1,X
	BSR E03_G06_3		; Lignes 9 à 42
	LDX #SCROFFSET+$0352 ; X pointe la colonne 3
	LBSR DISPLAY_YX_32	; Lignes 1 à 32	
	LBSR DISPLAY_YX_9	; Lignes 33 à 41	
	LDX #SCROFFSET+$0353 ; X pointe la colonne 4
	LBSR DISPLAY_YX_8	; Lignes 1 à 8
E03_G06_3:
	LBSR DISPLAY_2YX_32 ; Lignes 9 à 41
	LDA ,Y+
	STA ,X				; Ligne 42
	LDA ,Y+
	STA 1,X
	RTS

; Couleurs des colonnes 1 et 5
E03_G06_R1:	
	LDX #SCROFFSET+$0490 ; X pointe la colonne 1.
	BSR E03_G06_R1_1
	LDX #SCROFFSET+$0494 ; X pointe la colonne 5.
E03_G06_R1_1:
	LDA >VARDB2
	STA ,X				; Ligne 9
	ABX	
	LDA #$02			; A = Noir sur fond vert
	LBSR DISPLAY_A_8	; Lignes 10 à 17
	LDA >VARDB2
	STA ,X				; Ligne 18
	ABX	
	LDA #$02			; A = Noir sur fond vert
	LBSR DISPLAY_A_8	; Lignes 19 à 26
	LDA >VARDB2
	STA ,X				; Ligne 27
	ABX	
	LDA #$02			; A = Noir sur fond vert
	LBSR DISPLAY_A_7	; Lignes 28 à 34
	LDA >VARDB2
	STA ,X				; Ligne 35
	ABX	
	LDA #$02			; A = Noir sur fond vert
	LBSR DISPLAY_A_5	; Lignes 36 à 40
	LDA >VARDB2
	STA ,X				; Ligne 35	
	RTS

; Couleurs des colonnes 2 et 4
E03_G06_R2:	
	LDX #SCROFFSET+$0351 ; X pointe la colonne 2.
	BSR E03_G06_R2_1
	LDX #SCROFFSET+$0353 ; X pointe la colonne 4.
E03_G06_R2_1:
	LDA >VARDB1
	STA ,X				; Ligne 1
	ABX	
	LDA #$02			; A = Noir sur fond vert
	LBSR DISPLAY_A_17	; Lignes 2 à 18
	LDY #E03_G06_DATA_C2 ; Y pointe les données.
	LBSR DISPLAY_YX_9	; Lignes 19 à 27
	LDA #$02			; A = Noir sur fond vert
	LBSR DISPLAY_A_12	; Lignes 28 à 39
	LDA >VARDB2
	STA ,X				; Ligne 40
	ABX	
	STA ,X				; Ligne 41
	RTS

;------------------------------------------------------------------------------
; E03_G14 : Méduse en case G14, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G14:
	LDB #$07		; B = noir sur fond blanc.
	LBSR E02_G14_INI ; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0560 ; X pointe la colonne gauche
	BSR E03_G09_2	; Affichage
	LDX #SCROFFSET+$0511 ; X pointe la colonne du milieu
	BRA E03_G10A	; Affichage

;------------------------------------------------------------------------------
; E03_G12 : Méduse en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G12:
	LDB #$07		; B = noir sur fond blanc.
	LBSR E02_G12_INI ; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0559 ; X pointe la colonne de gauche
	BSR E03_G09_2	; Affichage
	LDX #SCROFFSET+$050A ; X pointe la colonne du milieu
	BSR E03_G10A	; Affichage
	LDX #SCROFFSET+$055B ; X pointe la colonne de droite
	BRA E03_G10B	; Affichage

;------------------------------------------------------------------------------
; E03_G09 : Méduse en case G9, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G09:
	LDB #$07		; B = noir sur fond blanc.
	LBSR E02_G09_INI ; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0551 ; X pointe E03_G09

; Routine commune avec E03_G12 et E03_G14
E03_G09_2:
	LDY #E03_G09_DATA ; Y pointe les formes de la colonne 1

; Routine commune avec E03_G10B et E03_G15
E03_G09_3:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	LDA >VARDB1	
	STA ,X
	ABX
	LDA #$02
	LBSR DISPLAY_A_20 ; Lignes 4 à 23
	LDA >VARDB1	
	STA ,X

	INC $A7C0		; Sélection vidéo forme.
	LEAX -840,X		; X pointe de nouveau la colonne
	LBSR DISPLAY_YX_16 ; Lignes 3 à 18
	LBRA DISPLAY_YX_6 ; Lignes 19 à 24	

;------------------------------------------------------------------------------
; E03_G10 : Méduse en case G10, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G10:
	LDB #$07		; B = noir sur fond blanc.
	LBSR E02_G10_INI ; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0502 ; X pointe la colonne du milieu
	BSR E03_G10A	; Affichage
	LDX #SCROFFSET+$0553 ; X pointe la colonne de droite + affichage

; Colonne de droite, commune avec E03_G12 et E03_G15
E03_G10B:
	LDY #E03_G10B_DATA ; Y pointe les formes de la colonne 3
	BRA E03_G09_3

; Colonne du milieu, commune avec E03_G12 et E03_G14
E03_G10A:	
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	LDY #E03_G10A_DATA ; Y pointe les données.
	LBSR DISPLAY_YX_16 ; Lignes 1 à 16
	LBSR DISPLAY_YX_7 ; Lignes 17 à 23
	LDA >VARDB1
	STA ,X			; Ligne 24

	INC $A7C0		; Sélection vidéo forme.
	LEAX -920,X
	LBSR DISPLAY_YX_16 ; Lignes 1 à 16
	LBRA DISPLAY_YX_8 ; Lignes 17 à 24	

;------------------------------------------------------------------------------
; E03_G15 : Méduse en case G15, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G15:
	LDB #$07		; B = noir sur fond blanc.
	LBSR E02_G15_INI ; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$0562 ; X pointe E03_G15
	BRA E03_G10B

;------------------------------------------------------------------------------
; E03_G24 : Méduse en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G24:
	LDA #$08		; A = noir sur fond gris.
	LBSR E02_G24_INI ; Identification des fonds + réinitialisation des décors.

	LDX #SCROFFSET+$05AF ; X pointe E02_G24.
	BRA E03_G19_2

;------------------------------------------------------------------------------
; E03_G23 : Méduse en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G23:
	LDA #$08		; A = noir sur fond gris.
	LBSR E02_G23_INI ; Identification des fonds + réinitialisation des décors. 

	LDX #SCROFFSET+$05AE ; X pointe E02_G23.
	BRA E03_G18_2

;------------------------------------------------------------------------------
; E03_G19 : Méduse en case G19, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G19:
	LDA #$08		; A = noir sur fond gris.
	LBSR E02_G19_INI ; Identification des fonds + réinitialisation des décors. 

	LDX #SCROFFSET+$05A5 ; X pointe E02_G19.

; Routine commune avec E02_G21 et E02_G25
E03_G19_2:
	LDY #E03_G19_DATA	; Y pointe les données de forme
	BRA E03_G18_3

;------------------------------------------------------------------------------
; E03_G18 : Méduse en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G18:
	LDA #$08		; A = noir sur fond gris.
	LBSR E02_G18_INI ; Identification des fonds + réinitialisation des décors. 

	LDX #SCROFFSET+$05A4 ; X pointe E02_G18.

; Routine commune avec E02_G21 et E02_G24
E03_G18_2:
	LDY #E03_G18_DATA	; Y pointe les données de forme

E03_G18_3:
	LBSR VIDEOC_B		; Sélection vidéo couleur.
	LDB #40				; B = 40 pour les sauts de ligne.
	LDA >VARDB1
	STA ,X				; Ligne 1
	ABX
	LDA #$02
	LBSR DISPLAY_A_7	; Lignes 2 à 8
	LDA #$72
	STA ,X				; Ligne 9
	ABX
	LDA #$02
	LBSR DISPLAY_A_6	; Lignes 10 à 15
	LDA >VARDB1
	STA ,X				; Ligne 16

	INC $A7C0			; Sélection vidéo forme.
	LEAX -600,X			; X pointe de nouveau la colonne.
	LBRA DISPLAY_YX_16 ; Lignes 1 à 16

;------------------------------------------------------------------------------
; E03_G21 : Méduse en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G21:
	LDA #$08		; A = noir sur fond gris.
	LBSR E02_G21_INI ; Identification des fonds + réinitialisation des décors. 

	LDX #SCROFFSET+$05AA ; X pointe E02_G21 colonne 2.	
	BSR E03_G19_2
	LDX #SCROFFSET+$05A9 ; X pointe E02_G21 colonne 1.	
	BRA E03_G18_2

;------------------------------------------------------------------------------
; DONNEES DES MEDUSES
;------------------------------------------------------------------------------
E03_G06_SON_DATA:
	FCB O3,A4,T5,L5,MI,MI,P,FIN

; Couleurs des boules d'énergie (jaune vif / jaune paille / blanc)
E03_G06_ATKPL:
	FCB $33,$BB,$77,$3B,$B7

E03_G06_DATA_C2:
	FCB $0A		; Couleurs des colonnes 2 et 4
	FCB $0A
	FCB $07
	FCB $07
	FCB $71
	FCB $71
	FCB $07
	FCB $0A
	FCB $A2

E03_G06_DATA_C3:
	FCB $02		; Couleurs de la colonne 3
	FCB $A2
	FCB $2A
	FCB $A2
	FCB $2A
	FCB $A2
	FCB $2A
	FCB $22
	FCB $02
	FCB $02
	FCB $02
	FCB $A0
	FCB $0A
	FCB $20
	FCB $0A
	FCB $A2
	FCB $A2
	FCB $20
	FCB $20
	FCB $20
	FCB $20
	FCB $22
	FCB $20
	FCB $07
	FCB $11
	FCB $70
	FCB $0A
	FCB $20
	FCB $20
	FCB $22
	FCB $22
	FCB $00

E03_G06_DATA_F12:
	FCB 	$78		; Formes colonnes 1 et 2
	FCB 	$87
	FCB 	$81
	FCB 	$91
	FCB 	$89
	FCB 	$94
	FCB 	$D4
	FCB 	$E0
	FCB $3F,$10
	FCB $C0,$00
	FCB $80,$40
	FCB $88,$80
	FCB $91,$00
	FCB $90,$C0
	FCB $90,$20
	FCB $88,$7C
	FCB $C4,$FF
	FCB $3F,$FF
	FCB $C2,$C1
	FCB $81,$3E
	FCB $89,$E1
	FCB $91,$C0
	FCB $92,$3B
	FCB $8C,$BB
	FCB $80,$61
	FCB $C0,$1E
	FCB $3F,$3F
	FCB $C0,$20
	FCB $80,$14
	FCB $87,$0A
	FCB $88,$95
	FCB $88,$8A
	FCB $86,$44
	FCB $C2,$49
	FCB $3F,$05
	FCB $C0,$81
	FCB $80,$00
	FCB $98,$08
	FCB $84,$3C
	FCB $84,$C3
	FCB $7B,$80

	FCB $70			; Formes colonne 3
	FCB $8F
	FCB $22
	FCB $22
	FCB $14
	FCB $94
	FCB $C8
	FCB $08
	FCB $00
	FCB $00
	FCB $AA
	FCB $AB
	FCB $BA
	FCB $83
	FCB $BA
	FCB $AB
	FCB $FF
	FCB $81
	FCB $C3
	FCB $E7
	FCB $DB
	FCB $99
	FCB $BD
	FCB $81
	FCB $DB
	FCB $99
	FCB $DB
	FCB $BD
	FCB $BD
	FCB $C3
	FCB $FF
	FCB $81
	FCB $C3
	FCB $FF
	FCB $81
	FCB $81
	FCB $C3
	FCB $BD
	FCB $FF
	FCB $FF
	FCB $FF

	FCB $7C			; Formes colonnes 4 et 5							
	FCB $83								
	FCB $01								
	FCB $31								
	FCB $49								
	FCB $89								
	FCB $89								
	FCB $67								
	FCB $01,$3E
	FCB $00,$C1
	FCB $08,$71
	FCB $06,$29
	FCB $05,$29
	FCB $03,$31
	FCB $00,$C1
	FCB $3C,$01
	FCB $FE,$03
	FCB $FF,$FC
	FCB $83,$23
	FCB $7C,$C1
	FCB $87,$81
	FCB $03,$19
	FCB $DC,$29
	FCB $DD,$21
	FCB $86,$21
	FCB $78,$23
	FCB $FC,$FC
	FCB $04,$03
	FCB $28,$01
	FCB $50,$71
	FCB $A8,$89
	FCB $50,$B9
	FCB $29,$C1
	FCB $91,$43
	FCB $A1,$FC
	FCB $80,$43
	FCB $00,$81
	FCB $10,$71
	FCB $3C,$01
	FCB $C3,$01
	FCB $01,$FE

E03_G10A_DATA:
	FCB $02		; Couleurs
	FCB $02
	FCB $20
	FCB $02
	FCB $2A
	FCB $2A
	FCB $2A
	FCB $02
	FCB $02
	FCB $02
	FCB $70
	FCB $72
	FCB $72
	FCB $22
	FCB $20
	FCB $02
	FCB $22
	FCB $20
	FCB $01
	FCB $07
	FCB $20
	FCB $22
	FCB $02

	FCB $95		; Formes
	FCB $C9
	FCB $D5
	FCB $80
	FCB $D7
	FCB $AB
	FCB $D7
	FCB $81
	FCB $C3
	FCB $E7
	FCB $C3
	FCB $E7
	FCB $C3
	FCB $FF
	FCB $DB
	FCB $99
	FCB $FF
	FCB $C3
	FCB $C3
	FCB $BD
	FCB $BD
	FCB $FF
	FCB $81
	FCB $7E

E03_G09_DATA:
	FCB $3F		; Formes
	FCB $C0
	FCB $92
	FCB $A4
	FCB $A2
	FCB $93
	FCB $87
	FCB $FC
	FCB $88
	FCB $AA
	FCB $90
	FCB $82
	FCB $F1
	FCB $82
	FCB $B1
	FCB $90
	FCB $8C
	FCB $F0
	FCB $8A
	FCB $81
	FCB $B3
	FCB $6C

E03_G10B_DATA:
	FCB $CE		; Formes
	FCB $31
	FCB $09
	FCB $29
	FCB $11
	FCB $C7
	FCB $E9
	FCB $31
	FCB $15
	FCB $45
	FCB $09
	FCB $4F
	FCB $91
	FCB $41
	FCB $8D
	FCB $09
	FCB $31
	FCB $1F
	FCB $51
	FCB $8D
	FCB $E1
	FCB $1E

E03_G18_DATA:
	FCB $0D
	FCB $32
	FCB $4A
	FCB $60
	FCB $90
	FCB $80
	FCB $54
	FCB $AB
	FCB $06
	FCB $60
	FCB $80
	FCB $51
	FCB $62
	FCB $88
	FCB $AC
	FCB $53

E03_G19_DATA:
	FCB $60
	FCB $9C
	FCB $92
	FCB $25
	FCB $09
	FCB $01
	FCB $22
	FCB $D5
	FCB $60
	FCB $01
	FCB $05
	FCB $89
	FCB $46
	FCB $13
	FCB $29
	FCB $C6

;------------------------------------------------------------------------------
; E04_G06_ATK : BLOB en case G6, animation de l'attaque
; E04_G06_ATKA sert aux attaques hors champ et E04_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E04_G06_ATKA:
	LDY #E04_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUS

E04_G06_ATK:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	BSR E04_G06_ATK1 ; Affichage colonnes 1 et 20
	BSR E04_G06_ATK2 ; Affichage colonnes 2 et 19
	BSR E04_G06_ATK3 ; Affichage colonnes 3, 9, 12 et 18
	LBSR E04_G06_ATK4 ; Affichage colonnes 4, 5, 16 et 17
	LBSR E04_G06_ATK5 ; Affichage colonnes 6 et 15
	LBSR E04_G06_ATK6 ; Affichage colonnes 7, 8, 13 et 14
	LDX #SCROFFSET+$0009 ; X pointe la 10ème colonne	
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_2A_64	; Lignes 1 à 64
	LBSR DISPLAY_2A_8	; Lignes 65 à 72
	CLRA				; A = noir sur fond noir
	LBSR DISPLAY_2A_32	; Lignes 73 à 104
	LBSR DISPLAY_2A_8	; Lignes 105 à 112
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_2A_16	; Lignes 113 à 128
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_2A_3	; Lignes 129 à 131

	LBSR E04_G06_ATKA	; Bruitage de l'attaque
	LBRA E03_G06_ATK2	; Tempo de maintien + réinitialisation des décors.	
	
; Colonnes 1 et 20
E04_G06_ATK1:
	LDX #SCROFFSET+$0000 ; X pointe la 1ère colonne
	BSR E04_G06_ATK1A
	LDX #SCROFFSET+$0013 ; X pointe la 20ème colonne	
E04_G06_ATK1A:
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_A_64	; Lignes 1 à 64
	LDA #$55			; A = magenta sur fond magenta.
	LBSR DISPLAY_A_8	; Lignes 65 à 72
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_A_48	; Lignes 73 à 120
	LBRA DISPLAY_A_11	; Lignes 121 à 131

; Colonnes 2 et 19
E04_G06_ATK2:
	LDX #SCROFFSET+$0001 ; X pointe la 2ème colonne
	BSR E04_G06_ATK2A
	LDX #SCROFFSET+$0012 ; X pointe la 19ème colonne	
E04_G06_ATK2A:
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_A_64	; Lignes 1 à 64
	LBSR DISPLAY_A_24	; Lignes 65 à 88
	CLRA				; A = noir sur fond noir
	LBSR DISPLAY_A_32	; Lignes 89 à 120
	LBSR DISPLAY_A_8	; Lignes 121 à 128
	LDA #$DD			; A = rose sur fond rose.
	STA ,X
	STA 1,X				; Lignes 129 à 131
	ABX
	STA ,X
	STA 1,X
	ABX
	STA ,X
	STA 1,X
	RTS	

; Colonnes 3, 9, 12 et 18
E04_G06_ATK3:
	LDX #SCROFFSET+$0002 ; X pointe la 3ème colonne
	BSR E04_G06_ATK3A
	LDX #SCROFFSET+$0008 ; X pointe la 9ème colonne
	BSR E04_G06_ATK3A
	LDX #SCROFFSET+$000B ; X pointe la 12ème colonne
	BSR E04_G06_ATK3A
	LDX #SCROFFSET+$0011 ; X pointe la 18ème colonne	
E04_G06_ATK3A:
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_A_64	; Lignes 1 à 64
E04_G06_ATK3B:
	LBSR DISPLAY_A_16	; Lignes 65 à 80
	CLRA				; A = noir sur fond noir
	LBSR DISPLAY_A_32	; Lignes 81 à 112
	LBSR DISPLAY_A_8	; Lignes 113 à 120
	LDA #$DD			; A = rose sur fond rose.
	LBRA DISPLAY_A_11	; Lignes 121 à 131

; Colonnes 4, 5, 16 et 17
E04_G06_ATK4:
	LDX #SCROFFSET+$0003 ; X pointe la 4ème colonne
	BSR E04_G06_ATK4A
	LDX #SCROFFSET+$000F ; X pointe la 16ème colonne	
E04_G06_ATK4A:
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_2A_8	; Lignes 1 à 8
	CLRA				; A = noir sur fond noir
	LBSR DISPLAY_2A_32	; Lignes 9 à 40
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_2A_32	; Lignes 41 à 72
	CLRA				; A = noir sur fond noir
	LBSR DISPLAY_2A_32	; Lignes 73 à 104
	LBSR DISPLAY_2A_8	; Lignes 104 à 112
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_2A_16	; Lignes 113 à 128
	STA ,X
	STA 1,X				; Lignes 129 à 131
	ABX
	STA ,X
	STA 1,X
	ABX
	STA ,X
	STA 1,X
	RTS		

; Colonnes 6 et 15
E04_G06_ATK5:
	LDX #SCROFFSET+$0005 ; X pointe la 6ème colonne
	BSR E04_G06_ATK5A
	LDX #SCROFFSET+$000E ; X pointe la 15ème colonne	
E04_G06_ATK5A:
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_A_8	; Lignes 1 à 8
	CLRA				; A = noir sur fond noir
	LBSR DISPLAY_A_32	; Lignes 9 à 40
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_A_8	; Lignes 41 à 48
	LDA #$55			; A = magenta sur fond magenta.
	LBSR DISPLAY_A_8	; Lignes 49 à 56
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_A_8	; Lignes 57 à 64
	BRA E04_G06_ATK3B	; Lignes 65 à 131
	
; Colonnes 7, 8, 13 et 14
E04_G06_ATK6:
	LDY #DISPLAY_0A_8 
	LDX #SCROFFSET+$0006 ; X pointe la 7ème colonne
	BSR E04_G06_ATK6A
	LDY #DISPLAY_A0_8 
	LDX #SCROFFSET+$000C ; X pointe la 13ème colonne	
E04_G06_ATK6A:
	STY >E04_G06_ATK6B+1 ; Automodification de code
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_2A_16	; Lignes 1 à 16
E04_G06_ATK6B:
	JSR DISPLAY_0A_8	; Lignes 17 à 24
	CLRA				; A = noir sur fond noir
	LBSR DISPLAY_2A_16	; Lignes 25 à 40
	LDA #$DD			; A = rose sur fond rose.
	LBSR DISPLAY_2A_48	; Lignes 41 à 88
	CLRA				; A = noir sur fond noir
	LBSR DISPLAY_2A_32	; Lignes 89 à 120
	LBSR DISPLAY_2A_8	; Lignes 121 à 128
	LDA #$DD			; A = rose sur fond rose.
	STA ,X
	STA 1,X				; Lignes 129 à 131
	ABX
	STA ,X
	STA 1,X
	ABX
	STA ,X
	STA 1,X
	RTS	

;------------------------------------------------------------------------------
; E04_G06 : BLOB en case G6, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G06:
	CLR >G6D	 	; Pour les restitutions de décors.

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDD #$5828		; A = mauve sur fond gris. B = 40 pour les sauts de ligne.
	BSR E04_G06_R1	; Couleur des colonnes 1 et 5
	BSR E04_G06_R2	; Couleurs des colonnes 2, 3 et 4

	INC $A7C0		; Sélection vidéo forme.
	LDY #E04_G06_DATA ; Y pointe les données de formes.
	LDX #SCROFFSET+$0CD8 ; X pointe la 1ère colonne
	LBSR DISPLAY_2YX_16 ; Lignes 2 à 17
	LBSR DISPLAY_2YX_6 ; Lignes 18 à 23
	LDX #SCROFFSET+$0CB2 ; X pointe la 3ème colonne
	LBSR DISPLAY_YX_16 ; Lignes 1 à 16
	LBSR DISPLAY_YX_7 ; Lignes 17 à 23
	LDX #SCROFFSET+$0CDB ; X pointe la 5ème colonne
	LBSR DISPLAY_2YX_16 ; Lignes 2 à 17
	LBRA DISPLAY_2YX_6 ; Lignes 18 à 23

; Couleurs des colonnes 1 et 5
E04_G06_R1:
	LDX #SCROFFSET+$0CD8 ; X pointe la 1ère colonne
	BSR E04_G06_R1_1
	LDX #SCROFFSET+$0CDC ; X pointe la 5ème colonne	
E04_G06_R1_1:
	LBSR DISPLAY_A_8 ; Lignes 2 à 9
	LDA #$5D		; A = mauve sur fond rose
	LBSR DISPLAY_A_13 ; Lignes 10 à 22
	LDA #$58		; A = mauve sur fond gris. 
	STA ,X			; Ligne 23
	RTS

; Couleurs des colonnes 2, 3 et 4
E04_G06_R2:
	LDX #SCROFFSET+$0CD9 ; X pointe la 2ème colonne
	BSR E04_G06_R2_1
	LDX #SCROFFSET+$0CDB ; X pointe la 4ème colonne	
	BSR E04_G06_R2_1	
	LDX #SCROFFSET+$0CB2 ; X pointe la 3ème colonne
	LDA #$5D		; A = mauve sur fond rose
	STA ,X			; Line 1
	ABX
	STA ,X			; Line 2
	BRA E04_G06_R2_2

E04_G06_R2_1:
	STA ,X			; Ligne 2
	LDA #$5D		; A = mauve sur fond rose
E04_G06_R2_2:
	ABX
	STA ,X			; Ligne 3
	ABX	
	LDA #$0D		; A = noir sur fond rose
	LBSR DISPLAY_A_6 ; Lignes 4 à 9
	LDA #$5D		; A = mauve sur fond rose
	LBSR DISPLAY_A_3 ; Lignes 10 à 12	
	LDA #$0D		; A = noir sur fond rose
	LBSR DISPLAY_A_8 ; Lignes 13 à 20
	LDA #$5D		; A = mauve sur fond rose
	STA ,X			; Ligne 21
	ABX	
	STA ,X			; Ligne 22
	ABX	
	LDA #$58		; A = mauve sur fond gris. 
	STA ,X			; Ligne 23
	RTS	

;------------------------------------------------------------------------------
; E04_G14 : BLOB en case G14, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G14:
	CLR >G14D	 		; Pour les restitutions de décors.
	LDX #SCROFFSET+$0A60 ; X pointe G12 colonne 1
	BSR E04_G09_R1
	LDX #SCROFFSET+$0A39 ; X pointe G12 colonne 2
	BRA E04_G10A

;------------------------------------------------------------------------------
; E04_G12 : BLOB en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G12:
	CLR >G12D	 	; Pour les restitutions de décors.
	LDX #SCROFFSET+$0A59 ; X pointe G12 colonne 1
	BSR E04_G09_R1
	LDX #SCROFFSET+$0A32 ; X pointe G12 colonne 2
	BSR E04_G10A
	LDX #SCROFFSET+$0A5B ; X pointe G12 colonne 3
	BRA E04_G10B

;------------------------------------------------------------------------------
; E04_G09 : BLOB en case G9, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G09:
	CLR >G9D	 	; Pour les restitutions de décors.
	LDX #SCROFFSET+$0A51 ; X pointe G09

; Routine commune avec E04_G12 et E04_G14
E04_G09_R1:
	LDY #E04_G09_DATA1 ; Y pointe les données de forme.

E04_G09_R2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDD #$5828		; A = mauve sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_5 ; Lignes 2 à 6
	LDA #$5D		; A = mauve sur fond rose
	LBSR DISPLAY_A_8 ; Lignes 7 à 14
	LDA #$58		; A = mauve sur fond gris
	STA ,X			; Ligne 15
	
	INC $A7C0		; Sélection vidéo forme.
	LEAX -520,X		; X pointe de nouveau la colonne
	LBRA DISPLAY_YX_14 ; Lignes 2 à 15	

;------------------------------------------------------------------------------
; E04_G10 : BLOB en case G10, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G10:
	CLR >G10D	 	; Pour les restitutions de décors.
	LDX #SCROFFSET+$0A2A ; X pointe G10 colonne 1
	BSR E04_G10A
	LDX #SCROFFSET+$0A53 ; X pointe G10 colonne 2

; Routine commune avec E04_G12 et E04_G14
E04_G10B:
	LDY #E04_G09_DATA3 ; Y pointe les données
	BRA E04_G09_R2

; Routine commune avec E04_G12 et E04_G15
E04_G10A:
	LDY #E04_G09_DATA2 ; Y pointe les données
	LDB #40			; B = 40 pour les sauts de ligne.

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LBSR DISPLAY_YX_15 ; Lignes 1 à 15
	INC $A7C0		; Sélection vidéo forme.
	LEAX -600,X		; X pointe de nouveau la colonne
	LBRA DISPLAY_YX_15 ; Lignes 1 à 15

;------------------------------------------------------------------------------
; E04_G15 : BLOB en case G15, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G15:
	CLR >G15D	 		; Pour les restitutions de décors.
	LDX #SCROFFSET+$0A62 ; X pointe G15
	BRA E04_G10B

;------------------------------------------------------------------------------
; E04_G21 : BLOB en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G21:
	CLR >G21D	 	; Pour les restitutions de décors.
	LDX #SCROFFSET+$08F1 ; X pointe G21 colonne 1
	BSR E04_G18_1
	LDX #SCROFFSET+$08F2 ; X pointe G21 colonne 2
	BRA E04_G19_1

;------------------------------------------------------------------------------
; E04_G19 : BLOB en case G19, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G19:
	CLR >G19D	 	; Pour les restitutions de décors.
	LDX #SCROFFSET+$08ED ; X pointe G19

; Routine commune avec E04_G21 et E04_G24
E04_G19_1:
	LDY #E04_G19_DATA ; Y pointe les données de forme.
	BRA E04_G18_2

;------------------------------------------------------------------------------
; E04_G18 : BLOB en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G18:
	CLR >G18D	 	; Pour les restitutions de décors.
	LDX #SCROFFSET+$08EC ; X pointe G18

; Routine commune avec E04_G21 et E04_G23
E04_G18_1:
	LDY #E04_G18_DATA ; Y pointe les données de forme.

E04_G18_2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDD #$8528		; A = gris sur fond mauve. B = 40 pour les sauts de ligne.
	STA ,X			; Ligne 1
	ABX
	STA ,X			; Ligne 2
	ABX
	LDA #$05		; A = noir sur fond mauve.
	LBSR DISPLAY_A_5 ; Lignes 2 à 6

	INC $A7C0		; Sélection vidéo forme.
	LEAX -280,X		; X pointe de nouveau la colonne
	LBRA DISPLAY_YX_7 ; Lignes 1 à 7

;------------------------------------------------------------------------------
; E04_G24 : BLOB en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G24:
	CLR >G24D	 	; Pour les restitutions de décors.
	LDX #SCROFFSET+$08F7 ; X pointe G24
	BRA E04_G19_1

;------------------------------------------------------------------------------
; E04_G23 : BLOB en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G23:
	CLR >G23D	 	; Pour les restitutions de décors.
	LDX #SCROFFSET+$08F6 ; X pointe G23
	BRA E04_G18_1

;------------------------------------------------------------------------------
; DONNEES DES BLOBS
;------------------------------------------------------------------------------
E04_G06_SON_DATA:
	FCB O2,A4,T3,L5,DO,RE,MI,MI,RE,DO,P,FIN

E04_G06_DATA:
	FCB $00,$3F
	FCB $00,$C0
	FCB $01,$03
	FCB $01,$07
	FCB $01,$07
	FCB $01,$07
	FCB $01,$03
	FCB $79,$00
	FCB $87,$01
	FCB $81,$00
	FCB $81,$20
	FCB $92,$03
	FCB $82,$07
	FCB $C4,$0F
	FCB $E0,$0F
	FCB $C0,$1F
	FCB $80,$1E
	FCB $90,$1C
	FCB $81,$00
	FCB $80,$00
	FCB $8F,$0F
	FCB $70,$F0

	FCB $FF
	FCB $00
	FCB $08
	FCB $00
	FCB $80
	FCB $C0
	FCB $E1
	FCB $E3
	FCB $03
	FCB $00
	FCB $08
	FCB $00
	FCB $30
	FCB $BC
	FCB $FD
	FCB $FF
	FCB $FF
	FCB $77
	FCB $33
	FCB $00
	FCB $40
	FCB $00
	FCB $FF

	FCB $FC,$00
	FCB $03,$00
	FCB $00,$80
	FCB $60,$80
	FCB $F0,$80
	FCB $F0,$80
	FCB $F0,$80
	FCB $E0,$9E
	FCB $00,$E1
	FCB $04,$81
	FCB $40,$89
	FCB $00,$41
	FCB $C0,$43
	FCB $F0,$27
	FCB $F0,$03
	FCB $E0,$01
	FCB $E0,$41
	FCB $C0,$01
	FCB $C0,$05
	FCB $00,$01
	FCB $F0,$F1
	FCB $0F,$0E

E04_G09_DATA1:
	FCB $01
	FCB $01
	FCB $01
	FCB $01
	FCB $73
	FCB $8E
	FCB $A2
	FCB $84
	FCB $C0
	FCB $C0
	FCB $84
	FCB $80
	FCB $98
	FCB $67

E04_G09_DATA2:
	FCB $55		; Couleur
	FCB $D5
	FCB $D0
	FCB $D0
	FCB $D0
	FCB $D0
	FCB $D5
	FCB $D0
	FCB $0D
	FCB $00
	FCB $00
	FCB $0D
	FCB $D5
	FCB $5D
	FCB $58

	FCB $FF		; Formes
	FCB $F7
	FCB $BF
	FCB $9D
	FCB $89
	FCB $F1
	FCB $DD
	FCB $BF
	FCB $EB
	FCB $FF
	FCB $FF
	FCB $92
	FCB $F7
	FCB $C3
	FCB $3C

E04_G09_DATA3:
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $CE
	FCB $71
	FCB $45
	FCB $21
	FCB $03
	FCB $03
	FCB $11
	FCB $01
	FCB $19
	FCB $E6

E04_G18_DATA:
	FCB $F8
	FCB $90
	FCB $02
	FCB $03
	FCB $00
	FCB $02
	FCB $07

E04_G19_DATA:
	FCB $1F
	FCB $09
	FCB $20
	FCB $60
	FCB $00
	FCB $E0
	FCB $A0

;------------------------------------------------------------------------------
; E05_G06_ATK : TROOPER bleu en case G6, animation de l'attaque
; E05_G06_ATKA sert aux attaques hors champ et E05_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E05_G06_ATKA:
	LDY #E05_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUS

E05_G06_ATK:
	LDX #SCROFFSET+$0672 ; X pointe la rafale à l'écran
	LDY #E05_G06_ATK_R1 ; Y pointe la routine de rafale
	LBRA BSPRITE16		; Affichage de la rafale.

; Routine du coup de feu
E05_G06_ATK_R1:
	LDX #SCROFFSET+$069A ; X pointe le sprite du coup de feu.
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDD #$3028		; A = jaune vif sur fond noir. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_8 ; Etablissement des couleurs du coup de feu.	

	INC	$A7C0		; Sélection vidéo forme.
	LEAX -320,X		; X pointe de nouveau le coup de feu.
	LDY #BLOOD12_DATA ; Y pointe les données de forme de la tâche de sang.
	LBSR DISPLAY_YX_8 ; Affichage de la tâche.		

	BRA E05_G06_ATKA ; Son de la rafale.

;------------------------------------------------------------------------------
; E05_G06 : TROOPER bleu en case G6, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G06:
	LDA #$07		; A = noir sur fond blanc.
	LDB >W6D		; Le mur W6 est-il affiché?
	BNE	E05_G06_2	; Si oui => E05_G06_2

	INCA			; A = noir sur fond gris
	LDB >W13D		; Le mur W13 est-il affiché?
	BNE	E05_G06_3	; Si oui => E05_G06_3. Sinon E05_G06_2.

E05_G06_2:
	STA >VARDB1
	STA >VARDB5
	ORA #$10		; A = rouge sur fond blanc ou gris
	STA >VARDB2
	BRA E05_G06_4

E05_G06_3:
	STA >VARDB1
	STA >VARDB5
	LDA #$18		; A = rouge sur fond gris
	STA >VARDB2
	DECA			; A = rouge sur fond blanc

E05_G06_4:
	STA >VARDB3
	CLR >G6D 		; Pour la restitution des décors.
	CLR >H6D
	CLR >CH6D
	CLR >W6D
	CLR >W13D
	CLR >G12D
	CLR >H12D
	CLR >CH12D
	CLR >B25D
	LBSR MASK_W13B

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	LDX #SCROFFSET+$0352 ; X pointe la deuxième colonne	
	LDA >VARDB1
	STA ,X			; Ligne 1
	ABX
	LDA #$08
	LBSR DISPLAY_A_4 ; Lignes 2 à 5
	LDA #$01
	STA ,X			; Ligne 6
	ABX
	LDA #$B1
	LBSR DISPLAY_A_6 ; Lignes 7 à 12
	LDA #$01
	STA ,X			; Ligne 13
	ABX
	STA ,X			; Ligne 14
	ABX	
	BSR E05_G06_R3	; Lignes 15 à 72
	BSR E05_G06_R1	; Couleurs des colonnes 1 et 3
	
	INC $A7C0		; Sélection vidéo forme.
	LDX #SCROFFSET+$0351 ; X pointe la première colonne
	LDY #E05_G06_DATA ; Y pointe les données
	LBSR DISPLAY_2YX_32 ; Lignes 1 à 72
	LBSR DISPLAY_2YX_32
	LBSR DISPLAY_2YX_8
	LDX #SCROFFSET+$0353 ; X pointe la troisième colonne	
	LBSR DISPLAY_YX_32 ; Lignes 1 à 72
	LBSR DISPLAY_YX_32
	LBRA DISPLAY_YX_8

; Couleurs des colonnes 1 et 3
E05_G06_R1:
	LDX #SCROFFSET+$0351 ; X pointe la première colonne
	BSR E05_G06_R2
	LDX #SCROFFSET+$0353 ; X pointe la troisième colonne
	LDA >E05COUL
	STA >VARDB5
E05_G06_R2:
	LDA >VARDB1
	LBSR DISPLAY_A_6 ; Lignes 1 à 6
	LDA >VARDB2
	LBSR DISPLAY_A_2 ; Lignes 7 à 8
	LDA >VARDB3
	LBSR DISPLAY_A_4 ; Lignes 9 à 12
	ANDA #%00001111	; A = noir sur fond xxx.
	STA ,X			; Ligne 13
	ABX
	LDA #$08		; A = noir sur fond gris.
	STA ,X			; Ligne 14
	ABX
E05_G06_R3:
	LDA >E05COUL
	LBSR DISPLAY_A_32 ; Lignes 15 à 46
	LBSR DISPLAY_A_11 ; Lignes 47 à 57
	LDA >VARDB5
	STA ,X			; Ligne 58
	ABX
	LDA >VARDB1
	STA ,X			; Ligne 59
	ABX
	LDA #$08		; A = noir sur fond gris.
	LBRA DISPLAY_A_13 ; Lignes 60 à 72

;------------------------------------------------------------------------------
; E05_G15 : TROOPER bleu en case G15, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G15:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W16D		; Le mur W16 est-il affiché?
	BNE	E05_G15_1	; Si oui => E05_G15_1

	LDA >W42D		; Le mur W42 est-il affiché?
	BNE	E05_G15_1	; Si oui => E05_G15_1

	INCB			; B = $x8 = fond gris.

E05_G15_1:
	LBSR E02_G15_IN2	; Pour la restauration de décors.
	LDX #SCROFFSET+$0422 ; X pointe E05_G15
	BRA E05_G10_2

;------------------------------------------------------------------------------
; E05_G10 : TROOPER bleu en case G10, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G10:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W11D		; Le mur W11 est-il affiché?
	BNE	E05_G10_1	; Si oui => E05_G10_1

	LDA >W33D		; Le mur W33 est-il affiché?
	BNE	E05_G10_1	; Si oui => E05_G10_1

	INCB			; B = $x8 = fond gris.

E05_G10_1:
	STB >VARDB1
	LBSR MASK_W5	; Pour la restauration des décors.
	LDX #SCROFFSET+$0412 ; X pointe E05_G10

; Routine commune avec E05_G12 et E05_G15
E05_G10_2:
	LDY #E05_G10_DATA ; Y pointe les données
	BRA E05_G09_3

;------------------------------------------------------------------------------
; E05_G12 : TROOPER bleu en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G12:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E05_G12_1	; Si oui => E05_G12_1

	INCB			; B = $x8 = fond gris.	

E05_G12_1:
	LBSR E02_G12_IN2	; Pour la restauration de décors.
	LDX #SCROFFSET+$041A ; X pointe E05_G12 colonne 2
	BSR E05_G10_2
	LDX #SCROFFSET+$0419 ; X pointe E05_G12 colonne 1
	BRA E05_G09_2

;------------------------------------------------------------------------------
; E05_G14 : TROOPER bleu en case G14, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G14:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W15D		; Le mur W15 est-il affiché?
	BNE	E05_G14_1 	; Si oui => E05_G14_1

	LDA >W43D		; Le mur W43 est-il affiché?
	BNE	E05_G14_1 	; Si oui => E05_G14_1

	INCB			; B = $x8 = fond gris.

E05_G14_1:
	STB >VARDB1
	LBSR MASK_W7	; Pour la restauration des décors.
	LDX #SCROFFSET+$0421 ; X pointe E05_G14
	BRA E05_G09_2

;------------------------------------------------------------------------------
; E05_G09 : TROOPER bleu en case G9, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G09:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W32D		; Le mur W32 est-il affiché?
	BNE	E05_G09_1	; Si oui => E05_G09_1

	LDA >W10D		; Le mur W10 est-il affiché?
	BNE	E05_G09_1	; Si oui => E05_G09_1

	INCB			; B = $x8 = fond gris.

E05_G09_1:
	LBSR E02_G09_IN2	; Pour la restauration de décors.
	LDX #SCROFFSET+$0411 ; X pointe E05_G09

; Routine commune avec E05_G12 et E05_G14
E05_G09_2:
	LDY #E05_G09_DATA ; Y pointe les données

; Routine commune avec E05_G10 et E05_G15
E05_G09_3:
	LBSR VIDEOC_A		; Sélection vidéo couleur.
	LDD #$0828			; A = noir sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_3 	; Lignes 1 à 3
	LDA >VARDB1
	LBSR DISPLAY_A_5 	; Lignes 4 à 8
	LDA #$01
	STA ,X				; Ligne 9
	ABX
	LDA #$08
	STA ,X				; Ligne 10
	ABX	
	LDA >E05COUL
	LBSR DISPLAY_A_16 	; Lignes 19 à 26	
	LBSR DISPLAY_A_12 	; Lignes 27 à 38
	LDA #$08
	LBSR DISPLAY_A_9 	; Lignes 39 à 47

	INC $A7C0			; Sélection vidéo forme.
	LEAX -1880,X		; X pointe de nouveau E05_G09.
	LBSR DISPLAY_YX_32	; Lignes 1 à 32
	LBRA DISPLAY_YX_15	; Lignes 33 à 47

;------------------------------------------------------------------------------
; E05_G24 : TROOPER bleu en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G24:
	CLR >G24D			; Pour la restauration des décors
	LDX #SCROFFSET+$0947 ; X pointe E05_G24.
	BRA E05_G19_2

;------------------------------------------------------------------------------
; E05_G19 : TROOPER bleu en case G19, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G19:
	CLR >G19D			; Pour la restauration des décors
	LDX #SCROFFSET+$093D ; X pointe E05_G18.

E05_G19_2:
	LBSR VIDEOC_B		; Sélection vidéo couleur.
	LDD #$0828			; A = noir sur fond gris. B = 40 pour les sauts de ligne.
	STA ,X				; Ligne 27
	ABX
	STA ,X				; Ligne 28
	
	INC $A7C0			; Sélection vidéo forme.
	LEAX -40,X			; X pointe de nouveau E05_G18
	LDA #$80
	STA ,X				; Ligne 27
	ABX
	STA ,X				; Ligne 28	
	RTS

;------------------------------------------------------------------------------
; E05_G21 : TROOPER bleu en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G21:
	LDA #$08			; A = noir sur fond gris.
	LBSR E02_G21_INI	; Identification des fonds + réinitialisation des décors.
	LDX #SCROFFSET+$0532 ; X pointe la première colonne
	BSR E05_G18_2
	LDX #SCROFFSET+$0943 ; X pointe la deuxième colonne
	BRA E05_G19_2

;------------------------------------------------------------------------------
; E05_G18 : TROOPER bleu en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G18:
	LDA #$08			; A = noir sur fond gris.
	LBSR E02_G18_INI	; Identification des fonds + réinitialisation des décors. 
	LDX #SCROFFSET+$052C ; X pointe E05_G18.

; Routine commune avec E05_G21 et E05_G23
E05_G18_2:
	LBSR VIDEOC_B		; Sélection vidéo couleur.
	LDD #$0828			; A = noir sur fond gris. B = 40 pour les sauts de ligne.
	STA ,X				; Ligne 1
	ABX
	LDA >VARDB1
	STA ,X				; Ligne 2
	ABX
	ORA #$10			; A = rouge sur fond xxx.
	LBSR DISPLAY_A_3	; Lignes 2 à 5
	LDA #$01
	STA ,X				; Ligne 6
	ABX
	LDA >E05COUL
	LBSR DISPLAY_A_17	; Lignes 7 à 23
	LDA #$08
	LBSR DISPLAY_A_5	; Lignes 24 à 28	

	INC $A7C0			; Sélection vidéo forme.
	LEAX -1120,X		; X pointe de nouveau la colonne.
	LDY #E05_G18_DATA	; Y pointe les données de forme
	LBSR DISPLAY_YX_16	; Lignes 1 à 16
	LBRA DISPLAY_YX_12	; Lignes 17 à 28

;------------------------------------------------------------------------------
; E05_G23 : TROOPER bleu en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G23:
	LDA #$08			; A = noir sur fond gris.
	LBSR E02_G23_INI	; Identification des fonds + réinitialisation des décors. 
	LDX #SCROFFSET+$0536 ; X pointe E05_G23.
	BRA E05_G18_2

;------------------------------------------------------------------------------
; DONNEES DES TROOPERS BLEUS
;------------------------------------------------------------------------------
E05_G06_SON_DATA:
	FCB O4,A5,T2,L5,MI,RE,P,MI,RE,P,MI,RE,P,FIN

E05_G06_DATA:
	FCB $00,$FE
	FCB $01,$FF
	FCB $03,$93
	FCB $03,$EF
	FCB $03,$FF
	FCB $03,$01
	FCB $03,$00
	FCB $03,$C6
	FCB $03,$6C
	FCB $03,$00
	FCB $01,$00
	FCB $01,$38
	FCB $3F,$01
	FCB $C1,$83
	FCB $FF,$C7
	FCB $C1,$6D
	FCB $80,$BA
	FCB $80,$7C
	FCB $80,$10
	FCB $80,$10
	FCB $84,$14
	FCB $84,$10
	FCB $84,$10
	FCB $84,$14
	FCB $84,$50
	FCB $85,$F0
	FCB $8F,$F4
	FCB $8F,$F1
	FCB $CF,$FE
	FCB $CF,$82
	FCB $B1,$C2
	FCB $A0,$82
	FCB $A1,$C2
	FCB $E0,$BD
	FCB $9F,$10
	FCB $C0,$10
	FCB $FF,$FF
	FCB $C0,$00
	FCB $80,$00
	FCB $88,$42
	FCB $90,$3C
	FCB $E0,$18
	FCB $80,$18
	FCB $80,$18
	FCB $80,$18
	FCB $C0,$18
	FCB $C0,$18
	FCB $C0,$18
	FCB $C0,$18
	FCB $80,$98
	FCB $9F,$1C
	FCB $80,$1C
	FCB $80,$3C
	FCB $80,$3C
	FCB $80,$3C
	FCB $C0,$FC
	FCB $FF,$FE
	FCB $7F,$E7
	FCB $77,$E3
	FCB $37,$C3
	FCB $3F,$C3
	FCB $3F,$83
	FCB $1F,$C1
	FCB $1F,$C1
	FCB $3F,$C1
	FCB $61,$C0
	FCB $5E,$C1
	FCB $7F,$C1
	FCB $3F,$81
	FCB $00,$01
	FCB $00,$01
	FCB $00,$00

	FCB $00
	FCB $00
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $00
	FCB $00
	FCB $FC
	FCB $03
	FCB $FF
	FCB $03
	FCB $01
	FCB $01
	FCB $01
	FCB $01
	FCB $21
	FCB $21
	FCB $21
	FCB $21
	FCB $21
	FCB $21
	FCB $21
	FCB $C1
	FCB $01
	FCB $01
	FCB $01
	FCB $03
	FCB $1F
	FCB $E1
	FCB $01
	FCB $03
	FCB $FF
	FCB $03
	FCB $01
	FCB $11
	FCB $09
	FCB $07
	FCB $01
	FCB $01
	FCB $03
	FCB $03
	FCB $03
	FCB $03
	FCB $03
	FCB $03
	FCB $81
	FCB $79
	FCB $01
	FCB $01
	FCB $01
	FCB $01
	FCB $01
	FCB $03
	FCB $FE
	FCB $FE
	FCB $BE
	FCB $BE
	FCB $9C
	FCB $DC
	FCB $DC
	FCB $FC
	FCB $FE
	FCB $FE
	FCB $C3
	FCB $BD
	FCB $FF
	FCB $FE

E05_G09_DATA:
	FCB $07
	FCB $0E
	FCB $0F
	FCB $0F
	FCB $0D
	FCB $0F
	FCB $07
	FCB $06
	FCB $FC
	FCB $87
	FCB $85
	FCB $83
	FCB $91
	FCB $91
	FCB $91
	FCB $95
	FCB $97
	FCB $9F
	FCB $DF
	FCB $BF
	FCB $A2
	FCB $E2
	FCB $9D
	FCB $C1
	FCB $FF
	FCB $C0
	FCB $91
	FCB $E0
	FCB $80
	FCB $80
	FCB $C0
	FCB $C4
	FCB $98
	FCB $80
	FCB $81
	FCB $81
	FCB $C3
	FCB $FF
	FCB $2E
	FCB $3C
	FCB $3E
	FCB $7E
	FCB $66
	FCB $7E
	FCB $3C
	FCB $00
	FCB $00

E05_G10_DATA:
	FCB $E0
	FCB $70
	FCB $F0
	FCB $F0
	FCB $B0
	FCB $F0
	FCB $E0
	FCB $60
	FCB $3F
	FCB $E1
	FCB $41
	FCB $81
	FCB $09
	FCB $49
	FCB $09
	FCB $49
	FCB $09
	FCB $49
	FCB $31
	FCB $E1
	FCB $21
	FCB $27
	FCB $D9
	FCB $03
	FCB $FF
	FCB $03
	FCB $C9
	FCB $87
	FCB $81
	FCB $83
	FCB $83
	FCB $83
	FCB $91
	FCB $CD
	FCB $C1
	FCB $C1
	FCB $C1
	FCB $E3
	FCB $7F
	FCB $3F
	FCB $36
	FCB $36
	FCB $1E
	FCB $3E
	FCB $33
	FCB $3F
	FCB $1F

E05_G18_DATA:
	FCB $3C
	FCB $3C
	FCB $3C
	FCB $3C
	FCB $3C
	FCB $E7
	FCB $18
	FCB $42
	FCB $52
	FCB $52
	FCB $DA
	FCB $7A
	FCB $3C
	FCB $D4
	FCB $FF
	FCB $80
	FCB $C9
	FCB $88
	FCB $88
	FCB $E8
	FCB $8B
	FCB $98
	FCB $FC
	FCB $77
	FCB $77
	FCB $F7
	FCB $E7
	FCB $03

PACK_END:
	BSZ $99C0-PACK_END	; Remplissage de zéros jusqu'à $97FF inclus.
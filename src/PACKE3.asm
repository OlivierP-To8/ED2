; =============================================================================
; EVIL DUNGEONS II - DUNGEON CRAWLER POUR MO5 - PACK D'ENNEMIS 3 (PORTAIL).
; Par Christophe PETIT
;
; Ce fichier contient les monstres de la tour 3, avec leurs déclarations, leurs
; sprites et leurs attaques. Il doit être inclu à la fin de ED2.asm avec la
; directive "INCLUDE .\PACKE3.asm", afin d'être compilé. C'est ED2PACK3.vbs qui
; se charge de la compilation et de l'extraction du fichier PACKE3.BIN à partir
; du code compilé ED2PACK3.BIN.
;
; Liste des ennemis du pack:
; E00 : (pas de boss)
; E01 : Araignée rouge.
; E02 : Spectre de guerrier mage jaune.
; E03 : Mimique (immitation de coffre).
; E04 : Cerbère.
; E05 : Trooper rouge.
; =============================================================================

; Adresse $8710
E0X_G06:	; Adresses des ennemis et de leur routine de restauration en G06
	FDB E01_G06
	FDB REST06B		; Restauration pour petits ennemis au sol.
	FDB E02_G06
	FDB REST06		; Restauration pour grands ennemis.
	FDB CHEST06
	FDB REST06B		; Restauration pour petits ennemis au sol.
	FDB E04_G06
	FDB REST06		; Restauration pour grands ennemis.
	FDB E05_G06
	FDB REST06		; Restauration pour grands ennemis.	

; Adresse $8724
E0X_G09:	; Adresses des ennemis et de leur routine de restauration en G09
	FDB E01_G09
	FDB REST09B		; Restauration pour petits ennemis au sol.
	FDB E02_G09
	FDB REST09		; Restauration pour grands ennemis.
	FDB CHEST09
	FDB REST09B		; Restauration pour petits ennemis au sol.
	FDB E04_G09
	FDB REST09		; Restauration pour grands ennemis.
	FDB E05_G09
	FDB REST09		; Restauration pour grands ennemis.	

; Adresse $8738
E0X_G10:	; Adresses des ennemis et de leur routine de restauration en G10
	FDB E01_G10
	FDB REST10B		; Restauration pour petits ennemis au sol.	
	FDB E02_G10
	FDB REST10		; Restauration pour grands ennemis.
	FDB CHEST10
	FDB REST10B		; Restauration pour petits ennemis au sol.	
	FDB E04_G10
	FDB REST10		; Restauration pour grands ennemis.
	FDB E05_G10
	FDB REST10		; Restauration pour grands ennemis.		

; Adresse $874C	
E0X_G12:	; Adresses des ennemis et de leur routine de restauration en G12
	FDB E01_G12
	FDB REST12B		; Restauration pour petits ennemis au sol.	
	FDB E02_G12
	FDB REST12		; Restauration pour grands ennemis.
	FDB CHEST12
	FDB REST12B		; Restauration pour petits ennemis au sol.	
	FDB E04_G12
	FDB REST12		; Restauration pour grands ennemis.	
	FDB E05_G12
	FDB REST12		; Restauration pour grands ennemis.	

; Adresse $8760	
E0X_G14:	; Adresses des ennemis et de leur routine de restauration en G14
	FDB E01_G14
	FDB REST14B		; Restauration pour petits ennemis au sol.
	FDB E02_G14
	FDB REST14		; Restauration pour grands ennemis.
	FDB CHEST14
	FDB REST14B		; Restauration pour petits ennemis au sol.
	FDB E04_G14
	FDB REST14		; Restauration pour grands ennemis.
	FDB E05_G14
	FDB REST14		; Restauration pour grands ennemis.

; Adresse $8774	
E0X_G15:	; Adresses des ennemis et de leur routine de restauration en G15
	FDB E01_G15
	FDB REST15B		; Restauration pour petits ennemis au sol.
	FDB E02_G15
	FDB REST15		; Restauration pour grands ennemis.
	FDB CHEST15
	FDB REST15B		; Restauration pour petits ennemis au sol.
	FDB E04_G15
	FDB REST15		; Restauration pour grands ennemis.
	FDB E05_G15
	FDB REST15		; Restauration pour grands ennemis.			

; Adresse $8788
E0X_G18:	; Adresses des ennemis et de leur routine de restauration en G18
	FDB E01_G18
	FDB REST18B		; Restauration pour petits ennemis au sol.
	FDB E02_G18
	FDB REST18		; Restauration pour grands ennemis.
	FDB CHEST18
	FDB REST18B		; Restauration pour petits ennemis au sol.
	FDB E04_G18
	FDB REST18		; Restauration pour grands ennemis.
	FDB E05_G18
	FDB REST18		; Restauration pour grands ennemis.	

; Adresse $879C	
E0X_G19:	; Adresses des ennemis et de leur routine de restauration en G19
	FDB E01_G19
	FDB REST19B		; Restauration pour petits ennemis au sol.	
	FDB E02_G19
	FDB REST19		; Restauration pour grands ennemis.
	FDB CHEST19
	FDB REST19B		; Restauration pour petits ennemis au sol.	
	FDB E04_G19
	FDB REST19		; Restauration pour grands ennemis.	
	FDB E05_G19
	FDB REST19B		; Restauration pour le pied gauche du trooper seulement.	

; Adresse $87B0	
E0X_G21:	; Adresses des ennemis et de leur routine de restauration en G21
	FDB E01_G21
	FDB REST21B		; Restauration pour petits ennemis au sol.
	FDB E02_G21
	FDB REST21		; Restauration pour grands ennemis.
	FDB CHEST21
	FDB REST21B		; Restauration pour petits ennemis au sol.
	FDB E04_G21
	FDB REST21		; Restauration pour grands ennemis.
	FDB E05_G21
	FDB REST21		; Restauration pour grands ennemis.	

; Adresse $87C4	
E0X_G23:	; Adresses des ennemis et de leur routine de restauration en G23
	FDB E01_G23
	FDB REST23B		; Restauration pour petits ennemis au sol.	
	FDB E02_G23
	FDB REST23		; Restauration pour grands ennemis.
	FDB CHEST23
	FDB REST23B		; Restauration pour petits ennemis au sol.	
	FDB E04_G23
	FDB REST23		; Restauration pour grands ennemis.
	FDB E05_G23
	FDB REST23		; Restauration pour grands ennemis.	

; Adresse $87D8	
E0X_G24:	; Adresses des ennemis et de leur routine de restauration en G24
	FDB E01_G24
	FDB REST24B		; Restauration pour petits ennemis au sol.	
	FDB E02_G24
	FDB REST24		; Restauration pour grands ennemis.
	FDB CHEST24
	FDB REST24B		; Restauration pour petits ennemis au sol.	
	FDB E04_G24
	FDB REST24		; Restauration pour grands ennemis.	
	FDB E05_G24
	FDB REST24B		; Restauration pour le pied gauche du trooper seulement.

; Adresse $87EC	
E0X_ATK:	; Déclaration des routines d'attaques (attaques G06 = G12 = G21).
	FDB E01_G06_ATKA
	FDB E02_G06_ATKA
	FDB E03_G06_ATKA
	FDB E04_G06_ATKA
	FDB E05_G06_ATKA

; Adresse $87F6	
E0X_12D:	; Déclaration des ennemis en secteur G12 pour les portes fermées
	FDB GAME_RTS
	FDB GAME_RTS
	FDB CHEST12B
	FDB GAME_RTS
	FDB GAME_RTS

;------------------------------------------------------------------------------
; Données des ennemis. 
;------------------------------------------------------------------------------

; Adresse $8800
DEN_FLAG0	FCB %00000000	; -
DEN_FLAG1	FCB %00000000	; Combat rapproché, non lévitant, mouvant, non immune, normal.
DEN_FLAG2	FCB %00000011	; Combat distant, lévitant, mouvant, non imumne, monstre normal.
DEN_FLAG3	FCB %00000000	; Combat rapproché, non lévitant, mouvant, non immune, toute direction, normal.
DEN_FLAG4	FCB %00001000	; Combat rapproché, non lévitant, mouvant, immune au feu, toute direction, normal.
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
DEN_PA00	FCB	0			; -
DEN_PA01	FCB	6			; (Araignée rouge)
DEN_PA02	FCB	12			; (Spectre de guerrier mage jaune)
DEN_PA03	FCB	7			; (Mimique)
DEN_PA04	FCB	10			; (Cerbère)
DEN_PA05	FCB	14			; (Trooper rouge)

; Points de vie (PV).
DEN_PV00	FCB	0			; -
DEN_PV01	FCB	10			; (Araignée rouge)
DEN_PV02	FCB	50			; (Spectre de guerrier mage jaune)
DEN_PV03	FCB	10			; (Mimique)
DEN_PV04	FCB	20			; (Cerbère)
DEN_PV05	FCB	80			; (Trooper rouge)

; Couleurs de la tâche de sang (COUL).
DEN_COUL00	FCB	0			; -
DEN_COUL01	FCB $51			; magenta (5) sur fond rouge (1).
DEN_COUL02	FCB $10			; rouge (1) sur fond noir (0).
DEN_COUL03	FCB $1B			; rouge (1) sur fond jaune paille (11).
DEN_COUL04	FCB $10			; rouge (1) sur fond noir (0).
DEN_COUL05	FCB $18			; rouge (1) sur fond gris (8).

; Adresse écran de la tâche de sang en secteur 06
DEN_A0600	FDB $0000			; -
DEN_A0601	FDB SCROFFSET+$0DC9	; (Araignée rouge)
DEN_A0602	FDB SCROFFSET+$0649	; (Spectre de guerrier mage jaune)
DEN_A0603	FDB SCROFFSET+$0D29	; (Mimique)
DEN_A0604	FDB SCROFFSET+$082A	; (Cerbère)
DEN_A0605	FDB SCROFFSET+$055A	; (Trooper rouge)

; Adresse écran de la tâche de sang en secteur 12
DEN_A1200	FDB $0000			; -
DEN_A1201	FDB SCROFFSET+$0B22	; (Araignée rouge)
DEN_A1202	FDB SCROFFSET+$064A	; (Spectre de guerrier mage jaune)
DEN_A1203	FDB SCROFFSET+$0AAA	; (Mimique)
DEN_A1204	FDB SCROFFSET+$082A	; (Cerbère)
DEN_A1205	FDB SCROFFSET+$0582	; (Trooper rouge)

; Adresse écran de la tâche de sang en secteur 21
DEN_A2100	FDB $0000			; -
DEN_A2101	FDB SCROFFSET+$08F2	; (Araignée rouge)
DEN_A2102	FDB SCROFFSET+$064A	; (Spectre de guerrier mage jaune)
DEN_A2103	FDB SCROFFSET+$08CA	; (Mimique)
DEN_A2104	FDB SCROFFSET+$06EA	; (Cerbère)
DEN_A2105	FDB SCROFFSET+$0622	; (Trooper rouge)

;------------------------------------------------------------------------------
; INIBOSS : Procédure d'initialisation du Boss de fin.
; Pas de boss dans ce pack.
;------------------------------------------------------------------------------
INIBOSS:	; Adresse $883C

	RTS

;------------------------------------------------------------------------------
; E01_G06_ATK : Araignée en case G6, position d'attaque.
; E01_G06_ATKA sert aux attaques hors champ et E01_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E01_G06_ATKA:
	LDY #E01_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUSA

E01_G06_ATK:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDX #SCROFFSET+$0E16 ; X pointe la première colonne de l'araignée.
	LDA #$81		; A = gris sur fond rouge.
	LBSR G2_R1_40x8
	LDX #SCROFFSET+$0EB9 ; X pointe les yeux de l'araignée.
	LDD #$0128		; A = noir sur fond rouge. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_2A_6
	LDA #$71		; A = blanc sur fond rouge	
	LBSR DISPLAY_2A_8
	
	INC	$A7C0		; Sélection vidéo forme.
	LDX #SCROFFSET+$0CB0 ; X pointe le haut de l'araignée G06
	LDY #E01_G06_ATK_DATA ; Y pointe les données de l'attaque.
	LDD #$FF24		; A = gris. B = 36 pour les sauts de ligne.
	LBSR G2_R1_8x5	; Effacement du haut de l'araignée G06
	LBSR G2_R1_1x5
	LEAX -2,X		; X pointe le haut de l'attaque.
	LDB #20			; 20x2 lignes à dessiner.
E01_G06_ATK_1:
	LBSR BSAVEN_8
	LEAY -8,Y
	LEAX 32,X
	LBSR BSAVEN_8
	LEAX 32,X
	DECB
	BNE E01_G06_ATK_1

	BSR E01_G06_ATKA ; Bruitage de l'attaque.
	LDB #10			; Tempo à réajuster
	LBSR TEMPO		

	LDX #SCROFFSET+$0E16 ; X pointe la première colonne de l'araignée.	
	LDA #$FF
	LBSR G2_R1_40x8	; Forme grise.
	LBSR VIDEOC_A	; Sélection video couleur.
	LDX #SCROFFSET+$0E16 ; X pointe de nouveau la 1ère ligne.
	LDA #$87		; A = gris sur fond blanc.
	LBSR G2_R1_40x8	; Restauration des couleurs + réaffichage de E01_G06

;------------------------------------------------------------------------------
; E01_G06 : Araignée en case G6, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G06:
	CLR >G6D		; Pour la restauration des décors.
	LBSR VIDEOC_A	; Sélection video couleur.	
E01_G06_1:
	LDD #$8124		; A = gris sur fond rouge. B = 36 pour les sauts de ligne.
	LDX #SCROFFSET+$0CB0 ; X pointe la première colonne de l'araignée.
	LBSR G2_R1_16x5
	LBSR G2_R1_6x5
	LDX #SCROFFSET+$0F82 ; X pointe la 3ème colonne de l'araignée.
	LDD #$0128		; A = noir sur fond rouge B = 40 pour les sauts de ligne.
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #$81		; A = gris sur fond rouge	
	STA ,X
	ABX
	STA ,X
	
	INC	$A7C0		; Sélection vidéo forme.
	LDY #E01_G06_DATA ; Y pointe les données
	LDX #SCROFFSET+$0CD8 ; X pointe la 1ere colonne de l'araignée.
	LBSR DISPLAY_2YX_16 ; 20 lignes
	LBSR DISPLAY_2YX_4
	LDX #SCROFFSET+$0CB2 ; X pointe la 3ème colonne de l'araignée.	
	LBSR DISPLAY_YX_16	; 23 lignes
	LBSR DISPLAY_YX_7
	LDX #SCROFFSET+$0CDB ; X pointe la 4ème colonne de l'araignée.		
	LBSR DISPLAY_2YX_16 ; 20 lignes
	LBRA DISPLAY_2YX_4

;------------------------------------------------------------------------------
; E01_G14 : Araignée en case G9, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G14:
	CLR >G14D		; Pour la restauration des décors.
	LDX #SCROFFSET+$0A38 ; X pointe la première colonne de l'araignée.	
	BSR E01_G09_1
	LDX #SCROFFSET+$0A39 ; X pointe la colonne du milieu de l'araignée.	
	BRA E01_G10_R1_1

;------------------------------------------------------------------------------
; E01_G15 : Araignée en case G15, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G15:
	CLR >G15D		; Pour la restauration des décors.
	LDX #SCROFFSET+$0A3A ; X pointe la dernière colonne de l'araignée.
	LDY #E01_G10_DATA2 ; Y pointe les données
	BRA E01_G09_2

;------------------------------------------------------------------------------
; E01_G12 : Araignée en case G12, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G12:
	CLR >G12D		; Pour la restauration des décors.
	LDX #SCROFFSET+$0A31 ; X pointe la première colonne de l'araignée.
	BSR E01_G09_1
	LDX #SCROFFSET+$0A32 ; X pointe la colonne du milieu de l'araignée.
	BSR E01_G10_R1_1
	LDX #SCROFFSET+$0A33 ; X pointe la dernière colonne de l'araignée.	
	BRA E01_G09_2	

;------------------------------------------------------------------------------
; E01_G09 : Araignée en case G9, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G09:
	CLR >G9D		; Pour la restauration des décors.
	LDX #SCROFFSET+$0A29 ; X pointe la première colonne de l'araignée.	

E01_G09_1:
	LDY #E01_G09_DATA ; Y pointe les données

E01_G09_2:
	LBSR VIDEOC_A	; Sélection video couleur.
	PSHS X
	LDD #$1828		; A = rouge sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_14
	PULS X

	INC	$A7C0		; Sélection vidéo forme.
	LBRA DISPLAY_YX_14

;------------------------------------------------------------------------------
; E01_G10 : Araignée en case G10, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G10:
	CLR >G10D		; Pour la restauration des décors.
	LDX #SCROFFSET+$0A2A ; X pointe la colonne du milieu de l'araignée.
	BSR E01_G10_R1
	LDX #SCROFFSET+$0A2B ; X pointe la dernière colonne de l'araignée.	
	BRA E01_G09_2

E01_G10_R1:
	LDY #E01_G10_DATA1 ; Y pointe les données
E01_G10_R1_1:
	LBSR VIDEOC_A	; Sélection video couleur.
	PSHS X
	LDD #$1828		; A = rouge sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_11
	LDA #$10		; A = rouge sur fond noir
	STA ,X
	ABX
	LDA #$18		; A = rouge sur fond gris
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #$78		; A = blanc sur fond gris	
	STA ,X	
	PULS X

	INC	$A7C0		; Sélection vidéo forme.
	LBRA DISPLAY_YX_15

;------------------------------------------------------------------------------
; E01_G21 : Araignée en case G21, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G21:
	CLR >G21D		; Pour la restauration des décors.
	LDX #SCROFFSET+$08F1 ; X pointe la première colonne de l'araignée.	
	BSR E01_G18_1
	LDX #SCROFFSET+$08F2 ; X pointe la deuxième colonne de l'araignée.
	BRA E01_G19_1

;------------------------------------------------------------------------------
; E01_G19 : Araignée en case G19, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G19:
	CLR >G19D		; Pour la restauration des décors.
	LDX #SCROFFSET+$08ED ; X pointe la deuxième colonne de l'araignée.	

E01_G19_1:
	LDY #E01_G19_DATA ; Y pointe les données
	BRA E01_G18_2

;------------------------------------------------------------------------------
; E01_G18 : Araignée en case G18, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G18:
	CLR >G18D		; Pour la restauration des décors.
	LDX #SCROFFSET+$08EC ; X pointe la première colonne de l'araignée.	

E01_G18_1:
	LDY #E01_G18_DATA ; Y pointe les données

E01_G18_2:
	LBSR VIDEOC_A	; Sélection video couleur.
	PSHS X
	LDD #$1828		; A = rouge sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_7
	PULS X

	INC	$A7C0		; Sélection vidéo forme.
	LBRA DISPLAY_YX_7

;------------------------------------------------------------------------------
; E01_G24 : Araignée en case G24, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G24:
	CLR >G24D		; Pour la restauration des décors.
	LDX #SCROFFSET+$08F7 ; X pointe la deuxième colonne de l'araignée.
	BRA E01_G19_1

;------------------------------------------------------------------------------
; E01_G23 : Araignée en case G23, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G23:
	CLR >G23D		; Pour la restauration des décors.
	LDX #SCROFFSET+$08F6 ; X pointe la première colonne de l'araignée.	
	BRA E01_G18_1

;------------------------------------------------------------------------------
; DONNEES DES ARAIGNEES
;------------------------------------------------------------------------------
E01_G06_SON_DATA:
	FCB O2,A0,T3,L9,DOD,SI,P,FIN

E01_G06_ATK_DATA:
	FCB $C3,$FF,$FF,$00,$00,$FF,$FF,$C3
	FCB $F0,$FF,$FC,$00,$00,$3F,$FF,$0F
	FCB $FC,$3F,$F0,$30,$0C,$0F,$FC,$3F
	FCB $FF,$0F,$F0,$0C,$30,$0F,$F0,$FF
	FCB $FF,$C0,$F0,$00,$00,$0F,$03,$FF
	FCB $0F,$F0,$0C,$0E,$70,$30,$0F,$F0
	FCB $C0,$FF,$00,$08,$10,$00,$FF,$03
	FCB $FC,$03,$C0,$00,$00,$03,$C0,$3F
	FCB $FF,$C0,$30,$0E,$70,$0C,$03,$FF
	FCB $FF,$FC,$00,$00,$00,$00,$3F,$FF
	FCB $FF,$C3,$C0,$00,$00,$03,$C3,$FF
	FCB $FF,$00,$38,$00,$00,$1C,$00,$FF
	FCB $FC,$3C,$00,$00,$00,$00,$3C,$3F
	FCB $F0,$FF,$00,$00,$00,$00,$FF,$0F
	FCB $C3,$F0,$C0,$00,$00,$03,$0F,$C3
	FCB $0F,$C0,$00,$00,$00,$00,$03,$F0
	FCB $FF,$0F,$00,$00,$00,$00,$F0,$FF
	FCB $FC,$3F,$F0,$00,$00,$0F,$FC,$3F
	FCB $F0,$FF,$FE,$00,$00,$7F,$FF,$0F
	FCB $C3,$FF,$FF,$E0,$07,$FF,$FF,$C3

E01_G06_ATK2_DATA:
	FCB $00
	FCB $7E
	FCB $7E
	FCB $42
	FCB $42
	FCB $7E
	FCB $7E
	FCB $00

	FCB $E7
	FCB $E7
	FCB $81
	FCB $81
	FCB $00
	FCB $00
	FCB $E7
	FCB $E7

E01_G06_DATA:	
	FCB $FF,$DF	; Colonnes 1 et 2
	FCB $FF,$8E
	FCB $FF,$24
	FCB $FE,$70
	FCB $FC,$D9
	FCB $F9,$89
	FCB $F3,$21
	FCB $F6,$71
	FCB $E4,$D9
	FCB $FD,$88
	FCB $F9,$20
	FCB $FB,$70
	FCB $F2,$7C
	FCB $FE,$E0
	FCB $FC,$CF
	FCB $FD,$DE
	FCB $F9,$9E
	FCB $FF,$BE
	FCB $FF,$BE
	FCB $FF,$3F
	FCB $80		; Colonne 3
	FCB $00
	FCB $1C
	FCB $7F
	FCB $FF
	FCB $9C
	FCB $08
	FCB $08
	FCB $9C
	FCB $F7
	FCB $E3
	FCB $7F
	FCB $49
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $41
	FCB $22
	FCB $00
	FCB $88
	FCB $9C
	FCB $7D,$FF	; Colonnes 4 et 5
	FCB $38,$FF
	FCB $12,$7F
	FCB $87,$3F
	FCB $CD,$9F
	FCB $48,$CF
	FCB $42,$67
	FCB $C7,$37
	FCB $CD,$93
	FCB $88,$DF
	FCB $02,$4F
	FCB $07,$6F
	FCB $1F,$27
	FCB $03,$BF
	FCB $79,$9F
	FCB $3D,$DF
	FCB $3C,$CF
	FCB $3E,$FF
	FCB $3E,$FF
	FCB $7E,$7F

E01_G09_DATA:
	FCB $04
	FCB $0A
	FCB $11
	FCB $25
	FCB $4B
	FCB $51
	FCB $17
	FCB $25
	FCB $29
	FCB $0B
	FCB $12
	FCB $14
	FCB $04
	FCB $04

E01_G10_DATA1:
	FCB $7F
	FCB $E3
	FCB $C1
	FCB $B6
	FCB $B6
	FCB $88
	FCB $C1
	FCB $D5
	FCB $FF
	FCB $7F
	FCB $FF
	FCB $DD
	FCB $7F
	FCB $3E
	FCB $22

E01_G10_DATA2:
	FCB $10
	FCB $A8
	FCB $C4
	FCB $D2
	FCB $E9
	FCB $C5
	FCB $F4
	FCB $D2
	FCB $CA
	FCB $68
	FCB $A4
	FCB $94
	FCB $10
	FCB $10

E01_G18_DATA:
	FCB $06
	FCB $09
	FCB $07
	FCB $09
	FCB $07
	FCB $09
	FCB $02

E01_G19_DATA:
	FCB $F6
	FCB $99
	FCB $6E
	FCB $09
	FCB $9E
	FCB $F9
	FCB $F4

;------------------------------------------------------------------------------
; E02_G06_ATK : Spectre jaune en case G6, position d'attaque.
; E02_G06_ATKA sert aux attaques hors champ et E02_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E02_G06_ATKA:
	LDY #E02_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUSA

E02_G06_ATK:
	LDU #E02_G06_ATK_DATA	; U pointe les couleurs de la boule.

E02_G06_ATK_1:
	LDX #SCROFFSET+$05D1 ; X pointe la 1ère boule d'énergie.
	LDY #E02_G06_SON_DATA	; Y pointe le bruitage
	LBRA ATKEN_S		; Affichage de l'attaque + fin.

;------------------------------------------------------------------------------
; E02_G06 : Spectre jaune en case G6, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G06:
	LDA >W6D		; Le mur W6 est-il affiché?
	BNE	E02_G06A	; Si oui => E02_G06A

	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E02_G06B	; Si oui => E02_G06B, sinon => E02_G06C.

; Initialisation pour les spectres devant un mur W24 ou un fond B24.
E02_G06C:
	LDD #$0808		; A = B = Noir sur fond gris.
	BRA E02_G06_2

; Initialisation pour les spectres devant un mur W13.
E02_G06B:
	LDD #$0807		; A = Noir sur fond gris. B = noir sur fond blanc.
	BRA E02_G06_2

; Initialisation pour les spectres devant un mur W6.
E02_G06A:
	LDD #$0707		; A = B = noir sur fond blanc.

; Corps principal
E02_G06_2:
	STD >VARDB1		; VARDB1 = A, VARDB2 = B.
	LBSR E02_G06_R1	; Pour la restitution des décors.

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDX #SCROFFSET+$02B0 ; X pointe le spectre à l'écran.
	LDD #$0825		; A = Noir sur fond gris. B = 37 pour les sauts de ligne.
	LBSR G2_R1_4x4
	LDA >VARDB1
	STA	,X+
	STA	,X+
	STA	,X+
	STA	,X
	ABX
	LDB #$03		; B = Noir sur fond jaune.
	BSR DISPLAY_ABBA_7
	LDA >VARDB2
	BSR DISPLAY_ABBA_3
	LDA #$03		; A = Noir sur fond jaune.
	BSR DISPLAY_ABBA_10
	LDD #$080B		; A = Noir sur fond gris. B = noir sur fond jaune paille.
	BSR DISPLAY_ABBA_8
	LDD #$0303		; A = B = Noir sur fond jaune.
	BSR DISPLAY_ABBA_7
	BSR DISPLAY_ABBA_32
	LDB #$F3		; B = Orange sur fond jaune.	
	BSR DISPLAY_ABBA_2
	LDD #$080F		; A = Noir sur fond gris. B = Noir sur fond orange.
	BSR DISPLAY_ABBA_5
	BRA E02_G06_3	; 2ème partie de code.

; Affichage A,B,B,A sur N lignes. 
DISPLAY_ABBA_32:
	BSR DISPLAY_ABBA_8
DISPLAY_ABBA_24:
	BSR DISPLAY_ABBA_4
DISPLAY_ABBA_20:
	BSR DISPLAY_ABBA_4
DISPLAY_ABBA_16:
	BSR DISPLAY_ABBA_6
DISPLAY_ABBA_10:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
DISPLAY_ABBA_9:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
DISPLAY_ABBA_8:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
DISPLAY_ABBA_7:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
DISPLAY_ABBA_6:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
DISPLAY_ABBA_5:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
DISPLAY_ABBA_4:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
DISPLAY_ABBA_3:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
DISPLAY_ABBA_2:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
DISPLAY_ABBA_1:
	STA ,X+
	STB ,X+
	STB ,X+
	STA ,X
	LEAX 37,X
	RTS

E02_G06_3:
	INC $A7C0		; Sélection vidéo forme.

	LDB #40			; Pour les sauts de ligne
	LDY #E02_G06_DATA
	LDX #SCROFFSET+$02B2 ; Colonne 3	
	LBSR DISPLAY_2YX_32
	LBSR DISPLAY_2YX_6
	LEAX 1,X
	LBSR DISPLAY_YX_6
	LBSR DISPLAY_A_24
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	LEAX -1,X
	LBSR DISPLAY_2YX_8	

	LDX #SCROFFSET+$02B0 ; Colonne 1
	LBSR DISPLAY_2YX_32
	LBSR DISPLAY_2YX_6
	LBSR DISPLAY_YX_6
	LBSR DISPLAY_A_24
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	LBSR DISPLAY_2YX_8

	LDX #SCROFFSET+$08A1 ; Colonne 2
	LBSR DISPLAY_2A_32
	STA ,X
	STA 1,X
	RTS

; Pour la restitution des décors. Routine commune avec E05_G06
E02_G06_R1:
	CLR >G6D
	CLR >W6D
	CLR >W13D
	CLR >G12D
	CLR >B25D
	LBRA MASK_W13B

;------------------------------------------------------------------------------
; E02_G14 : Spectre jaune en case G14, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G14:
	LDB #$07		; B = noir sur fond blanc.
	LDA >W15D		; Le mur W15 est-il affiché?
	BNE	E02_G14_2	; Si oui => E02_G14_2

	INCB			; Sinon W43, W28 ou un fond B28 => B = noir sur fond gris.

E02_G14_2:
	STB >VARDB1
	LBSR MASK_W7	; Pour la restitution des décors.
	LDX #SCROFFSET+$03D0 ; X pointe la partie gauche en G14.	
	LBSR E02_G09_3		; Affichage de la partie gauche.
	LDX #SCROFFSET+$03D1 ; X pointe la partie centrale en G14.
	LBRA E02_G10_R2

;------------------------------------------------------------------------------
; E02_G12 : Spectre jaune en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G12:
	LDB #$07		; B = noir sur fond blanc.
	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E02_G12_2	; Si oui => E02_G12_2.

	INCB			; Sinon mur W24 ou un fond B24 => B = Noir sur fond gris.
	
; Corps principal
E02_G12_2:
	STB >VARDB1
	CLR >W13D		; Pour la restitution des décors.
	CLR >G12D
	LBSR MASK_W13B
	LDX #SCROFFSET+$03C9 ; X pointe la partie gauche en G12.	
	BSR E02_G09_3	; Affichage de la partie gauche.
	LDX #SCROFFSET+$03CA ; X pointe la partie centrale en G12.
	BSR E02_G10_R2
	LDX #SCROFFSET+$03CB ; Partie droite en G12
	BRA E02_G10_R1

;------------------------------------------------------------------------------
; E02_G09 : Spectre jaune en case G09, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G09:
	LDB #$07		; B = noir sur fond blanc.
	LDA >W10D		; Le mur W10 est-il affiché?
	BNE	E02_G09_2	; Si oui => E02_G09_2

	LDA >W32D		; Le mur W32 est-il affiché?
	BNE	E02_G09_2	; Si oui => E02_G09_2

	INCB			; Sinon W19 ou B19 => B = noir sur fond gris.

; Corps principal
E02_G09_2:
	STB >VARDB1
	LBSR MASK_W4	; Pour la restauration des décors.
	LDX #SCROFFSET+$03C1 ; X pointe la partie gauche en G9.
E02_G09_3:
	LDY #E02_G09_DATA ; Y pointe les données de E02_G09.
	BRA E02_G10_R1

;------------------------------------------------------------------------------
; E02_G10 : Spectre jaune en case G10, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G10:
	LDB #$07		; B = noir sur fond blanc.
	LDA >W11D		; Le mur W11 est-il affiché?
	BNE	E02_G10_2	; Si oui => E02_G10_2

	INCB			; Sinon W43, W28 ou B28 => B = noir sur fond gris.

; Corps principal
E02_G10_2:
	STB >VARDB1
	LBSR MASK_W5	; Pour la restauration des décors.
	LDY #E02_G10_DATA1   ; Y pointe les données de E02_G10.
	LDX #SCROFFSET+$03C2 ; Partie centrale.
	BSR E02_G10_R2
	LDX #SCROFFSET+$03C3 ; Partie droite.

; Partie droite. Code commun avec E02_G09_2 et E02_G15_2.
E02_G10_R1:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	PSHS X
	LDD #$0828		; A = Noir sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_5
	LDA >VARDB1		; A = noir sur fond blanc ou gris.
	LBSR DISPLAY_A_7
	LDA #$03		; A = Noir sur fond jaune.
	LBSR DISPLAY_A_5
	LDA #$08		; A = noir sur fond gris.
	LBSR DISPLAY_A_5
	LDA #$03		; A = Noir sur fond jaune.
	LBSR DISPLAY_A_24
	STA	,X
	ABX
	STA	,X
	ABX	
	LDA #$08		; A = Noir sur fond gris
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	PULS X
	
	INC $A7C0		; Sélection vidéo forme.
	LBSR DISPLAY_YX_32
	LBSR DISPLAY_A_14
	LBRA DISPLAY_YX_5
	
; Partie centrale. Code commun avec E02_G12_2 et E02_G14_2.
E02_G10_R2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	PSHS X
	LDD #$0828		; A = Noir sur fond gris. B = 40 pour les sauts de ligne.
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	LDA #$03		; A = Noir sur fond jaune.
	LBSR DISPLAY_A_13
	LDA #$0B		; A = noir sur fond jaune paille.
	LBSR DISPLAY_A_6
	LDA #$03		; A = Noir sur fond jaune.
	LBSR DISPLAY_A_24
	LDA #$F3		; A = orange sur fond jaune.
	STA	,X
	ABX
	LDA #$0F		; A = noir sur fond orange.
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	PULS X

	INC $A7C0		; Sélection vidéo forme.
	LBSR DISPLAY_YX_16
	LBSR DISPLAY_YX_11	
	LBSR DISPLAY_A_20
	LBRA DISPLAY_YX_4	

;------------------------------------------------------------------------------
; E02_G15 : Spectre jaune en case G15, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G15:
	LDB #$07		; B = noir sur fond blanc.
	LDA >W16D		; Le mur W16 est-il affiché?
	BNE	E02_G15_2	; Si oui => E02_G15_2

	LDA >W42D		; Le mur W42 est-il affiché?
	BNE	E02_G15_2	; Si oui => E02_G15_2

	INCB			; Sinon W29 ou B29 => B = noir sur fond gris.

; Corps principal
E02_G15_2:
	STB >VARDB1
	LBSR MASK_W8	; Pour la restauration des décors.
	LDY #E02_G10_DATA2   ; Y pointe les données de E02_G15.
	LDX #SCROFFSET+$03D2 ; Partie droite.
	LBRA E02_G10_R1

;------------------------------------------------------------------------------
; E02_G21 : Spectre jaune en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G21:
	LBSR MASK_W13B	; Pour la restitution des décors.
	LDY #E02_G18_DATA
	LDX #SCROFFSET+$0469 ; Adresse écran de la partie gauche
	LBSR E02_G18_2
	LDX #SCROFFSET+$046A ; Adresse écran de la partie droite
	LBRA E02_G18_2

;------------------------------------------------------------------------------
; E02_G19 : Spectre jaune en case G19, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G19:
	LBSR MASK_W12	; Pour la restitution des décors.
	LDX #SCROFFSET+$0465 ; Adresse écran de la partie droite

E02_G19_1:
	LDY #E02_G19_DATA
	BRA E02_G18_2

;------------------------------------------------------------------------------
; E02_G18 : Spectre jaune en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G18:
	LBSR MASK_W11	; Pour la restauration des décors.
	LDX #SCROFFSET+$0464 ; Adresse écran de la partie gauche

E02_G18_1:
	LDY #E02_G18_DATA
	
E02_G18_2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	PSHS X
	LDD #$0828		; A = Noir sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_4
	LDA #$03		; A = Noir sur fond jaune.
	LBSR DISPLAY_A_8	
	LDA #$08		; A = noir sur fond gris.
	LBSR DISPLAY_A_4
	LDA #$03		; A = Noir sur fond jaune.
	LBSR DISPLAY_A_15
	LDA #$0F		; A = noir sur fond orange.
	STA ,X
	ABX
	STA ,X
	ABX	
	LDA #$08		; A = noir sur fond gris.
	STA ,X
	PULS X
	
	INC $A7C0		; Sélection vidéo forme.
	LBSR DISPLAY_YX_32
	LDA ,Y+
	STA ,X
	ABX
	LDA ,Y+
	STA ,X	
	RTS

;------------------------------------------------------------------------------
; E02_G24 : Spectre jaune en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G24:
	LBSR MASK_W15	; Pour la restauration des décors.
	LDX #SCROFFSET+$046F ; X pointe la première colonne du fantôme.
	LBRA E02_G19_1

;------------------------------------------------------------------------------
; E02_G23 : Spectre jaune en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G23:
	LBSR MASK_W14	; Pour la restauration des décors.
	LDX #SCROFFSET+$046E ; X pointe la première colonne du fantôme.
	LBRA E02_G18_1

;------------------------------------------------------------------------------
; DONNEES DU SPECTRE JAUNE
;------------------------------------------------------------------------------
E02_G06_SON_DATA:
	FCB O3,A5,T3,L5,SI,LA,SO,P,FIN

; Magenta/jaune, rose/rose, blanc/blanc
E02_G06_ATK_DATA:
	FCB $55,$99,$77,$59,$97

E02_G06_DATA:
	FCB $90,$00	; Colonnes 3 et 4
	FCB $D8,$00
	FCB $F8,$00
	FCB $F2,$00
	FCB $F6,$80
	FCB $7F,$80
	FCB $3F,$80
	FCB $1F,$20
	FCB $8F,$30
	FCB $C7,$B0
	FCB $E3,$B8
	FCB $F3,$78
	FCB $F3,$F8
	FCB $F3,$FA
	FCB $F3,$F6
	FCB $F3,$FF
	FCB $E0,$FF
	FCB $C0,$3F
	FCB $00,$1F
	FCB $00,$0F
	FCB $F0,$0F
	FCB $EC,$07
	FCB $DE,$07
	FCB $BF,$07
	FCB $7F,$07
	FCB $7F,$57
	FCB $3F,$AF
	FCB $1F,$57
	FCB $1F,$AF
	FCB $3F,$57
	FCB $7F,$AF
	FCB $FF,$57
	FCB $FF,$AF
	FCB $FC,$7B
	FCB $10,$7B
	FCB $C3,$7B
	FCB $CF,$3B
	FCB $1F,$3B
	FCB     $7B
	FCB     $FB
	FCB     $BB
	FCB     $FB
	FCB     $73
	FCB     $03
	FCB $FC,$03
	FCB $3C,$0F
	FCB $3C,$3F
	FCB $C1,$FF
	FCB $C0,$FF
	FCB $E0,$FE
	FCB $F1,$F8
	FCB $FF,$C0

	FCB $00,$09	; Colonnes 1 et 2
	FCB $00,$1B
	FCB $00,$1F
	FCB $00,$4F
	FCB $01,$6F
	FCB $01,$FE
	FCB $01,$FC
	FCB $04,$F8
	FCB $0C,$F1
	FCB $0D,$E3
	FCB $1D,$C7
	FCB $1E,$CF
	FCB $1F,$CF
	FCB $5F,$CF
	FCB $6F,$CF
	FCB $FF,$CF
	FCB $FF,$07
	FCB $FC,$03
	FCB $F8,$00
	FCB $F0,$00
	FCB $F0,$0F
	FCB $E0,$37
	FCB $E0,$7B
	FCB $E0,$FD
	FCB $E0,$FE
	FCB $EA,$FE
	FCB $F5,$FC
	FCB $EA,$F8
	FCB $F5,$F8
	FCB $EA,$FC
	FCB $F5,$FE
	FCB $EA,$FF
	FCB $F5,$FF
	FCB $DE,$3F
	FCB $DE,$08
	FCB $DE,$C3
	FCB $DC,$F3
	FCB $DC,$F8
	FCB $DE
	FCB $DF
	FCB $DD
	FCB $DF
	FCB $CE
	FCB $C0
	FCB $C0,$3F
	FCB $F0,$3C
	FCB $FC,$3C
	FCB $FF,$83
	FCB $FF,$03
	FCB $7F,$07
	FCB $1F,$8F
	FCB $03,$FF

E02_G09_DATA:
	FCB $00
	FCB $00
	FCB $00
	FCB $02
	FCB $03
	FCB $07
	FCB $17
	FCB $33
	FCB $27
	FCB $37
	FCB $BF
	FCB $FF
	FCB $F8
	FCB $F0
	FCB $F0
	FCB $E1
	FCB $E1
	FCB $EB
	FCB $F5
	FCB $EB
	FCB $F5
	FCB $EB
	FCB $DD
	FCB $DC
	FCB $DD
	FCB $D9
	FCB $DD
	FCB $DB
	FCB $CD
	FCB $C1
	FCB $C1
	FCB $C1	
	FCB $E0
	FCB $F8
	FCB $7F
	FCB $1F
	FCB $07

E02_G10_DATA1:	; Colonne 2
	FCB $89
	FCB $DB
	FCB $FF
	FCB $7E
	FCB $E7
	FCB $C3
	FCB $99
	FCB $3C
	FCB $7E
	FCB $7E
	FCB $7E
	FCB $3C
	FCB $18
	FCB $00
	FCB $BD
	FCB $DB
	FCB $E7
	FCB $E7
	FCB $C3
	FCB $C3
	FCB $E7
	FCB $FF
	FCB $FF
	FCB $42
	FCB $99
	FCB $C3
	FCB $FF
	FCB $66
	FCB $18
	FCB $3C
	FCB $FF

E02_G10_DATA2:	; Colonne 3
	FCB $00
	FCB $00
	FCB $00
	FCB $40
	FCB $C0
	FCB $E0
	FCB $E8
	FCB $CC
	FCB $E4
	FCB $EC
	FCB $FD
	FCB $FF
	FCB $1F
	FCB $0F
	FCB $0F
	FCB $87
	FCB $87
	FCB $D7
	FCB $AF
	FCB $D7
	FCB $AF
	FCB $D7
	FCB $BB
	FCB $3B
	FCB $BB
	FCB $9B
	FCB $BB
	FCB $DB
	FCB $B3
	FCB $83
	FCB $83
	FCB $83
	FCB $07
	FCB $1F
	FCB $FE
	FCB $F8
	FCB $E0

E02_G18_DATA:
	FCB $09
	FCB $0D
	FCB $27
	FCB $B7
	FCB $FE
	FCB $FD
	FCB $FB
	FCB $FB
	FCB $F3
	FCB $E1
	FCB $C2
	FCB $C5
	FCB $EE
	FCB $DC
	FCB $EF
	FCB $DF
	FCB $B0
	FCB $B6
	FCB $AF
	FCB $97
	FCB $87
	FCB $87
	FCB $87
	FCB $87
	FCB $87
	FCB $87
	FCB $87
	FCB $87
	FCB $87
	FCB $87
	FCB $C7
	FCB $F9
	FCB $F3
	FCB $3F

E02_G19_DATA:
	FCB $90
	FCB $B0
	FCB $E4
	FCB $ED
	FCB $7F
	FCB $BF
	FCB $DF
	FCB $DF
	FCB $CF
	FCB $87
	FCB $43
	FCB $A3
	FCB $77
	FCB $6B
	FCB $F7
	FCB $EB
	FCB $0D
	FCB $6D
	FCB $F5
	FCB $E9
	FCB $E1
	FCB $E1
	FCB $E1
	FCB $E1
	FCB $E1
	FCB $E1
	FCB $E1
	FCB $E1
	FCB $E1
	FCB $E1
	FCB $E3
	FCB $9F
	FCB $CF
	FCB $FC

;------------------------------------------------------------------------------
; E03_G06_ATK : Mimique en case G6, position d'attaque.
; E03_G06_ATKA sert aux attaques hors champ et E03_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E03_G06_ATKA:
	LDY #E03_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUS

E03_G06_ATK:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LBSR REST06B	; Restauration des couleurs de fond du coffre en G6
	INC $A7C0		; Sélection vidéo forme.	
	LDA #$FF		; A = formes pleines.
	LBSR REST06B2	; Restauration des formes de fond du coffre en G6

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	BSR E03_G06_ATK_R0 ; Initialisation des couleurs de l'attaque.
	BSR E03_G06_ATK_R1 ; Formes générales de l'attaque.
	LDX #SCROFFSET+$06E9
	LDY #E03_G06_D4		; Y pointe les formes de la langue.
	LBSR DISPLAY_2YX_16	; Affichage de la langue
	LBSR DISPLAY_2YX_6

	BSR E03_G06_ATKA ; Bruitage de l'attaque.
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
E03_G06_ATK_R0:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDB #40			; B = 40 pour les sauts de ligne.
	LDX #SCROFFSET+$0465 ; X pointe l'attaque du mimique à l'écran.	
	LDY #E03_G06_D0	; Y pointe les couleurs	
	BSR E03_G06_ATK_R0A ; Colonnes 1 et 2
	BSR E03_G06_ATK_R0A ; Colonnes 3 et 4
	BSR E03_G06_ATK_R0A ; Colonnes 5 et 6
	BSR E03_G06_ATK_R0A ; Colonnes 7 et 8
E03_G06_ATK_R0A:	 ; Colonnes 9 et 10
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
E03_G06_ATK_R1:
	INC $A7C0		; Sélection vidéo forme
	LDX #SCROFFSET+$0465 ; X pointe l'attaque du mimique à l'écran.
	BSR E03_G06_ATK_R2A	; Colonnes 1, 2 et 3
	LDY #E03_G06_D1
	BSR E03_G06_ATK_R2C	; Colonne 4
	LDY #E03_G06_D2	
	BSR E03_G06_ATK_R2C	; Colonne 5
	BSR E03_G06_ATK_R2B	; Colonnes 6,7 + 8, 9, 10
E03_G06_ATK_R2A:	
	LDY #E03_G06_D1	
	BSR E03_G06_ATK_R2C
E03_G06_ATK_R2B:	
	LDY #E03_G06_D2
	BSR E03_G06_ATK_R2C
	LDY #E03_G06_D3
E03_G06_ATK_R2C:
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
E03_G06_SON_DATA:
	FCB O4,A4,T3,L5,DO,FA,SI,O5,RE,P,FIN

E03_G06_D0:
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

E03_G06_D1:
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

E03_G06_D2:
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

E03_G06_D3:
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

E03_G06_D4:		; Formes de la langue et de la serrure
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
; E04_G06_ATK : Cerbère en case G6, animation de l'attaque
; E04_G06_ATKA sert aux attaques hors champ et E04_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E04_G06_ATKA:
	LDY #E04_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUS

E04_G06_ATK:
	LDU #ATKPL_S1_D1	; U pointe les couleurs de la boule de feu.
	LDX #SCROFFSET+$0992 ; X pointe la 1ère boule d'énergie.
	LDY #E04_G06_SON_DATA ; Y pointe le bruitage
	LBRA ATKEN_S		; Affichage de l'attaque + fin.

;------------------------------------------------------------------------------
; E04_G06 : Cerbère en case G6, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G06:
	LDB #$70		; B = blanc sur fond noir
	LDA >W6D		; Le mur W6 est-il affiché?
	BNE	E04_G06_1	; Si oui => E04_G06_1

	LDB #$80		; B = gris sur fond noir
	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E04_G06_1	; Si oui => E04_G06_1
	
	LDB #$18		; B = rouge sur fond gris.
	LDA >W24D		; Le mur W24 est-il affiché?
	BNE	E04_G06_0	; Si oui => E04_G06_0.

	LDB #$10		; Sinon fond B24 : B = rouge sur fond noir.	

E04_G06_0:
	STB >VARDB1
	LDB #$80		; B = gris sur fond noir.
	STB >VARDB3

	LDB #$17		; B = rouge sur fond blanc.
	LDA >W49D		; Le mur W49 est-il affiché?
	BNE E04_G06_2	; Si oui => E04_G06_2
	
	INCB			; B = $18 = rouge sur fond gris.
	LDA >W25D		; Le mur W25 est-il affiché?
	BNE E04_G06_2	; Si oui => E04_G06_2.

	LDB #$10		; Sinon fond B25 : B = rouge sur fond noir.
	BRA E04_G06_2

E04_G06_1:
	STB >VARDB3
	LDB #$17		; B = rouge sur fond blanc.
	STB >VARDB1

; Couleurs du corps principal
E04_G06_2:
	STB >VARDB2
	CLR >G6D		; Pour la restitution des décors.
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
	LDY #E04_G06_DATA_C3 ; Y pointe les couleurs
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
	BSR E04_G06_R1		; Colonnes 1 et 5
	BSR E04_G06_R2		; Colonnes 2 et 4	

	INC $A7C0			; Sélection vidéo forme.
	LDY #E04_G06_DATA_F12 ; Y pointe les formes.
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

E04_G06_R1:
	LDX #SCROFFSET+$0788 ; X pointe la colonne 1
	LDA >VARDB1
	BSR E04_G06_R1_1
	LDX #SCROFFSET+$078C ; X pointe la colonne 5
	LDA >VARDB2	
E04_G06_R1_1:
	LDY #E04_G06_DATA_C1 ; Y pointe les couleurs
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

E04_G06_R2:
	LDX #SCROFFSET+$0671 ; X pointe la colonne 2
	LDA #$10
	BSR E04_G06_R2_1
	LDX #SCROFFSET+$0673 ; X pointe la colonne 4
	LDA #$80
E04_G06_R2_1:
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
	LDY #E04_G06_DATA_C2 ; Y pointe les couleurs
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
; E04_G14 : Cerbère en case G14, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G14:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W15D		; Le mur W15 est-il affiché?
	BNE	E04_G14_1	; Si oui => E04_G14_1

	LDA >W43D		; Le mur W43 est-il affiché?
	BNE	E04_G14_1	; Si oui => E04_G14_1

	INCB			; B = $x8 = fond gris.
	LDA >W28D		; Le mur W28 est-il affiché?
	BNE	E04_G14_1	; Si oui => E04_G14_1

	ANDB #%11110000	; Sinon B28 : B = $x0 = fond noir.	

E04_G14_1:
	STB >VARDB1
	LBSR MASK_W7	; Pour la restauration des décors.

	LDX #SCROFFSET+$0718 ; X pointe la colonne gauche
	LBSR E04_G09_2
	LDX #SCROFFSET+$06A1 ; X pointe la colonne du milieu
	LBRA E04_G10A	

;------------------------------------------------------------------------------
; E04_G12 : Cerbère en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G12:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E04_G12_1	; Si oui => E04_G12_1

	INCB			; B = $x8 = fond gris.
	LDA >W24D		; Le mur W24 est-il affiché?
	BNE	E04_G12_1	; Si oui => E04_G12_1
	
	ANDB #%11110000	; Sinon B24 : B = $x0 = fond noir.

E04_G12_1:
	STB >VARDB1
	CLR >G12D	 	; Pour les restitutions de décors.
	CLR >W13D
	LBSR MASK_W13B

	LDX #SCROFFSET+$0711 ; X pointe la colonne gauche
	BSR E04_G09_2
	LDX #SCROFFSET+$069A ; X pointe la colonne du milieu
	LBSR E04_G10A
	LDX #SCROFFSET+$0713 ; X pointe la colonne de droite
	LBRA E04_G10B

;------------------------------------------------------------------------------
; E04_G09 : Cerbère en case G9, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G09:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W32D		; Le mur W32 est-il affiché?
	BNE	E04_G09_1	; Si oui => E04_G09_1

	LDA >W10D		; Le mur W10 est-il affiché?
	BNE	E04_G09_1	; Si oui => E04_G09_1

	INCB			; B = $x8 = fond gris.
	LDA >W19D		; Le mur W19 est-il affiché?
	BNE	E04_G09_1	; Si oui => E04_G09_1

	ANDB #%11110000	; Sinon B19 : B = $x0 = fond noir.

E04_G09_1:
	STB >VARDB1
	CLR >G9D		; Pour la restitution des décors.
	LBSR MASK_W4B	; MASK_W4B = CLR >W10D et tout ce qu'il y a derrière W10

	LDX #SCROFFSET+$0709 ; X pointe E04_G09

; Routine commune avec E04_G12 et E04_G14
E04_G09_2:
	BSR E04_G09_R1

; Routine commune avec E04_G10B
E04_G09_3:
	INC $A7C0			; Sélection vidéo forme.
	LEAX -1400,X		; X pointe de nouveau E04_G09.
	LBSR DISPLAY_YX_32	; Lignes 5 à 36
	LDA ,Y+
	STA ,X				; Ligne 37
	ABX	
	LDA ,Y
	STA ,X				; Ligne 38	
	RTS

; Routine commune avec E04_G10B
E04_G09_R1:
	LBSR VIDEOC_B		; Sélection vidéo couleur.
	LDB #40				; B = 40 pour les sauts de ligne.
	LDY #E04_G09_DATA	; Y pointe les données de couleur
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

;------------------------------------------------------------------------------
; E04_G10 : Cerbère en case G10, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G10:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W11D		; Le mur W11 est-il affiché?
	BNE	E04_G10_1	; Si oui => E04_G10_1

	LDA >W33D		; Le mur W33 est-il affiché?
	BNE	E04_G10_1	; Si oui => E04_G10_1

	INCB			; B = $x8 = fond gris.
	LDA >W20D		; Le mur W20 est-il affiché?
	BNE	E04_G10_1	; Si oui => E04_G10_1

	ANDB #%11110000	; Sinon B20 : B = $x0 = fond noir.

E04_G10_1:
	STB >VARDB1
	LBSR MASK_W5	; Pour la restauration des décors.

	LDX #SCROFFSET+$0692 ; X pointe la colonne du milieu
	BSR E04_G10A	; Affichage
	LDX #SCROFFSET+$070B ; X pointe la colonne de droite + affichage

; Colonne de droite, commune avec E04_G12 et E04_G15
E04_G10B:
	BSR E04_G09_R1		; Affichage des couleurs
	LDY #E04_G10B_DATA	; Y pointe les données de forme
	LBRA E04_G09_3		; Affichage des formes.

; Colonne du milieu, commune avec E04_G12 et E04_G14
E04_G10A:
	LBSR VIDEOC_A		; Sélection vidéo couleur.
	LDB #40				; B = 40 pour les sauts de ligne.
	LDY #E04_G10A_DATA	; Y pointe les données de couleur
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
	LEAX -1440,X		; X pointe de nouveau E04_G10A.	
	LBSR DISPLAY_YX_32	; Lignes 1 à 32
	LBRA DISPLAY_YX_5	; Lignes 33 à 37

;------------------------------------------------------------------------------
; E04_G15 : Cerbère en case G15, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G15:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W16D		; Le mur W16 est-il affiché?
	BNE	E04_G15_1	; Si oui => E04_G15_1

	LDA >W42D		; Le mur W42 est-il affiché?
	BNE	E04_G15_1	; Si oui => E04_G15_1

	INCB			; B = $x8 = fond gris.
	LDA >W29D		; Le mur W29 est-il affiché?
	BNE	E04_G15_1	; Si oui => E04_G15_1

	ANDB #%11110000	; Sinon B29 : B = $x0 = fond noir.

E04_G15_1:
	STB >VARDB1
	CLR >G15D		; Pour la restitution des décors
	CLR >W16D
	LBSR MASK_W16

	LDX #SCROFFSET+$071A ; X pointe E04_G15
	BRA E04_G10B

;------------------------------------------------------------------------------
; E04_G24 : Cerbère en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G24:
	LDA #$18		; A = rouge sur fond gris.
	LDB >W27D		; Le mur W27 est-il affiché?
	BNE	E04_G24_1	; Si oui => E04_G24_1

	ANDA #%11110000	; Sinon B27 : A = $x0 = fond noir.

E04_G24_1:
	STA >VARDB1
	CLR >G24D		; Pour la restitution des décors
	CLR >W27D
	CLR >B27D
	CLR >B27DRD

	LDX #SCROFFSET+$0627 ; X pointe E04_G24.
	BRA E04_G19_2

;------------------------------------------------------------------------------
; E04_G23 : Cerbère en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G23:
	LDA #$18		; A = rouge sur fond gris.
	LDB >W26D		; Le mur W26 est-il affiché?
	BNE	E04_G23_1	; Si oui => E04_G23_1

	ANDA #%11110000	; Sinon B26 : A = $x0 = fond noir.

E04_G23_1:
	STA >VARDB1
	LBSR MASK_W14	; Pour la restauration des décors.

	LDX #SCROFFSET+$0626 ; X pointe E04_G23.
	BRA E04_G18_2

;------------------------------------------------------------------------------
; E04_G19 : Cerbère en case G19, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G19:
	LDA #$18		; A = rouge sur fond gris.
	LDB >W22D		; Le mur W22 est-il affiché?
	BNE	E04_G19_1	; Si oui => E04_G19_1

	ANDA #%11110000	; Sinon B22 : A = $x0 = fond noir.

E04_G19_1:
	STA >VARDB1
	LBSR MASK_W12	; Pour la restauration des décors.

	LDX #SCROFFSET+$061D ; X pointe E04_G19.

; Routine commune avec E04_G21 et E04_G25
E04_G19_2:
	BSR E04_G18_R0
	LDY #E04_G19_DATA	; Y pointe les données de forme
	LBSR DISPLAY_YX_16	; Lignes 1 à 16
	LBRA DISPLAY_YX_9	; Lignes 17 à 25

;------------------------------------------------------------------------------
; E04_G18 : Cerbère en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G18:
	LDA #$18		; A = rouge sur fond gris.
	LDB >W21D		; Le mur W21 est-il affiché?
	BNE	E04_G18_1	; Si oui => E04_G18_1

	LDA #$10		; Sinon B21 : A = rouge fond noir.

E04_G18_1:
	STA >VARDB1
	CLR >G18D		; Pour la restauration des décors.
	CLR >W21D
	CLR >B21D
	CLR >B21GAD	

	LDX #SCROFFSET+$061C ; X pointe E04_G18.

; Routine commune avec E04_G21 et E04_G24
E04_G18_2:
	BSR E04_G18_R0
	LBSR DISPLAY_YX_16	; Lignes 1 à 16
	LBRA DISPLAY_YX_9	; Lignes 17 à 25

E04_G18_R0:
	LDY #E04_G18_DATA	; Y pointe les données de couleur
	LBSR VIDEOC_B		; Sélection vidéo couleur.
	LDB #40				; B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_2	; Lignes 1 à 2
	LBSR DISPLAY_YX_16	; Lignes 3 à 18
	LBSR DISPLAY_YX_7	; Lignes 19 à 25
	LEAX -1000,X
	INC $A7C0			; Sélection vidéo forme.	
	RTS

;------------------------------------------------------------------------------
; E04_G21 : Cerbère en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G21:
	LDA #$18		; A = rouge sur fond gris.
	LDB >W24D		; Le mur W24 est-il affiché?
	BNE	E04_G21_1	; Si oui => E04_G21_1

	LDA #$10		; Sinon B24 : A = rouge sur fond noir.

E04_G21_1:
	STA >VARDB1
	LBSR MASK_W13B	; Pour la restitution des décors.
	
	LDX #SCROFFSET+$0622 ; X pointe E04_G21 colonne 2.	
	BSR E04_G19_2
	LDA >VARDB1
	LDX #SCROFFSET+$0621 ; X pointe E04_G21 colonne 1.	
	BRA E04_G18_2

;------------------------------------------------------------------------------
; DONNEES DES CERBERES
;------------------------------------------------------------------------------
E04_G06_SON_DATA:
	FCB O4,A5,T4,L3,DO,FA,SI,P,FIN

E04_G06_DATA_C3:
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

E04_G06_DATA_C1:
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

E04_G06_DATA_C2:
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

E04_G06_DATA_F12:
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

E04_G06_DATA_F3:
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

E04_G06_DATA_F45:
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

E04_G09_DATA:
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

E04_G10A_DATA:
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

E04_G10B_DATA:
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

E04_G18_DATA:
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

E04_G19_DATA:
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
; E05_G06_ATK : TROOPER rouge en case G6, animation de l'attaque
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
; E05_G06 : TROOPER rouge en case G6, position d'attente.
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
	LBSR E02_G06_R1	; Pour la restitution des décors.

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
	LDA #$01
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
	LDA #$01
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
; E05_G15 : TROOPER rouge en case G15, position d'attente.
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
	CLR >G15D		; Pour la restitution des décors
	CLR >W16D
	LBSR MASK_W16
	LDX #SCROFFSET+$0422 ; X pointe E05_G15
	BRA E05_G10_2

;------------------------------------------------------------------------------
; E05_G10 : TROOPER rouge en case G10, position d'attente.
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
; E05_G12 : TROOPER rouge en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G12:
	LDB #$17		; B = rouge sur fond blanc.
	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E05_G12_1	; Si oui => E05_G12_1

	INCB			; B = $x8 = fond gris.	

E05_G12_1:
	STB >VARDB1
	CLR >G12D	 	; Pour les restitutions de décors.
	CLR >W13D
	LBSR MASK_W13B
	LDX #SCROFFSET+$041A ; X pointe E05_G12 colonne 2
	BSR E05_G10_2
	LDX #SCROFFSET+$0419 ; X pointe E05_G12 colonne 1
	BRA E05_G09_2

;------------------------------------------------------------------------------
; E05_G14 : TROOPER rouge en case G14, position d'attente.
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
; E05_G09 : TROOPER rouge en case G9, position d'attente.
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
	STB >VARDB1
	CLR >G9D		; Pour la restitution des décors.
	LBSR MASK_W4B
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
	LDA #$01
	LBSR DISPLAY_A_16 	; Lignes 19 à 26	
	LBSR DISPLAY_A_12 	; Lignes 27 à 38
	LDA #$08
	LBSR DISPLAY_A_9 	; Lignes 39 à 47

	INC $A7C0			; Sélection vidéo forme.
	LEAX -1880,X		; X pointe de nouveau E05_G09.
	LBSR DISPLAY_YX_32	; Lignes 1 à 32
	LBRA DISPLAY_YX_15	; Lignes 33 à 47

;------------------------------------------------------------------------------
; E05_G24 : TROOPER rouge en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G24:
	CLR >G24D			; Pour la restauration des décors
	LDX #SCROFFSET+$0947 ; X pointe E05_G24.
	BRA E05_G19_2

;------------------------------------------------------------------------------
; E05_G19 : TROOPER rouge en case G19, position d'attente.
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
; E05_G21 : TROOPER rouge en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G21:
	LDA #$08			; A = noir sur fond gris.
	LDB >W24D			; Le mur W24 est-il affiché?
	BNE	E05_G21_IN2		; Si oui => E05_G21_IN2

	CLRA				; Sinon B24 : A = noir sur fond noir.

E05_G21_IN2:
	STA >VARDB1
	LBSR MASK_W13B	; Pour la restitution des décors.

	LDX #SCROFFSET+$0532 ; X pointe la première colonne
	BSR E05_G18_2
	LDX #SCROFFSET+$0943 ; X pointe la deuxième colonne
	BRA E05_G19_2

;------------------------------------------------------------------------------
; E05_G18 : TROOPER rouge en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G18:
	LDA #$08		; A = noir sur fond gris.
	LDB >W21D		; Le mur W21 est-il affiché?
	BNE	E05_G18_IN2	; Si oui => E05_G18_IN2

	CLRA			; Sinon B21 : A = noir sur fond noir.

E05_G18_IN2:
	STA >VARDB1
	CLR >G18D		; Pour la restauration des décors.
	CLR >W21D
	CLR >B21D
	CLR >B21GAD	

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
	LDA #$01
	LBSR DISPLAY_A_17	; Lignes 7 à 23
	LDA #$08
	LBSR DISPLAY_A_5	; Lignes 24 à 28	

	INC $A7C0			; Sélection vidéo forme.
	LEAX -1120,X		; X pointe de nouveau la colonne.
	LDY #E05_G18_DATA	; Y pointe les données de forme
	LBSR DISPLAY_YX_16	; Lignes 1 à 16
	LBRA DISPLAY_YX_12	; Lignes 17 à 28

;------------------------------------------------------------------------------
; E05_G23 : TROOPER rouge en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E05_G23:
	LDA #$08		; A = noir sur fond gris.
	LDB >W26D		; Le mur W26 est-il affiché?
	BNE	E05_G23_IN2	; Si oui => E05_G23_IN2

	CLRA			; Sinon B25 : A = noir sur fond noir.

E05_G23_IN2:
	STA >VARDB1
	LBSR MASK_W14	; Pour la restauration des décors.
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
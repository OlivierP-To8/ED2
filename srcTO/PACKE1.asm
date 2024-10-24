; =============================================================================
; EVIL DUNGEONS II - DUNGEON CRAWLER POUR MO5 - PACK D'ENNEMIS DE LA TOUR 1.
; Par Christophe PETIT
;
; Ce fichier contient les monstres de la tour 1, avec leurs déclarations, leurs
; sprites et leurs attaques. Il doit être inclu à la fin de ED2.asm avec la
; directive "INCLUDE PACKE1.asm", afin d'être compilé.
;
; Liste des ennemis du pack:
; E00 : Boss = spectre de guerrier mage jaune.
; E01 : Squelette.
; E02 : Fantôme PAC-MAN rouge.
; E03 : Spectre de guerrier mage magenta.
; E04 : Spectre de guerrier mage bleu.
; E05 : Araignée noire.
; =============================================================================

; Adresse $C710
E0X_G06:	; Adresses des ennemis et de leur routine de restauration en G06
	FDB E01_G06
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G06
	FDB REST06A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G06
	FDB REST06		; Restauration pour grands ennemis.
	FDB E04_G06
	FDB REST06		; Restauration pour grands ennemis.
	FDB E05_G06
	FDB REST06B		; Restauration pour petits ennemis au sol.

; Adresse $C724
E0X_G09:	; Adresses des ennemis et de leur routine de restauration en G09
	FDB E01_G09
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G09
	FDB REST09A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G09
	FDB REST09		; Restauration pour grands ennemis.
	FDB E04_G09
	FDB REST09		; Restauration pour grands ennemis.
	FDB E05_G09
	FDB REST09B		; Restauration pour petits ennemis au sol.

; Adresse $C738
E0X_G10:	; Adresses des ennemis et de leur routine de restauration en G10
	FDB E01_G10
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G10
	FDB REST10A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G10
	FDB REST10		; Restauration pour grands ennemis.
	FDB E04_G10
	FDB REST10		; Restauration pour grands ennemis.
	FDB E05_G10
	FDB REST10B		; Restauration pour petits ennemis au sol.

; Adresse $C74C
E0X_G12:	; Adresses des ennemis et de leur routine de restauration en G12
	FDB E01_G12
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G12
	FDB REST12A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G12
	FDB REST12		; Restauration pour grands ennemis.
	FDB E04_G12
	FDB REST12		; Restauration pour grands ennemis.
	FDB E05_G12
	FDB REST12B		; Restauration pour petits ennemis au sol.

; Adresse $C760
E0X_G14:	; Adresses des ennemis et de leur routine de restauration en G14
	FDB E01_G14
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G14
	FDB REST14A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G14
	FDB REST14		; Restauration pour grands ennemis.
	FDB E04_G14
	FDB REST14		; Restauration pour grands ennemis.
	FDB E05_G14
	FDB REST14B		; Restauration pour petits ennemis au sol.

; Adresse $C774
E0X_G15:	; Adresses des ennemis et de leur routine de restauration en G15
	FDB E01_G15
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G15
	FDB REST15A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G15
	FDB REST15		; Restauration pour grands ennemis.
	FDB E04_G15
	FDB REST15		; Restauration pour grands ennemis.
	FDB E05_G15
	FDB REST15B		; Restauration pour petits ennemis au sol.

; Adresse $C788
E0X_G18:	; Adresses des ennemis et de leur routine de restauration en G18
	FDB E01_G18
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G18
	FDB REST18A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G18
	FDB REST18		; Restauration pour grands ennemis.
	FDB E04_G18
	FDB REST18		; Restauration pour grands ennemis.
	FDB E05_G18
	FDB REST18B		; Restauration pour petits ennemis au sol.

; Adresse $C79C
E0X_G19:	; Adresses des ennemis et de leur routine de restauration en G19
	FDB E01_G19
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G19
	FDB REST19A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G19
	FDB REST19		; Restauration pour grands ennemis.
	FDB E04_G19
	FDB REST19		; Restauration pour grands ennemis.
	FDB E05_G19
	FDB REST19B		; Restauration pour petits ennemis au sol.

; Adresse $C7B0
E0X_G21:	; Adresses des ennemis et de leur routine de restauration en G21
	FDB E01_G21
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G21
	FDB REST21A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G21
	FDB REST21		; Restauration pour grands ennemis.
	FDB E04_G21
	FDB REST21		; Restauration pour grands ennemis.
	FDB E05_G21
	FDB REST21B		; Restauration pour petits ennemis au sol.

; Adresse $C7C4
E0X_G23:	; Adresses des ennemis et de leur routine de restauration en G23
	FDB E01_G23
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G23
	FDB REST23A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G23
	FDB REST23		; Restauration pour grands ennemis.
	FDB E04_G23
	FDB REST23		; Restauration pour grands ennemis.
	FDB E05_G23
	FDB REST23B		; Restauration pour petits ennemis au sol.

; Adresse $C7D8
E0X_G24:	; Adresses des ennemis et de leur routine de restauration en G24
	FDB E01_G24
	FDB GAME_RTS	; Pas de restauration de couleurs pour le squelette.
	FDB E02_G24
	FDB REST24A		; Restauration pour ennemis intermédiaires flottants.
	FDB E03_G24
	FDB REST24		; Restauration pour grands ennemis.
	FDB E04_G24
	FDB REST24		; Restauration pour grands ennemis.
	FDB E05_G24
	FDB REST24B		; Restauration pour petits ennemis au sol.

; Adresse $C7EC
E0X_ATK:	; Déclaration des routines d'attaques (attaques G06 = G12 = G21).
	FDB E01_G06_ATKA
	FDB E02_G06_ATKA
	FDB E03_G06_ATKA
	FDB E04_G06_ATKA
	FDB E05_G06_ATKA

; Adresse $C7F6
E0X_12D:	; Déclaration des ennemis en secteur G12 pour les portes fermées
	FDB E01_G12D
	FDB GAME_RTS
	FDB GAME_RTS
	FDB GAME_RTS
	FDB GAME_RTS

;------------------------------------------------------------------------------
; Données des ennemis. 
;------------------------------------------------------------------------------

; Adresse $C800
DEN_FLAG0	FCB %10000011	; Combat distant, lévitant, mouvant, non immune, boss.
DEN_FLAG1	FCB %00000000	; Combat rapproché, non lévitant, mouvant, non immune, normal.
DEN_FLAG2	FCB %00000010	; Combat rapproché, lévitant, mouvant, non immune, monstre normal.
DEN_FLAG3	FCB %00000011	; Combat distant, lévitant, mouvant, non imumne, monstre normal.
DEN_FLAG4	FCB %00000011	; Combat distant, lévitant, mouvant, non immune, monstre normal.
DEN_FLAG5	FCB %00000000	; Combat rapproché, non lévitant, mouvant, non immune, monstre normal.
;                |||||||+ 0 = Combat rapproché, 1 = combat distant.
;                ||||||+- 0 = Non lévitant, 1 = lévitant.
;                |||||+-- 0 = Mouvant, 1 = immobile.
;                ||||+--- 0 = Non immune au feu, 1 = immune.
;                |||+---- 0 = Non immune à la glace, 1 = immune (non utilisé dans cette version).
;                ||+----- 0 = Non immune à l'antimatière, 1 = immune (non utilisé dans cette version).
;                |+------ 0 = Toute direction, 1 = frontal uniquement.
;                +------- 0 = Monstre normal. 1 = boss

; Points d'attaque (PA).
DEN_PA00	FCB	12			; (Boss).
DEN_PA01	FCB	4			; (Squelette).
DEN_PA02	FCB	6			; (Fantôme PAC-MAN rouge)
DEN_PA03	FCB	6			; (Spectre de guerrier mage magenta)
DEN_PA04	FCB	8			; (Spectre de guerrier mage bleu)
DEN_PA05	FCB	4			; (Araignée noire)

; Points de vie (PV).
DEN_PV00	FCB	50			; (Boss).
DEN_PV01	FCB	4			; (Squelette).
DEN_PV02	FCB	4			; (Fantôme PAC-MAN rouge)
DEN_PV03	FCB	6			; (Spectre de guerrier mage magenta)
DEN_PV04	FCB	6			; (Spectre de guerrier mage bleu)
DEN_PV05	FCB	2			; (Araignée noire)

; Couleurs de la tâche de sang (COUL).
DEN_COUL00	FCB c10			; rouge (1) sur fond noir (0).
DEN_COUL01	FCB c17			; rouge (1) sur fond blanc (7).
DEN_COUL02	FCB c51			; magenta (5) sur fond rouge (1).
DEN_COUL03	FCB c10			; rouge (1) sur fond noir (0).
DEN_COUL04	FCB c10			; rouge (1) sur fond noir (0).
DEN_COUL05	FCB c18			; rouge (1) sur fond gris (8).

; Adresse écran de la tâche de sang en secteur 06
DEN_A0600	FDB SCROFFSET+$0649	; (Boss).
DEN_A0601	FDB SCROFFSET+$04E1	; (Squelette).
DEN_A0602	FDB SCROFFSET+$04B9	; (Fantôme PAC-MAN rouge)
DEN_A0603	FDB SCROFFSET+$0649	; (Spectre de guerrier mage magenta)
DEN_A0604	FDB SCROFFSET+$0649	; (Spectre de guerrier mage bleu)
DEN_A0605	FDB SCROFFSET+$0DC9	; (Araignée noire)

; Adresse écran de la tâche de sang en secteur 12
DEN_A1200	FDB SCROFFSET+$064A	; (Boss).
DEN_A1201	FDB SCROFFSET+$0581	; (Squelette).
DEN_A1202	FDB SCROFFSET+$0622	; (Fantôme PAC-MAN rouge)
DEN_A1203	FDB SCROFFSET+$064A	; (Spectre de guerrier mage magenta)
DEN_A1204	FDB SCROFFSET+$064A	; (Spectre de guerrier mage bleu)
DEN_A1205	FDB SCROFFSET+$0B22	; (Araignée noire)

; Adresse écran de la tâche de sang en secteur 21
DEN_A2100	FDB SCROFFSET+$064A	; (Boss).
DEN_A2101	FDB SCROFFSET+$069A	; (Squelette).
DEN_A2102	FDB SCROFFSET+$0621	; (Fantôme PAC-MAN rouge)
DEN_A2103	FDB SCROFFSET+$064A	; (Spectre de guerrier mage magenta)
DEN_A2104	FDB SCROFFSET+$064A	; (Spectre de guerrier mage bleu)
DEN_A2105	FDB SCROFFSET+$08F2	; (Araignée noire)

;------------------------------------------------------------------------------
; INIBOSS : Procédure d'initialisation du Boss de fin.
; Cette procédure transforme les spectres bleus en spectres jaunes. Il ne doit
; donc pas y avoir de spectres bleus dans l'arène du boss.
;------------------------------------------------------------------------------
INIBOSS:	; Adresse $C83C
	LDD #BOSS_G06_ATK_DATA1 ; Couleurs des boules magenta
	STD >E04_G06_ATK+1

	LDA #c03		; A = Noir sur fond jaune.
	STA >E04_G06+1	; Maquillage du spectre bleu en spectre jaune.
	STA >E04_G09+1
	STA >E04_G10+1
	STA >E04_G12+1
	STA >E04_G14+1
	STA >E04_G15+1
	STA >E04_G18+1
	STA >E04_G19+1
	STA >E04_G21+1
	STA >E04_G23+1
	STA >E04_G24+1

	LDA >DEN_FLAG0	; Recopie des données du boss vers E04.
	STA >DEN_FLAG4
	LDA >DEN_PA00
	STA >DEN_PA04
	LDA >DEN_PV00
	STA >DEN_PV04

	RTS

;------------------------------------------------------------------------------
; TTS_1XLN : Dessins de tuiles transparentes d'un octet de large.
;
; Les lignes de données de tuiles doivent être déclarées comme suit:
; FCB AND1,OR1
; AND1 et OR1 = masques ET et OU de chaque ligne.
;
; ENTREES :
; B = 40.
; X pointe l'adresse de la tuile à l'écran.
; Y pointe les données de la tuile.
;------------------------------------------------------------------------------
TTS_1XL48:
	BSR TTS_1XL16
TTS_1XL32:
	BSR TTS_1XL16
TTS_1XL16:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL15:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL14:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL13:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL12:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL11:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL10:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL9:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL8:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL7:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL6:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL5:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL4:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL3:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL2:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
TTS_1XL1:
	LDA ,X
	ANDA ,Y+
	ORA ,Y+
	STA ,X
	ABX
	RTS

;------------------------------------------------------------------------------
; E01_G06_ATK : Squelette  en case G6, position d'attaque.
; E01_G06_ATKA sert aux attaques hors champ et E01_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E01_G06_ATKA:
	LDY #E01_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUSA

E01_G06_ATK:
	LDX #SCROFFSET+$0B47 ; Sauvegarde du fond du bras droit.
	LDY #LISTE1		; Y pointe la liste 1 pour le buffer de fond.
	LDB #40
	LBSR BSAVE2_5
	LDX #SCROFFSET+$0670
	LBSR BSAVE2_48

	LDY #E01_G06_ATK_DATA ; Affichage du bras en position d'attaque.
	LDX #SCROFFSET+$0B47
	LBSR TTS_1XL5
	LDX #SCROFFSET+$0670
	LBSR TTS_1XL9
	LBSR DISPLAY_YX_5
	LBSR TTS_1XL12
	LBSR DISPLAY_YX_12
	LBSR TTS_1XL4
	LDX #SCROFFSET+$0991
	LBSR DISPLAY_YX_9
	LBSR TTS_1XL10

	BSR E01_G06_ATKA ; Bruitage de l'attaque.
	LDB #20			; Tempo
	LBSR TEMPO

	LDX #SCROFFSET+$0B47 ; Restauration du fond du bras droit.
	LDY #LISTE1		; Y pointe la liste 1 pour le buffer de fond.
	LDB #40
	LBSR DISPLAY_2YX_5
	LDX #SCROFFSET+$0670
	LBRA DISPLAY_2YX_48

;------------------------------------------------------------------------------
; E01_G06 : Squelette en case G6, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E01_G06:
	LDY #E01_G06_DATA	; Y pointe les données du squelette.
	LDB #40				; Pour les sauts de ligne.
	LDX #SCROFFSET+$0E8F ; Colonne 1
	LDA ,Y+
	STA ,X
	ABX
	LDA ,Y+
	STA ,X
	LDX #SCROFFSET+$0440 ; Colonne 2
	LBSR TTS_1XL3
	LEAX 80,X
	LBSR TTS_1XL48
	LBSR DISPLAY_YX_15
	LDX #SCROFFSET+$0379 ; Colonnes 3
	LBSR TTS_1XL3
	LBSR DISPLAY_YX_7
	LBSR TTS_1XL1
	LBSR DISPLAY_YX_15
	LBSR TTS_1XL3
	LBSR DISPLAY_YX_16
	LBSR DISPLAY_YX_3
	LBSR TTS_1XL10
	LDX #SCROFFSET+$03A2 ; Colonnes 4 et 5 
	LBSR TTS_1XL12
	LBSR DISPLAY_YX_8
	LBSR DISPLAY_2YX_16
	LBSR DISPLAY_2YX_11
	LBSR TTS_1XL10
	LBSR DISPLAY_YX_11
	LBSR DISPLAY_2YX_4
	LDX #SCROFFSET+$05AB ; Colonne 5
	LBSR TTS_1XL7

; Routine de réinitialisation des décors, commune avec E02, E03 et E04
E01_G06_R1:
	CLR >G6D
	CLR >H6D
	CLR >CH6D
E01_G06_R3:
	CLR >W6D
E01_G06_R2:
	CLR >W13D
	CLR >G12D
	CLR >H12D
	CLR >CH12D
	CLR >B25D
	LBRA MASK_W13B

;------------------------------------------------------------------------------
; E01_G09 : Squelette case G9
;------------------------------------------------------------------------------
E01_G09:
	BSR E01_G09_R1	; Pour la restauration des décors.
	LDX #SCROFFSET+$0579 ; X pointe l'écran en &0579

E01_G09_1:
	LDB #40			; Pour les sauts de ligne.
	LDY #E01_G09_DATA ; Y pointe les données du bras.
	LBSR TTS_1XL16
	LBSR TTS_1XL4
	LEAX 640,X
	LBRA DISPLAY_YX_3

; Routine de réinitialisation des décors, commune avec E03 et E04
E01_G09_R1:
	CLR >G9D
	CLR >H9D
	CLR >CH9D
	LBRA MASK_W4B

;------------------------------------------------------------------------------
; E01_G12 : Squelette case G12
; E01_G12D est pour le buffer de porte.
;------------------------------------------------------------------------------
; Routine spécifique au buffer de porte.
E01_G12D:
	LDB #10
	LDX #BUFFERF+203
	LDY #E01_G09_DATA ; Y pointe les données du bras.
	LBSR TTS_1XL16
	LBSR TTS_1XL4
	LEAX 160,X
	LBSR DISPLAY_YX_3
	LDX #BUFFERF+134
	LBSR E01_G10_1A	; Partie centrale.
	LDX #BUFFERF+165
	BSR E01_G10_2A	; Partie droite.
	BRA E01_G06_R2	; Pour la restituation des décors.

; Routine normale.
E01_G12:
	LDX #SCROFFSET+$0580 ; X pointe l'écran en &0580
	BSR E01_G09_1	; Partie gauche.
	LDX #SCROFFSET+$0469 ; X pointe l'écran en &0469
	BSR E01_G10_1	; Partie centrale.
	LDX #SCROFFSET+$04E2 ; X pointe l'écran en &04E2
	BSR E01_G10_2	; Partie droite.
	BRA E01_G06_R2	; Pour la restituation des décors.

;------------------------------------------------------------------------------
; E01_G14 : Squelette case G14
;------------------------------------------------------------------------------
E01_G14:
	LBSR MASK_W7	; Pour la restauration des décors.
	LDX #SCROFFSET+$0588 ; X pointe l'écran en &0588
	BSR E01_G09_1	; Partie gauche.
	LDX #SCROFFSET+$0471 ; X pointe l'écran en &0471
	BRA E01_G10_1	; Partie centrale.

;------------------------------------------------------------------------------
; E01_G15 : Squelette case G15
;------------------------------------------------------------------------------
E01_G15:
	LDX #SCROFFSET+$04EA ; X pointe l'écran en &048A
	BSR E01_G10_2

; Routine de réinitialisation des décors, commune avec E02, E03 et E04
E01_G15_R1:
	CLR >G15D
	CLR >H15D
	CLR >CH15D
E01_G15_R2:
	CLR >W16D
	LBRA MASK_W16

;------------------------------------------------------------------------------
; E01_G10 : Squelette case G10
;------------------------------------------------------------------------------
E01_G10:
	LBSR MASK_W5	; Pour la restauration des décors.
	LDX #SCROFFSET+$0462 ; X pointe l'écran en &0462
	BSR E01_G10_1	; Dessin de la partie centrale.

	LDX #SCROFFSET+$04DB ; X pointe l'écran en &04DB
E01_G10_2:			; Partie droite du squelette.
	LDB #40			; Pour les sauts de ligne.

E01_G10_2A:
	LDY #E01_G10_DATA2 ; Y pointe les données de la partie droite.
	LBSR TTS_1XL10
	BRA E01_G10_1B

; Partie centrale du squelette.
E01_G10_1:
	LDB #40			; Pour les sauts de ligne.

E01_G10_1A:
	LDY #E01_G10_DATA1 ; Y pointe les données de la partie centrale.
	LBSR TTS_1XL3
	LBSR DISPLAY_YX_10
E01_G10_1B:
	LBSR DISPLAY_YX_16
	LDA ,Y+
	STA ,X
	ABX
	LBSR TTS_1XL6
	LBRA DISPLAY_YX_10

;------------------------------------------------------------------------------
; E01_G23 : Squelette case G23
;------------------------------------------------------------------------------
E01_G23:
	LBSR MASK_W14	; Pour la restauration des décors.
	LDX #SCROFFSET+$05AE ; X pointe l'écran en &05AE
	BRA E01_G18_1	; Partie gauche.

;------------------------------------------------------------------------------
; E01_G24 : Squelette case G24
;------------------------------------------------------------------------------
E01_G24:
	LDX #SCROFFSET+$055F ; X pointe l'écran en &055F
	BSR E01_G19_1	; Partie droite.

E01_G24_R1:			; Pour la restauration des décors.
	LBSR MASK_W43B
E01_G24_R2:
	CLR >W27D		; W27 marqué comme non affiché. Rien derrière.
	CLR >B27D		; B27 marqué comme non affiché.
	CLR >B27DRD
	RTS

;------------------------------------------------------------------------------
; E01_G21 : Squelette case G21
;------------------------------------------------------------------------------
E01_G21:
	LBSR MASK_W13B	; Pour la restitution des décors.
	LDX #SCROFFSET+$05A9 ; X pointe l'écran en &05A9
	BSR E01_G18_1	; Partie gauche.
	LDX #SCROFFSET+$055A ; X pointe l'écran en &055A
	BRA E01_G19_1	; Partie droite.

;------------------------------------------------------------------------------
; E01_G18 : Squelette case G18
;------------------------------------------------------------------------------
E01_G18:
	BSR E01_G18_R1	; Pour la restauration des décors.
	LDX #SCROFFSET+$05A4 ; X pointe l'écran en &05A9

E01_G18_1:
	LDY #E01_G18_DATA ; Y pointe les données de la partie centrale.
	LDB #40			; Pour les sauts de ligne.
	LBSR TTS_1XL16
	LBSR TTS_1XL4
	LBRA DISPLAY_YX_5

E01_G18_R1:
	LBSR MASK_W33B
E01_G18_R2:
	CLR >W21D		; W21 marqué comme non affiché. Rien derrière.
	CLR >B21D		; B21 marqué comme non affiché.
	CLR >B21GAD
	RTS

;------------------------------------------------------------------------------
; E01_G19 : Squelette case G19
;------------------------------------------------------------------------------
E01_G19:
	LBSR MASK_W12	; Pour la restauration des décors.
	LDX #SCROFFSET+$0555 ; X pointe l'écran en &0555

E01_G19_1:
	LDY #E01_G19_DATA ; Y pointe les données de la partie centrale.
	LDB #40			; Pour les sauts de ligne.
	LBSR TTS_1XL7
	LBSR DISPLAY_YX_16
	LBRA DISPLAY_YX_4

;------------------------------------------------------------------------------
; DONNEES DU SQUELETTE
;------------------------------------------------------------------------------
E01_G06_SON_DATA:
	FCB O4,A5,T2,L2,MI,RE,DO,P,FIN

E01_G06_ATK_DATA:
	FCB $FE,$01		; Colonne 1
	FCB $FE,$01
	FCB $FE,$01
	FCB $FE,$01
	FCB $FE,$01
	FCB $80,$46		; Colonne 2
	FCB $80,$45
	FCB $80,$76
	FCB $80,$4D
	FCB $80,$46
	FCB $82,$4D
	FCB $01,$8A
	FCB $01,$9E
	FCB $01,$E2
	FCB $8D
	FCB $D6
	FCB $BB
	FCB $D6
	FCB $BA
	FCB $80,$75
	FCB $C0,$2B
	FCB $C0,$35
	FCB $C0,$2B
	FCB $C0,$35
	FCB $C0,$2B
	FCB $80,$55
	FCB $80,$6A
	FCB $80,$55
	FCB $80,$6A
	FCB $80,$55
	FCB $80,$7F
	FCB $C0
	FCB $80
	FCB $80
	FCB $80
	FCB $80
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $80
	FCB $80
	FCB $80,$40
	FCB $C0,$21
	FCB $E0,$12
	FCB $F0,$0C
	FCB $E3		; Colonne 3
	FCB $E1
	FCB $E0
	FCB $E0
	FCB $E0
	FCB $E0
	FCB $60
	FCB $70
	FCB $7F
	FCB $3F,$40
	FCB $3F,$40
	FCB $1F,$20
	FCB $1F,$20
	FCB $1F,$20
	FCB $1F,$20
	FCB $1F,$20
	FCB $3F,$40
	FCB $3F,$40
	FCB $7F,$80

E01_G06_DATA:
	FCB $FE		; Colonne 1
	FCB $FD
	FCB $FE,$01	; Colonne 2
	FCB $FE,$01
	FCB $FE,$01
	FCB $FF,$00
	FCB $FE,$01
	FCB $F0,$0E
	FCB $E0,$11
	FCB $C0,$24
	FCB $C0,$3E
	FCB $C0,$25
	FCB $C0,$26
	FCB $C0,$25
	FCB $C0,$26
	FCB $C0,$25
	FCB $C0,$26
	FCB $C0,$25
	FCB $C0,$26
	FCB $C2,$3D
	FCB $C1,$26
	FCB $C1,$2E
	FCB $81,$52
	FCB $80,$6D
	FCB $80,$5A
	FCB $C0,$2E
	FCB $E0,$1A
	FCB $E0,$16
	FCB $E0,$1A
	FCB $E0,$1F
	FCB $E0,$12
	FCB $C0,$21
	FCB $C0,$21
	FCB $C0,$21
	FCB $C0,$21
	FCB $E0,$12
	FCB $F0,$0E
	FCB $FC,$02
	FCB $FC,$02
	FCB $FC,$02
	FCB $FC,$02
	FCB $FC,$02
	FCB $FC,$02
	FCB $F8,$04
	FCB $F8,$04
	FCB $FC,$03
	FCB $F8,$04
	FCB $F8,$04
	FCB $FC,$03
	FCB $F8,$04
	FCB $F8,$04
	FCB $F8,$04
	FCB $F8,$04
	FCB $FC
	FCB $FC
	FCB $FC
	FCB $FC
	FCB $FC
	FCB $F8
	FCB $FC
	FCB $F2
	FCB $F1
	FCB $FF
	FCB $E3
	FCB $D5
	FCB $CB
	FCB $A9
	FCB $59
	FCB $E0,$1F	; Colonne 3
	FCB $C0,$20
	FCB $80,$40
	FCB $80
	FCB $80
	FCB $00
	FCB $7B
	FCB $6A
	FCB $B5
	FCB $80
	FCB $80,$75
	FCB $DF
	FCB $55
	FCB $A0
	FCB $5F
	FCB $31
	FCB $0E
	FCB $E4
	FCB $11
	FCB $E0
	FCB $11
	FCB $FF
	FCB $30
	FCB $E0
	FCB $20
	FCB $E1
	FCB $C0,$23
	FCB $C0,$23
	FCB $40,$A7
	FCB $67
	FCB $27
	FCB $27
	FCB $A7
	FCB $67
	FCB $27
	FCB $A7
	FCB $66
	FCB $67
	FCB $63
	FCB $63
	FCB $61
	FCB $60
	FCB $60
	FCB $60
	FCB $60
	FCB $60
	FCB $70
	FCB $7F
	FCB $3F,$40
	FCB $3F,$40
	FCB $7F,$80
	FCB $7F,$80
	FCB $7F,$80
	FCB $7F,$80
	FCB $3F,$40
	FCB $3F,$40
	FCB $7F,$80
	FCB $7F,$80
	FCB $7F,$80	; Colonne 4 et 5
	FCB $3F,$40
	FCB $1F,$20
	FCB $1F,$20
	FCB $0F,$10
	FCB $0F,$D0
	FCB $0F,$D0
	FCB $1F,$A0
	FCB $1F,$20
	FCB $3F,$C0
	FCB $0F,$70
	FCB $01,$2E
	FCB $B1
	FCB $44
	FCB $8F
	FCB $14
	FCB $EC
	FCB $14
	FCB $EE
	FCB $16
	FCB $FF,$FF
	FCB $00,$03
	FCB $40,$81
	FCB $C4,$C1
	FCB $CE,$E1
	FCB $9D,$71
	FCB $9F,$71
	FCB $1B,$B9
	FCB $BC,$79
	FCB $FF,$F9
	FCB $FF,$F9
	FCB $FF,$F9
	FCB $BF,$79
	FCB $3E,$39
	FCB $1C,$39
	FCB $1E,$19
	FCB $1E,$39
	FCB $0F,$31
	FCB $87,$71
	FCB $87,$61
	FCB $A3,$41
	FCB $23,$01
	FCB $37,$01
	FCB $1E,$01
	FCB $0C,$01
	FCB $00,$03
	FCB $FF,$FF
	FCB $C1,$22
	FCB $C1,$22
	FCB $E3,$1C
	FCB $E1,$12
	FCB $E1,$12
	FCB $E3,$1C
	FCB $C1,$22
	FCB $C1,$22
	FCB $E1,$12
	FCB $E1,$12
	FCB $F3
	FCB $F3
	FCB $F3
	FCB $F3
	FCB $F3
	FCB $F1
	FCB $F3
	FCB $F4
	FCB $F8
	FCB $FF
	FCB $F8
	FCB $F5,$7F
	FCB $FA,$7F
	FCB $F2,$AF
	FCB $F3,$57
	FCB $7F,$80
	FCB $7F,$80
	FCB $7F,$80
	FCB $7F,$80
	FCB $3F,$40
	FCB $3F,$40
	FCB $3F,$40

; G09 = partie gauche
E01_G09_DATA:
	FCB $FC,$03
	FCB $F8,$04
	FCB $F8,$07
	FCB $F8,$05
	FCB $F8,$05
	FCB $F8,$05
	FCB $F8,$05
	FCB $F0,$0B
	FCB $F0,$0B
	FCB $F0,$0C
	FCB $F0,$0B
	FCB $F0,$0A
	FCB $F8,$07
	FCB $FC,$02
	FCB $FC,$03
	FCB $FC,$02
	FCB $FC,$03
	FCB $F8,$04
	FCB $F8,$04
	FCB $FC,$03
	FCB $FE
	FCB $FC
	FCB $F1

; G10 = partie centrale
E01_G10_DATA1:
	FCB $F3,$1C
	FCB $C1,$22
	FCB $80,$41
	FCB $80
	FCB $B6
	FCB $AA
	FCB $41
	FCB $EB
	FCB $55
	FCB $A2
	FCB $7F
	FCB $88
	FCB $77
	FCB $9F
	FCB $78
	FCB $92
	FCB $F6
	FCB $54
	FCB $F6
	FCB $97
	FCB $97
	FCB $B6
	FCB $D4
	FCB $B6
	FCB $92
	FCB $92
	FCB $90
	FCB $90
	FCB $98
	FCB $9F
	FCB $0E,$91
	FCB $0E,$91
	FCB $0E,$F1
	FCB $0E,$91
	FCB $0E,$F1
	FCB $0E,$91
	FCB $9F
	FCB $9F
	FCB $9F
	FCB $9F
	FCB $5F
	FCB $3F
	FCB $FF
	FCB $3F
	FCB $BF
	FCB $3F

; G10 = partie droite
E01_G10_DATA2:
	FCB $7F,$80
	FCB $7F,$80
	FCB $7F,$80
	FCB $FF,$00
	FCB $1F,$E0
	FCB $0F,$10
	FCB $0F,$70
	FCB $0F,$D0
	FCB $07,$C8
	FCB $07,$68
	FCB $FF
	FCB $03
	FCB $49
	FCB $ED
	FCB $F5
	FCB $CD
	FCB $FD
	FCB $FD
	FCB $ED
	FCB $C5
	FCB $ED
	FCB $69
	FCB $A9
	FCB $E1
	FCB $41
	FCB $03
	FCB $FF
	FCB $1F,$20
	FCB $1F,$20
	FCB $1F,$E0
	FCB $1F,$20
	FCB $1F,$E0
	FCB $1F,$20
	FCB $3F
	FCB $3F
	FCB $3F
	FCB $3F
	FCB $5F
	FCB $9F
	FCB $FF
	FCB $8F
	FCB $A7
	FCB $91

; G18 = partie gauche
E01_G18_DATA:
	FCB $FE,$01
	FCB $FE,$01
	FCB $FC,$03
	FCB $F8,$04
	FCB $F0,$0A
	FCB $F0,$0A
	FCB $E0,$17
	FCB $E0,$13
	FCB $E0,$15
	FCB $E0,$1B
	FCB $F0,$0F
	FCB $F0,$0B
	FCB $F0,$0F
	FCB $F0,$0B
	FCB $F0,$09
	FCB $F8,$05
	FCB $F8,$07
	FCB $F8,$05
	FCB $F8,$07
	FCB $F8,$05
	FCB $FD
	FCB $FD
	FCB $FD
	FCB $FB
	FCB $E5

; G19 = partie droite
E01_G19_DATA:
	FCB $BF,$40
	FCB $1F,$A0
	FCB $0F,$10
	FCB $0F,$B0
	FCB $07,$58
	FCB $03,$E4
	FCB $03,$54
	FCB $AB
	FCB $FF
	FCB $01
	FCB $5D
	FCB $55
	FCB $7D
	FCB $7D
	FCB $55
	FCB $39
	FCB $11
	FCB $01
	FCB $FF
	FCB $6D
	FCB $BA
	FCB $6D
	FCB $EF
	FCB $EF
	FCB $EF
	FCB $F7
	FCB $E9

;------------------------------------------------------------------------------
; E02_G06_ATK : Fantôme rouge en case G6, animation de l'attaque
; E02_G06_ATKA sert aux attaques hors champ et E02_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E02_G06_ATKA:
	LDY #E02_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUS

E02_G06_ATK:
	LBSR VIDEOC_A	; Sélection vidéo couleur.

	LDD #c1118		; A = rouge sur fond rouge. B = 24 pour les sauts de ligne.
	LDX #SCROFFSET+$0002
	LBSR G2_R1_12x16
	LDX #SCROFFSET+$0822
	LBSR G2_R1_16x16
	LDX #SCROFFSET+$1222
	LBSR G2_R1_15x16
	LDD #c001C		; A = noir sur fond noir. B = 26 pour les sauts de ligne.
	LDX #SCROFFSET+$0AA4
	LBSR G2_R1_48x12
	LDD #c1111		; A = B = rouge sur fond rouge.
	LDX #SCROFFSET+$01E8
	LBSR DISPLAY_ABBA_20
	LDA #c41		; A = bleu sur fond rouge.
	LBSR DISPLAY_ABBA_20
	LDD #c1128		; A = rouge sur fond rouge. B = 40 pour les sauts de ligne.
	LDX #SCROFFSET+$0AA2
	LBSR DISPLAY_2A_48
	LDX #SCROFFSET+$0AB0
	LBSR DISPLAY_2A_48
	BSR E02_G06_ATK_R1
	LDX #SCROFFSET+$01E3
	LBSR DISPLAY_2A_32
	LBSR DISPLAY_2A_8
	LDX #SCROFFSET+$01EF
	LBSR DISPLAY_2A_32
	LBSR DISPLAY_2A_8
	BSR E02_G06_ATK_R2
	LBSR E02_G06_ATK_R3
	LBSR E02_G06_ATK_R4

	INC $E7C3		; Sélection vidéo forme.

	BSR E02_G06_ATK_R0 ; Dessin des formes.
	BSR E02_G06_ATKA ; Bruitage de l'attaque.
	CLR >G2D		; Sol G2 marqué comme non affichés. Pas de trous ici.
	CLR >W2D		; W2 marqué comme non affiché.
	LBSR MASK_W2	; Ainsi que tout ce qu'il y a derrière.

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDA	>MAPCOULC	; A = couleurs mur/sol courantes.
	LDB #24			; Pour les sauts de ligne.
	LDX #SCROFFSET+$0002
	LBSR G2_R1_131x16 ; 131 lignes à réinitialiser.

	INC $E7C3		; Sélection vidéo forme.
	LDA #$39		; A = code machine de l'opérande RTS.
	STA >LISTE0		; LISTE0 initialisée avec un RTS (aucun pré-affichage).
	LBRA SET00		; Réaffichage des décors.

E02_G06_ATK_R0:
	LDY #E02_G06_ATK_DATA
	LDA #$F0
	BSR E02_G06_ATK_R0_1
	LDA #$0F
E02_G06_ATK_R0_1:
	LDX ,Y++
	LBSR DISPLAY_A_20
	LDX ,Y++
	BSR E02_G06_ATK_R1_2
	LDX ,Y++
	BSR E02_G06_ATK_R1_2
	LDX ,Y++
	BSR E02_G06_ATK_R1_2
	LDX ,Y++
	BRA E02_G06_ATK_R1_2

E02_G06_ATK_R1:
	LDX #SCROFFSET+$01E2
	BSR E02_G06_ATK_R1_1
	LDX #SCROFFSET+$01F1
E02_G06_ATK_R1_1:
	LDA #c71
	BSR E02_G06_ATK_R1_2
	LDA #c77
	LBSR DISPLAY_A_32
E02_G06_ATK_R1_2:
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	RTS

E02_G06_ATK_R2:
	LDX #SCROFFSET+$01E5
	BSR E02_G06_ATK_R2_1
	LDX #SCROFFSET+$01EE
E02_G06_ATK_R2_1:
	LDA #c77
	LBSR DISPLAY_A_16
	LDA #c74
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #c44
	LBRA DISPLAY_A_20

E02_G06_ATK_R3:
	LDX #SCROFFSET+$01E6
	BSR E02_G06_ATK_R3_1
	LDX #SCROFFSET+$01ED
E02_G06_ATK_R3_1:
	LDA #c11
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #c71
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #c77
	LBSR DISPLAY_A_8
	LDA #c44
	LBRA DISPLAY_A_24

E02_G06_ATK_R4:
	LDX #SCROFFSET+$01E7
	BSR E02_G06_ATK_R4_1
	LDX #SCROFFSET+$01EC
E02_G06_ATK_R4_1:
	LDA #c11
	LBSR DISPLAY_A_12
	LDA #c71
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #c44
	LBRA DISPLAY_A_24

;------------------------------------------------------------------------------
; E02_G06 : Fantôme rouge en case G6, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G06:
	LDX >SQRADDR	; X pointe la case courante
	LBSR PAS_AV		; Puis la case G6.
	LBSR PAS_AV		; Puis la case G12.
	LDA ,X			; A = contenu de la case G12
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle (mur)?
	BEQ E02_G06A	; Oui => E02_G06A

	LBSR PAS_AV		; X pointe la case G21.
	LDA ,X			; A = contenu de la case G21
	ANDA #%01110000	; A = type de case
	CMPA #%01110000 ; Obstacle (mur)?
	BEQ E02_G06B	; Oui => E02_G06B

; Initialisation pour les fantômes devant un mur W24 ou un fond B24.
E02_G06C:
	LDD #c0101		; A = B = Noir sur fond rouge.
	BRA E02_G06_2

; Initialisation pour les fantômes devant un mur W13.
E02_G06B:
	LDD #c0141		; A = Noir sur fond rouge. B = bleu sur fond rouge.
	BRA E02_G06_2

; Initialisation pour les fantômes devant un mur W6.
E02_G06A:
	LDD #c4141		; A = B = bleu sur fond rouge.

; Corps principal
E02_G06_2:
	STD >VARDB1		; VARDB1 = A, VARDB2 = B.
	LBSR E01_G06_R3	; Pour la restituation des décors.

	LBSR VIDEOC_B	; Sélection video couleur
	LDX #SCROFFSET+$0350 ; X pointe le fantôme à l'écran.
	LDB #37			; B = 37 pour les sauts de ligne.
	LBSR G2_R1_8x4
	LDA #c71		; A = blanc sur fond rouge.
	LBSR G2_R1_8x4
	LDD #c4741		; A = bleu sur fond blanc. B = bleu sur fond rouge.
	LBSR DISPLAY_ABBA_6
	LDD #c1125		; A = rouge sur fond rouge.	B = 37 pour les sauts de ligne.
	LBSR G2_R1_16x4
	LDA >VARDB2
	LBSR G2_R1_5x4

	INC $E7C3		; Sélection vidéo forme.
	LDB #40			; Pour les sauts de ligne.
	LDX #SCROFFSET+$0350 ; X pointe la colonne 1
	LDY #E02_G06_DATA
	BSR E02_G06_3
	LDX #SCROFFSET+$0352 ; X pointe la colonne 3.
E02_G06_3:
	LBSR DISPLAY_2YX_16
	LBSR DISPLAY_2YX_6
	LEAX 640,X
	LBRA DISPLAY_2YX_5

;------------------------------------------------------------------------------
; E02_G14 : Fantôme rouge en case G14, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G14:
	LDA >W15D		; Le mur W15 est-il affiché?
	BNE	E02_G14A	; Si oui => E02_G14A

	LDA >W43D		; Le mur W43 est-il affiché?
	BNE	E02_G14B	; Si oui => E02_G14B, sinon => E02_G14C.

; Initialisation pour les fantômes devant un mur W28 ou un fond B28.
E02_G14C:
	LDD #c0101		; A = B = Noir sur fond rouge.
	BRA E02_G14_2

; Initialisation pour les fantômes devant un mur W43.
E02_G14B:
	LDD #c4101		; A = bleu sur fond rouge. B = noir sur fond rouge.
	BRA E02_G14_2

; Initialisation pour les fantômes devant un mur W15.
E02_G14A:
	LDD #c4141		; A = B = bleu sur fond rouge.

; Corps principal
E02_G14_2:
	STD >VARDB1		; VARDB1 = A, VARDB2 = B.
	LBSR MASK_W7B	; Pour la restitution des décors.
	LDX #SCROFFSET+$0498 ; X pointe la partie gauche en G14.
	LBSR E02_G09_3		; Affichage de la partie gauche.
	LDX #SCROFFSET+$0499 ; X pointe la partie centrale en G14.
	LBRA E02_G10_R2

;------------------------------------------------------------------------------
; E02_G12 : Fantôme rouge en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G12:
	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E02_G12A	; Si oui => E02_G12A. Sinon E02_G12B

; Initialisation pour les fantômes devant un mur W24 ou un fond B24.
E02_G12B:
	LDD #c0101		; A = B = Noir sur fond rouge.
	BRA E02_G12_2

; Initialisation pour les fantômes devant W13.
E02_G12A:
	LDD #c4141		; A = B = bleu sur fond rouge.

; Corps principal
E02_G12_2:
	STD >VARDB1		; VARDB1 = A, VARDB2 = B.

	LBSR MASK_W13B ; Pour la restitution des décors.
	CLR >W13D

	LDX #SCROFFSET+$0491 ; X pointe la partie gauche en G12.
	BSR E02_G09_3	; Affichage de la partie gauche.
	LDX #SCROFFSET+$0492 ; X pointe la partie centrale en G12.
	LBSR E02_G10_R2
	LDX #SCROFFSET+$0493 ; Partie droite en G12
	LBRA E02_G10_3

;------------------------------------------------------------------------------
; E02_G09 : Fantôme rouge en case G9, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G09:
	LDA >W10D		; Le mur W10 est-il affiché?
	BNE	E02_G09A	; Si oui => E02_G09A

	LDA >W32D		; Le mur W32 est-il affiché?
	BNE	E02_G09A	; Si oui => E02_G09A, sinon => E02_G09B.

; Initialisation pour les fantômes devant un mur W19 ou un fond B19.
E02_G09B:
	LDA #c01		; A = Noir sur fond rouge.
	BRA E02_G09_2

; Initialisation pour les fantômes devant un mur W10 ou W32.
E02_G09A:
	LDA #c41		; A = bleu sur fond rouge.

; Corps principal
E02_G09_2:
	STA >VARDB2
	LBSR MASK_W4B	; Pour la restauration des décors.
	LDX #SCROFFSET+$0489 ; X pointe la partie gauche en G9.
E02_G09_3:
	LDY #E02_G09_DATA ; Y pointe les données de E02_G09.
	BRA E02_G10_R1

;------------------------------------------------------------------------------
; E02_G10 : Fantôme rouge en case G10, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G10:
	LDA >W11D		; Le mur W11 est-il affiché?
	BNE	E02_G10A	; Si oui => E02_G10A

	LDA >W33D		; Le mur W33 est-il affiché?
	BNE	E02_G10B	; Si oui => E02_G10B, sinon => E02_G10C.

; Initialisation pour les fantômes devant un mur W29 ou un fond B29.
E02_G10C:
	LDD #c0101		; A = B = Noir sur fond rouge.
	BRA E02_G10_2

; Initialisation pour les fantômes devant un mur W33.
E02_G10B:
	LDD #c4101		; A = bleu sur fond rouge. B = noir sur fond rouge.
	BRA E02_G10_2

; Initialisation pour les fantômes devant un mur W11.
E02_G10A:
	LDD #c4141		; A = B = bleu sur fond rouge.

; Corps principal
E02_G10_2:
	STD >VARDB1		; VARDB1 = A, VARDB2 = B.

	LBSR MASK_W11B	; Pour la restitution des décors.
	CLR >W11D

	LDX #SCROFFSET+$048A ; Partie centrale.
	BSR E02_G10_R2

	LDX #SCROFFSET+$048B ; Partie droite.
E02_G10_3:
	LDY #E02_G10_DATA ; Y pointe les données de E10_G10

; Partie droite. Code commun avec E02_G09_2 et E02_G15_2.
E02_G10_R1:
	LBSR VIDEOC_A	; Sélection vidéo couleur.

	PSHS X
	LDB #40
	LDA >VARDB2
	LBSR DISPLAY_A_9
	LDA #c71
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	LDA #c74
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	LDA >VARDB2
	LBSR DISPLAY_A_15
	PULS X

	INC $E7C3		; Sélection vidéo forme.

	LBSR DISPLAY_YX_16
	LDA ,Y+
	STA ,X
	ABX
	CLRA
	LBSR DISPLAY_A_11
	LBRA DISPLAY_YX_4

; Partie centrale. Code commun avec E02_G12_2 et E02_G14_2.
E02_G10_R2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.

	PSHS X
	LDD #c4128		; A = bleu sur fond rouge. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_17
	LDA >VARDB1
	LBSR DISPLAY_A_15
	PULS X

	INC $E7C3		; Sélection vidéo forme.

	CLRA
	LBSR DISPLAY_A_13
	LDA #$81
	STA	,X
	ABX
	LDA #$C3
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	CLRA
	LBSR DISPLAY_A_11
	LDA #$7E
	LBRA DISPLAY_A_4

;------------------------------------------------------------------------------
; E02_G15 : Fantôme rouge en case G15, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G15:
	LDA >W16D		; Le mur W16 est-il affiché?
	BNE	E02_G15A	; Si oui => E02_G15A

	LDA >W42D		; Le mur W42 est-il affiché?
	BNE	E02_G15A	; Si oui => E02_G15A, sinon => E02_G15B.

; Initialisation pour les fantômes devant un mur W29 ou un fond B29.
E02_G15B:
	LDA #c01		; A = Noir sur fond rouge.
	BRA E02_G15_2

; Initialisation pour les fantômes devant un mur W16 ou W42.
E02_G15A:
	LDA #c41		; A = bleu sur fond rouge.

; Corps principal
E02_G15_2:
	STA >VARDB2
	LBSR E01_G15_R2	; Pour la restitution des décors.
	LDX #SCROFFSET+$049A ; Partie droite.
	LBRA E02_G10_3

;------------------------------------------------------------------------------
; E02_G21 : Fantôme rouge en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G21:
	LDA >W24D		; Le mur W24 est-il affiché?
	BNE	E02_G21A	; Si oui => E02_G21A

; Initialisation pour les fantômes devant un fond B24.
E02_G21B:
	LDA #c01		; A = Noir sur fond rouge.
	BRA E02_G21_2

; Initialisation pour les fantômes devant un mur W24.
E02_G21A:
	LDA #c41		; A = bleu sur fond rouge.

; Corps principal
E02_G21_2:
	STA >VARDB1		; VARDB1 = A
	LBSR MASK_W13C	; Pour la restitution des décors.
	LDX #SCROFFSET+$0531 ; X pointe la première colonne du fantôme.
	BSR E02_G18_3	; Affichage de la première colonne.
	LDX #SCROFFSET+$0532 ; X pointe la deuxième colonne du fantôme.
	BRA E02_G19_3	; Affichage de la deuxième colonne.

;------------------------------------------------------------------------------
; E02_G19 : Fantôme rouge en case G19, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G19:
	LDA >W22D		; Le mur W22 est-il affiché?
	BNE	E02_G19A	; Si oui => E02_G19A

; Initialisation pour les fantômes devant un mur W19 ou un fond B19.
E02_G19B:
	LDA #c01		; A = Noir sur fond rouge.
	BRA E02_G19_2

; Initialisation pour les fantômes devant un mur W10 ou W32.
E02_G19A:
	LDA #c41		; A = bleu sur fond rouge.

; Corps principal
E02_G19_2:
	STA >VARDB1		; VARDB1 = A
	LBSR MASK_W12B	; Pour la restauration des décors.
	LDX #SCROFFSET+$052D ; X pointe la deuxième colonne du fantôme.

; Partie réutilisée par E02_G21 et E02_G24.
E02_G19_3:
	LDY #E02_G19_DATA ; Y pointe les données de formes.
	BRA E02_G18_4	; Affichage de la colonne.

;------------------------------------------------------------------------------
; E02_G18 : Fantôme rouge en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G18:
	LDA >W21D		; Le mur W21 est-il affiché?
	BNE	E02_G18A	; Si oui => E02_G18A

; Initialisation pour les fantômes devant un fond B21.
E02_G18B:
	LDA #c01		; A = Noir sur fond rouge.
	BRA E02_G18_2

; Initialisation pour les fantômes devant un mur W21.
E02_G18A:
	LDA #c41		; A = bleu sur fond rouge.

; Corps principal
E02_G18_2:
	STA >VARDB1		; VARDB1 = A
	LBSR E01_G18_R2	; Pour la restauration des décors.
	LDX #SCROFFSET+$052C ; Adresse écran de la partie gauche

; Partie réutilisée par E02_G21 et E02_G23.
E02_G18_3:
	LDY #E02_G18_DATA ; Y pointe les données de formes.

; Partie réutilisée par E02_G19.
E02_G18_4:
	LBSR VIDEOC_A	; Sélection video couleur.

	PSHS X
	LDB #40
	LDA >VARDB1
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	LDA #c71		; blanc sur fond rouge
	LBSR DISPLAY_A_5
	LDA #c74		; blanc sur fond bleu
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	LDA >VARDB1
	LBSR DISPLAY_A_10
	PULS X

	INC $E7C3		; Sélection vidéo forme.

	LBSR DISPLAY_YX_11
	CLRA
	LBSR DISPLAY_A_8
	LDA ,Y+
	STA ,X
	ABX
	LDA ,Y+
	STA ,X
	RTS

;------------------------------------------------------------------------------
; E02_G24 : Fantôme rouge en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G24:
	LDA >W27D		; Le mur W27 est-il affiché?
	BNE	E02_G24A	; Si oui => E02_G24A

; Initialisation pour les fantômes devant un mur W19 ou un fond B19.
E02_G24B:
	LDA #c01		; A = Noir sur fond rouge.
	BRA E02_G24_2

; Initialisation pour les fantômes devant un mur W10 ou W32.
E02_G24A:
	LDA #c41		; A = bleu sur fond rouge.

; Corps principal
E02_G24_2:
	STA >VARDB1		; VARDB1 = A
	LBSR E01_G24_R2	; Pour la restauration des décors.
	LDX #SCROFFSET+$0537 ; X pointe la première colonne du fantôme.
	LBRA E02_G19_3

;------------------------------------------------------------------------------
; E02_G23 : Fantôme rouge en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E02_G23:
	LDA >W26D		; Le mur W26 est-il affiché?
	BNE	E02_G23A	; Si oui => E02_G23A

; Initialisation pour les fantômes devant un bond B26.
E02_G23B:
	LDA #c01		; A = Noir sur fond rouge.
	BRA E02_G23_2

; Initialisation pour les fantômes devant un mur W26.
E02_G23A:
	LDA #c41		; A = bleu sur fond rouge.

; Corps principal
E02_G23_2:
	STA >VARDB1		; VARDB1 = A
	LBSR MASK_W14B	; Pour la restauration des décors.
	LDX #SCROFFSET+$0536 ; X pointe la première colonne du fantôme.
	LBRA E02_G18_3

;------------------------------------------------------------------------------
; DONNEES DES FANTOMES PAC-MAN
;------------------------------------------------------------------------------
E02_G06_SON_DATA:
	FCB O4,A4,T3,L5,DO,RE,MI,MI,RE,DO,P,FIN

E02_G06_ATK_DATA:
	FDB SCROFFSET+$0508
	FDB SCROFFSET+$0286
	FDB SCROFFSET+$03C7
	FDB SCROFFSET+$01F1
	FDB SCROFFSET+$0465

	FDB SCROFFSET+$050B
	FDB SCROFFSET+$01E2
	FDB SCROFFSET+$028D
	FDB SCROFFSET+$03CC
	FDB SCROFFSET+$046E

E02_G06_DATA:
	FCB $FF,$C0		; Colonnes 1 et 2
	FCB $FE,$00
	FCB $F8,$00
	FCB $F0,$00
	FCB $E0,$00
	FCB $C0,$00
	FCB $80,$00
	FCB $80,$00
	FCB $00,$00
	FCB $00,$00
	FCB $00,$00
	FCB $00,$00
	FCB $7F,$00
	FCB $FF,$80
	FCB $FF,$C0
	FCB $FF,$E0
	FCB $01,$F0
	FCB $03,$F8
	FCB $03,$F8
	FCB $03,$F8
	FCB $03,$F8
	FCB $03,$F8
	FCB $06,$0F
	FCB $0F,$0F
	FCB $1F,$8F
	FCB $3F,$CF
	FCB $7F,$EF

	FCB $03,$FF		; Colonnes 3 et 4
	FCB $00,$7F
	FCB $00,$1F
	FCB $00,$0F
	FCB $00,$07
	FCB $00,$03
	FCB $00,$01
	FCB $00,$01
	FCB $00,$00
	FCB $00,$00
	FCB $00,$00
	FCB $00,$00
	FCB $00,$FE
	FCB $01,$FF
	FCB $03,$FF
	FCB $07,$FF
	FCB $0F,$80
	FCB $1F,$C0
	FCB $1F,$C0
	FCB $1F,$C0
	FCB $1F,$C0
	FCB $1F,$C0
	FCB $F0,$60
	FCB $F0,$F0
	FCB $F1,$F8
	FCB $F3,$FC
	FCB $F7,$FE

E02_G09_DATA:
	FCB $FF	; Formes colonne 1
	FCB $F8
	FCB $E0
	FCB $C0
	FCB $80
	FCB $80
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $7C
	FCB $FE
	FCB $FF
	FCB $F8
	FCB $F0
	FCB $F0
	FCB $F0
	FCB $08
	FCB $1C
	FCB $3E
	FCB $7F

E02_G10_DATA:
	FCB $FF	; Formes colonne 3
	FCB $1F
	FCB $07
	FCB $03
	FCB $01
	FCB $01
	FCB $00
	FCB $00
	FCB $00
	FCB $00
	FCB $3E
	FCB $7F
	FCB $FF
	FCB $1F
	FCB $0F
	FCB $0F
	FCB $0F
	FCB $10
	FCB $38
	FCB $7C
	FCB $FE

E02_G18_DATA:
	FCB $F0	; Formes colonne 1
	FCB $C0
	FCB $80
	FCB $00
	FCB $00
	FCB $00
	FCB $78
	FCB $FC
	FCB $F8
	FCB $F0
	FCB $F8
	FCB $33
	FCB $7B

E02_G19_DATA:
	FCB $0F	; Formes colonne 2
	FCB $03
	FCB $01
	FCB $00
	FCB $00
	FCB $00
	FCB $1E
	FCB $3F
	FCB $1F
	FCB $0F
	FCB $1F
	FCB $CC
	FCB $DE

;------------------------------------------------------------------------------
; E04_G06_ATK : Spectre bleu en case G6, position d'attaque
; E04_G06_ATKA sert aux attaques hors champ et E04_G06_ATK aux attaques de front.
;------------------------------------------------------------------------------
E04_G06_ATKA:
	LDY #E03_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUSA

E04_G06_ATK:
	LDU #E04_G06_ATK_DATA1	; U pointe les couleurs de la boule.
	BRA E03_G06_ATK_1

;------------------------------------------------------------------------------
; E03_G06_ATK : Spectre magenta en case G6, position d'attaque.
; E03_G06_ATKA sert aux attaques hors champ et E03_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E03_G06_ATKA:
	LDY #E03_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUSA

E03_G06_ATK:
	LDU #E03_G06_ATK_DATA1	; U pointe les couleurs de la boule.

E03_G06_ATK_1:
	LDX #SCROFFSET+$05D1 ; X pointe la 1ère boule d'énergie.
	LDY #E03_G06_SON_DATA	; Y pointe le bruitage
	LBRA ATKEN_S		; Affichage de l'attaque + fin.

;------------------------------------------------------------------------------
; E04_G06 : Spectre bleu en case G6, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G06:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G06_0

;------------------------------------------------------------------------------
; E03_G06 : Spectre magenta en case G6, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G06:
	LDA #c05		; A = Noir sur fond magenta.

E03_G06_0:
	STA >VARDB4		; VARB4 = couleur de robe du spectre.

	LDA >W6D		; Le mur W6 est-il affiché?
	BNE	E03_G06A	; Si oui => E03_G06A

	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E03_G06B	; Si oui => E03_G06B, sinon => E02_G06C.

; Initialisation pour les spectres devant un mur W24 ou un fond B24.
E03_G06C:
	LDD #c0808		; A = B = Noir sur fond gris.
	BRA E03_G06_1

; Initialisation pour les spectres devant un mur W13.
E03_G06B:
	LDD #c0807		; A = Noir sur fond gris. B = noir sur fond blanc.
	BRA E03_G06_1

; Initialisation pour les spectres devant un mur W6.
E03_G06A:
	LDD #c0707		; A = B = noir sur fond blanc.

E03_G06_1:
	STD >VARDB1		; VARDB1 = A, VARDB2 = B.

	LDA >H6D		; Le trou H6D est-il affiché?
	BNE	E03_G06_1A	; Si oui => E03_G06_1A

; Initialisation pour les spectres au-dessus d'un sol.
E03_G06_1B:
	LDA #c08		; A = Noir sur fond gris
	BRA E03_G06_2

; Initialisation pour les spectres au-dessus d'un trou.
E03_G06_1A:
	LDA #c07		; A = Noir sur fond blanc

; Corps principal
E03_G06_2:
	STA >VARDB3		; VARDB3 = A
	LBSR E01_G06_R1	; Pour la restituation des décors.

	LBSR VIDEOC_A	; Sélection vidéo couleur.
	LDX #SCROFFSET+$02B0 ; X pointe le spectre à l'écran.
	LDD #c0825		; A = Noir sur fond gris. B = 37 pour les sauts de ligne.
	LBSR G2_R1_4x4
	LDA >VARDB1
	STA	,X+
	STA	,X+
	STA	,X+
	STA	,X
	ABX
	LDB >VARDB4		; B = couleur de robe du spectre (noir / bleu ou magenta).
	BSR DISPLAY_ABBA_7
	LDA >VARDB2
	BSR DISPLAY_ABBA_3
	LDA >VARDB4		; A = couleur de robe du spectre (noir / bleu ou magenta).
	BSR DISPLAY_ABBA_8
	BSR DISPLAY_ABBA_2
	LDD #c080B		; A = Noir sur fond gris. B = noir sur fond jaune paille.
	BSR DISPLAY_ABBA_8
	LDA >VARDB4		; A = couleur de robe du spectre (noir / bleu ou magenta).
	LDB >VARDB4		; B = couleur de robe du spectre (noir / bleu ou magenta).
	BSR DISPLAY_ABBA_7
	BSR DISPLAY_ABBA_32
	EORB #%01111000	; B = Orange sur fond bleu ou magenta.
	BSR DISPLAY_ABBA_2
	LDA >VARDB3
	LDB #c0F		; B = Noir sur fond orange.
	BSR DISPLAY_ABBA_5
	BRA E03_G06_3	; 2ème partie de code.

; Affichage A,B,B,A sur N lignes. 
DISPLAY_ABBA_32:
	BSR DISPLAY_ABBA_8
DISPLAY_ABBA_24:
	BSR DISPLAY_ABBA_4
DISPLAY_ABBA_20:
	BSR DISPLAY_ABBA_4
DISPLAY_ABBA_16:
	BSR DISPLAY_ABBA_8
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

E03_G06_3:
	INC $E7C3		; Sélection vidéo forme.

	LDB #40			; Pour les sauts de ligne
	LDY #E03_G06_DATA
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

;------------------------------------------------------------------------------
; E04_G14 : Spectre bleu en case G14, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G14:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G14_0

;------------------------------------------------------------------------------
; E03_G14 : Spectre magenta en case G14, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G14:
	LDA #c05		; A = Noir sur fond magenta.

E03_G14_0:
	STA >VARDB3		; VARB3 = couleur de robe du spectre.

	LDB #c07		; B = noir sur fond blanc.
	LDA >W15D		; Le mur W15 est-il affiché?
	BNE	E03_G14_1	; Si oui => E03_G14_1

	LDB #c08		; Sinon W43, W28 ou un fond B28 => B = noir sur fond gris.

E03_G14_1:
	STB >VARDB1

	LDA >H14D		; Le trou H14D est-il affiché?
	BNE	E03_G14_1A	; Si oui => E03_G14_1A

; Initialisation pour les spectres au-dessus d'un sol.
E03_G14_1B:
	LDA #c08		; A = Noir sur fond gris
	BRA E03_G14_2

; Initialisation pour les spectres au-dessus d'un trou.
E03_G14_1A:
	LDA #c07		; A = Noir sur fond blanc

; Corps principal
E03_G14_2:
	STA >VARDB2		; VARDB2 = A
	LBSR MASK_W7	; Pour la restitution des décors.
	LDX #SCROFFSET+$03D0 ; X pointe la partie gauche en G14.
	LBSR E03_G09_3		; Affichage de la partie gauche.
	LDX #SCROFFSET+$03D1 ; X pointe la partie centrale en G14.
	LBRA E03_G10_R2

;------------------------------------------------------------------------------
; E04_G12 : Spectre bleu en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G12:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G12_0

;------------------------------------------------------------------------------
; E03_G12 : Spectre magenta en case G12, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G12:
	LDA #c05		; A = Noir sur fond magenta.

E03_G12_0:
	STA >VARDB3		; VARB3 = couleur de robe du spectre.

	LDB #c07		; B = noir sur fond blanc.
	LDA >W13D		; Le mur W13 est-il affiché?
	BNE	E03_G12_1	; Si oui => E03_G12_1.

	LDB #c08		; Sinon mur W24 ou un fond B24 => B = Noir sur fond gris.

; Corps principal
E03_G12_1:
	STB >VARDB1

	LDA >H12D		; Le trou H12D est-il affiché?
	BNE	E03_G12_1A	; Si oui => E03_G12_1A

; Initialisation pour les spectres au-dessus d'un sol.
E03_G12_1B:
	LDA #c08		; A = Noir sur fond gris
	BRA E03_G12_2

; Initialisation pour les spectres au-dessus d'un trou.
E03_G12_1A:
	LDA #c07		; A = Noir sur fond blanc

; Corps principal
E03_G12_2:
	STA >VARDB2		; VARDB2 = A
	LBSR E01_G06_R2	; Pour la restauration des décors.
	LDX #SCROFFSET+$03C9 ; X pointe la partie gauche en G12.
	BSR E03_G09_3	; Affichage de la partie gauche.
	LDX #SCROFFSET+$03CA ; X pointe la partie centrale en G12.
	LBSR E03_G10_R2
	LDX #SCROFFSET+$03CB ; Partie droite en G12
	LBRA E03_G10_R1

;------------------------------------------------------------------------------
; E04_G09 : Spectre bleu en case G09, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G09:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G09_0

;------------------------------------------------------------------------------
; E03_G09 : Spectre magenta en case G09, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G09:
	LDA #c05		; A = Noir sur fond magenta.

E03_G09_0:
	STA >VARDB3		; VARB3 = couleur de robe du spectre.

	LDB #c07		; B = noir sur fond blanc.
	LDA >W10D		; Le mur W10 est-il affiché?
	BNE	E03_G09_1	; Si oui => E03_G09_1

	LDA >W32D		; Le mur W32 est-il affiché?
	BNE	E03_G09_1	; Si oui => E03_G09_1

	LDB #c08		; Sinon W19 ou B19 => B = noir sur fond gris.

E03_G09_1:
	STB >VARDB1

	LDA >H9D		; Le trou H9D est-il affiché?
	BNE	E03_G09_1A	; Si oui => E03_G09_1A

; Initialisation pour les spectres au-dessus d'un sol.
E03_G09_1B:
	LDA #c08		; A = Noir sur fond gris
	BRA E03_G09_2

; Initialisation pour les spectres au-dessus d'un trou.
E03_G09_1A:
	LDA #c07		; A = Noir sur fond blanc

; Corps principal
E03_G09_2:
	STA >VARDB2		; VARDB2 = A
	LBSR E01_G09_R1	; Pour la restauration des décors.
	LDX #SCROFFSET+$03C1 ; X pointe la partie gauche en G9.
E03_G09_3:
	LDY #E03_G09_DATA ; Y pointe les données de E03_G09.
	BRA E03_G10_R1

;------------------------------------------------------------------------------
; E04_G10 : Spectre bleu en case G10, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G10:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G10_0

;------------------------------------------------------------------------------
; E03_G10 : Spectre magenta en case G10, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G10:
	LDA #c05		; A = Noir sur fond magenta.

E03_G10_0:
	STA >VARDB3		; VARB3 = couleur de robe du spectre.

	LDB #c07		; B = noir sur fond blanc.
	LDA >W11D		; Le mur W11 est-il affiché?
	BNE	E03_G10_1	; Si oui => E03_G10_1

	LDB #c08		; Sinon W43, W28 ou B28 => B = noir sur fond gris.

E03_G10_1:
	STB >VARDB1

	LDA >H10D		; Le trou H10D est-il affiché?
	BNE	E03_G10_1A	; Si oui => E03_G10_1A

; Initialisation pour les spectres au-dessus d'un sol.
E03_G10_1B:
	LDA #c08		; A = Noir sur fond gris
	BRA E03_G10_2

; Initialisation pour les spectres au-dessus d'un trou.
E03_G10_1A:
	LDA #c07		; A = Noir sur fond blanc

; Corps principal
E03_G10_2:
	STA >VARDB2		; VARDB2 = A
	LBSR MASK_W5	; Pour la restauration des décors.
	LDY #E03_G10_DATA1   ; Y pointe les données de E03_G10.
	LDX #SCROFFSET+$03C2 ; Partie centrale.
	BSR E03_G10_R2
	LDX #SCROFFSET+$03C3 ; Partie droite.

; Partie droite. Code commun avec E03_G09_2 et E03_G15_2.
E03_G10_R1:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	PSHS X
	LDD #c0828		; A = Noir sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_5
	LDA >VARDB1		; A = noir sur fond blanc ou gris.
	LBSR DISPLAY_A_7
	LDA >VARDB3		; A = couleur de robe du spectre (noir / bleu ou magenta).
	LBSR DISPLAY_A_5
	LDA #c08		; A = noir sur fond gris.
	LBSR DISPLAY_A_5
	LDA >VARDB3		; A = couleur de robe du spectre (noir / bleu ou magenta).
	LBSR DISPLAY_A_24
	STA	,X
	ABX
	STA	,X
	ABX
	LDA >VARDB2		; A = noir sur fond blanc ou gris.
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	PULS X

	INC $E7C3		; Sélection vidéo forme.
	LBSR DISPLAY_YX_32
	LBSR DISPLAY_A_14
	LBRA DISPLAY_YX_5

; Partie centrale. Code commun avec E03_G12_2 et E03_G14_2.
E03_G10_R2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	PSHS X
	LDD #c0828		; A = Noir sur fond gris. B = 40 pour les sauts de ligne.
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	ABX
	LDA >VARDB3		; A = couleur de robe du spectre (noir / bleu ou magenta).
	LBSR DISPLAY_A_13
	LDA #c0B		; A = noir sur fond jaune paille.
	LBSR DISPLAY_A_6
	LDA >VARDB3		; A = couleur de robe du spectre (noir / bleu ou magenta).
	LBSR DISPLAY_A_24
	EORA #%01111000	; A = orange sur fond bleu ou magenta.
	STA	,X
	ABX
	LDA #c0F		; A = noir sur fond orange.
	STA	,X
	ABX
	STA	,X
	ABX
	STA	,X
	PULS X

	INC $E7C3		; Sélection vidéo forme.
	LBSR DISPLAY_YX_16
	LBSR DISPLAY_YX_11
	LBSR DISPLAY_A_20
	LBRA DISPLAY_YX_4

;------------------------------------------------------------------------------
; E04_G15 : Spectre bleu en case G15, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G15:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G15_0

;------------------------------------------------------------------------------
; E03_G15 : Spectre magenta en case G15, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G15:
	LDA #c05		; A = Noir sur fond magenta.

E03_G15_0:
	STA >VARDB3		; VARB3 = couleur de robe du spectre.

	LDB #c07		; B = noir sur fond blanc.
	LDA >W16D		; Le mur W16 est-il affiché?
	BNE	E03_G15_1	; Si oui => E03_G15_1

	LDA >W42D		; Le mur W42 est-il affiché?
	BNE	E03_G15_1	; Si oui => E03_G15_1

	LDB #c08		; Sinon W29 ou B29 => B = noir sur fond gris.

E03_G15_1:
	STB >VARDB1		; VARDB1 = A

	LDA >H10D		; Le trou H10D est-il affiché?
	BNE	E03_G15_1A	; Si oui => E03_G15_1A

; Initialisation pour les spectres au-dessus d'un sol.
E03_G15_1B:
	LDA #c08		; A = Noir sur fond gris
	BRA E03_G15_2

; Initialisation pour les spectres au-dessus d'un trou.
E03_G15_1A:
	LDA #c07		; A = Noir sur fond blanc

; Corps principal
E03_G15_2:
	STA >VARDB2		; VARDB2 = A
	LBSR E01_G15_R1	; Pour la restauration des décors.
	LDY #E03_G10_DATA2   ; Y pointe les données de E03_G15.
	LDX #SCROFFSET+$03D2 ; Partie droite.
	LBRA E03_G10_R1

;------------------------------------------------------------------------------
; E04_G21_ATK = E04_G06_ATK
; E03_G21_ATK = E03_G06_ATK
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; E04_G21 : Spectre bleu en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G21:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G21_0

;------------------------------------------------------------------------------
; E03_G21 : Spectre magenta en case G21, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G21:
	LDA #c05		; A = Noir sur fond magenta.

E03_G21_0:
	STA >VARDB1		; VARDB1 = A
	LBSR MASK_W13B	; Pour la restitution des décors.

E03_G21_1:
	LDY #E03_G18_DATA
	LDX #SCROFFSET+$0469 ; Adresse écran de la partie gauche
	LBSR E03_G18_2
	LDX #SCROFFSET+$046A ; Adresse écran de la partie droite
	LBRA E03_G18_2

;------------------------------------------------------------------------------
; E04_G19 : Spectre bleu en case G19, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G19:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G19_0

;------------------------------------------------------------------------------
; E03_G19 : Spectre magenta en case G19, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G19:
	LDA #c05		; A = Noir sur fond magenta.

E03_G19_0:
	STA >VARDB1		; VARDB1 = A
	LBSR MASK_W12	; Pour la restitution des décors.
	LDX #SCROFFSET+$0465 ; Adresse écran de la partie droite

E03_G19_1:
	LDY #E03_G19_DATA
	BRA E03_G18_2

;------------------------------------------------------------------------------
; E04_G18 : Spectre bleu en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G18:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G18_0

;------------------------------------------------------------------------------
; E03_G18 : Spectre magenta en case G18, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G18:
	LDA #c05		; A = Noir sur fond magenta.

E03_G18_0:
	STA >VARDB1		; VARDB1 = A
	LBSR E01_G18_R1	; Pour la restauration des décors.
	LDX #SCROFFSET+$0464 ; Adresse écran de la partie gauche

E03_G18_1:
	LDY #E03_G18_DATA

E03_G18_2:
	LBSR VIDEOC_A	; Sélection vidéo couleur.
	PSHS X
	LDD #c0828		; A = Noir sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_4
	LDA >VARDB1		; A = couleur de robe du spectre (noir / bleu ou magenta).
	LBSR DISPLAY_A_8
	LDA #c08		; A = noir sur fond gris.
	LBSR DISPLAY_A_4
	LDA >VARDB1		; A = couleur de robe du spectre (noir / bleu ou magenta).
	LBSR DISPLAY_A_15
	LDA #c0F		; A = noir sur fond orange.
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #c08		; A = noir sur fond gris.
	STA ,X
	PULS X

	INC $E7C3		; Sélection vidéo forme.
	LBSR DISPLAY_YX_32
	LDA ,Y+
	STA ,X
	ABX
	LDA ,Y+
	STA ,X
	RTS

;------------------------------------------------------------------------------
; E04_G24 : Spectre bleu en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G24:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G24_0

;------------------------------------------------------------------------------
; E03_G24 : Spectre magenta en case G24, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G24:
	LDA #c05		; A = Noir sur fond magenta.

E03_G24_0:
	STA >VARDB1		; VARDB1 = A
	LBSR E01_G24_R1	; Pour la restauration des décors.
	LDX #SCROFFSET+$046F ; X pointe la première colonne du fantôme.
	LBRA E03_G19_1

;------------------------------------------------------------------------------
; E04_G23 : Spectre bleu en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E04_G23:
	LDA #c0C		; A = Noir sur fond bleu.
	BRA E03_G23_0

;------------------------------------------------------------------------------
; E03_G23 : Spectre magenta en case G23, position d'attente.
;------------------------------------------------------------------------------
; Sous-routine de tuile codée.
E03_G23:
	LDA #c05		; A = Noir sur fond magenta.

E03_G23_0:
	STA >VARDB1		; VARDB1 = A
	LBSR MASK_W14	; Pour la restauration des décors.
	LDX #SCROFFSET+$046E ; X pointe la première colonne du fantôme.
	LBRA E03_G18_1

;------------------------------------------------------------------------------
; DONNEES DES SPECTRES MAGENTA ET BLEUS
;------------------------------------------------------------------------------
E03_G06_SON_DATA:
	FCB O3,A5,T3,L5,SI,LA,SO,P,FIN

; Bleu-mauve/Bleu-mauve, bleu/bleu, bleu ciel/bleu ciel
E03_G06_ATK_DATA1:
	FCB c44,cCC,cEE,c4C,cCE

; Vert fluo/vert fluo, vert pale/vert pale, blanc/blanc
E04_G06_ATK_DATA1:
	FCB c22,cAA,c77,c2A,cA7

; Magenta/magenta, rose/rose, blanc/blanc (sort du BOSS)
BOSS_G06_ATK_DATA1:
	FCB c55,c99,c77,c59,c97

E03_G06_DATA:
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

E03_G09_DATA:
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

E03_G10_DATA1:	; Colonne 2
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

E03_G10_DATA2:	; Colonne 3
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

E03_G18_DATA:
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

E03_G19_DATA:
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
; E05_G06_ATK : Araignée en case G6, position d'attaque.
; E05_G06_ATKA sert aux attaques hors champ et E05_G06_ATK aux attaques de front. 
;------------------------------------------------------------------------------
E05_G06_ATKA:
	LDY #E05_G06_SON_DATA ; Bruitage de l'attaque.
	LBRA MUSA

E05_G06_ATK:
	LBSR VIDEOC_A	; Sélection video couleur.
	LDX #SCROFFSET+$0E16 ; X pointe la première colonne de l'araignée.
	LDA #c80		; A = gris sur fond noir.
	LBSR G2_R1_40x8
	LDX #SCROFFSET+$0EB9 ; X pointe les yeux de l'araignée.
	LDD #c1028		; A = rouge sur fond noir. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_2A_6
	LDA #c70		; A = blanc sur fond noir
	LBSR DISPLAY_2A_8

	INC	$E7C3		; Sélection vidéo forme.
	LDX #SCROFFSET+$0CB0 ; X pointe le haut de l'araignée G06
	LDY #E05_G06_ATK_DATA ; Y pointe les données de l'attaque.
	LDD #$FF24		; A = gris. B = 36 pour les sauts de ligne.
	LBSR G2_R1_8x5	; Effacement du haut de l'araignée G06
	LBSR G2_R1_1x5
	LEAX -2,X		; X pointe le haut de l'attaque.
	LDB #20			; 20x2 lignes à dessiner.
E05_G06_ATK_1:
	LBSR BSAVEN_8
	LEAY -8,Y
	LEAX 32,X
	LBSR BSAVEN_8
	LEAX 32,X
	DECB
	BNE E05_G06_ATK_1

	BSR E05_G06_ATKA ; Bruitage de l'attaque.
	LDB #10			; Tempo à réajuster
	LBSR TEMPO

	LDX #SCROFFSET+$0E16 ; X pointe la première colonne de l'araignée.
	LDA #$FF
	LBSR G2_R1_40x8	; Forme grise.
	LBSR VIDEOC_A	; Sélection video couleur.
	LDX #SCROFFSET+$0E16 ; X pointe de nouveau la 1ère ligne.
	LDA #c87		; A = gris sur fond blanc.
	LBSR G2_R1_40x8	; Restauration des couleurs + réaffichage de E05_G06

;------------------------------------------------------------------------------
; E05_G06 : Araignée en case G6, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G06:
	CLR >G6D		; Pour la restauration des décors.
	CLR >CH6D

	LBSR VIDEOC_A	; Sélection video couleur.
E05_G06_1:
	LDD #c8024		; A = gris sur fond noir. B = 36 pour les sauts de ligne.
	LDX #SCROFFSET+$0CB0 ; X pointe la première colonne de l'araignée.
	LBSR G2_R1_16x5
	LBSR G2_R1_6x5
	LDX #SCROFFSET+$0F82 ; X pointe la 3ème colonne de l'araignée.
	LDD #c1028		; A = rouge sur fond noir B = 40 pour les sauts de ligne.
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #c80		; A = gris sur fond noir
	STA ,X
	ABX
	STA ,X

	INC	$E7C3		; Sélection vidéo forme.
	LDY #E05_G06_DATA ; Y pointe les données
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
; E05_G14 : Araignée en case G9, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G14:
	CLR >G14D		; Pour la restauration des décors.
	CLR >CH14D

	LDX #SCROFFSET+$0A38 ; X pointe la première colonne de l'araignée.
	BSR E05_G09_1
	LDX #SCROFFSET+$0A39 ; X pointe la colonne du milieu de l'araignée.
	BRA E05_G10_R1_1

;------------------------------------------------------------------------------
; E05_G15 : Araignée en case G15, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G15:
	CLR >G15D		; Pour la restauration des décors.
	CLR >CH15D

	LDX #SCROFFSET+$0A3A ; X pointe la dernière colonne de l'araignée.
	LDY #E05_G10_DATA2 ; Y pointe les données
	BRA E05_G09_2

;------------------------------------------------------------------------------
; E05_G12 : Araignée en case G12, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G12:
	CLR >G12D		; Pour la restauration des décors.
	CLR >CH12D

	LDX #SCROFFSET+$0A31 ; X pointe la première colonne de l'araignée.
	BSR E05_G09_1
	LDX #SCROFFSET+$0A32 ; X pointe la colonne du milieu de l'araignée.
	BSR E05_G10_R1_1
	LDX #SCROFFSET+$0A33 ; X pointe la dernière colonne de l'araignée.
	BRA E05_G09_2

;------------------------------------------------------------------------------
; E05_G09 : Araignée en case G9, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G09:
	CLR >G9D		; Pour la restauration des décors.
	CLR >CH9D
	LDX #SCROFFSET+$0A29 ; X pointe la première colonne de l'araignée.

E05_G09_1:
	LDY #E05_G09_DATA ; Y pointe les données

E05_G09_2:
	LBSR VIDEOC_A	; Sélection video couleur.
	PSHS X
	LDD #c0828		; A = noir sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_14
	PULS X

	INC	$E7C3		; Sélection vidéo forme.
	LBRA DISPLAY_YX_14

;------------------------------------------------------------------------------
; E05_G10 : Araignée en case G10, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G10:
	CLR >G10D		; Pour la restauration des décors.
	CLR >CH10D

	LDX #SCROFFSET+$0A2A ; X pointe la colonne du milieu de l'araignée.
	BSR E05_G10_R1
	LDX #SCROFFSET+$0A2B ; X pointe la dernière colonne de l'araignée.
	BRA E05_G09_2

E05_G10_R1:
	LDY #E05_G10_DATA1 ; Y pointe les données
E05_G10_R1_1:
	LBSR VIDEOC_A	; Sélection video couleur.
	PSHS X
	LDD #c0828		; A = noir sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_11
	LDA #c01		; A = noir sur fond rouge
	STA ,X
	ABX
	LDA #c08		; A = noir sur fond gris
	STA ,X
	ABX
	STA ,X
	ABX
	LDA #c78		; A = blanc sur fond gris
	STA ,X
	PULS X

	INC	$E7C3		; Sélection vidéo forme.
	LBRA DISPLAY_YX_15

;------------------------------------------------------------------------------
; E05_G21 : Araignée en case G21, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G21:
	CLR >G21D		; Pour la restauration des décors.
	CLR >CH21D

	LDX #SCROFFSET+$08F1 ; X pointe la première colonne de l'araignée.
	BSR E05_G18_1
	LDX #SCROFFSET+$08F2 ; X pointe la deuxième colonne de l'araignée.
	BRA E05_G19_1

;------------------------------------------------------------------------------
; E05_G19 : Araignée en case G19, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G19:
	CLR >G19D		; Pour la restauration des décors.
	LDX #SCROFFSET+$08ED ; X pointe la deuxième colonne de l'araignée.

E05_G19_1:
	LDY #E05_G19_DATA ; Y pointe les données
	BRA E05_G18_2

;------------------------------------------------------------------------------
; E05_G18 : Araignée en case G18, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G18:
	CLR >G18D		; Pour la restauration des décors.
	LDX #SCROFFSET+$08EC ; X pointe la première colonne de l'araignée.

E05_G18_1:
	LDY #E05_G18_DATA ; Y pointe les données

E05_G18_2:
	LBSR VIDEOC_A	; Sélection video couleur.
	PSHS X
	LDD #c0828		; A = noir sur fond gris. B = 40 pour les sauts de ligne.
	LBSR DISPLAY_A_7
	PULS X

	INC	$E7C3		; Sélection vidéo forme.
	LBRA DISPLAY_YX_7

;------------------------------------------------------------------------------
; E05_G24 : Araignée en case G24, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G24:
	CLR >G24D		; Pour la restauration des décors.
	LDX #SCROFFSET+$08F7 ; X pointe la deuxième colonne de l'araignée.
	BRA E05_G19_1

;------------------------------------------------------------------------------
; E05_G23 : Araignée en case G23, position d'attente.
;------------------------------------------------------------------------------
; Routine de tuile codée.
E05_G23:
	CLR >G23D		; Pour la restauration des décors.
	LDX #SCROFFSET+$08F6 ; X pointe la première colonne de l'araignée.
	BRA E05_G18_1

;------------------------------------------------------------------------------
; DONNEES DES ARAIGNEES
;------------------------------------------------------------------------------
E05_G06_SON_DATA:
	FCB O2,A0,T3,L9,DOD,SI,P,FIN

E05_G06_ATK_DATA:
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

E05_G06_ATK2_DATA:
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

E05_G06_DATA:
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

E05_G09_DATA:
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

E05_G10_DATA1:
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

E05_G10_DATA2:
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

E05_G18_DATA:
	FCB $06
	FCB $09
	FCB $07
	FCB $09
	FCB $07
	FCB $09
	FCB $02

E05_G19_DATA:
	FCB $F6
	FCB $99
	FCB $6E
	FCB $09
	FCB $9E
	FCB $F9
	FCB $F4

PACK_END:
	BSZ $D9C0-PACK_END	; Remplissage de zéros jusqu'à $D9BF inclus.

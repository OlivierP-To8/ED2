; =============================================================================
; EVIL DUNGEONS II - DUNGEON CRAWLER POUR MO5 - PARTIE INITIALISATION DU JEU
; Par Christophe PETIT
;
; Ce listing est destiné à créer le fichier INIT.BIN pour l'initialisation
; d'EVIL DUNGEONS 2. Le programme affiche l'image compressée de l'interface de
; jeu et initialise une partie des données de jeu. La pile S doit avoir été
; déplacée en $20CC (= STKEND du moniteur).
; =============================================================================

	ORG	$6000

;******************************************************************************
;*                            CONSTANTES GENERALES                            *
;******************************************************************************
DBUFFER		EQU $8000	; Adresse du double buffer pour l'affichage d'images
TABCOMP		EQU $1F40	; Table de compression/décompression en mémoire vidéo.

;******************************************************************************
; DECOMPRESSEUR EXOMIZER POUR 6809
; Compilation du code original de PULS fourni avec Exomizer 2.09.
;
; Extrait des données compressées à l'aide d'Exomiser 2.09, avec les commandes
; raw et -b (backward). Exemple: exomizer raw -b essai.bin -o essai2.bin
;
; Ce programme est relogeable n'importe où en RAM et sans recompilation. Mais 
; l'adresse doit être de type $xx00, avec l'octet de poids faible à 0, car il
; utilise de l'adressage direct.
;
; Entrées  : U pointe le dernier octet des données compressées.
;		     Y pointe l'octet juste après le buffer.
; Sortie   : Y pointe la première donnée décompressée.
;******************************************************************************
EXO2:
    INCLUDE ../res/exo2_final.asm

;******************************************************************************
; INITIALISATION DU JEU
;******************************************************************************
; Point d'entrée de l'interface seule pour débogage (adresse $6152).
INIT0:
	LDS #$20CC		; Initialisation de la pile S.

; Point d'entrée pour le lancement de l'interface et du jeu (adresse $6156).
INIT1:
	LDA >$2019
	ORA #%00001000	; Suppression du bip des touches.
	STA >$2019

	ORCC #$50		; Désactivation des interruptions.
	CLR >$203E		; Poids fort de la variable OCTAVE du moniteur = 0.

	LBSR AFFICHE	; Affichage de l'interface + sélection vidéo couleur.

	LDY #TABDECOMP_DATA	; Y pointe la table de décompression.
	LDX #$1F40		; X pointe la partie cachée de la mémoire vidéo couleur.
	LDB #32			; Recopie de la table de décompression.
	BSR INIT_R1
	
	LDY #GAME_DATA	; Y pointe les données d'initialisation du jeu et du joueur.	
	LDX #$1FD4		; X pointe après les touches du clavier.
	LDB #11			; Recopie de 44 octets.
	BSR INIT_R1

	INC $A7C0		; Sélection video forme.
	LDY #TABCOMP_DATA ; Y pointe la table de compression.
	LDX #$1F40		; X pointe la partie cachée de la mémoire vidéo forme.
	LDB #48			; Recopie de la table et des routines d'orientation.
	BSR INIT_R1

	LDX #$0924		; Tempo 3 secondes (X = $030C/seconde)
TEMPO:
	LDA #$FF
TEMPO1:
	DECA
	BNE TEMPO1
	LEAX -1,X
	BNE TEMPO
	RTS

INIT_R1:
	LDA ,Y+			; 1
	STA ,X+
	LDA ,Y+			; 2
	STA ,X+
	LDA ,Y+			; 3
	STA ,X+
	LDA ,Y+			; 4
	STA ,X+
	DECB
	BNE INIT_R1
	RTS

;******************************************************************************
; ROUTINE D'AFFICHAGE DE L'IMAGE COMPRESSEE
;******************************************************************************
AFFICHE:
	LDA	$A7C0
	ANDA #%11100000
	STA	$A7C0		; Bordure noire + sélection video couleur

	CLRA			; Encre noire sur fond noir
	LDB #200		; 200 lignes à initialiser
	LDX #$0000		; X pointe le début de la mémoire vidéo couleur
	LBSR AFFICHE_R1	; Ecran noir

	LDY #MESSAGE_C
	LBSR AFFICHE_R3 ; Affichage du texte d'intro + sélection vidéo forme.

	LDU #FIN-1		; U pointe le dernier octet de l'image de forme compressée
	LDY #DBUFFER+$1F40 ; Y pointe la fin du double buffer
	LBSR EXO2		; Décompression de l'image de forme dans le double buffer

	LDU #DBUFFER	; U pointe le début du double buffer
	LDX #$0000		; X pointe le début de la mémoire vidéo forme
	LDB #96
	BSR AFFICHE_R2	; Copie des 96 premières lignes dans la mémoire vidéo forme
	LDU #DBUFFER+$1040 ; Y pointe la ligne 105 du double buffer
	LDX #$1040		; X pointe la ligne 105 de la mémoire vidéo forme
	LDB #96
	BSR AFFICHE_R2	; Copie des 96 dernières lignes dans la mémoire vidéo forme
	LDU #DBUFFER+$0F00 ; Y pointe la ligne 97 du double buffer
	LDX #INTERFACE_F ; X pointe l'image de forme pour en faire un buffer de
	LDB #8			; sauvegarde.
	BSR AFFICHE_R2	; Sauvegarde des lignes de forme 97 à 104

	DEC	$A7C0		; Sélection video couleur

	LDU #INTERFACE_F-1 ; U pointe le dernier octet de l'image couleur compressée
	LDY #DBUFFER+$1F40 ; Y pointe la fin du double buffer
	LBSR EXO2		; Décompression de l'image couleur dans le double buffer
	
	CLRA			; Encre noire sur fond noir
	LDB #8			; 8 lignes à noircir
	LDX #$0F00		; X pointe la ligne 97 de la mémoire vidéo couleur
	LBSR AFFICHE_R1	; Noircissement des lignes 97 à 104 à l'écran

	INC	$A7C0		; Sélection vidéo forme

	LDU #INTERFACE_F ; Y pointe le buffer de sauvegarde
	LDX #$0F00		; X pointe la ligne 97 de la mémoire vidéo forme
	LDB #8
	BSR AFFICHE_R2	; Recopie des lignes 96 à 104 dans la mémoire vidéo forme

	DEC	$A7C0		; Sélection video couleur
	
	LDU #DBUFFER	; U pointe le début du double buffer
	LDX #$0000		; X pointe le début de la mémoire vidéo couleur
	LDB #200		; 200 lignes à recopier	et affichage de l'image couleur

AFFICHE_R2:			; Copie de B lignes de 40 octets.
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	PULU A
	STA ,X+
	DECB
	LBNE AFFICHE_R2
	RTS

AFFICHE_R1:			; Affichage de B lignes de 40 octets.
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	STA ,X+
	DECB
	LBNE AFFICHE_R1
	RTS

AFFICHE_R3:
	LDB #28				; Pour les sauts de ligne.
	BSR AFFICHE_R3_8	; Affichage de la tuile couleur
	INC	$A7C0			; Sélection vidéo forme + affichage de la tuile de forme	
AFFICHE_R3_8:
	LDX #$0F0D			; X pointe le texte d'intro à l'écran.
	BSR AFFICHE_R3_4	; 8 lignes de 13 octets à afficher.
AFFICHE_R3_4:	
	BSR AFFICHE_R3_1
	BSR AFFICHE_R3_1
	BSR AFFICHE_R3_1	
AFFICHE_R3_1:
	LDA ,Y+
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X+
	LDA ,Y+	
	STA ,X
	ABX
	RTS

;******************************************************************************
; DONNEES
;******************************************************************************

; Table de compression de map à recopier en $1F40 de la mémoire vidéo forme.
TABCOMP_DATA:
	FCB $0A,$00,$00,$00,$00,$00,$00,$00,$0B,$00 ; 0
	FCB $00,$00,$00,$00,$00,$00,$0C,$00,$00,$00 ; 10
	FCB $00,$00,$00,$00,$0D,$00,$00,$00,$00,$00 ; 20
	FCB $00,$00,$0E,$00,$00,$00,$0F,$00,$00,$00 ; 30
	FCB $1C,$00,$00,$00,$1D,$00,$00,$00,$1E,$00 ; 40
	FCB $00,$00,$1F,$00,$00,$00,$22,$00,$00,$00 ; 50
	FCB $23,$00,$00,$00,$24,$00,$25,$00,$26,$00 ; 60
	FCB $27,$00,$28,$00,$29,$00,$2A,$00,$2B,$00 ; 70
	FCB $2C,$00,$2D,$00,$2E,$00,$2F,$00,$34,$00 ; 80
	FCB $35,$00,$36,$00,$37,$00,$3C,$3D,$3E,$3F ; 90
	FCB $46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F ; 100
	FCB $59,$5A,$5B,$5C,$5D,$5E,$5F,$69,$6A,$6B ; 110
	FCB $6C,$6D,$6E,$6F,$7C,$7D,$7E,$7F			; 120

; Sous-routines d'orientation pour la mise à jour des sous-routines de pas.
PAS_NORD_DATA:
	FCB $30,$88,$E0,$39	; PAS AVANT   = LEAX -32,X ; RET
	FCB $30,$01,$39,$12	; PAS DROITE  = LEAX 1,X ; RET ; NOP
	FCB $30,$88,$20,$39	; PAS ARRIERE = LEAX 32,X ; RET
	FCB $30,$1F,$39,$12	; PAS GAUCHE  = LEAX -1,X ; RET ; NOP
PAS_EST_DATA:
	FCB $30,$01,$39,$12	; PAS AVANT   = LEAX 1,X ; RET ; NOP
	FCB $30,$88,$20,$39	; PAS DROITE  = LEAX 32,X ; RET	
	FCB $30,$1F,$39,$12	; PAS ARRIERE = LEAX -1,X ; RET ; NOP
	FCB $30,$88,$E0,$39	; PAS GAUCHE  = LEAX -32,X ; RET
PAS_SUD_DATA:
	FCB $30,$88,$20,$39	; PAS AVANT   = LEAX 32,X ; RET
	FCB $30,$1F,$39,$12	; PAS DROITE  = LEAX -1,X ; RET ; NOP
	FCB $30,$88,$E0,$39	; PAS ARRIERE = LEAX -32,X ; RET
	FCB $30,$01,$39,$12	; PAS GAUCHE  = LEAX 1,X ; RET ; NOP
PAS_OUEST_DATA:
	FCB $30,$1F,$39,$12	; PAS AVANT   = LEAX -1,X ; RET ; NOP
	FCB $30,$88,$E0,$39	; PAS DROITE  = LEAX -32,X ; RET
	FCB $30,$01,$39,$12	; PAS ARRIERE = LEAX 1,X ; RET ; NOP
	FCB $30,$88,$20,$39	; PAS GAUCHE  = LEAX 32,X ; RET

; Table de décompression de map à recopier en $1F40 de la mémoire vidéo couleur.
TABDECOMP_DATA:
	FCB $01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; 0
	FCB $00,$08,$10,$18,$20,$24,$01,$01,$01,$01 ; 10
	FCB $01,$01,$01,$01,$01,$01,$01,$01,$28,$2C ; 20
	FCB $30,$34,$01,$01,$38,$3C,$40,$42,$44,$46 ; 30
	FCB $48,$4A,$4C,$4E,$50,$52,$54,$56,$01,$01 ; 40
	FCB $01,$01,$58,$5A,$5C,$5E,$01,$01,$01,$01 ; 50
	FCB $60,$61,$62,$63,$01,$01,$01,$01,$01,$01 ; 60
	FCB $64,$65,$66,$67,$68,$69,$6A,$6B,$6C,$6D ; 70
	FCB $01,$01,$01,$01,$01,$01,$01,$01,$01,$6E ; 80
	FCB $6F,$70,$71,$72,$73,$74,$01,$01,$01,$01 ; 90
	FCB $01,$01,$01,$01,$01,$75,$76,$77,$78,$79 ; 100
	FCB $7A,$7B,$01,$01,$01,$01,$01,$01,$01,$01 ; 110
	FCB $01,$01,$01,$01,$7C,$7D,$7E,$7F			; 120

; Données d'initialisation du jeu pour la tour 1
GAME_DATA:
STATEF		FCB $00		; Etats de jeu.
FMINIMAP	FCB	$01		; 0 = pas d'affichage de la minimap. 1 = affichage.
PACKNUM		FCB $00		; Numéro de pack de map (commence à 0).
MAPNUM		FCB $00		; Numéro de map (Niveau 1 = map n°0, montée = +1).
SQRADDR		FDB $24D0	; Adresse de la case courante dans la map.
ORIENT		FCB $00		; Orientation
						; 00 ($00) - Nord
						; 16 ($10) - Est
						; 32 ($20) - Sud
						; 48 ($30) - Ouest
MAPCOUL1 	FCB $87 	; Couleurs sol/mur de map primaires.
MAPCOUL21	FCB $04		; Couleurs sol/mur de map secondaires, niveau 1.
MAPCOUL22	FCB $04		; Couleurs sol/mur de map secondaires, niveau 2.
MAPCOUL23	FCB $04		; Couleurs sol/mur de map secondaires, niveau 3.
MAPCOUL24	FCB $04		; Couleurs sol/mur de map secondaires, niveau 4.
MAPCOULC	FCB $87		; Couleurs sol/mur de map courantes.
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
INVW_MUN1	FCB $00		; Niveau de munition 1 (carreaux) = 00-99
INVW_MUN2	FCB $00		; Niveau de munition 2 (cartouches 9mm) = 00-99
INVW_MUN3	FCB $00		; Niveau de munition 3 (charges plasma) = 00-99
INVW_0		FCB $01		; Acquisition épée (0 = non acquis, 1 = acquis).
INVW_1		FCB $00		; Acquisition arbalette légère (0 = non acquis, 1 = acquis).
INVW_2		FCB $00		; Acquisition arbalette lourde (0 = non acquis, 1 = acquis).
INVW_3		FCB $00		; Acquisition revolver (0 = non acquis, 1 = acquis).
INVW_4		FCB $00		; Acquisition pistolet mitrailleur (0 = non acquis, 1 = acquis).
INVW_5		FCB $00		; Acquisition pistolet plasma (0 = non acquis, 1 = acquis).
INVW_6		FCB $00		; Acquisition fusil plasma (0 = non acquis, 1 = acquis).
INVK1		FCB $00		; Acquisition de la clé jaune (0 = non acquise, 1 = acquise).
INVK2		FCB $00		; Acquisition de la clé bleue (0 = non acquise, 1 = acquise).
INVK3		FCB $00		; Acquisition de la clé rouge (0 = non acquise, 1 = acquise).
INVS0		FCB $01		; Acquisition du sort 0 = régénération (0 = non acquis, 1 = acquis).
INVS1		FCB $00		; Acquisition du sort 1 = boule de feu (0 = non acquis, 1 = acquis).
INVS2		FCB $00		; Acquisition du sort 2 = éclair (0 = non acquis, 1 = acquis).
INVS3		FCB $00		; Acquisition du sort 3 = antimatière (0 = non acquis, 1 = acquis).

MESSAGE_C: ; Octets de vidéo couleur du message "Patientez SVP"
	FCB $70,$00,$00,$07,$00,$00,$00,$00,$00,$00,$07,$70,$70 ; 97
	FCB $07,$00,$07,$00,$00,$70,$07,$00,$00,$00,$07,$07,$07 ; 98
	FCB $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$00,$0B,$0B,$0B ; 99
	FCB $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$00,$0B,$0B,$0B ; 100
	FCB $03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$03,$03,$03 ; 101
	FCB $03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$03,$03,$03 ; 102
	FCB $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$00,$0F,$0F,$0F ; 103
	FCB $F0,$00,$0F,$00,$00,$00,$0F,$00,$00,$00,$0F,$0F,$F0 ; 104

MESSAGE_F: ; Octets de vidéo forme du message "Patientez SVP"
	FCB $FC,$FF,$FF,$CF,$FF,$FF,$FF,$FF,$FF,$FF,$C5,$C3,$FC ; 97
	FCB $99,$FF,$CF,$FF,$FF,$C0,$CF,$FF,$FF,$FF,$99,$99,$99 ; 98
	FCB $99,$C1,$81,$E7,$C3,$83,$81,$C3,$81,$FF,$9F,$99,$99 ; 99
	FCB $99,$99,$CF,$F3,$99,$99,$CF,$99,$F3,$FF,$C3,$99,$99 ; 100
	FCB $93,$99,$CF,$F3,$81,$99,$CF,$81,$81,$FF,$F9,$99,$93 ; 101
	FCB $9F,$99,$CF,$F3,$9F,$99,$CF,$9F,$CE,$FF,$F9,$99,$9F ; 102
	FCB $9F,$C4,$C9,$F3,$C1,$9C,$C9,$C1,$81,$FF,$99,$C3,$9F ; 103
	FCB $C0,$FF,$E3,$FF,$FF,$FF,$E3,$FF,$FF,$FF,$A3,$E7,$C0 ; 104

INTERFACE_C: ; Partie vidéo couleur de l'interface compressée
    INCLUDEBIN ../res/interface.fond.exo2

INTERFACE_F: ; Partie vidéo forme de l'interface compressée
    INCLUDEBIN ../res/interface.forme.exo2

FIN END
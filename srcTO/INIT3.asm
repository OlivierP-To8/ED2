; =============================================================================
; EVIL DUNGEONS II - (RE)INITIALISATION DU SYSTEME DE JEU DU NIVEAU PORTAIL
; Par Christophe PETIT
;
; Ce fichier contient l'initialisation du niveau "portail". C'est ED2PACK3.vbs
; qui se charge de la compilation et de l'extraction du fichier INIT3.BIN à 
; partir du code compilé ED2PACK3.BIN.
;
; Rôle :
; - (Ré)initialisation des variables du joueur, des clés et des scores.
; - Affichage d'un message d'accueil.
;
; Une fois l'initialisation faite, cette partie de code est écrasée par les
; listes d'appel. Elle est rechargée quand le joueur perd avant la fin et qu'il
; doit recommencer la tour 3. Les données sont alors réinitialisées.
; =============================================================================
INIT3:
	LDY #PACKSTART	; Y pointe les données de fin de pack.
	LDD ,Y++		; D = adresse de départ.
	ORA #$40		; conversion adresse TO
	STD >SQRADDR	; Adresse courante = adresse de départ.
	LDX #SCORE_E2	; X pointe les variables de score à réaliser
	LBSR BSAVEN_4	; Recopie dans les variables de score.

	CLR >ORIENT		; Orientation Nord.
	CLR >MAPNUM		; Map n°0 = Niveau 1
	LDA #2
	STA >PACKNUM	; Pack n°2 = Niveau portail

	LBSR VIDEOC_A	; Sélection video couleur
	LDY #$5FE0		; Y pointe les données d'initialisation dans la mémoire couleur.
	LDX #MAPCOULC	; X pointe les données de jeu à initialiser.
	LBSR BSAVEN_16	; 32 octets de données d'initialisation à recopier
	LBSR BSAVEN_16

	LBSR AFF_INTERFACE ; Mise à jour de l'interface
	LBSR FEN_COUL	; Initialisation des couleurs sol/mur + vidéo forme.
	BSR INIT3_R2	; Affichage du décor de fond.

	LDX #SCROFFSET+$0438 ; X pointe l'écran pour un message.
	LDU #MESSAGE1	; U pointe le message de début de tour.
	LBSR PRINTM		; Affichage du message + demande d'appui sur A

	LBSR FEN_COUL	; Initialisation des couleurs sol/mur + vidéo forme.
	BSR INIT3_R1	; Affichage du décor de fond.

	LDY #PACKMAP+400 ; Y pointe les données du creuset dans le pack de maps 3
	LBSR AFF_INVW_0B1 ; Message d'acquisition du creuset.
	LDA #20
	STA >PA_W0		; Points d'attaque du creuset = 20
	LBSR TOUCHE		; Attente de touche.
	LBRA DONJON		; Démarrage du jeu.

INIT3_R1:
	LBSR B22
	LBSR B23
	LBSR B24
	LBSR B25
	LBSR B26
	LBSR G19
	LBSR G20
	LBSR G21
	LBSR G22
	LBSR G23
	LBSR E02_G21
INIT3_R2:
	LBSR CH2
	LBSR G6
	LBSR G11
	LBSR G12
	LBSR G13
	LBSR CHEST06
	LBSR W36
	LBSR W46
	LBSR W37
	LBRA W47

MESSAGE1:
	FDB $92C0,$C122,$D4E8,$D124,$D3E2,$24A0,$A13C	; SLAYER TU ES PRESQUE
	FDB $0534,$7BA2,$9810,$5EF4,$42F4,$6934,$993C	; AU PORTAIL. IL NE TE
	FDB $8924,$9934,$7AE8,$96A0,$A740,$D4E8,$247C	; RESTE PLUS QU'A TUER
	FDB $9BA8,$9696,$24B4,$235A,$2310,$96A0,$A23C	; TOUS LES ENNEMIS QUI
	FDB $5934,$3022,$191A,$9EF4,$D6B4,$D6B4,$D6BD	; LE GARDENT.

INIT2_FIN:
	BSZ $6700-INIT2_FIN	; Remplissage de zéros jusqu'à $66FF inclus.

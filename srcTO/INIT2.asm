; =============================================================================
; EVIL DUNGEONS II - (RE)INITIALISATION DU SYSTEME DE JEU DE LA TOUR 2
; Par Christophe PETIT
;
; Ce fichier contient l'initialisation de la tour 2 (Est). C'est ED2PACK2.vbs
; qui se charge de la compilation et de l'extraction du fichier INIT2.BIN à 
; partir du code compilé ED2PACK2.BIN.
;
; Rôle :
; - Modification de l'épée en tronçonneuse.
; - (Ré)initialisation des variables du joueur, des clés et des scores.
; - Affichage d'un message d'accueil.
;
; Une fois l'initialisation faite, cette partie de code est écrasée par les
; listes d'appel. Elle est rechargée quand le joueur perd avant la tour 3 et
; qu'il doit recommencer la tour 2. Les données sont alors réinitialisées.
; =============================================================================
INIT2:
	LDY #PACKSTART	; Y pointe les données de fin de pack.
	LDD ,Y++		; D = adresse de départ.
	ORA #$40		; conversion adresse TO
	STD >SQRADDR	; Adresse courante = adresse de départ.
	LDX #SCORE_E2	; X pointe les variables de score à réaliser
	LBSR BSAVEN_4	; Recopie dans les variables de score.

	CLR >ORIENT		; Orientation Nord.
	CLR >MAPNUM		; Map n°0 = Niveau 1
	LDA #1
	STA >PACKNUM	; Pack n°1 = Tour 2 (EST)

	LDA #cBE		; A = Bleu (12) sur fond bleu ciel (14).
	STA >MAPCOUL21	; Couleurs sol/mur de map secondaires, niveau 1.
	STA >MAPCOUL22	; Couleurs sol/mur de map secondaires, niveau 2.
	STA >MAPCOUL23	; Couleurs sol/mur de map secondaires, niveau 3.
	STA >MAPCOUL24	; Couleurs sol/mur de map secondaires, niveau 4.

	LBSR VIDEOC_A	; Sélection video couleur
	LDY #$5FE0		; Y pointe les données d'initialisation dans la mémoire couleur.
	LDX #MAPCOULC	; X pointe les données de jeu à initialiser.
	LBSR BSAVEN_16	; 32 octets de données d'initialisation à recopier
	LBSR BSAVEN_16

	LBSR AFF_INTERFACE ; Mise à jour de l'interface
	LBSR FEN_COUL	; Initialisation des couleurs sol/mur + vidéo forme.
	BSR INIT2_R1	; Affichage des décors de fond du message.

	LDX #SCROFFSET+$0410 ; X pointe l'écran pour un message.
	LDU #MESSAGE1	; U pointe le message de début de tour.
	LBSR PRINTM		; Affichage du message + demande d'appui sur A

	BSR INIT2_R1	; Réaffichage des décors de fond.

	LBSR AFF_INVW_0B ; Message d'acquisition de la tronçonneuse.
	LDA #10
	STA >PA_W0		; Points d'attaque de la tronçonneuse = 10
	LBSR TOUCHE		; Attente de touche.
	LBRA DONJON		; Démarrage du jeu.

INIT2_R1:
	LBSR FEN_COUL	; Initialisation des couleurs sol/mur + vidéo forme.
	LBSR CH2		; Affichage de sols et de murs pour le fond du message.
	LBSR G6
	LBSR G7
	LBSR W6
	LBSR W7
	LBSR W36
	LBSR W37
	LBRA W46

MESSAGE1:
	FDB $92C0,$C122,$E696,$06A6,$7522,$D124,$9EBC ; SLAYER, LA TOUR EST
	FDB $0062,$44C8,$D10C,$02C8,$611A,$9EA8,$693C ; ABRITE EGALEMENT UNE
	FDB $93A8,$8888,$D0FA,$2348,$8990,$26A0,$A23C ; SOURCE D'ENERGIE QUI
	FDB $02D0,$611A,$9934,$5934,$7BA2,$9810,$5EFC ; ALIMENTE LE PORTAIL.
	FDB $22D0,$621A,$26A4,$7374,$3022,$1A08,$6F3C ; ELIMINE SON GARDIEN,
	FDB $1926,$8D10,$9696,$06A4,$7522,$1134,$24FC ; DETRUIS LA SOURCE ET
	FDB $8912,$721A,$9696,$269E,$7466,$0216,$DEBD ; REJOINS LE PORTAIL.

INIT2_FIN:
	BSZ $6700-INIT2_FIN	; Remplissage de zéros jusqu'à $66FF inclus.
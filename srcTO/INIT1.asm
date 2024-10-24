; =============================================================================
; EVIL DUNGEONS II - (RE)INITIALISATION DU SYSTEME DE JEU DE LA TOUR 1
; Par Christophe PETIT
;
; Ce fichier contient l'initialisation de la tour 1 (Ouest). C'est ED2PACK1.vbs
; qui se charge de la compilation et de l'extraction du fichier INIT1.BIN à 
; partir du code compilé ED2PACK1.BIN.
;
; Rôle :
; - Modification des codes de touche pour la boucle DONJON_TOUCHE.
; - (Ré)initialisation des données de jeu.
; - Affichage d'un message d'accueil.
;
; Une fois l'initialisation faite, cette partie de code est écrasée par les
; listes d'appel. Elle est rechargée quand le joueur perd avant la tour 2 et
; qu'il doit recommencer la tour 1. Les données sont alors réinitialisées.
; =============================================================================
INIT1:
	LBSR VIDEOC_A	; Sélection video couleur
	LDY #$5FC0		; Y pointe les codes de touche dans la vidéo couleur.
	LDX #DONJON_TOUCHE1+1 ; X pointe la première touche à modifier dans le code.
	LDB #19			; 19 touches à modifier.

INIT1_1:			; Modification des touches.
	LDA ,Y+
	STA ,X
	LEAX 6,X
	DECB
	BNE INIT1_1

	LDY #$5FD4		; Y pointe les données d'initialisation dans la mémoire couleur.
	LDX #STATEF		; X pointe les données de jeu à initialiser.
	LBSR BSAVEN_20	; 44 octets de données d'initialisation à recopier
	LBSR BSAVEN_20
	LBSR BSAVEN_4

	LDY #PACKSTART	; Y pointe les données de fin de pack.
	LDD ,Y++		; D = adresse de départ.
	ORA #$40		; conversion adresse TO
	STD >SQRADDR	; Adresse courante = adresse de départ.
	LDX #SCORE_E2	; X pointe les variables de score à réaliser
	LBSR BSAVEN_4	; Recopie dans les variables de score.

    LDB $FFF0
    CMPB #$01
    BGT INIT1_2		; si modèle supérieur au TO7/70
	LDD #$01A1		; valeur de TEMPO pour clavier TO7/70
	LDX #CLAVIER+1
	STD ,X			; modification de la valeur de TEMPO clavier

INIT1_2:
	LBSR AFF_INTERFACE ; Mise à jour de l'interface
	LBSR FEN_COUL	; Initialisation des couleurs sol/mur + vidéo forme.
	LBSR G1			; Affichage de sols et de murs pour le fond du message.
	LBSR G6
	LBSR G11
	LBSR G12
	LBSR W1
	LBSR W37
	LBSR W46
	LBSR W47
	LBSR W48
	LBSR CH2

	LDX #SCROFFSET+$0410 ; X pointe l'écran pour un message.
	LDU #MESSAGE1	; U pointe le message de début de tour.
	LBSR PRINTM		; Affichage du message + demande d'appui sur A
	LBRA DONJON		; Démarrage du jeu.

MESSAGE1:
	FDB $92C0,$C122,$D2C0,$D4DC,$A474,$7508,$94FC ; SLAYER LA TOUR OUEST
	FDB $1D34,$1B9A,$4B9A,$D002,$8A26,$26A8,$693C ; DU DONJON ABRITE UNE
	FDB $93A8,$8888,$D0FA,$2348,$8990,$26A0,$A23C ; SOURCE D'ENERGIE QUI
	FDB $02D0,$611A,$9934,$5934,$7BA2,$9810,$5EFC ; ALIMENTE LE PORTAIL.
	FDB $22D0,$621A,$26A4,$7374,$3022,$1A08,$6F3C ; ELIMINE SON GARDIEN,
	FDB $1926,$8D10,$9696,$06A4,$7522,$1134,$24FC ; DETRUIS LA SOURCE ET
	FDB $8912,$721A,$9696,$06A6,$7522,$D124,$9EFD ; REJOINS LA TOUR EST.

INIT1_FIN:
	BSZ $6700-INIT1_FIN	; Remplissage de zéros jusqu'à $66FF inclus.

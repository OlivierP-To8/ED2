; =============================================================================
; INTRODUCTION D'EVIL DUNGEON 2
;
; Ce listing est destiné à créer le fichier INTRO.BIN pour l'introduction du
; jeu EVIL DUNGEON 2. Le programme affiche des images compressées, dont le titre
; du jeu avec une animation de flammes, permet la configuration des touches,
; l'affichage de l'histoire et des crédits, et affiche une animation sonore de
; bienvenue.
; =============================================================================
; par OlivierP-To8 en mai 2024 (https://github.com/OlivierP-To8)
; =============================================================================

; Options pour lwasm (http://www.lwtools.ca/manual/x832.html)
    PRAGMA 6809,operandsizewarning
    OPT c

    ORG $2600


EXO2
    INCLUDE ../res/exo2_final.asm


;********************************************************************************

PUTC    equ $02    ; Affichage d'un caractère
GETC    equ $0A    ; Lecture du clavier
NOTE    equ $1E    ; Génération de musique

STATUS  equ $2019

TEMPO   equ $203A  ; Tempo général pour la génération de musique.
DUREE   equ $203C  ; Durée de la note (de 1 à 96).
TIMBRE  equ $203D  ; Attaque de la note.
OCTAVE  equ $203F  ; Octave (1, 2, 4, 8 ou 16).

PAUSE   equ $00 ; pause
DO      equ $01 ; do
DOd     equ $02 ; do#
RE      equ $03 ; ré
REd     equ $04 ; re#
MI      equ $05 ; mi
FA      equ $06 ; fa
FAd     equ $07 ; fa#
SOL     equ $08 ; sol
SOLd    equ $09 ; sol#
LA      equ $0A ; la
LAd     equ $0B ; la#
SI      equ $0C ; si
UT      equ $0D

PRC     equ $A7C0

LGATOU  equ $A7DD  ; b5 (MO uniquement) bit pour masquer la cartouche (0: visible, 1: masquée)
                   ; b4 (MO uniquement) bit du basic à sélectionner (0: BASIC1, 1: BASIC128)

MODELE  equ $FFF0  ; Modèle de la gamme

BUFW        equ 10
BUF_ECRAN   equ $8000  ; Adresse de la couleur de l'écran de titre


    PSHS A,B,X,Y

	ORCC #$50		; ne pas interrompre

;********************************************************************************
;* Bord
;********************************************************************************

AFFICHE_BORD
    LDB MODELE     ; 0=MO5, 1=MO6
    BEQ AFFICHE_BORD_MO5

    ; bord sur MO6
    LDA #$10       ; XXXXPBVR (pastel bleu vert rouge)
    STA LGATOU     ; registre uniquement en écriture

    BRA AFFICHE_ECRAN

AFFICHE_BORD_MO5
    ; bord sur MO5
    LDA PRC
    ANDA #$E1      ; border color b4321=0000
    STA PRC



;********************************************************************************
;* Affichage de l'écran de présentation
;********************************************************************************

AFFICHE_ECRAN
    ; désactivation buzzer
    LDA STATUS
    ORA #$08
    STA STATUS

    LDU #IMG_DEBUT1_FORME_FIN-1     ; U pointe le dernier octet de l'image de forme compressée
    LDY #BUF_ECRAN+$1F40			; Y pointe la fin du buffer
    LBSR EXO2				        ; Décompression de l'image de forme

    JSR AFF_MONO                    ; Affichage du buffer
    LDD #$1010                      ; rouge sur fond noir
    JSR EFF			                ; Effacement de l'écran

    LDU #IMG_DEBUT2_FORME_FIN-1     ; U pointe le dernier octet de l'image de forme compressée
    LDY #BUF_ECRAN+$1F40			; Y pointe la fin du buffer
    LBSR EXO2				        ; Décompression de l'image de forme

    LDX #MUSIC1DATA
    LBSR MUSIC
    LDX #MUSIC2DATA
    LBSR MUSIC

    JSR AFF_MONO                    ; Affichage du buffer
    LDD #$1010                      ; rouge sur fond noir
    JSR EFF			                ; Effacement de l'écran


;********************************************************************************
;* Affichage de l'écran titre
;********************************************************************************

    LDU #IMG_TITRE_FORME_FIN-1      ; U pointe le dernier octet de l'image de forme compressée
    LDY #BUF_ECRAN+$1F40			; Y pointe la fin du buffer
    LBSR EXO2				        ; Décompression de l'image de forme

    LDX #MUSIC1DATA
    LBSR MUSIC
    LDX #MUSIC2DATA
    LBSR MUSIC

    JSR AFF_MONO                    ; Affichage du buffer

    LDU #IMG_TITRE_FOND_FIN-1       ; U pointe le dernier octet de l'image de forme compressée
    LDY #BUF_ECRAN+$1F40            ; Y pointe la fin du buffer
    LBSR EXO2				        ; Décompression de l'image de forme

    LDU #BUF_ECRAN
    LDX #$0000
TITRE_COL                           ; Affichage des couleurs de l'écran titre
    PULU D
    STD ,X++
    CMPU #BUF_ECRAN+8000
    BLO TITRE_COL

    LDY #0
MUSIC_DEB
    LDX #MUSIC3DATA
    LBSR MUSIC
    LDX #MUSIC4DATA
    LBSR MUSIC
    LEAY 1,Y
    CMPY #3
    BNE MUSIC_DEB
    LDX #MUSIC5DATA
    LBSR MUSIC
    LDX #MUSIC6DATA
    LBSR MUSIC

    ;LBSR BUFFER_DEBUT               ; Initialisation du feu

BOUCLE
    LBSR METTRE_FEU                 ; Mise à jour du feu

    SWI
    FCB GETC                        ; Test clavier
    TSTB
    BEQ BOUCLE


;********************************************************************************
;* Affichage du menu
;********************************************************************************

    LDU #IMG_MENU_FORME_FIN-1       ; U pointe le dernier octet de l'image de forme compressée
    LDY #BUF_ECRAN+$1F40            ; Y pointe la fin du buffer
    LBSR EXO2				        ; Décompression de l'image de forme

AFFICHE_TITRE
    LDX #MUSICSORTIE
    LBSR MUSIC
    JSR AFF_MONO                    ; Affichage du buffer
    LDD #$1010                      ; rouge sur fond noir
    JSR EFF			                ; Effacement de l'écran

ATTENTE_TITRE
    LBSR SAISIE_TOUCHE
    CMPB #49
    BEQ MENU_FIN
    CMPB #50
    LBEQ PARAM_TOUCHES
    CMPB #51
    BEQ MENU_HISTOIRE
    CMPB #52
    BEQ MENU_CREDITS
    BRA ATTENTE_TITRE

MENU_FIN
    LDX #MUSICENTREE
    LBSR MUSIC
    LDD #$0000                      ; noir sur fond noir
    JSR EFF			                ; Effacement de l'écran
    LBSR DEFINITION_TOUCHES
    LBRA AFFICHER_INTRO             ; retour au bootloader pour lancer la suite

MENU_HISTOIRE
    LDX #MUSICENTREE
    LBSR MUSIC
    LDX #MSG_HISTOIRE_P1
    LBSR AFFICHE_MSG
    LDX #MSG_APPUYER
    LBSR AFFICHE_MSG
    LBSR SAISIE_TOUCHE
    LDX #MSG_HISTOIRE_P2
    LBSR AFFICHE_MSG
    LDX #MSG_APPUYER
    LBSR AFFICHE_MSG
    LBSR SAISIE_TOUCHE
    LDX #MSG_HISTOIRE_P3
    LBSR AFFICHE_MSG
    LDX #MSG_APPUYER
    LBSR AFFICHE_MSG
    LBSR SAISIE_TOUCHE
    LDX #MSG_HISTOIRE_P4
    LBSR AFFICHE_MSG
    LDX #MSG_APPUYER
    LBSR AFFICHE_MSG
    LBSR SAISIE_TOUCHE
    LDX #MSG_HISTOIRE_P5
    LBSR AFFICHE_MSG
    LDX #MSG_APPUYER
    LBSR AFFICHE_MSG
    LBSR SAISIE_TOUCHE
    LBRA AFFICHE_TITRE

MENU_CREDITS
    LDX #MUSICENTREE
    LBSR MUSIC
    LDX #MSG_CREDITS
    LBSR AFFICHE_MSG
    LBSR SAISIE_TOUCHE
    LBRA AFFICHE_TITRE



;********************************************************************************
;* Affichage des touches et des choix Retour/Redéfinir/Réinitialiser
;********************************************************************************

PARAM_TOUCHES
    LDX #MUSICENTREE
    LBSR MUSIC
ATTENTE_TOUCHES_DEBUT
    LDU #MSG_SAISIE_TOUCHES         ; affichage des touches
    LDY #TOUCHES
AFFICHER_TOUCHE
    LDB ,U+                         ; valeur par défaut lors de la redéfinition
    LDB ,Y+                         ; B = valeur définie pour le jeu
    LDX ,U++
    LBSR AFF_TOUCHE
    LDX ,U++
    LBSR AFFICHE_MSG
    CMPU #MSG_SAISIE_TOUCHES_FIN
    BLO AFFICHER_TOUCHE

    LDU #CHOIX0_VIDINV
AFF_CHOIX0_VIDINV
    LDA ,U+
    LDX ,U++
    STA ,X
    CMPU #CHOIX0_VIDINV_FIN
    BLO AFF_CHOIX0_VIDINV

    LDA #0                          ; choix retour par défaut
    STA CHOIX

ATTENTE_TOUCHES_CHOIX
    LDX #MSG_TOUCHES_CHOIX          ; chgmt choix en vidéo inv en cas d'autre touche
    LBSR AFFICHE_MSG

    LBSR SAISIE_TOUCHE

    LDA CHOIX
    CMPA #0
    BEQ CHOIX_RETOUR
    CMPA #1
    BEQ CHOIX_REDEFINIR
    CMPA #2
    BEQ CHOIX_REINITIALISER
    BRA ATTENTE_TOUCHES_CHOIX

CHOIX_RETOUR
    LDU #CHOIX1_VIDINV
CHOIX_RETOUR_VIDINV
    LDA ,U+
    LDX ,U++
    STA ,X
    CMPU #CHOIX1_VIDINV_FIN
    BLO CHOIX_RETOUR_VIDINV
    PSHS B
    LDX #MSG_TOUCHES_CHOIX          ; chgmt choix en vidéo inv
    LBSR AFFICHE_MSG
    PULS B

    LDA #1
    STA CHOIX
	CMPB #13                        ; si entrée alors retour
    LBEQ AFFICHE_TITRE
    BRA ATTENTE_TOUCHES_CHOIX

CHOIX_REDEFINIR
    LDU #CHOIX2_VIDINV
CHOIX_REDEFINIR_VIDINV
    LDA ,U+
    LDX ,U++
    STA ,X
    CMPU #CHOIX2_VIDINV_FIN
    BLO CHOIX_REDEFINIR_VIDINV
    PSHS B
    LDX #MSG_TOUCHES_CHOIX          ; chgmt choix en vidéo inv
    LBSR AFFICHE_MSG
    PULS B

    LDA #2
    STA CHOIX
	CMPB #13                        ; si entrée alors redéfinir
    BEQ REDEFINIR_TOUCHES
    BRA ATTENTE_TOUCHES_CHOIX

CHOIX_REINITIALISER
    LDU #CHOIX0_VIDINV
CHOIX_REINITIALISER_VIDINV
    LDA ,U+
    LDX ,U++
    STA ,X
    CMPU #CHOIX0_VIDINV_FIN
    BLO CHOIX_REINITIALISER_VIDINV
    PSHS B
    LDX #MSG_TOUCHES_CHOIX          ; chgmt choix en vidéo inv
    LBSR AFFICHE_MSG
    PULS B

    LDA #0
    STA CHOIX
	CMPB #13                        ; si entrée alors reinitialiser
    BEQ REINITIALISER_TOUCHES
    LBRA ATTENTE_TOUCHES_CHOIX



;********************************************************************************
;* Définition des touches du jeu en $1FC0 de la mémoire vidéo couleur
;********************************************************************************

DEFINITION_TOUCHES
    PSHS U,X,A
    LDU #TOUCHES
    LDX #$1FC0
    ; commutation du bit de couleur (C0 a 0)
    LDA PRC
    ANDA #$FE
    STA PRC
DEFINITION_TOUCHE
    LDA ,U+
    STA ,X+
    CMPA #$00
    BNE DEFINITION_TOUCHE
    PULS U,X,A
    RTS



;********************************************************************************
;* Redéfinition des touches
;********************************************************************************

REDEFINIR_TOUCHES
    LDU #MSG_SAISIE_TOUCHES         ; affichage des touches
    LDY #TOUCHES
REDEFINIR_TOUCHE
    LDB ,U+                         ; B = valeur par défaut
    LDX ,U++                        ; X = affichage de la touche
    LBSR AFF_TOUCHE
    LDX ,U++                        ; X = affichage du message
    LBSR AFFICHE_MSG
REDEFINIR_TOUCHE_SAISIE
    LBSR SAISIE_TOUCHE               ; Saisie d'une nouvelle valeur

    TFR Y,X                         ; Copie de la touche courante
REDEFINIR_TOUCHE_VERIF
    LEAX -1,X                       ; Pointe vers les touches précédentes
    CMPB ,X                         ; Compare avec touche précédente
    BEQ REDEFINIR_TOUCHE_SAISIE     ; Resaisir si déjà utilisé
    CMPX #TOUCHES
    BHS REDEFINIR_TOUCHE_VERIF      ; Comparer tant qu'il y a des touches précédentes

    STB ,Y+                         ; Enregistre la nouvelle touche
    LDX #MSG_TOUCHES_AFFSTR_VAL     ; X = nouvelle valeur
    LBSR AFF_TOUCHE                  ; conv en chaine
    LDX #MSG_TOUCHES_AFFSTR         ; X = affichage de la touche
    LBSR AFFICHE_MSG
    CMPU #MSG_SAISIE_TOUCHES_FIN
    BLO REDEFINIR_TOUCHE
    LBRA ATTENTE_TOUCHES_DEBUT



;********************************************************************************
;* Reinitialisation des touches
;********************************************************************************

REINITIALISER_TOUCHES
    LDU #MSG_SAISIE_TOUCHES         ; affichage des touches
    LDY #TOUCHES
REINITIALISER_TOUCHE
    LDB ,U+                         ; valeur par défaut lors de la redéfinition
    STB ,Y+                         ; B = valeur définie pour le jeu
    LEAU 4,U
    CMPU #MSG_SAISIE_TOUCHES_FIN
    BLO REINITIALISER_TOUCHE
    LBRA ATTENTE_TOUCHES_DEBUT



;********************************************************************************
;* Affichage de l'intro
;********************************************************************************

AFFICHER_INTRO
    LDU #IMG_FORME_FIN-1            ; U pointe le dernier octet de l'image de forme compressée
    LDY #BUF_ECRAN+$1F40            ; Y pointe la fin du buffer
    LBSR EXO2                       ; Décompression de l'image de forme

    JSR AFF_MONO                    ; Affichage du buffer

    LDD #$0707          ; noir sur fond blanc
    LDY #$0000
SET_FOND
    STD ,Y++
    CMPY #$1F40
    BLE SET_FOND

    LDD #$0101          ; noir sur fond rouge
    LDY #70*40+16
FOND_ROUGE_DEB
    STD ,Y
    LEAY 6,Y
    STD ,Y
    LEAY 34,Y
    CMPY #73*40+16
    BLO FOND_ROUGE_DEB
    LDB #$17            ; rouge sur fond blanc
    STD ,Y
    LEAY 6,Y
    STB ,Y+
    STA ,Y
    LDY #74*40+16
FOND_ROUGE_FIN
    STD ,Y++
    STA ,Y
    LEAY 3,Y
    STD ,Y++
    STA ,Y
    LEAY 33,Y
    CMPY #77*40+16
    BLS FOND_ROUGE_FIN
    LDY #78*40+17
    STA ,Y
    LDY #78*40+22
    STA ,Y
    LDY #79*40+17
    STA ,Y
    LDY #79*40+22
    STA ,Y



;********************************************************************************
;* Affichage de l'animation sonore
;********************************************************************************

    ; Initialisation son
    CLR $A7CF
    LDD #$3F04
    STA $A7CD
    STB $A7CF

    ; Affichage du texte sur l'image
    LDX #MSG_INTRO
    LBSR AFFICHE_MSG

INTRO_ANIM_DEBUT
    ; commutation du bit de forme (C0 a 1)
    LDA PRC
    ORA #$01
    STA PRC

    LDU #SAMPLE
    STU SAMPLE_PTR          ; sauve U sample

    ; affichage de l'animation
INTRO_ANIM_RESTART
    LDU #IMG_FORMES
INTRO_ANIM_START
    PULU Y                  ; 7 cycles contre 9 cycles pour LDY ,U++
    PULU X                  ; 7 cycles contre 8 cycles pour LDX ,U++

INTRO_ANIM_FRAME
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++

    PSHS U                  ; sauve U anim
    LDU SAMPLE_PTR          ; restaure U sample
    LDA ,U+                 ; prend un octet de sample (6 cycles comme PULU A)
    STA $A7CD			    ; envoi l'octet vers la sortie son (253 cycles depuis précédent)
    STU SAMPLE_PTR          ; sauve U sample
    PULS U                  ; restaure U anim

    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y
    LEAY 38,Y
    LDD ,X++
    STD ,Y++
    LDD ,X++
    STD ,Y

    PSHS U                  ; sauve U anim
    LDU SAMPLE_PTR          ; restaure U sample
    LDA ,U+                 ; prend un octet de sample
    STA $A7CD			    ; envoi l'octet vers la sortie son (254 cycles depuis précédent)

    ; il y a environ 7000 octets de son à 4000 Hz (4000 envois par sec pendant 1.75 sec)
    ; l'animation fait 8 frames (1,2,3,4,3,2,1,0)
    ; il faut jouer l'animation 8x durant le son
    LDB #105                ; envoyer ce nb d'octets de sample avant la frame suivante
    NOP
    NOP

    ; lecture d'un morceau du sample avant frame suivante
LECTURE_TEMPO
    LDA #$2E			    ; 248 cycles = 4032 Hz
LECTURE_WAIT
    DECA
    BNE LECTURE_WAIT
    LDA ,U+
    STA $A7CD			    ; envoi de l'octet vers la sortie son
    DECB
    BNE LECTURE_TEMPO

    STU SAMPLE_PTR          ; sauve U sample
    PULS U                  ; restaure U anim

    ; test si fin de l'animation
    CMPU #IMG_FORMES_FIN
    LBLS INTRO_ANIM_START   ; frame suivante

    ; lecture de l'animation terminée, on boucle si le sample n'est pas fini
LECTURE_FIN
    LDU SAMPLE_PTR          ; restaure U sample
    CMPU #SAMPLE_FIN-(7000/8) ; il doit rester de quoi jouer pendant 8 frames
    LBLS INTRO_ANIM_RESTART

    ; lecture de ce qui reste du sample après l'animation
LECTURE_FIN_TEMPO
    LDA #$2D                ; 246 cycles = 4065 Hz
LECTURE_FIN_WAIT
    DECA
    BNE LECTURE_FIN_WAIT
    LDA ,U+
    STA $A7CD               ; envoi de l'octet vers la sortie son
    CMPU #SAMPLE_FIN-1
    BLS LECTURE_FIN_TEMPO

    LDX #MSG_TOUR_NOIR
    LBSR AFFICHE_MSG

    PULS A,B,X,Y
    RTS



;********************************************************************************
; Routine de saisie d'une touche
;********************************************************************************
SAISIE_TOUCHE
    SWI
    FCB GETC
    TSTB
    BEQ SAISIE_TOUCHE
    RTS


;********************************************************************************
; Routine d'effacement de l'écran
;********************************************************************************
EFF
    LDY #$0000
EFF_RAM
    STD ,Y++
    CMPY #$1F40
    BLE EFF_RAM
    RTS


;********************************************************************************
; Routine d'affichage d'une image monochrome via buffer
; U doit pointer sur le dernier octet de l'image de forme compressée
;********************************************************************************
AFF_MONO
    ; commutation du bit de couleur (C0 a 0)
    LDA PRC
    ANDA #$FE
    STA PRC

    LDD #$0000		; noir sur fond noir pour décompression invisible de la forme
    BSR EFF			; Effacement de l'écran

    ; commutation du bit de forme (C0 a 1)
    LDA PRC
    ORA #$01
    STA PRC

    ; U pointe le dernier octet de l'image de forme compressée
    LDU #BUF_ECRAN
    LDX #$0000
AFF_MONO_BUF
    PULU D
    STD ,X++
    CMPU #BUF_ECRAN+8000
    BLO AFF_MONO_BUF

    ; commutation du bit de couleur (C0 a 0)
    LDA PRC
    ANDA #$FE
    STA PRC

    ; il faut ensuite mettre la couleur correspondante (actuellement noir sur noir)
    RTS


;********************************************************************************
; Musique
;********************************************************************************
;   PLAY"O1 T11 L8 A1 MI#REREREREREREMI#REREREREREREMI#FA#RERERERERERE
MUSIC1DATA  FCB $10,$0B,$08,$01,FA,RE,RE,RE,RE,RE,RE,FA,RE,RE,RE,RE,RE,RE,FA,FAd,RE,RE,RE,RE,RE,RE,$FF
;   PLAY"O1 T2 L40 A13 DODODODO
MUSIC2DATA  FCB $10,$02,$28,$0D,DO,DO,DO,DO,$FF

;   PLAY"O2T7L13A5REREDOREREDOMIO1RE#RE#RE#
MUSIC3DATA  FCB $08,$07,$0D,$05,RE,RE,DO,RE,RE,DO,MI,$FF
MUSIC4DATA  FCB $10,$07,$0D,$05,REd,REd,REd,$FF
;   PLAY"O2T7L20A7RE#MI#RE#SO#
MUSIC5DATA  FCB $08,$07,$14,$07,REd,FA,REd,SOLd,$FF
;   PLAY"O2T40L20A1DO"
MUSIC6DATA  FCB $08,$28,$14,$01,DO,$FF

;   PLAY"O1T4L9A4SI#MI"
;MUSICSELECT FCB $10,$04,$09,$04,FA,MI,$FF
;   PLAY"O2T9L6A5LAMILA"
MUSICENTREE FCB $08,$09,$06,$05,LA,MI,LA,$FF
;   PLAY"O2T9L6A5MILAMI"
MUSICSORTIE FCB $08,$09,$06,$05,MI,LA,MI,$FF

MUSIC
    LDD ,X++
    STA OCTAVE
    STB TEMPO
    LDD ,X++
    STA DUREE
    STB TIMBRE
MUSIC_LOOP
    LDB ,X+
    CMPB #$FF
    BEQ MUSIC_END
    SWI
    FCB NOTE
    BRA MUSIC_LOOP
MUSIC_END
    RTS


;********************************************************************************
; Affichage d'un message
;********************************************************************************
AFFICHE_CAR
    SWI
    FCB PUTC
AFFICHE_MSG
    LDB ,X+
    CMPB #$04
    BNE AFFICHE_CAR
    RTS


;*******************************************************************************
; Initialisation du buffer avec une ligne blanche en bas de l'écran
;*******************************************************************************
BUFFER_DEBUT
    LDD #$0000      ; noir
    LDY #BUFFER
EFF_LIGNE_BUFFER
    STD ,Y++
    CMPY #BUFFER_FIN-BUFW
    BLO EFF_LIGNE_BUFFER

    LDA #(FEU_LEVEL_FIN-FEU_LEVEL)
EFF_DERLIGNE_BUFFER
    STA ,Y+
    CMPY #BUFFER_FIN
    BLO EFF_DERLIGNE_BUFFER
    RTS


;*******************************************************************************
; Mettre le feu
; Basé sur https://fabiensanglard.net/doom_fire_psx/
;*******************************************************************************
METTRE_FEU
    LDU #BUFFER+BUFW
    LDY #RANDOM
FEU_LIGNE
    PULU A
    TSTA
    BEQ RNDA_POSITIF
    SUBA ,Y+
    TSTA
    BGE RNDA_POSITIF
    LDA #$00
RNDA_POSITIF
    CMPY #RANDOM_FIN
    BLO FEU_NEXT
    LDY #RANDOM
FEU_NEXT
    LEAU -BUFW,U
    PSHU A
    LEAU BUFW+1,U
    CMPU #BUFFER_FIN
    BLO FEU_LIGNE

    ; le calcul est fait dans un buffer de 10 colonnes
    ; l'affichage est répété 4 fois (pour les 40 octets par ligne)
    LDU #BUFFER
    LDX #BUF_ECRAN+$0F40-(BUFFER_FIN-BUFFER)*(40/BUFW)
    LDY #FEU_LEVEL
AFF_FEU_LIGNE
    PULU D
    LDA A,Y
    LDB B,Y
    STD ,X
    STD 10,X
    STD 20,X
    STD 30,X
    PULU D
    LDA A,Y
    LDB B,Y
    STD 2,X
    STD 12,X
    STD 22,X
    STD 32,X
    PULU D
    LDA A,Y
    LDB B,Y
    STD 4,X
    STD 14,X
    STD 24,X
    STD 34,X
    PULU D
    LDA A,Y
    LDB B,Y
    STD 6,X
    STD 16,X
    STD 26,X
    STD 36,X
    PULU D
    LDA A,Y
    LDB B,Y
    STD 8,X
    STD 18,X
    STD 28,X
    STD 38,X
    LEAX 40,X
    CMPU #BUFFER_FIN
    BLO AFF_FEU_LIGNE

    ; on remet le fond blanc pour le texte du titre
    LDU #BUF_ECRAN+$1F40-(BUFFER_FIN-BUFFER)*(40/BUFW)
    LDY #BUF_ECRAN+$0F40-(BUFFER_FIN-BUFFER)*(40/BUFW)
    LDX #$1F40-(BUFFER_FIN-BUFFER)*(40/BUFW)
TEXTE_FEU
    PULU D

    TSTA                    ; si noir
    BEQ TEXTE_FEU_VIDEA
    CMPA #$01               ; si rouge
    BEQ TEXTE_FEU_ROUGEA
    LDA ,Y+                 ; blanc
    ANDA #$F0               ; garde la forme / efface le fond
    ORA #$07                ; remet le fond blanc
    BRA TEXTE_FEU_NEXTA
TEXTE_FEU_ROUGEA
    LDA ,Y+
    ANDA #$F0               ; garde la forme / efface le fond
    ORA #$01                ; remet le fond rouge
    BRA TEXTE_FEU_NEXTA
TEXTE_FEU_VIDEA
    LDA ,Y+                 ; si A == 0

TEXTE_FEU_NEXTA
    TSTB                    ; si noir
    BEQ TEXTE_FEU_VIDEB
    CMPB #$01               ; si rouge
    BEQ TEXTE_FEU_ROUGEB
    LDB ,Y+                 ; blanc
    ANDB #$F0               ; garde la forme / efface le fond
    ORB #$07                ; remet le fond blanc
    BRA TEXTE_FEU_NEXTB
TEXTE_FEU_ROUGEB
    LDB ,Y+
    ANDB #$F0               ; garde la forme / efface le fond
    ORB #$01                ; remet le fond rouge
    BRA TEXTE_FEU_NEXTB
TEXTE_FEU_VIDEB
    LDB ,Y+                 ; si A == 0

TEXTE_FEU_NEXTB
    STD ,X++
    CMPX #$1F18
    BLO TEXTE_FEU

    RTS


FEU_LEVEL   ; couleur selon la hauteur
    FCB $00,$00,$10,$01
    FCB $10,$01,$10,$01,$10,$01,$10,$01,$10,$01
    FCB $19,$91,$19,$91,$19,$91,$19,$91,$19,$91
    FCB $F9,$9F,$F9,$9F,$F9,$9F,$F9,$9F,$F9,$9F
    FCB $F3,$3F,$F3,$3F,$F3,$3F,$F3,$3F,$F3,$3F
    FCB $B3,$3B,$B3,$3B,$B3,$3B,$B3,$3B,$B3,$3B
    FCB $B7,$7B,$B7,$7B,$B7,$7B,$B7,$7B,$B7,$7B
    FCB $77,$77,$77,$77
FEU_LEVEL_FIN


RANDOM
    FCB 1,2,1,1,1,1,1,2,1,2,1,2,1,2,2,1
    FCB 2,1,2,1,1,2,2,2,2,2,2,1,1,1,1,1
    FCB 2,2,2,2,1,1,2,1,1,2,2,2,1,2,2,1
    FCB 2,1,1,1,1,1,2,1,2,2,2,2,1,2,1,1
    FCB 1,2,2,1,2,2,1,2,1,1,2,1,2,2,1,1
    FCB 1,1,1,1,2,1,1,1,2,1,1,1,1,2,1,2
    FCB 1,2,1,1,1,1,1,2,1,2,1,2,1,2,2,1
    FCB 2,2,1,2,1,1,2,1,1,2,1,1,2,1,1,2
    FCB 2,2,2,2,1,1,2,2,2,2,2,2,2,1,2,1
    FCB 1,2,2,1,1,1,1,1,2,1,2,1,2,2,1,1
    FCB 1,1,2,1,2,2,2,2,2,2,2,1,1,1,1,2
    FCB 1,1,2,1,1,1,2,1,1,2,2,1,1,2,2,2
RANDOM_FIN


BUFFER      ; pré-rempli de quelques lignes
    ;RMB BUFW*(FEU_LEVEL_FIN-FEU_LEVEL)
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    FCB $35,$26,$35,$35,$35,$35,$35,$26,$35,$26
    FCB $36,$28,$36,$28,$28,$36,$28,$36,$28,$36
    FCB $37,$2a,$2a,$2a,$2a,$2a,$2a,$37,$37,$37
    FCB $38,$38,$2c,$2c,$2c,$2c,$38,$38,$2c,$38
    FCB $39,$2e,$2e,$2e,$39,$2e,$2e,$39,$2e,$39
    FCB $3a,$3a,$3a,$3a,$30,$3a,$30,$30,$30,$30
    FCB $3b,$32,$3b,$3b,$3b,$32,$32,$3b,$32,$32
    FCB $3c,$34,$3c,$3c,$34,$3c,$34,$34,$3c,$3c
    FCB $3d,$3d,$3d,$3d,$36,$3d,$3d,$3d,$36,$3d
    FCB $3e,$3e,$3e,$38,$3e,$38,$3e,$38,$3e,$3e
    FCB $3f,$3f,$3f,$3a,$3f,$3a,$3f,$3a,$3f,$3a
    FCB $3c,$40,$3c,$3c,$40,$3c,$40,$40,$3c,$40
    FCB $41,$3e,$41,$41,$3e,$41,$41,$3e,$3e,$3e
    FCB $40,$40,$42,$42,$40,$40,$40,$40,$40,$40
    FCB $42,$43,$42,$43,$43,$42,$42,$43,$43,$43
    FCB $44,$44,$44,$44,$44,$44,$44,$44,$44,$44
BUFFER_FIN


;********************************************************************************
;* Routine d'affichage de la valeur d'une touche
;********************************************************************************
AFF_TOUCHE
    PSHS U
    ; Gestion des touches non affichables
    LDU #TEXTE_TOUCHE
AFF_TOUCHE_DEB
    CMPB ,U+                        ; A = valeur de la touche
    BEQ AFF_TEXTE_TOUCHE
    LEAU 6,U                        ; X = affichage de la touche
    CMPU #TEXTE_TOUCHE_FIN
    BLO AFF_TOUCHE_DEB
    BRA AFF_VAL_TOUCHE
AFF_TEXTE_TOUCHE
    LDD ,U++                        ; X = affichage de la touche
    STD ,X++
    LDD ,U++
    STD ,X++
    LDD ,U++
    STD ,X
    BRA AFF_TOUCHE_FIN
AFF_VAL_TOUCHE                      ; Affichage d'une touche affichable
    PSHS B
    LDD #$2020
    STD ,X++
    LDD #$2020
    STD ,X++
    PULS B
    LDA #$20
    STD ,X
AFF_TOUCHE_FIN
    PULS U
    RTS



MSG_HISTOIRE_P1
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$50                  ; couleur fond  noir
    FCB     $1B,$60                  ; couleur tour  noir
    FCB     $0C                      ; effacement de la fenêtre
    FCB     $1F,$42,$41              ; positionnement du curseur
    FCC     "Hiver 1953, le centre CNES-GEIPAN"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "apr"
    FCB     $16,$41                  ; accent grave
    FCC     "es plusieurs t"
    FCB     $16,$42                  ; accent aigu
    FCC     "emoignages rapportant"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "des ph"
    FCB     $16,$42                  ; accent aigu
    FCC     "enom"
    FCB     $16,$41                  ; accent grave
    FCC     "enes "
    FCB     $16,$42                  ; accent aigu
    FCC     "etranges et des lueurs"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "sur le site de VIX d"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecide d'envoyer"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "une "
    FCB     $16,$42                  ; accent aigu
    FCC     "equipe d'arch"
    FCB     $16,$42                  ; accent aigu
    FCC     "eologues et de"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "scientifiques sur la zone situ"
    FCB     $16,$42                  ; accent aigu
    FCC     "ee en"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "C"
    FCB     $16,$43                  ; accent circonflexe
    FCC     "ote-d'Or."

    FCB     $0D,$0A                  ; ligne suivante
    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "La d"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecouverte est historique et"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "formidable : la tombe de la Dame de"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "VIX, l'une des plus grandes reines"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "celtes mais aussi un bloc de 2,5 de"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "long sur 1,2 m"
    FCB     $16,$41                  ; accent grave
    FCC     "etres de large, d'un"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "alliage de bronze et d'or, d"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecor"
    FCB     $16,$42                  ; accent aigu
    FCC     "e de"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "chevaux ail"
    FCB     $16,$42                  ; accent aigu
    FCC     "es et d'"
    FCB     $16,$42                  ; accent aigu
    FCC     "eclairs avec le nom"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "OGMIOS grav"
    FCB     $16,$42                  ; accent aigu
    FCC     "e dessus."

    FCB     $04


MSG_HISTOIRE_P2
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$50                  ; couleur fond  noir
    FCB     $1B,$60                  ; couleur tour  noir
    FCB     $0C                      ; effacement de la fenêtre
    FCB     $1F,$42,$41              ; positionnement du curseur
    FCC     "Octobre 2022, le centre re"
    FCB     $16,$4B                  ; cedille
    FCC     "coit un"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "nombre incroyable de signalements de"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "ph"
    FCB     $16,$42                  ; accent aigu
    FCC     "enom"
    FCB     $16,$41                  ; accent grave
    FCC     "enes appel"
    FCB     $16,$42                  ; accent aigu
    FCC     "es "
    FCB     $22                      ; "
    FCC     "lueurs n"
    FCB     $16,$42                  ; accent aigu
    FCC     "egatives"
    FCB     $22                      ; "
    FCC     ","

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "tous situ"
    FCB     $16,$42                  ; accent aigu
    FCC     "es sur des puys localis"
    FCB     $16,$42                  ; accent aigu
    FCC     "es en"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Auvergne, et il s'aper"
    FCB     $16,$4B                  ; cedille
    FCC     "coit que sur le"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "bloc de bronze et d'or, appel"
    FCB     $16,$42                  ; accent aigu
    FCC     "e aussi"

    FCB     $0D,$0A                  ; ligne suivante
    FCB     $22                      ; "
    FCC     "bloc de VIX"
    FCB     $22                      ; "
    FCC     ", commence "
    FCB     $16,$41                  ; accent grave
    FCC     "a se former"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "une sorte de miroir sans reflet...."

    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "26 Novembre 2022, sur le bloc de VIX"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "le miroir sans reflet "
    FCB     $16,$42                  ; accent aigu
    FCC     "emet une "
    FCB     $16,$42                  ; accent aigu
    FCC     "etrange"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "lueur et il coule de ce dernier de"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "fines gouttelettes de m"
    FCB     $16,$42                  ; accent aigu
    FCC     "etal."

    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "26 Novembre 2022, 18h30, le bloc de VIX"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "se met "
    FCB     $16,$41                  ; accent grave
    FCC     "a rayonner de plusieurs couleurs"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "et de plus en plus vite."

    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "26 Novembre 2022, 18H52, un homme sort"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "du bloc de VIX, les mesures de s"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecurit"
    FCB     $16,$42                  ; accent aigu
    FCC     "e"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "n"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecessaires sont mises en place."

    FCB     $04


MSG_HISTOIRE_P3
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$50                  ; couleur fond  noir
    FCB     $1B,$60                  ; couleur tour  noir
    FCB     $0C                      ; effacement de la fenêtre
    FCB     $1F,$42,$41              ; positionnement du curseur
    FCC     "15 D"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecembre 2022, les scientifiques et"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "les chercheurs du GEIPAN apprennent que"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "l'homme sorti du bloc de VIX, est bien "

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Ogmios."

    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Ogmios explique qu'il est le fils"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "d'une mortelle et du dieu du tonnerre"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "et de la foudre TARANIS et qu'il y a"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "2300 ans, apr"
    FCB     $16,$41                  ; accent grave
    FCC     "es un combat sanglant,"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "il a vaincu Dis Pater et sa horde"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "de d"
    FCB     $16,$42                  ; accent aigu
    FCC     "emons, les enfermant pour un temps"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "au quatre coins de la France actuelle"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "mais aussi, qu'"
    FCB     $16,$41                  ; accent grave
    FCC     "a la suite de ce combat,"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "le conseil des druides, a d"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecid"
    FCB     $16,$42                  ; accent aigu
    FCC     "e de"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "l'envoyer par le portail dans notre"

    FCB     $0D,$0A                  ; ligne suivante
    FCB     $16,$42                  ; accent aigu
    FCC     "epoque pour vaincre Dis Pater"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "une bonne fois pour toute."

    FCB     $04


MSG_HISTOIRE_P4
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$50                  ; couleur fond  noir
    FCB     $1B,$60                  ; couleur tour  noir
    FCB     $0C                      ; effacement de la fenêtre
    FCB     $1F,$42,$41              ; positionnement du curseur
    FCC     "Apr"
    FCB     $16,$41                  ; accent grave
    FCC     "es plusieurs tests sur Ogmios, les"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "scientifiques du GEIPAN observent"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "qu'Ogmios poss"
    FCB     $16,$41                  ; accent grave
    FCC     "ede "
    FCB     $16,$41                  ; accent grave
    FCC     "a lui seul une force"

    FCB     $0D,$0A                  ; ligne suivante
    FCB     $16,$42                  ; accent aigu
    FCC     "equivalente "
    FCB     $16,$41                  ; accent grave
    FCC     "a celle d'une cinquantaine"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "d'hommes et qu'il poss"
    FCB     $16,$41                  ; accent grave
    FCC     "ede en outre une"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "partie des dons suppos"
    FCB     $16,$42                  ; accent aigu
    FCC     "es de son p"
    FCB     $16,$41                  ; accent grave
    FCC     "ere"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Taranis."

    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "16 Ao"
    FCB     $16,$43                  ; accent circonflexe
    FCC     "ut 2023, le centre GEIPAN, observe"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "une activit"
    FCB     $16,$42                  ; accent aigu
    FCC     "e d'"
    FCB     $16,$42                  ; accent aigu
    FCC     "energie n"
    FCB     $16,$42                  ; accent aigu
    FCC     "egative au Puy"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "de Lassolas et d"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecide d'envoyer l'agent"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Nosmoht afin d'enqu"
    FCB     $16,$43                  ; accent circonflexe
    FCC     "eter et de mesurer"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "les risques."

    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "21 Ao"
    FCB     $16,$43                  ; accent circonflexe
    FCC     "ut 2023, dernier message de Nosmoht"

    ;FCB     $0D,$0A                  ; ligne suivante
    FCC     "qui dit "
    FCB     $22                      ; "
    FCC     "Danger, d"
    FCB     $16,$42                  ; accent aigu
    FCC     "emons, Alastar..."
    FCB     $22                      ; "

    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "29 Ao"
    FCB     $16,$43                  ; accent circonflexe
    FCC     "ut 2023, le conseil de la s"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecurit"
    FCB     $16,$42                  ; accent aigu
    FCC     "e"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "nationale envoie ses troupes d'"
    FCB     $16,$42                  ; accent aigu
    FCC     "elites"

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "sur zone, toutes sont an"
    FCB     $16,$42                  ; accent aigu
    FCC     "eanties..."

    FCB     $04


MSG_HISTOIRE_P5
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$50                  ; couleur fond  noir
    FCB     $1B,$60                  ; couleur tour  noir
    FCB     $0C                      ; effacement de la fenêtre
    FCB     $1F,$40,$41              ; positionnement du curseur
    FCC     "2 Septembre 2023, apr"
    FCB     $16,$41                  ; accent grave
    FCC     "es plusieurs jours"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "de r"
    FCB     $16,$42                  ; accent aigu
    FCC     "eflexion, le Conseil de la s"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecurit"
    FCB     $16,$42                  ; accent aigu
    FCC     "e"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "nationale fran"
    FCB     $16,$4B                  ; cedille
    FCC     "caise et le GEIPAN,"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "d"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecident d'envoyer Ogmios, sous le nom"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "de code "
    FCB     $22                      ; "
    FCC     "Slayer of evils"
    FCB     $22                      ; "
    FCC     ", avec pour"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "mission de retrouver l'agent Nosmoht et"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "de d"
    FCB     $16,$42                  ; accent aigu
    FCC     "etruire tous les d"
    FCB     $16,$42                  ; accent aigu
    FCC     "emons ainsi que"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "leur chef Alastar."
    
    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Apr"
    FCB     $16,$41                  ; accent grave
    FCC     "es avoir vaincu les d"
    FCB     $16,$42                  ; accent aigu
    FCC     "emons et le"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "gardien Alastar, le Slayer trouve un"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "message de Nosmoht, avec juste deux"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "mots : "
    FCB     $22                      ; "
    FCC     "Tarasque"
    FCB     $22                      ; "
    FCC     " et "
    FCB     $22                      ; "
    FCC     "Dis Pater"
    FCB     $22                      ; "
    FCC     "."
    
    FCB     $0D,$0A                  ; ligne suivante

    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Le Slayer, apr"
    FCB     $16,$41                  ; accent grave
    FCC     "es "
    FCB     $16,$43                  ; accent circonflexe
    FCC     "etre retourn"
    FCB     $16,$42                  ; accent aigu
    FCC     "e au"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Centre pour s'"
    FCB     $16,$42                  ; accent aigu
    FCC     "equiper et r"
    FCB     $16,$42                  ; accent aigu
    FCC     "ecup"
    FCB     $16,$42                  ; accent aigu
    FCC     "erer son"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Anticyth"
    FCB     $16,$41                  ; accent grave
    FCC     "ere sur le bloc de VIX pour"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "pouvoir se rep"
    FCB     $16,$42                  ; accent aigu
    FCC     "erer, se dirige vers "
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "le lieu o"
    FCB     $16,$41                  ; accent grave
    FCC     "u autrefois il avait vaincu,"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "la cr"
    FCB     $16,$42                  ; accent aigu
    FCC     "eature d"
    FCB     $16,$42                  ; accent aigu
    FCC     "emoniaque appel"
    FCB     $16,$42                  ; accent aigu
    FCC     "e Tarasque,"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "car il "
    FCB     $16,$42                  ; accent aigu
    FCC     "etait certain de retrouver"
    
    FCB     $0D,$0A                  ; ligne suivante
    FCC     "Dis Pater dans ce lieu."

    FCB     $04


MSG_APPUYER
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$40                  ; couleur forme noir
    FCB     $1B,$51                  ; couleur fond  rouge
    FCB     $1F,$58,$4A              ; positionnement du curseur
    FCC     "Appuyez sur une touche"
    FCB     $04


MSG_CREDITS
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$50                  ; couleur fond  noir
    FCB     $1B,$60                  ; couleur tour  noir
    FCB     $0C                      ; effacement de la fenêtre
    FCB     $1F,$42,$41              ; positionnement du curseur

    FCB     $1B,$47                  ; couleur forme blanc
    FCB     $1B,$73                  ; double taille
    FCC     "Christophe"
    FCB     $0D,$0A                  ; ligne suivante
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$70                  ; taille normale
    FCC     "            Programmeur, Concept artist"
    FCB     $0D,$0A,$0D,$0A          ; lignes suivantes

    FCB     $1B,$47                  ; couleur forme blanc
    FCB     $1B,$73                  ; double taille
    FCC     "Vincent (Retro VinZ)"
    FCB     $0B                      ; ligne précédente
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$70                  ; taille normale
    FCC     "                         Concept artist"
    FCB     $0D,$0A,$0D,$0A          ; lignes suivantes

    FCB     $1B,$47                  ; couleur forme blanc
    FCB     $1B,$73                  ; double taille
    FCC     "OlivierP-To8"
    FCB     $0D,$0A                  ; ligne suivante
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$70                  ; taille normale
    FCC     "    Coordinateur technique, Programmeur"
    FCB     $0D,$0A,$0D,$0A          ; lignes suivantes

    FCB     $1B,$47                  ; couleur forme blanc
    FCB     $1B,$73                  ; double taille
    FCC     "Dhypse"
    FCB     $0D,$0A                  ; ligne suivante
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$70                  ; taille normale
    FCC     "                         Sound designer"
    FCB     $0D,$0A,$0D,$0A          ; lignes suivantes

    FCB     $1B,$47                  ; couleur forme blanc
    FCB     $1B,$73                  ; double taille
    FCC     "StevanR"
    FCB     $0D,$0A                  ; ligne suivante
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$70                  ; taille normale
    FCC     "                                Testeur"
    FCB     $0D,$0A,$0D,$0A          ; lignes suivantes

    FCB     $1B,$47                  ; couleur forme blanc
    FCB     $1B,$73                  ; double taille
    FCC     "Thom MO5"
    FCB     $0D,$0A                  ; ligne suivante
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$70                  ; taille normale
    FCC     "              Sc"
    FCB     $16,$42                  ; accent aigu
    FCC     "enariste, communication"
    FCB     $0D,$0A,$0D,$0A          ; lignes suivantes

    FCB     $1B,$47                  ; couleur forme blanc
    FCB     $1B,$73                  ; double taille
    FCC     "sbmicro1896"
    FCB     $0D,$0A                  ; ligne suivante
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$70                  ; taille normale
    FCC     "                  Correcteur artistique"
    FCB     $04


MSG_INTRO
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$50                  ; couleur fond  noir
    FCB     $1B,$67                  ; couleur tour  blanc
    ;FCB     $1B,$70                  ; taille normale
    ;FCB     $1B,$71                  ; double hauteur
    FCB     $1B,$73                  ; double taille
    FCB     $1F,$54,$4C              ; positionnement du curseur
    FCC     "Bienvenue"
    FCB     $04


MSG_TOUR_NOIR
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$60                  ; couleur tour noir
    FCB     $04


MSG_TOUCHES_REDEFINIR_Avancer
    ;FCB     $1F,$20,$20,$1F,$12,$14  ; séquence de définition d'une fenêtre de travail des lignes 00 à 24
    FCB     $14                      ; effacer le curseur de l'écran
    FCB     $1B,$41                  ; couleur forme rouge
    FCB     $1B,$50                  ; couleur fond  noir
    FCB     $1B,$60                  ; couleur tour  noir
    FCB     $0C                      ; effacement de la fenêtre
    FCB     $1B,$70                  ; taille normale

    FCB     $1F,$41,$41              ; positionnement du curseur en ligne 01 colonne 01
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Avancer_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Avancer"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Reculer
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Reculer_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Reculer"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Gauche
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Gauche_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Tourner d'1/4 de tour "
    FCB     $16,$41                  ; accent grave
    FCC     "a gauche"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Droite
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Droite_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Tourner d'1/4 de tour "
    FCB     $16,$41                  ; accent grave
    FCC     "a droite"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Feu
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Feu_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Feu avec l'arme s"
    FCB     $16,$42                  ; accent aigu
    FCC     "electionn"
    FCB     $16,$42                  ; accent aigu
    FCC     "ee"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Sort
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Sort_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Lancer le sort s"
    FCB     $16,$42                  ; accent aigu
    FCC     "electionn"
    FCB     $16,$42                  ; accent aigu
    FCC     "e"
    FCB     $04

MSG_TOUCHES_REDEFINIR_PasGauche
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_PasGauche_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Pas "
    FCB     $16,$41                  ; accent grave
    FCC     "a gauche"
    FCB     $04

MSG_TOUCHES_REDEFINIR_PasDroite
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_PasDroite_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Pas "
    FCB     $16,$41                  ; accent grave
    FCC     "a droite"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Map
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Map_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Affichage de la map"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Quitter
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Quitter_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Quitter"
    FCB     $04

MSG_TOUCHES_REDEFINIR_ArmePrec
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_ArmePrec_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Arme pr"
    FCB     $16,$42                  ; accent aigu
    FCC     "ec"
    FCB     $16,$42                  ; accent aigu
    FCC     "edente"
    FCB     $04

MSG_TOUCHES_REDEFINIR_ArmeSuiv
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_ArmeSuiv_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Arme suivante"
    FCB     $04

MSG_TOUCHES_REDEFINIR_SortPrec
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_SortPrec_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Sort pr"
    FCB     $16,$42                  ; accent aigu
    FCC     "ec"
    FCB     $16,$42                  ; accent aigu
    FCC     "edent"
    FCB     $04

MSG_TOUCHES_REDEFINIR_SortSuiv
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_SortSuiv_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Sort suivant"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Obj1
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Obj1_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Utilisation de l'objet 1"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Obj2
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Obj2_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Utilisation de l'objet 2"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Obj3
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Obj3_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Utilisation de l'objet 3"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Obj4
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Obj4_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Utilisation de l'objet 4"
    FCB     $04

MSG_TOUCHES_REDEFINIR_Obj5
    FCB     $0D,$0A                  ; retour en début de ligne courante et descente d'une ligne
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_REDEFINIR_Obj5_Val
    FCC     "       "
    FCB     $1B,$41                  ; couleur forme rouge
    FCC     "Utilisation de l'objet 5"
    FCB     $04

MSG_TOUCHES_CHOIX
    FCB     $1F,$57,$43              ; positionnement du curseur en ligne 22 colonne 03
MSG_TOUCHES_CHOIX_0
    FCB     $1B,$7B                  ; inversion de la vidéo
    FCC     "Retour"
    FCB     $1F,$57,$4C              ; positionnement du curseur en ligne 22 colonne 12
MSG_TOUCHES_CHOIX_1
    FCB     $1B,$7B                  ; inversion de la vidéo
    FCC     "Red"
    FCB     $16,$42                  ; accent aigu
    FCC     "efinir"
    FCB     $1F,$57,$58              ; positionnement du curseur en ligne 22 colonne 24
MSG_TOUCHES_CHOIX_2
    FCB     $1B,$70                  ; taille normale (modifiable en $7B)
    FCC     "R"
    FCB     $16,$42                  ; accent aigu
    FCC     "einitialiser"
MSG_TOUCHES_CHOIX_3
    FCB     $1B,$70                  ; taille normale (modifiable en $7B)
    FCB     $04

MSG_TOUCHES_AFFSTR
    FCB     $0D                      ; retour en début de ligne courante
    FCB     $1B,$47                  ; couleur forme blanc
MSG_TOUCHES_AFFSTR_VAL
    FCC     "     "
MSG_TOUCHES_AFFCAR_VAL
    FCC     "  "
    FCB     $04


CHOIX0_VIDINV
    FCB $7B
    FDB MSG_TOUCHES_CHOIX_0+1
    FCB $7B
    FDB MSG_TOUCHES_CHOIX_1+1
    FCB $70
    FDB MSG_TOUCHES_CHOIX_2+1
    FCB $70
    FDB MSG_TOUCHES_CHOIX_3+1
CHOIX0_VIDINV_FIN

CHOIX1_VIDINV
    FCB $70
    FDB MSG_TOUCHES_CHOIX_0+1
    FCB $7B
    FDB MSG_TOUCHES_CHOIX_1+1
    FCB $7B
    FDB MSG_TOUCHES_CHOIX_2+1
    FCB $70
    FDB MSG_TOUCHES_CHOIX_3+1
CHOIX1_VIDINV_FIN

CHOIX2_VIDINV
    FCB $70
    FDB MSG_TOUCHES_CHOIX_0+1
    FCB $70
    FDB MSG_TOUCHES_CHOIX_1+1
    FCB $7B
    FDB MSG_TOUCHES_CHOIX_2+1
    FCB $7B
    FDB MSG_TOUCHES_CHOIX_3+1
CHOIX2_VIDINV_FIN


TEXTE_TOUCHE
    FCB $02
    FCC "  Stop"
    FCB $08
    FCC "Gauche"
    FCB $09
    FCC "Droite"
    FCB $0A
    FCC "   Bas"
    FCB $0B
    FCC "  Haut"
    FCB $0C
    FCC "   RAZ"
    FCB $0D
    FCC "Entree"
    FCB $14
    FCC " Arret"
    FCB $1C
    FCC "   INS"
    FCB $1D
    FCC "   EFF"
    FCB $20
    FCC "Espace"
TEXTE_TOUCHE_FIN



;********************************************************************************
; Configuration des touches en $1FC0 de la mémoire vidéo couleur.
;********************************************************************************
CHOIX FCB $00   ; 0 = retour, 1 = redéfinir, 2 = réinitialiser

MSG_SAISIE_TOUCHES
	FCB $0B	; = TOUCHE_HAUT = Avancer.
    FDB MSG_TOUCHES_REDEFINIR_Avancer_Val
    FDB MSG_TOUCHES_REDEFINIR_Avancer

	FCB $0A	; = TOUCHE_BAS = Reculer.
    FDB MSG_TOUCHES_REDEFINIR_Reculer_Val
    FDB MSG_TOUCHES_REDEFINIR_Reculer

	FCB $08	; = TOUCHE_GAUCHE = Tourner d'un quart de tour à gauche.
    FDB MSG_TOUCHES_REDEFINIR_Gauche_Val
    FDB MSG_TOUCHES_REDEFINIR_Gauche

	FCB $09	; = TOUCHE_DROITE = Tourner d'un quart de tour à droite.
    FDB MSG_TOUCHES_REDEFINIR_Droite_Val
    FDB MSG_TOUCHES_REDEFINIR_Droite

	FCB $20	; = TOUCHE_ESPACE = Action / Feu avec l'arme sélectionnée.
    FDB MSG_TOUCHES_REDEFINIR_Feu_Val
    FDB MSG_TOUCHES_REDEFINIR_Feu

	FCB $42	; = TOUCHE_B = Lancer le sort sélectionné.
    FDB MSG_TOUCHES_REDEFINIR_Sort_Val
    FDB MSG_TOUCHES_REDEFINIR_Sort

	FCB $43	; = TOUCHE_C = Pas à gauche.
    FDB MSG_TOUCHES_REDEFINIR_PasGauche_Val
    FDB MSG_TOUCHES_REDEFINIR_PasGauche

	FCB $56	; = TOUCHE_V = Pas à droite.
    FDB MSG_TOUCHES_REDEFINIR_PasDroite_Val
    FDB MSG_TOUCHES_REDEFINIR_PasDroite

	FCB $4D	; = TOUCHE_M = Affichage de la map.
    FDB MSG_TOUCHES_REDEFINIR_Map_Val
    FDB MSG_TOUCHES_REDEFINIR_Map

	FCB $51	; = TOUCHE_Q = Quitter.
    FDB MSG_TOUCHES_REDEFINIR_Quitter_Val
    FDB MSG_TOUCHES_REDEFINIR_Quitter

	FCB $45	; = TOUCHE_E = Arme précédente.
    FDB MSG_TOUCHES_REDEFINIR_ArmePrec_Val
    FDB MSG_TOUCHES_REDEFINIR_ArmePrec

	FCB $52	; = TOUCHE_R = Arme suivante.
    FDB MSG_TOUCHES_REDEFINIR_ArmeSuiv_Val
    FDB MSG_TOUCHES_REDEFINIR_ArmeSuiv

	FCB $44	; = TOUCHE_D = Sort précédent.
    FDB MSG_TOUCHES_REDEFINIR_SortPrec_Val
    FDB MSG_TOUCHES_REDEFINIR_SortPrec

	FCB $46	; = TOUCHE_F = Sort suivant.
    FDB MSG_TOUCHES_REDEFINIR_SortSuiv_Val
    FDB MSG_TOUCHES_REDEFINIR_SortSuiv

	FCB $31	; = TOUCHE_1 = Utilisation de l'objet 1.
    FDB MSG_TOUCHES_REDEFINIR_Obj1_Val
    FDB MSG_TOUCHES_REDEFINIR_Obj1

	FCB $32	; = TOUCHE_2 = Utilisation de l'objet 2.
    FDB MSG_TOUCHES_REDEFINIR_Obj2_Val
    FDB MSG_TOUCHES_REDEFINIR_Obj2

	FCB $33	; = TOUCHE_3 = Utilisation de l'objet 3.
    FDB MSG_TOUCHES_REDEFINIR_Obj3_Val
    FDB MSG_TOUCHES_REDEFINIR_Obj3

	FCB $34	; = TOUCHE_4 = Utilisation de l'objet 4.
    FDB MSG_TOUCHES_REDEFINIR_Obj4_Val
    FDB MSG_TOUCHES_REDEFINIR_Obj4

	FCB $35	; = TOUCHE_5 = Utilisation de l'objet 5.
    FDB MSG_TOUCHES_REDEFINIR_Obj5_Val
    FDB MSG_TOUCHES_REDEFINIR_Obj5
MSG_SAISIE_TOUCHES_FIN

	FCB $00 ; = TOUCHE_RES = touche réservée.


; Touches par défaut, à recopier en $1FC0 de la mémoire vidéo couleur.
TOUCHES
	FCB $0B	; = TOUCHE_HAUT = Avancer.
	FCB $0A	; = TOUCHE_BAS = Reculer.
	FCB $08	; = TOUCHE_GAUCHE = Tourner d'un quart de tour à gauche.
	FCB $09	; = TOUCHE_DROITE = Tourner d'un quart de tour à droite.
	FCB $20	; = TOUCHE_ESPACE = Action / Feu avec l'arme sélectionnée.
	FCB $42	; = TOUCHE_B = Lancer le sort sélectionné.
	FCB $43	; = TOUCHE_C = Pas à gauche.
	FCB $56	; = TOUCHE_V = Pas à droite.
	FCB $4D	; = TOUCHE_M = Affichage de la map.
	FCB $51	; = TOUCHE_Q = Quitter.
	FCB $45	; = TOUCHE_E = Arme précédente.
	FCB $52	; = TOUCHE_R = Arme suivante.
	FCB $44	; = TOUCHE_D = Sort précédent.
	FCB $46	; = TOUCHE_F = Sort suivant.
	FCB $31	; = TOUCHE_1 = Utilisation de l'objet 1.
	FCB $32	; = TOUCHE_2 = Utilisation de l'objet 2.
	FCB $33	; = TOUCHE_3 = Utilisation de l'objet 3.
	FCB $34	; = TOUCHE_4 = Utilisation de l'objet 4.
	FCB $35	; = TOUCHE_5 = Utilisation de l'objet 5.
	FCB $00 ; = TOUCHE_RES = touche réservée.



;********************************************************************************
; Images début
;********************************************************************************
IMG_DEBUT1_FORME
    INCLUDEBIN ../res/ed2debut1.forme.exo2
IMG_DEBUT1_FORME_FIN
IMG_DEBUT2_FORME
    INCLUDEBIN ../res/ed2debut2.forme.exo2
IMG_DEBUT2_FORME_FIN
IMG_MENU_FORME
    INCLUDEBIN ../res/ed2menu.forme.exo2
IMG_MENU_FORME_FIN



;********************************************************************************
; Image titre
;********************************************************************************
IMG_TITRE_FORME
    INCLUDEBIN ../res/ed2titre.forme.exo2
IMG_TITRE_FORME_FIN
IMG_TITRE_FOND
    INCLUDEBIN ../res/ed2titre.fond.exo2
IMG_TITRE_FOND_FIN



;********************************************************************************
; Image intro
;********************************************************************************
IMG_FORME
    INCLUDEBIN ../res/ed2intro.forme.exo2
IMG_FORME_FIN

IMG_FORMES
    FDB 40*113+18
    FDB IMG_FORME_1
    FDB 40*113+18
    FDB IMG_FORME_2
    FDB 40*114+18
    FDB IMG_FORME_3
    FDB 40*114+18
    FDB IMG_FORME_4
    FDB 40*114+18
    FDB IMG_FORME_3
    FDB 40*113+18
    FDB IMG_FORME_2
    FDB 40*113+18
    FDB IMG_FORME_1
    FDB 40*113+18
    FDB IMG_FORME_0
IMG_FORMES_FIN

IMG_FORME_0          ; 18,113
    FCB $93,$2f,$f6,$49
    FCB $d3,$21,$c6,$49
    FCB $d9,$21,$c6,$4b
    FCB $b9,$21,$c6,$4c
    FCB $8f,$31,$c6,$74
    FCB $8b,$b1,$c7,$e0
    FCB $2a,$f1,$cf,$00
    FCB $28,$7f,$f9,$28
    FCB $00,$59,$c9,$20
    FCB $10,$09,$c8,$00
    FCB $88,$01,$c0,$40
    FCB $40,$01,$c0,$01
    ;FCB $80,$01,$c0,$00

IMG_FORME_1          ; 18,113
    FCB $f3,$2f,$f6,$4f
    FCB $df,$21,$c6,$79
    FCB $d9,$e1,$c7,$cb
    FCB $b9,$31,$ce,$4c
    FCB $8f,$2f,$f6,$74
    FCB $8b,$a1,$c7,$e0
    FCB $2a,$f1,$cf,$00
    FCB $28,$7f,$f9,$28
    FCB $00,$59,$c9,$20
    FCB $10,$09,$c8,$00
    FCB $88,$01,$c0,$40
    FCB $40,$01,$c0,$01
    ;FCB $80,$01,$c0,$00

IMG_FORME_2          ; 18,113
    FCB $f3,$2f,$f6,$4f
    FCB $df,$21,$c6,$79
    FCB $d9,$e1,$c7,$cb
    FCB $b9,$f1,$cf,$4c
    FCB $8f,$7f,$fe,$74
    FCB $8b,$2f,$fa,$e0
    FCB $2a,$a1,$c3,$00
    FCB $28,$f1,$cf,$28
    FCB $00,$7f,$f9,$20
    FCB $10,$59,$c9,$00
    FCB $88,$09,$c8,$40
    FCB $40,$01,$c0,$01
    ;FCB $80,$01,$c0,$00

IMG_FORME_3          ; 18,113
    ;FCB $f3,$2f,$f6,$4f
    FCB $ff,$21,$c6,$7f
    FCB $df,$e1,$c7,$f9
    FCB $d9,$f1,$cf,$cb
    FCB $b9,$ff,$ff,$4c
    FCB $8f,$7f,$fe,$74
    FCB $8b,$2f,$fa,$e0
    FCB $2a,$a1,$c3,$00
    FCB $28,$f1,$cf,$28
    FCB $00,$7f,$f9,$20
    FCB $90,$59,$c9,$00
    FCB $48,$09,$c8,$41
    FCB $80,$01,$c0,$00

IMG_FORME_4          ; 18,113
    ;FCB $f3,$2f,$f6,$4f
    FCB $ff,$21,$c6,$7f
    FCB $ff,$e1,$c7,$ff
    FCB $df,$f1,$cf,$f9
    FCB $d9,$ff,$ff,$cb
    FCB $b9,$ff,$ff,$4c
    FCB $8f,$7f,$fe,$74
    FCB $8b,$2f,$fa,$e0
    FCB $2a,$a1,$c3,$00
    FCB $28,$f1,$cf,$28
    FCB $80,$7f,$f9,$20
    FCB $50,$59,$c9,$01
    FCB $88,$09,$c8,$40



;********************************************************************************
; Sample intro
; créé avec tools/snd6bit res/evil-snd.wav res/evil-snd.bin
;********************************************************************************
SAMPLE_PTR FDB $0000
SAMPLE
    INCLUDEBIN ../res/evil-snd.bin
SAMPLE_FIN

    END $2752


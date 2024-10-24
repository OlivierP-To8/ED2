; =============================================================================
; FIN D'EVIL DUNGEON 2
;
; Ce listing est destiné à créer le fichier INIT4 qui charge OUTRO.DAT
; pour la fin du jeu EVIL DUNGEON 2.
; =============================================================================
; par OlivierP-To8 en octobre 2024 (https://github.com/OlivierP-To8)
; =============================================================================

; Options pour lwasm (http://www.lwtools.ca/manual/x832.html)
    PRAGMA 6809,operandsizewarning
    OPT c

    ORG $2600

;********************************************************************************

STATUS  EQU $2019
PRC     EQU $A7C0
LGATOU  EQU $A7DD  ; b5 (MO uniquement) bit pour masquer la cartouche (0: visible, 1: masquée)
                   ; b4 (MO uniquement) bit du basic à sélectionner (0: BASIC1, 1: BASIC128)
MODELE  EQU $FFF0  ; Modèle de la gamme

; Contrôleur de disque
DKOPC   EQU $2048   ; Commande du controleur de disque
DKDRV   EQU $2049   ; Numero du disque (0 a 3)
DKTRK   EQU $204B   ; Numero de piste (0 a 39 ou 79)
DKSEC   EQU $204C   ; Numero de secteur (1 a 16)
DKSTA   EQU $204E   ; Etat du controleur de disquettes
DKBUF   EQU $204F   ; Pointeur de la zone tampon d'I/O disque (256 octets max)
DKCO    EQU $26     ; Contrôleur de disque


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

    BRA AFFICHE_BORD_FIN

AFFICHE_BORD_MO5
    ; bord sur MO5
    LDA PRC
    ANDA #$E1      ; border color b4321=0000
    STA PRC

AFFICHE_BORD_FIN


;********************************************************************************
;* Initialisations
;********************************************************************************

    ; désactivation buzzer
    LDA STATUS
    ORA #$08
    STA STATUS

    ; commutation du bit de couleur (C0 a 0)
    LDA PRC
    ANDA #$FE
    STA PRC

    ; Effacement de l'écran
    LDD #$0000
    LDY #$0000
EFF_RAM
    STD ,Y++
    CMPY #$1F40
    BLE EFF_RAM

    ; Initialisation son
    CLR $A7CF
    LDD #$3F04
    STA $A7CD
    STB $A7CF


;********************************************************************************
;* Chargement de l'outro
;********************************************************************************

    ldx #$2700
    ldy #OUTRO.DAT      ; infos piste / secteur début / secteur fin
    ldd ,y++            ; AB = piste/secteur à lire
    bra Outro_loop

Outro_bloc              ; se positionne sur le prochain bloc de 2K (piste/sect.deb./sect.fin.)
    leay 1,y            ; Y pointe sur la piste et le premier secteur
    cmpy #FIN_OUTRO.DAT
    bge Outro_end       ; si on arrive à FIN_OUTRO.DAT alors fin de chargement
    ldd ,y++            ; AB = piste/secteur à lire

Outro_loop
    pshs a,b
    sta DKTRK           ; track in A
    stb DKSEC           ; sector in B
    stx DKBUF           ; buffer address
    lda #$02            ; read sector command
    sta DKOPC
    swi                 ; call ROM
    fcb DKCO
    puls a,b

    leax 256,x          ; X = adresse où charger le secteur

    incb
    cmpb ,y             ; test du secteur avec le secteur de fin
    bgt Outro_bloc      ; si on a lu le dernier secteur alors on passe au bloc suivant
    bra Outro_loop

Outro_end
    ldx #$2852
    jsr ,x              ; lancement de l'outro


OUTRO.DAT      ; 8 blocs pour 59 secteurs de $2600 à $61FF qui chargera la fin du jeu
    FCB 16,10,16
    FCB 16,1,8
    FCB 15,9,16
    FCB 15,1,8
    FCB 14,9,16
    FCB 14,1,8
    FCB 13,9,16
    FCB 13,1,5
FIN_OUTRO.DAT


INIT4_FIN:
	BSZ $2700-INIT4_FIN	; Remplissage de zéros jusqu'à $26FF inclus.

    END $2600

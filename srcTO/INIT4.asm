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

    ORG $6600

;********************************************************************************

PRC     equ $E7C3
LGATOU  equ $E7DD
MODELE  equ $FFF0  ; Modèle de la gamme

BUZZ    equ $6073  ; Sémaphore d'extinction du buzzer.

; Contrôleur de disque
DKOPC   equ $6048   ; Commande du contrôleur de disque
DKDRV   equ $6049   ; Numéro du disque (0 à 3)
DKTRK   equ $604B   ; Numéro de piste (0 à 39 ou 79)
DKSEC   equ $604C   ; Numéro de secteur (1 à 16)
DKSTA   equ $604E   ; Etat du contrôleur de disquettes
DKBUF   equ $604F   ; Pointeur de la zone tampon d'I/O disque (256 octets max)
DKCO    equ $E82A   ; Contrôleur de disque


    PSHS A,B,X,Y

	ORCC #$50		; ne pas interrompre


;********************************************************************************
;* Bord
;********************************************************************************

AFFICHE_BORD
    ;    01 = TO7-70     => bord écran par PRC
    ;    02 = TO9        => bord écran par LGATOU avec saturation $08
    ;    03 = TO8,TO8D   => bord écran par LGATOU
    ;    06 = TO9+
    LDB MODELE
    CMPB #$03
    BLO AFFICHE_BORD_TO9

    ; bord noir sur TO8/TO8D/TO9+
    LDA #$00   ; XXXXPBVR (pastel bleu vert rouge)
    STA LGATOU ; registre uniquement en écriture

    BRA AFFICHE_BORD_FIN

AFFICHE_BORD_TO9
    CMPB #$02
    BLO AFFICHE_BORD_TO7

    ; bord noir sur TO9
    LDA #$08    ; XXXXSBVR (saturation bleu vert rouge)
    STA LGATOU  ; registre uniquement en écriture

    BRA AFFICHE_BORD_FIN

AFFICHE_BORD_TO7
    ; bord noir sur TO7 et TO7-70
    LDA PRC
    ANDA #$8f   ; border color b654=000
    STA PRC

    ; désactivation buzzer
    LDA #1      ; 0=ON 1=OFF
    STA BUZZ

AFFICHE_BORD_FIN


;********************************************************************************
;* Initialisations
;********************************************************************************

    ; commutation du bit de couleur (C0 a 0)
    LDA PRC
    ANDA #$FE
    STA PRC

    ; Effacement de l'écran
    LDD #$C0C0
    LDY #$4000
EFF_RAM
    STD ,Y++
    CMPY #$5F40
    BLE EFF_RAM

    ; Initialisation son
    CLR $E7CF
    LDD #$3F04
    STA $E7CD
    STB $E7CF


;********************************************************************************
;* Chargement de l'outro
;********************************************************************************

    ldx #$6700
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
    jsr DKCO            ; call ROM
    puls a,b

    leax 256,x          ; X = adresse où charger le secteur

    incb
    cmpb ,y             ; test du secteur avec le secteur de fin
    bgt Outro_bloc      ; si on a lu le dernier secteur alors on passe au bloc suivant
    bra Outro_loop

Outro_end
    ldx #$6852
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
	BSZ $6700-INIT4_FIN	; Remplissage de zéros jusqu'à $66FF inclus.

    END $6600

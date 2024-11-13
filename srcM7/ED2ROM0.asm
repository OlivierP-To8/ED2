; =============================================================================
; MEMO7 ED2
; =============================================================================
; par OlivierP-To8 en octobre 2024 (https://github.com/OlivierP-To8)
; =============================================================================

    ORG $0000

    FCC " Evil Dungeons II"
    FCB $04             ; fin du nom
    FCB $00,$00,$00,$00,$00,$00,$00,$00
    FCB $1E             ; checksum
    FCB $00
    FDB ED2MemoStart    ; démarrage à chaud
    FDB ED2MemoStart    ; démarrage à froid
    ;FDB $A55A          ; pas compatible .CHG (commutation de page)

HEADER_END
    BSZ $0022-HEADER_END

    FDB PatientezSVP
    FDB ED2Install
    FDB INTRO_END-1


INIT
    BSZ $0030-INIT

    INCLUDE INIT.asm
INIT_END


PatientezSVP
	LDA	$E7C3
	ANDA #%11111110
	STA	$E7C3		; Sélection video couleur
	LDA #$C0		; Encre noire sur fond noir
	LDB #200		; 200 lignes à initialiser
	LDX #$4000		; X pointe le début de la mémoire vidéo couleur
	LBSR AFFICHE_R1	; Ecran noir
	LDY #MESSAGE_C
	LBSR AFFICHE_R3 ; Affichage du texte d'intro + sélection vidéo forme.
    RTS


ED2MemoStart        ; Démarrage de la ROM (point d'entrée en $EFFE)
    bsr PatientezSVP


ED2Boot equ $6500

ED2Install          ; Copie de ED2Exec en RAM pour accéder aux 4 banques mémoire
    pshs u
    ldu #ED2Boot+ED2Exec_END-ED2Exec
    ldx #ED2Exec_END
CopyED2Exec
    leax -2,x
    ldd ,x
    pshu d
    cmpu #ED2Boot
    bhi CopyED2Exec
    puls u

    jsr Init        ; Initialisation Bord écran et Mégarom T.2

    jmp ED2Boot     ; Execution de ED2Exec depuis la RAM


ED2Exec
    SETDP $60

    ; set S (system stack)
    lds #$60CC

    ; set DP (direct page) register
    lda #$60
    tfr a,dp

    ; Copie de EXO2 en [$6300-$6452]
    ldu #EXO2+$152
    ldx #EXO2_END
CopyEXO2
    leax -2,x
    ldd ,x
    pshu d
    cmpu #EXO2
    bne CopyEXO2

    ; Décompression de l'intro en $6600
    ldu $0026       ; dernier octet de INTRO.BIN.exo2
    ldy #$8400      ; dernier octet de la destination
    jsr EXO2        ; décompression

    ; Page rom 2 avec le sample de l'intro
    ldb #$2
    bsr SetRomPage

    ; Décompression du sample
    ldu $0022       ; dernier octet de evil-snd.bin.exo2
    ldy #$A000      ; dernier octet de la destination
    jsr EXO2        ; décompression

    ; Page rom 1 avec les graphismes de l'intro
    ldb #$1
    bsr SetRomPage

    ; Exécution de l'intro
    jsr $6600

    ; Page rom 0 avec INIT.BIN
    ldb #$0
    bsr SetRomPage

    ; Exécution de l'init
    jsr INIT1

    ; Page rom 3 avec ED2Part.DAT.exo2
    ldb #$3
    bsr SetRomPage

    ; Décompression de ED2Part.DAT.exo2
    ldu $0022       ; dernier octet de ED2Part.DAT.exo2
    ldy #$C700      ; dernier octet de la destination
    jsr EXO2        ; décompression

    ; Retour à la page rom 0
    ldb #$0
    bsr SetRomPage

    ; Exécution de ED2Restart qui charge l'INIT et le PACK
    jmp $C6E5

SetRomPage
    ldx #$0000
    abx
    stb ,x
    rts

ED2Exec_END

EXO2_START
    BSZ $1D00-EXO2_START
    INCLUDE ../res/exo2_final.asm
EXO2_END

INTRO
    INCLUDEBIN INTRO.BIN.exo2
INTRO_END


PRC     equ $E7C3
LGATOU  equ $E7DD
MODELE  equ $FFF0  ; Modèle de la gamme

Init
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
    ANDA #$8B   ; border color b654=000
    ORA #$04    ; saturée color b2=1
    STA PRC

AFFICHE_BORD_FIN

    IFEQ MEGAROM-1
        ; Configuration des 4 pages de 16K
        ldd #$0000
        bsr SETCM7
        ldd #$0101
        bsr SETCM7
        ldd #$0202
        bsr SETCM7
        ldd #$0303
        bsr SETCM7

        ; Emulation de la commutation de page MEMO7
        lda #$01
        bsr SETMOD

        bra Init_END

SETCM7
        PSHS D
        LDD #$AA55
        STA $0555
        STB $02AA
        LDA #$C1		    ; Commande de configuration
        STA $0555
        PULS D
        LDX #$0000
        STB A,X			    ; B est stocké en $0000+A
        RTS

SETMOD
        PSHS A
        LDD #$AA55
        STA $0555
        STB $02AA
        LDA #$B0
        STA $0555
        PULS A
        STA $0556
        RTS
    ENDC

Init_END
    RTS

PACK_START
    BSZ $2D57-PACK_START

    INCLUDEBIN PACK1.DAT.exo2

INIT_START
    BSZ $3F00-INIT_START

    INCLUDEBIN INIT1.DAT

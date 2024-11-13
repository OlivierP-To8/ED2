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
    FDB $C6E5           ; démarrage à chaud
    FDB $C6E5           ; démarrage à froid
    FDB $A55A           ; compatible .CHG

HEADER_END
    BSZ $0022-HEADER_END

    FDB SAMPLE_EXO2_FIN-1

OUTRO_START
    BSZ $0030-OUTRO_START

    INCLUDE OUTRO.asm

EXO2_START
    BSZ $2E00-EXO2_START

    INCLUDE ../res/exo2_final.asm


;********************************************************************************
; Rechargement du jeu
;********************************************************************************
RestartED2
    ldu #$6600+ReinstallED2_END-ReinstallED2
    ldx #ReinstallED2_END
ReinstallED2Loop
    leax -2,x
    ldd ,x
    pshu d
    cmpu #$6600
    bhi ReinstallED2Loop
    jmp $6600

ReinstallED2
    ; Retour à la page rom 0
    ldb #$0
    bsr SetRomPage

    jsr [$0022]     ; PatientezSVP
    jmp [$0024]     ; ED2Install

SetRomPage
    ldx #$0000
    abx
    stb ,x
    rts

ReinstallED2_END


PACK_START
    BSZ $2FD0-PACK_START

    INCLUDEBIN PACK3.DAT.exo2

INIT_START
    BSZ $3F00-INIT_START

    INCLUDEBIN INIT3.DAT

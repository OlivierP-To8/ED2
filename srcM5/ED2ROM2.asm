; =============================================================================
; MEMO5 ED2
; =============================================================================
; par OlivierP-To8 en octobre 2024 (https://github.com/OlivierP-To8)
; =============================================================================

    ORG $B000

    INCLUDE ../res/exo2_final.asm

    INCLUDE OUTRO.asm


PACK_START
    BSZ $DFC4-PACK_START

    INCLUDEBIN PACK3.DAT.exo2

INIT_START
    BSZ $EEE0-INIT_START

    INCLUDEBIN INIT3.DAT

HEADER_START
    BSZ $EFE0-HEADER_START

    FCC "Evil Dungeons II"
    FCB $04
    FCC "JJ/MM/AAAA"
    FCB $00,$00,$00
    FDB $86E5

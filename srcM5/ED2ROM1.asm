; =============================================================================
; MEMO5 ED2
; =============================================================================
; par OlivierP-To8 en octobre 2024 (https://github.com/OlivierP-To8)
; =============================================================================

    ORG $B000

IMG_TITRE_FORME
    INCLUDEBIN ../res/ed2titre.forme.exo2
IMG_TITRE_FORME_FIN

IMG_TITRE_FOND
    INCLUDEBIN ../res/ed2titre.fond.exo2
IMG_TITRE_FOND_FIN

IMG_FORME
    INCLUDEBIN ../res/ed2intro.forme.exo2
IMG_FORME_FIN


BANK_SWITCH
	BSZ $BFEE-BANK_SWITCH
    FDB IMG_DEBUT1_FORME_FIN-1
    FDB IMG_DEBUT2_FORME_FIN-1
    FDB IMG_MENU_FORME_FIN-1
    FDB IMG_TITRE_FORME_FIN-1
    FDB IMG_TITRE_FOND_FIN-1
    FDB IMG_FORME_FIN-1
    FDB ED2Part3_END-1
    FDB $0000
    FDB $0000


IMG_DEBUT1_FORME
    INCLUDEBIN ../res/ed2debut1.forme.exo2
IMG_DEBUT1_FORME_FIN

IMG_DEBUT2_FORME
    INCLUDEBIN ../res/ed2debut2.forme.exo2
IMG_DEBUT2_FORME_FIN

IMG_MENU_FORME
    INCLUDEBIN ../res/ed2menu.forme.exo2
IMG_MENU_FORME_FIN

ED2Part3    ; [$8500-$86FF]
    INCLUDEBIN ED2Part3.DAT.exo2
ED2Part3_END


PACK_START
    BSZ $DBAC-PACK_START

    INCLUDEBIN PACK2.DAT.exo2

INIT_START
    BSZ $EEE0-INIT_START

    INCLUDEBIN INIT2.DAT

HEADER_START
    BSZ $EFE0-HEADER_START

    FCC "Evil Dungeons II"
    FCB $04
    FCC "JJ/MM/AAAA"
    FCB $00,$00,$00
    FDB $86E5


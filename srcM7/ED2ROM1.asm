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

    FDB IMG_DEBUT1_FORME_FIN-1
    FDB IMG_DEBUT2_FORME_FIN-1
    FDB IMG_MENU_FORME_FIN-1
    FDB IMG_TITRE_FORME_FIN-1
    FDB IMG_TITRE_FOND_FIN-1
    FDB IMG_FORME_FIN-1


IMG_DEBUT1_FORME
    INCLUDEBIN ../res/ed2debut1.forme.exo2
IMG_DEBUT1_FORME_FIN

IMG_DEBUT2_FORME
    INCLUDEBIN ../res/ed2debut2.forme.exo2
IMG_DEBUT2_FORME_FIN

IMG_MENU_FORME
    INCLUDEBIN ../res/ed2menu.forme.exo2
IMG_MENU_FORME_FIN

IMG_TITRE_FORME
    INCLUDEBIN ../res/ed2titre.forme.exo2
IMG_TITRE_FORME_FIN

IMG_TITRE_FOND
    INCLUDEBIN ../res/ed2titre.fondTO.exo2
IMG_TITRE_FOND_FIN

IMG_FORME
    INCLUDEBIN ../res/ed2intro.forme.exo2
IMG_FORME_FIN


PACK_START
    BSZ $2BB1-PACK_START

    INCLUDEBIN PACK2.DAT.exo2

INIT_START
    BSZ $3F00-INIT_START

    INCLUDEBIN INIT2.DAT

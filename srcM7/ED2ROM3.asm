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
    FDB ED2Part_END-1

ED2Part    ; [$6700-$C6FF]
    INCLUDEBIN ED2Part.DAT.exo2
ED2Part_END

MEMO_END
    BSZ $4000-MEMO_END

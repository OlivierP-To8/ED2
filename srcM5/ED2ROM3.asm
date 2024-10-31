; =============================================================================
; MEMO5 ED2
; =============================================================================
; par OlivierP-To8 en octobre 2024 (https://github.com/OlivierP-To8)
; =============================================================================

    ORG $B000

ED2Part1    ; [$2700-$3EFF]
    INCLUDEBIN ED2Part1.DAT.exo2
ED2Part1_END


BANK_SWITCH
	BSZ $BFF8-BANK_SWITCH
    FDB ED2Part1_END-1
    FDB ED2Part2_END-1
    FDB $0000
    FDB $0000


ED2Part2    ; [$3F00-$84FF]
    INCLUDEBIN ED2Part2.DAT.exo2
ED2Part2_END

HEADER_START
    BSZ $EFE0-HEADER_START

    FCC "Evil Dungeons II"
    FCB $04
    FCC "JJ/MM/AAAA"
    FCB $00,$00,$00
    FDB $86E5


; =============================================================================
; MEMO5 ED2
; =============================================================================
; par OlivierP-To8 en octobre 2024 (https://github.com/OlivierP-To8)
; =============================================================================

    ORG $B000

    INCLUDE ../res/exo2_final.asm

INTRO
    INCLUDEBIN INTRO.BIN.exo2
INTRO_END


BANK_SWITCH
	BSZ $BFF4-BANK_SWITCH
    FDB INTRO_END-1
    FDB PatientezSVP
    FDB ED2Install
    FDB ED2Exec_END-SetRomPage
    FDB $0000
    FDB $0000


    INCLUDE INIT.asm


PatientezSVP
	LDA	$A7C0
	ANDA #%11100000
	STA	$A7C0		; Bordure noire + sélection video couleur
	CLRA			; Encre noire sur fond noir
	LDB #200		; 200 lignes à initialiser
	LDX #$0000		; X pointe le début de la mémoire vidéo couleur
	LBSR AFFICHE_R1	; Ecran noir
	LDY #MESSAGE_C
	LBSR AFFICHE_R3 ; Affichage du texte d'intro + sélection vidéo forme.
    RTS


ED2MemoStart        ; Démarrage de la ROM (point d'entrée en $EFFE)
    bsr PatientezSVP


ED2Boot equ $2500

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

    jmp ED2Boot     ; Execution de ED2Exec depuis la RAM


ED2Exec
    SETDP $20

    ; set S (system stack)
    lds #$20CC

    ; set DP (direct page) register
    lda #$20
    tfr a,dp

    ; Copie de EXO2 en [$2300-$2452]
    ldu #EXO2+$152
    ldx #$B152      ; [$2300-$2452] est stocké en [$B000-$B152]
CopyEXO2
    leax -2,x
    ldd ,x
    pshu d
    cmpu #EXO2
    bne CopyEXO2

    ; Décompression de l'intro en $2600
    ldu $BFF4       ; dernier octet de INTRO.BIN.exo2
    ldy #$4400      ; dernier octet de la destination
    jsr EXO2        ; décompression

    ; Page rom 2 avec le sample de l'intro
    ldb #$2
    bsr SetRomPage

    ; Décompression du sample
    ldu $BFFA       ; dernier octet de evil-snd.bin.exo2
    ldy #$6000      ; dernier octet de la destination
    jsr EXO2        ; décompression

    ; Page rom 1 avec les graphismes de l'intro
    ldb #$1
    bsr SetRomPage

    ; Exécution de l'intro
    jsr $2600

    ; Page rom 0 avec INIT.BIN
    ldb #$0
    bsr SetRomPage

    ; Exécution de l'init
    jsr $C000

    ; Page rom 1 avec ED2Part3.DAT.exo2
    ldb #$1
    bsr SetRomPage

    ; Décompression de ED2Part3.DAT.exo2
    ldu $BFFA       ; dernier octet de ED2Part3.DAT.exo2
    ldy #$8700      ; dernier octet de la destination
    jsr EXO2        ; décompression

    ; Page rom 3 avec ED2Part2.DAT.exo2 et ED2Part1.DAT.exo2
    ldb #$3
    bsr SetRomPage

    ; Décompression de ED2Part2.DAT.exo2
    ldu $BFFA       ; dernier octet de ED2Part2.DAT.exo2
    ldy #$8500      ; dernier octet de la destination
    jsr EXO2        ; décompression

    ; Décompression de ED2Part1.DAT.exo2
    ldu $BFF8       ; dernier octet de ED2Part1.DAT.exo2
    ldy #$3F00      ; dernier octet de la destination
    jsr EXO2        ; décompression

    ; Retour à la page rom 0
    ldb #$0
    bsr SetRomPage

    ; Exécution de ED2Restart qui charge l'INIT et le PACK
    jmp $86E5

SetRomPage
    ; test si l'espace cartouche est une page de RAM (MO6) ou l'extension mémoire 64K (MO5)
    ldx #$EFFB
    lda ,x
    com ,x
    cmpa ,x
    beq SetRomPageROM
    lda $FFF0       ; 0=MO5, 1=MO6
    beq SetRomPageMO5
SetRomPageMO6
    orb #%01100000  ; set ram page in A writable in ROM area [$B000-$EFFF]
    addb #3         ; first available page is 3 on MO6
    stb $A7E6
    bra SetRomPageEnd
SetRomPageMO5
    orb #%00001100  ; set ram page in A writable in ROM area [$B000-$EFFF]
    stb $A7CB
    bra SetRomPageEnd
SetRomPageROM
    ldx #$BFFC
    abx
    ldb ,x
SetRomPageEnd
    rts

ED2Exec_END


PACK_START
    BSZ $DD41-PACK_START

    INCLUDEBIN PACK1.DAT.exo2

INIT_START
    BSZ $EEE0-INIT_START

    INCLUDEBIN INIT1.DAT

HEADER_START
    BSZ $EFE0-HEADER_START

    FCC "Evil Dungeons II"
    FCB $04
    FCC "JJ/MM/AAAA"
    FCB $00,$00,$00
    FDB ED2MemoStart


; =============================================================================
; FIN D'EVIL DUNGEON 2
;
; Ce listing est destiné à créer le fichier OUTRO.DAT
; pour la fin du jeu EVIL DUNGEON 2.
; =============================================================================
; par OlivierP-To8 en octobre 2024 (https://github.com/OlivierP-To8)
; =============================================================================

; Options pour lwasm (http://www.lwtools.ca/manual/x832.html)
    PRAGMA 6809,operandsizewarning
    OPT c

    ORG $B152


;********************************************************************************

PUTC    equ $02    ; Affichage d'un caractère
GETC    equ $0A    ; Lecture du clavier
PRC     equ $A7C0

    PSHS A,B,X,Y

	ORCC #$50		; ne pas interrompre

EXO2        EQU $2300
SAMPLE      EQU $A000-7003
SAMPLE_FIN  EQU $A000

OUTRO_DEBUT
;********************************************************************************
;* Affichage du texte de fin
;********************************************************************************

    ; décompression du sample
    ldu #SAMPLE_EXO2_FIN-1  ; dernier octet de evil-snd.bin.exo2
    ldy #SAMPLE_FIN         ; dernier octet du sample
    jsr EXO2                ; décompression

    ; Initialisation son
    CLR $A7CF
    LDD #$3F04
    STA $A7CD
    STB $A7CF

    LBSR LECTURE_SAMPLE

    ; Affichage du texte
    LDU #IMG_MSG1_FIN-1        ; U pointe le dernier octet de l'image de forme compressée
    BSR AFF_IMAGE

    BSR SAISIE_TOUCHE

    ; Affichage du texte
    LDU #IMG_MSG2_FIN-1        ; U pointe le dernier octet de l'image de forme compressée
    BSR AFF_IMAGE

    BSR SAISIE_TOUCHE

    ; Affichage du texte
    LDU #IMG_MSG3_FIN-1        ; U pointe le dernier octet de l'image de forme compressée
    BSR AFF_IMAGE

    BSR SAISIE_TOUCHE


;********************************************************************************
;* Affichage de l'image de fin
;********************************************************************************

    LDU #IMG_FORME_FIN-1        ; U pointe le dernier octet de l'image de forme compressée
    BSR AFF_IMAGE

    LDU #IMG_COULEURS1
AFF_IMG_COULEUR1
    LDX ,U++                    ; prend l'adresse
    LDA ,U+                     ; prend la couleur
    STA ,X
    CMPU #IMG_COULEURS1_FIN-1
    BLS AFF_IMG_COULEUR1

    LDU #IMG_COULEURS6
AFF_IMG_COULEUR6
    LDX ,U++                    ; prend l'adresse
    LDD ,U++                    ; prend les couleurs
    STD ,X++
    LDD ,U++                    ; prend les couleurs
    STD ,X++
    LDD ,U++                    ; prend les couleurs
    STD ,X
    CMPU #IMG_COULEURS6_FIN-1
    BLS AFF_IMG_COULEUR6

    LBSR LECTURE_SAMPLE

    BSR SAISIE_TOUCHE

    lbsr RestartED2


;********************************************************************************
;* Affichage d'une image
;********************************************************************************
AFF_IMAGE
    ; commutation du bit de couleur (C0 a 0)
    LDA PRC
    ANDA #$FE
    STA PRC

    LDD #$0000		            ; noir sur fond noir pour décompression invisible de la forme
    BSR EFF			            ; Effacement de l'écran

    ; commutation du bit de forme (C0 a 1)
    LDA PRC
    ORA #$01
    STA PRC

    LDY #$1F40                  ; Y pointe la fin du buffer
    JSR EXO2                    ; Décompression de l'image de forme

    ; commutation du bit de couleur (C0 a 0)
    LDA PRC
    ANDA #$FE
    STA PRC

    LDD #$1010                  ; rouge sur fond noir
    BSR EFF			            ; Effacement de l'écran

    RTS


;********************************************************************************
; Routine de saisie d'une touche
;********************************************************************************
SAISIE_TOUCHE
    SWI
    FCB GETC
    TSTB
    BEQ SAISIE_TOUCHE
    RTS


;********************************************************************************
; Routine d'effacement de l'écran
;********************************************************************************
EFF
    LDY #$0000
EFF_RAM
    STD ,Y++
    CMPY #$1F40
    BLE EFF_RAM
    RTS


;********************************************************************************
; Image outro
;********************************************************************************
IMG_FORME
    INCLUDEBIN ../res/ed2outro.forme.exo2
IMG_FORME_FIN

IMG_COULEURS1
    FDB 40*101+21
    FCB $71         ; blanc sur fond rouge
    FDB 40*102+19
    FCB $71         ; blanc sur fond rouge
    FDB 40*102+21
    FCB $71         ; blanc sur fond rouge
    FDB 40*103+19
    FCB $71         ; blanc sur fond rouge
    FDB 40*103+21
    FCB $71         ; blanc sur fond rouge
    FDB 40*104+19
    FCB $71         ; blanc sur fond rouge
    FDB 40*115+19
    FCB $70         ; blanc sur fond noir
    FDB 40*116+19
    FCB $70         ; blanc sur fond noir
    FDB 40*116+20
    FCB $70         ; blanc sur fond noir
    FDB 40*116+21
    FCB $71         ; blanc sur fond rouge
    FDB 40*117+19
    FCB $70         ; blanc sur fond noir
    FDB 40*117+20
    FCB $70         ; blanc sur fond noir
    FDB 40*117+21
    FCB $71         ; blanc sur fond rouge
    FDB 40*118+19
    FCB $71         ; blanc sur fond rouge
    FDB 40*118+20
    FCB $70         ; blanc sur fond noir
    FDB 40*118+21
    FCB $71         ; blanc sur fond rouge
    FDB 40*119+19
    FCB $71         ; blanc sur fond rouge
    FDB 40*119+20
    FCB $70         ; blanc sur fond noir
    FDB 40*119+21
    FCB $71         ; blanc sur fond rouge
    FDB 40*120+19
    FCB $71         ; blanc sur fond rouge
    FDB 40*120+20
    FCB $71         ; blanc sur fond rouge
    FDB 40*120+21
    FCB $71         ; blanc sur fond rouge
    FDB 40*121+19
    FCB $71         ; blanc sur fond rouge
    FDB 40*121+20
    FCB $71         ; blanc sur fond rouge
    FDB 40*121+21
    FCB $71         ; blanc sur fond rouge
    FDB 40*160+16
    FCB $91         ; rouge clair sur fond rouge
    FDB 40*160+23
    FCB $91         ; rouge clair sur fond rouge
    FDB 40*161+23
    FCB $91         ; rouge clair sur fond rouge
IMG_COULEURS1_FIN

IMG_COULEURS6
    FDB 40*158+17
    FCB $91,$91,$10,$10,$91,$11
    FDB 40*159+17
    FCB $91,$91,$10,$10,$91,$91
    FDB 40*160+17
    FCB $91,$91,$10,$10,$91,$91
    FDB 40*161+17
    FCB $F1,$91,$90,$90,$97,$73
    FDB 40*162+17
    FCB $97,$F7,$90,$90,$F7,$F7
    FDB 40*163+17
    FCB $73,$73,$37,$30,$73,$97
    FDB 40*164+17
    FCB $F7,$73,$F7,$73,$F7,$73
    FDB 40*165+17
    FCB $D7,$F7,$D7,$F7,$D7,$F7
    FDB 40*166+17
    FCB $F0,$FD,$F0,$FD,$F0,$F0
IMG_COULEURS6_FIN


;********************************************************************************
; Images
;********************************************************************************
IMG_MSG1
    INCLUDEBIN ../res/ed2outromsg1.forme.exo2
IMG_MSG1_FIN

BANK_SWITCH:
	BSZ $BFFA-BANK_SWITCH
    FDB SAMPLE_EXO2_FIN-1
    FDB $0000
    FDB $0000

IMG_MSG2
    INCLUDEBIN ../res/ed2outromsg2.forme.exo2
IMG_MSG2_FIN

IMG_MSG3
    INCLUDEBIN ../res/ed2outromsg3.forme.exo2
IMG_MSG3_FIN


;********************************************************************************
; Routine de lecture du sample
;********************************************************************************
LECTURE_SAMPLE
    LDU #SAMPLE
LECTURE_TEMPO
    ; il y a environ 7000 octets de son à 4000 Hz (4000 envois par sec pendant 1.75 sec)
    LDA #$2D                ; 246 cycles = 4065 Hz
LECTURE_WAIT
    DECA
    BNE LECTURE_WAIT
    LDA ,U+                 ; prend un octet de sample
    STA $A7CD			    ; envoi de l'octet vers la sortie son
    CMPU #SAMPLE_FIN-1
    BLS LECTURE_TEMPO
    RTS


;********************************************************************************
; Sample intro
; créé avec tools/snd6bit res/evil-snd.wav res/evil-snd.bin
;********************************************************************************
SAMPLE_EXO2
    INCLUDEBIN ../res/evil-snd.bin.exo2
SAMPLE_EXO2_FIN


;********************************************************************************
; Rechargement du jeu
;********************************************************************************
RestartED2
    ldu #$2600+ReinstallED2_END-ReinstallED2
    ldx #ReinstallED2_END
ReinstallED2Loop
    leax -2,x
    ldd ,x
    pshu d
    cmpu #$2600
    bhi ReinstallED2Loop
    jmp $2600

ReinstallED2
    ; Retour à la page rom 0
    ldb #$0
    bsr SetRomPage

    jsr [$BFF6]     ; PatientezSVP
    jmp [$BFF8]     ; ED2Install

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

ReinstallED2_END

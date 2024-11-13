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

    ORG $0030


;********************************************************************************

PUTC    equ $E803  ; Affichage d'un caractère
GETC    equ $E806  ; Lecture du clavier
PRC     equ $E7C3

    PSHS A,B,X,Y

	ORCC #$50		; ne pas interrompre

EXO2        EQU $6300
SAMPLE      EQU $E000-7003
SAMPLE_FIN  EQU $E000

OUTRO_DEBUT
;********************************************************************************
;* Affichage du texte de fin
;********************************************************************************

    ; décompression du sample
    ldu #SAMPLE_EXO2_FIN-1  ; dernier octet de evil-snd.bin.exo2
    ldy #SAMPLE_FIN         ; dernier octet du sample
    jsr EXO2                ; décompression

    ; Initialisation son
    CLR $E7CF
    LDD #$3F04
    STA $E7CD
    STB $E7CF

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

    BSR LECTURE_SAMPLE

    BSR SAISIE_TOUCHE

    ;BRA OUTRO_DEBUT
    lbsr RestartED2

    PULS A,B,X,Y
    RTS


;********************************************************************************
;* Affichage d'une image
;********************************************************************************
AFF_IMAGE
    ; commutation du bit de couleur (C0 a 0)
    LDA PRC
    ANDA #$FE
    STA PRC

    LDD #$C0C0		            ; noir sur fond noir pour décompression invisible de la forme
    BSR EFF			            ; Effacement de l'écran

    ; commutation du bit de forme (C0 a 1)
    LDA PRC
    ORA #$01
    STA PRC

    LDY #$5F40                  ; Y pointe la fin du buffer
    LBSR EXO2                   ; Décompression de l'image de forme

    ; commutation du bit de couleur (C0 a 0)
    LDA PRC
    ANDA #$FE
    STA PRC

    LDD #$C8C8                  ; rouge sur fond noir
    BSR EFF			            ; Effacement de l'écran

    RTS


;********************************************************************************
; Routine de saisie d'une touche
;********************************************************************************
SAISIE_TOUCHE
    JSR GETC
    TSTB
    BEQ SAISIE_TOUCHE
    RTS


;********************************************************************************
; Routine d'effacement de l'écran
;********************************************************************************
EFF
    LDY #$4000
EFF_RAM
    STD ,Y++
    CMPY #$5F40
    BLE EFF_RAM
    RTS


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
    STA $E7CD			    ; envoi de l'octet vers la sortie son
    CMPU #SAMPLE_FIN-1
    BLS LECTURE_TEMPO
    RTS


;********************************************************************************
; Images
;********************************************************************************
IMG_MSG1
    INCLUDEBIN ../res/ed2outromsg1.forme.exo2
IMG_MSG1_FIN

IMG_MSG2
    INCLUDEBIN ../res/ed2outromsg2.forme.exo2
IMG_MSG2_FIN

IMG_MSG3
    INCLUDEBIN ../res/ed2outromsg3.forme.exo2
IMG_MSG3_FIN


;********************************************************************************
; Image outro
;********************************************************************************
IMG_FORME
    INCLUDEBIN ../res/ed2outro.forme.exo2
IMG_FORME_FIN

IMG_COULEURS1
    FDB $4000+40*101+21
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*102+19
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*102+21
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*103+19
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*103+21
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*104+19
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*115+19
    FCB $F8         ; blanc sur fond noir
    FDB $4000+40*116+19
    FCB $F8         ; blanc sur fond noir
    FDB $4000+40*116+20
    FCB $F8         ; blanc sur fond noir
    FDB $4000+40*116+21
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*117+19
    FCB $F8         ; blanc sur fond noir
    FDB $4000+40*117+20
    FCB $F8         ; blanc sur fond noir
    FDB $4000+40*117+21
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*118+19
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*118+20
    FCB $F8         ; blanc sur fond noir
    FDB $4000+40*118+21
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*119+19
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*119+20
    FCB $F8         ; blanc sur fond noir
    FDB $4000+40*119+21
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*120+19
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*120+20
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*120+21
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*121+19
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*121+20
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*121+21
    FCB $F9         ; blanc sur fond rouge
    FDB $4000+40*160+16
    FCB $89         ; rouge clair sur fond rouge
    FDB $4000+40*160+23
    FCB $89         ; rouge clair sur fond rouge
    FDB $4000+40*161+23
    FCB $89         ; rouge clair sur fond rouge
IMG_COULEURS1_FIN

IMG_COULEURS6
    FDB $4000+40*158+17
    FCB $89,$89,$C8,$C8,$89,$C9
    FDB $4000+40*159+17
    FCB $89,$89,$C8,$C8,$89,$89
    FDB $4000+40*160+17
    FCB $89,$89,$C8,$C8,$89,$89
    FDB $4000+40*161+17
    FCB $B9,$89,$88,$88,$8F,$FB
    FDB $4000+40*162+17
    FCB $8F,$BF,$88,$88,$BF,$BF
    FDB $4000+40*163+17
    FCB $FB,$FB,$DF,$D8,$FB,$8F
    FDB $4000+40*164+17
    FCB $BF,$FB,$BF,$FB,$BF,$FB
    FDB $4000+40*165+17
    FCB $AF,$BF,$AF,$BF,$AF,$BF
    FDB $4000+40*166+17
    FCB $B8,$3D,$B8,$3D,$B8,$B8
IMG_COULEURS6_FIN


;********************************************************************************
; Sample intro
; créé avec tools/snd6bit res/evil-snd.wav res/evil-snd.bin
;********************************************************************************
SAMPLE_EXO2
    INCLUDEBIN ../res/evil-snd.bin.exo2
SAMPLE_EXO2_FIN

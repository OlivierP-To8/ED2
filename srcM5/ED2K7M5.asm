; =============================================================================
; Chargeur ED2 K7 pour MO
; =============================================================================
; par OlivierP-To8 en octobre 2024 (https://github.com/OlivierP-To8)
; =============================================================================
; Basé sur https://github.com/OlivierP-To8/BootK7/blob/main/BootK7MO.asm

; Une extension mémoire de 64K est nécessaire sur MO5.

; Le principe est de tout charger en mémoire, en cas
; d'utilisation directe d'une prise jack branchée
; sur le lecteur K7, puis d'exécuter les programmes.


; lwasm settings (http://www.lwtools.ca/manual/x832.html)
    PRAGMA 6809,operandsizewarning
    OPT c

    org $3100

; Page 0 moniteur [$2000-$20FF] (Stack [$2087-$20CC])
; Page 0 extra-moniteur [$2100-$22FF]
; Free : [$2300-$9FFF]

Buffer_ equ $3000
EXO2    equ $2300
ED2Boot equ $2500

K7CO    equ $20     ; Lecture/écriture sur la cassette
K7MO    equ $22     ; Mise en route/arrêt du moteur
DKBOOT  equ $28     ; Lancement du boot

    SETDP $20

    ; set S (system stack)
    lds #$20CC

    ; set DP (direct page) register
    lda #$20
    tfr a,dp

    lda $FFF0       ; 0=MO5, 1=MO6
    beq MO5ext64k

    ldx $DBB5
    lda $DBB7
    cmpx #$3132
    beq ErreurBasic128
    cmpb #$38
    beq ErreurBasic128

    ; MO6 (128K), autorise le changement de page RAM [$6000-9FFF]
    lda $2081
    ora #$50
    sta $2081
    sta $A7E7

    ldx #MO6SetPageInROM
    stx SetPageInROM

    ; Page 2 en [$6000-9FFF] par défaut
    lda #$02
    sta $A7E5

    bra Boot_start

ErreurBasic128
    ldx #MSGBASIC128
    jsr ShowMsg
    jmp Exit

MO5ext64k
    ; test de la présence de l'extension
    ; en écrivant dans l'espace cartouche
    ldb #$0
    jsr MO5SetPageInROM
    ldx #$EFE0
    lda ,x
    com ,x
    cmpa ,x
    bne Boot_start
    ldx #MSGEXT64K
    jsr ShowMsg
    jmp Exit


Boot_start
    ; Initialisation de la barre de progression
    ldx #MSGINIT
    jsr ShowMsg

    ; Page 0 en espace cartouche
    ldb #$0
    pshs b          ; sauve la page courante
    jsr [SetPageInROM]

    ldb #$00
    stb FileBloc_
    ldx #$0000
    stx FileSize_

Boot_loop
    ; Démarrage casette
    lda #$01        ; $01 for read (no delay); $02 for write (with 1 sec delay)
    swi
    fcb K7MO

    ; Chargement du fichier en $B000
    ldx #$B000
    stx FileAddr_

    ; Chargement du fichier via le buffer
    ldy #Buffer_
    bsr ReadFile_

    ; Page suivante en espace cartouche
    puls b          ; restaure la page courante
    cmpb #$03       ; chargement jusqu'à la page 3 incluse
    bge ExecED2
    incb            ; incrémente la page courante
    pshs b          ; sauve la page courante
    jsr [SetPageInROM]
    bra Boot_loop

    ; Reboot
    swi
    fcb DKBOOT


ReadFile_
    lda #$01        ; $00 = write, read if not null
    swi
    fcb K7CO
    ; A = computed checksum of data
    ; B = type of block ($00 = header, $01 = content, $ff = end)
    ; at Y
    ; - 1 byte for the length of data (n+2; $00 means 256)
    ; - n bytes of data
    ; - 1 byte of expected checksum

    cmpb #$ff       ; End of file
    beq ReadFileEnd_
    cmpb #$00       ; File header : name
    beq ReadFile_   ; ignore file header

    bsr CopyBlock_
    bra ReadFile_

ReadFileEnd_
    rts


CopyBlock_
    pshs x,y,a,b    ; Y = length + data + checksum

    tfr y,u
    pulu b          ; B = length of data
    subb #2         ; remove 2 bytes for length and checksum
    tfr b,a
    ldx FileSize_   ; X = block size
    abx             ; X = X + B
    stx FileSize_   ; remembers processed data length

    ; Incrémente la barre de progression tous les 7 blocs
    ldb FileBloc_
    incb
    cmpb #7
    blt Progress_end
    ldx #MSGSTEP
    ldb 2,x
    incb
    stb 2,x
    bsr ShowMsg
    ldb #$0
Progress_end
    stb FileBloc_

CopyBlockByte_
    ldx FileAddr_
CopyBlockByteLoop_
    pulu b
    stb ,x+
    deca
    bne CopyBlockByteLoop_
    stx FileAddr_
    puls x,y,a,b
    rts

MO5SetPageInROM
    orb #%00001100  ; set ram page in A writable in ROM area [$B000-$EFFF]
    stb $A7CB
    rts
    nop
    nop

MO6SetPageInROM
    orb #%01100000  ; set ram page in A writable in ROM area [$B000-$EFFF]
    addb #3         ; first available page is 3 on MO6
    stb $A7E6
    rts

SetPageInROM FDB MO5SetPageInROM

ExecED2
    ; Arrêt cassette après 1/2 sec
    lda #$00
    swi
    fcb K7MO

    ; Page 0 en espace cartouche
    ldb #$0
    jsr [SetPageInROM]

    ; Affiche message d'attente depuis la cartouche
    jsr [$BFF6]     ; PatientezSVP

    ; Récupération des valeurs de ED2Install en ROM
    ldy $BFF8       ; Adresse ED2Install en ROM
    leay 3,y
    ldx ,y
    stx ED2Install+1
    leay 3,y
    ldx ,y
    stx ED2Install+4

    ; ED2Install en RAM, sans le jmp à la fin
ED2Install
    ldu #$0000
    ldx #$0000
    pshs u          ; Sauve l'adresse de fin de ED2Exec
CopyED2Exec         ; Copie de ED2Exec (avec SetRomPage à la fin)
    leax -2,x
    ldd ,x
    pshu d
    cmpu #ED2Boot
    bhi CopyED2Exec

    ; ED2Exec
    jmp ED2Boot


ShowChar
    swi
    fcb $02
ShowMsg
    ldb ,x+
    cmpb #$04
    bne ShowChar
    rts

MSGBASIC128
    FCB $0D,$0A                  ; ligne suivante
    FCC "Ne fonctionne qu'avec le BASIC 1.0"
    FCB $0D,$0A                  ; ligne suivante
    FCB $04

MSGEXT64K
    FCB $0D,$0A                  ; ligne suivante
    FCC "Extension m"
    FCB $16,$42                  ; accent aigu
    FCC "emoire 64K absente"
    FCB $0D,$0A                  ; ligne suivante
    FCB $04

MSGINIT
    FCB $1F,$20,$20,$1F,$12,$14  ; séquence de définition d'une fenêtre de travail des lignes 00 à 24
    FCB $14                      ; effacer le curseur de l'écran
    FCB $1B,$47                  ; couleur forme blanc
    FCB $1B,$50                  ; couleur fond  noir
    FCB $1B,$60                  ; couleur tour  noir
    FCB $0C                      ; effacement de la fenêtre
    FCB $1F,$4C,$41              ; positionnement du curseur en ligne 12 colonne 1
    FCC "["
    FCB $1F,$4C,$68              ; positionnement du curseur en ligne 12 colonne 40
    FCC "]"
    FCB $04
MSGSTEP
    FCB $1F,$4C,$41              ; positionnement du curseur en ligne 12 colonne 1
    FCC "=>"
    FCB $04

FileBloc_ FCB $00   ; number of blocks processed
FileSize_ FDB $0000 ; data length of blocks processed
FileAddr_ FDB $6000 ; file loading address according to the bin header

Exit
    bra Exit

    end $3100

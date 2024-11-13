        opt   c,ct

********************************************************************************
* Installation d'ED2 dans les premiers 64Ko de la Mégarom T.2
* par OlivierP-To8
* basé sur https://github.com/wide-dot/thomson-to8-game-engine/blob/main/engine/megarom-t2/t2-test.asm
* et sur la documentation technique de la Mégarom T.2 (https://megarom.forler.ch/fr/)
********************************************************************************
* T2Loader (TO8 Thomson) - Benoit Rousseau 2021
* ------------------------------------------------------------------------------
* Lib. MEGAROM T.2 : Prehisto
********************************************************************************

* ===========================================================================
* TO8 Registers
* ===========================================================================
dk_opc          equ $6048
dk_drive        equ $6049
dk_track        equ $604A
dk_track_lsb    equ $604B
dk_sector       equ $604C
dk_buffer       equ $604F
dk_source       equ $604F

DKCO            equ $E82A    ; Contrôleur de disque
PUTC            equ $E803    ; Affichage d'un caractère
GETC            equ $E806    ; Lecture du clavier

backupTrack     equ $0001    ; pistes 1 à 16
memo7Track      equ $0018    ; pistes 24 à 39


        org   $8000
        lds   #$9FFF            ; reinit de la pile systeme

        setdp $60
        lda   #$60
        tfr   a,dp              ; positionne la direct page a 60

        ldx #MSG_HELLO
        jsr AFFICHE_MSG

        jsr   ENM7              ; rend la MEGAROM T.2 visible


        ; Test de la présence de la Mégarom T.2
        LDD #$AA55
        STA $0555
        STB $02AA
        LDD #$90F0              ; Commande d’identification
        STA $0555
        LDX $0000
        STB $0555               ; Sortie du mode commande, N’importe quelle adresse fait l’affaire
        cmpx #$01AD             ; Teste si le registre X contient $01AD (identifiant de la flash)
        beq TEST_CONTENU_ROM
        ldx #MSG_MEGAROM_ABS
        jsr AFFICHE_MSG
        bra *


        ; Vérifie que le contenu de la Mégarom T.2 est original
TEST_CONTENU_ROM
        LDX #MEGAROM_HEADER
        LDY #$0000
CMPROM  LDA ,X+
        CMPA ,Y+
        BNE TEST_CONTENU_BAK    ; le contenu de la Mégarom T.2 est modifié
        CMPA #$04
        BNE CMPROM

        ldx #ASK_MEGAROM_PRES
        jsr AFFICHE_MSG
        ldx #ASK_MEGAROM_INSTALL
        jsr AFFICHE_MSG
        jsr SAISIE
        cmpb #'O'
        beq BACKUP
        bra *


        ; Vérifie la présence du backup Mégarom T.2
TEST_CONTENU_BAK
        ldd #backupTrack
        std <dk_track
        ldd #$0001              ; init positionnement disquette
        ;sta <dk_drive          ; ne pas forcer le numéro de lecteur
        stb <dk_sector          ; secteur (1-16) 
        ldd #$A000              ; le buffer DKCO est toujours positionne a $A000
        std <dk_buffer
        lda #$02
        sta <$6048              ; DK.OPC $02 Operation - lecture d'un secteur
        jsr DKCO                ; DKCO Appel Moniteur - lecture d'un secteur

        LDX #MEGAROM_HEADER
        LDY #$A000
CMPBAK  LDA ,X+
        CMPA ,Y+
        LBNE BACKUP_ABS         ; pas de sauvegarde
        CMPA #$04
        BNE CMPBAK


        ; Le contenu de la Mégarom T.2 est modifié + une sauvegarde est présente
        ldx #ASK_MEGAROM_RESTORE
        jsr AFFICHE_MSG
        jsr SAISIE
        cmpb #'O'
        beq RESTORE             ; restauration à l'état initial
        bra ED2_INSTALL


BACKUP_ABS
        ldx #MSG_BACKUP_ABS
        jsr AFFICHE_MSG
ED2_INSTALL
        ldx #ASK_MEGAROM_INSTALL
        jsr AFFICHE_MSG
        jsr SAISIE
        cmpb #'O'
        beq MAJED2              ; mise à jour d'ED2
        bra *


BACKUP
        ; Sauvegarde des 64K dans les pistes [1-16]
        lda #$00
        sta cur_ROMPage

        ldx #MSG_BACKUP
        jsr AFFICHE_MSG
        jsr WriteROMtoDisk

        lda #$00
        sta cur_ROMPage

        ldx #MSG_VERIFY
        jsr AFFICHE_MSG
        jsr VerifyROMfromDisk

MAJED2
        ; Efface les premiers 64K de la Mégarom T.2
        ldx #MSG_ERASE
        jsr AFFICHE_MSG

        lda #$00
        jsr SETPAG

        jsr ERASE


        ; Ecrit ED2.m7 (pistes [24-39]) dans les 64K de la Mégarom T.2
        ldx #MSG_PROG
        jsr AFFICHE_MSG

        lda #$00
        sta cur_ROMPage

        ldd #memo7Track
        jsr ReadROMfromDisk

        ldx #MSG_BACKUP_FIN
        jsr AFFICHE_MSG
        jsr SAISIE

REBOOT
        ; Reboot
        lda #$00
        jsr SETPAG              ; ROM page a 0 pour la voir apres reboot

	ldx #$0000		; Différent de $A55A
	stx $60FE		; Redémarrage à froid du TO.
	jmp $E82D		; Retour au menu principal

        bra *


RESTORE
        ; Efface les premiers 64K de la Mégarom T.2
        ldx #MSG_ERASE
        jsr AFFICHE_MSG

        lda #$00
        jsr SETPAG

        jsr ERASE


        ; Restaure la Mégarom (pistes [1-16]) dans les 64K de la Mégarom T.2
        ldx #MSG_RESTORE
        jsr AFFICHE_MSG

        lda #$00
        sta cur_ROMPage

        ldd #backupTrack
        jsr ReadROMfromDisk

        bra REBOOT


cur_ROMPage fcb   $00

MEGAROM_HEADER
        FCB $20
        FCB $4D
        FCB $16
        FCC "BegaRom T.2"
        FCB $04


SAISIE
        jsr GETC
        bcc SAISIE
        jsr PUTC
        rts


;********************************************************************************
; Affichage d'un message
;********************************************************************************
AFFICHE_CAR
    JSR PUTC
AFFICHE_MSG
    LDB ,X+
    CMPB #$04
    BNE AFFICHE_CAR
    RTS

MSG_HELLO
    FCB $0D,$0A                  ; ligne suivante
    FCC "Installation de la MEMO7 d'ED2 dans"
    FCB $0D,$0A                  ; ligne suivante
    FCC "les premiers 64Ko de la M"
    FCB $16,$42                  ; accent aigu
    FCC "egarom T.2"
    FCB $0D,$0A                  ; ligne suivante
    FCC "avec remise "
    FCB $16,$41                  ; accent grave
    FCC "a l'"
    FCB $16,$42                  ; accent aigu
    FCC "etat initial"
    FCB $0D,$0A                  ; ligne suivante
    FCB $04

MSG_BACKUP
    FCB $0D,$0A                  ; ligne suivante
    FCC "Sauvegarde de la M"
    FCB $16,$42                  ; accent aigu
    FCC "egarom T.2 "
    FCB $04

MSG_VERIFY
    FCB $0D,$0A                  ; ligne suivante
    FCC "V"
    FCB $16,$42                  ; accent aigu
    FCC "erification de la sauvegarde "
    FCB $04

MSG_ERASE
    FCB $0D,$0A                  ; ligne suivante
    FCC "Effacement de la M"
    FCB $16,$42                  ; accent aigu
    FCC "egarom T.2 "
    FCB $04

MSG_PROG
    FCB $0D,$0A                  ; ligne suivante
    FCC "Ecriture d'ED2 dans la M"
    FCB $16,$42                  ; accent aigu
    FCC "egarom T.2 "
    FCB $04

MSG_BACKUP_FIN
    FCB $0D,$0A                  ; ligne suivante
    FCC "Prot"
    FCB $16,$42                  ; accent aigu
    FCC "egez la disquette en "
    FCB $16,$42                  ; accent aigu
    FCC "ecriture."
    FCB $04

MSG_RESTORE
    FCB $0D,$0A                  ; ligne suivante
    FCC "Restauration de la M"
    FCB $16,$42                  ; accent aigu
    FCC "egarom T.2 "
    FCB $04

MSG_ERREUR
    FCB $0D,$0A                  ; ligne suivante
    FCC "Erreur "
    FCB $04

ASK_MEGAROM_PRES
    FCB $0D,$0A                  ; ligne suivante
    FCC "La M"
    FCB $16,$42                  ; accent aigu
    FCC "egarom T.2 est pr"
    FCB $16,$42                  ; accent aigu
    FCC "esente."
    FCB $04

MSG_MEGAROM_ABS
    FCB $0D,$0A                  ; ligne suivante
    FCC "La M"
    FCB $16,$42                  ; accent aigu
    FCC "egarom T.2 n'est pas pr"
    FCB $16,$42                  ; accent aigu
    FCC "esente."
    FCB $04

MSG_BACKUP_ABS
    FCB $0D,$0A                  ; ligne suivante
    FCC "La M"
    FCB $16,$42                  ; accent aigu
    FCC "egarom T.2 n'est pas sauvegard"
    FCB $16,$42                  ; accent aigu
    FCC "ee."
    FCB $04

ASK_MEGAROM_INSTALL
    FCB $0D,$0A                  ; ligne suivante
    FCC "Installer ED2 (O/N) ? "
    FCB $04

ASK_MEGAROM_RESTORE
    FCB $0D,$0A                  ; ligne suivante
    FCC "Restaurer la M"
    FCB $16,$42                  ; accent aigu
    FCC "egarom T.2 (O/N) ? "
    FCB $04


* ===========================================================================
WriteROMtoDisk
        ldd   #backupTrack
        std   <dk_track
        ldd   #$0001            ; init positionnement disquette
        ;sta   <dk_drive        ; ne pas forcer le numéro de lecteur
        stb   <dk_sector        ; secteur (1-16) 

WR_Continue
        lda   cur_ROMPage
        jsr   SETPAG

        ldd   #$0000
        std   <dk_source

        lda   #$08
        sta   <dk_opc           ; DK.OPC $08 Opération - écriture d'un secteur
WR_DKCO
        jsr   DKCO              ; DKCO Appel Moniteur - écriture d'un secteur
        inc   <dk_sector        ; incrément du registre Moniteur DK.SEC
        lda   <dk_sector        ; chargement de DK.SEC
        cmpa  #16               ; si DK.SEC est inférieur ou égal à 16
        bls   WR_DKContinue     ; on continue le traitement
        lda   #$01              ; sinon on a dépassé le secteur 16
        sta   <dk_sector        ; positionnement du secteur à 1
        inc   <dk_track_lsb     ; incrément du registre Moniteur DK.TRK
WR_DKContinue
        inc   <dk_source        ; incrément de 256 octets de la zone à ecrire DK.BUF
        ldx   <dk_source        ; chargement de la zone à ecrire DK.BUF
        cmpx  #$3F00            ; test début du dernier bloc de 256 octets à lire
        bls   WR_DKCO           ; si DK.BUF inférieur ou egal à la limite alors DKCO
WR_Page
        ldb #46
        jsr PUTC

        ldb   #$01
        stb   <dk_sector

        inc   cur_ROMPage
        lda   cur_ROMPage
        cmpa  #4
        bne   WR_Continue
        rts


* ===========================================================================
VerifyROMfromDisk
        ldd   #backupTrack
        std   <dk_track
        ldd   #$0001            ; init positionnement disquette
        ;sta   <dk_drive        ; ne pas forcer le numéro de lecteur
        stb   <dk_sector        ; secteur (1-16) 

VL_Continue
        ldd   #$A000            ; le buffer DKCO est toujours positionné a $A000
        std   <dk_buffer

        lda   #$02
        sta   <$6048            ; DK.OPC $02 Opération - lecture d'un secteur
VL_DKCO
        jsr   DKCO              ; DKCO Appel Moniteur - lecture d'un secteur
        inc   <dk_sector        ; incrément du registre Moniteur DK.SEC
        lda   <dk_sector        ; chargement de DK.SEC
        cmpa  #$10              ; si DK.SEC est inferieur ou egal à 16
        bls   VL_DKContinue     ; on continue le traitement
        lda   #$01              ; sinon on a dépassé le secteur 16
        sta   <dk_sector        ; positionnement du secteur à 1
        inc   <dk_track_lsb     ; incrément du registre Moniteur DK.TRK
VL_DKContinue                            
        inc   <dk_buffer        ; incrément de 256 octets de la zone à ecrire DK.BUF
        ldx   <dk_buffer        ; chargement de la zone à ecrire DK.BUF
        cmpx  #$DF00            ; test debut du dernier bloc de 256 octets à ecrire
        bls   VL_DKCO           ; si DK.BUF inferieur ou égal à la limite alors DKCO
VL_Page
        ldb #46
        jsr PUTC

        ldb   #$01              ; repositionnement pour chargement de la page RAM suivante
        stb   <dk_sector 

        lda   cur_ROMPage       ; page destination
        ldy   #$A000            ; début donnees à copier en ROM
        jsr   C16K              ; vérification des données copiées
        lbne  WriteError

        inc   cur_ROMPage       ; page ROM suivante
        lda   cur_ROMPage
        cmpa  #4
        bne   VL_Continue
        rts


* ===========================================================================
ReadROMfromDisk
        std   <dk_track
        ldd   #$0001            ; init positionnement disquette
        ;sta   <dk_drive        ; ne pas forcer le numéro de lecteur
        stb   <dk_sector        ; secteur (1-16) 

RL_Continue
        ldd   #$A000            ; le buffer DKCO est toujours positionné a $A000
        std   <dk_buffer

        lda   #$02
        sta   <$6048            ; DK.OPC $02 Opération - lecture d'un secteur
RL_DKCO
        jsr   DKCO              ; DKCO Appel Moniteur - lecture d'un secteur
        inc   <dk_sector        ; incrément du registre Moniteur DK.SEC
        lda   <dk_sector        ; chargement de DK.SEC
        cmpa  #$10              ; si DK.SEC est inferieur ou egal à 16
        bls   RL_DKContinue     ; on continue le traitement
        lda   #$01              ; sinon on a dépassé le secteur 16
        sta   <dk_sector        ; positionnement du secteur à 1
        inc   <dk_track_lsb     ; incrément du registre Moniteur DK.TRK
RL_DKContinue                            
        inc   <dk_buffer        ; incrément de 256 octets de la zone à ecrire DK.BUF
        ldx   <dk_buffer        ; chargement de la zone à ecrire DK.BUF
        cmpx  #$DF00            ; test debut du dernier bloc de 256 octets à ecrire
        bls   RL_DKCO           ; si DK.BUF inferieur ou égal à la limite alors DKCO
RL_Page
        ldb #46
        jsr PUTC

        ldb   #$01              ; repositionnement pour chargement de la page RAM suivante
        stb   <dk_sector 

        lda   cur_ROMPage       ; page destination
        ldy   #$A000            ; début donnees à copier en ROM
        jsr   P16K              ; recopie RAM vers ROM
        jsr   C16K              ; vérification des données copiées
        lbne  WriteError

        inc   cur_ROMPage       ; page ROM suivante
        lda   cur_ROMPage
        cmpa  #4
        bne   RL_Continue
        rts


WriteError
        ldx #MSG_ERREUR
        jsr AFFICHE_MSG

        lda   #$00
        jsr   SETPAG            ; ROM page à 0 pour la voir après reboot
        bra   *                 ; boucle infinie


* ===========================================================================
* Ext. Libraries
* ===========================================================================

* SETMOD
* Sélection du mode de fonctionnement
* In  : A = Mode
* Out : néant
* Mod : néant
* Le mode d’émulation peut valoir
*   00 (émulation de la commutation de page Mégarom T.1),
*   01 (émulation de la commutation de page MEMO7) ou
*   10/11 (mode neutre, pas d’émulation).

SETMOD
        PSHS   A
        LDA    #$AA
        STA    $0555
        LDA    #$55
        STA    $02AA
        LDA    #$B0
        STA    $0555
        PULS   A
        STA    $0556
        RTS


* SETPAG
* Cette commande permet de commuter une page à tout moment et sans recourir aux modes d’émulation.
* Sélection de la page entre 0 et 127
* In  : A = No. de page
* Out : néant
* Mod : néant
* Le bit 7 de l’octet de page est réservé et doit toujours être fixé à 0.

SETPAG
        PSHS   A
        LDD    #$AA55
        STA    $0555
        STB    $02AA
        LDA    #$C0
        STA    $0555
        PULS   A
        STA    $0555
        RTS


* ENM7
* Rend la MEMO7 visible sur TO9/8/8D/9+
* In  : néant
* Out : néant
* Mod : néant

ENM7
        PSHS   A

        LDA    $FFF0            ; Modèle de la gamme
        CMPA   #$03
        BGE    ENM7_TO8
        CMPA   #$02
        BEQ    ENM7_TO9
        BRA    ENM7_END

ENM7_TO9
        LDA    $E7C3
        ANDA   #$CF
        ORA    #$30             ; b4=1 b5=1 => sélection slot numéro 3 (cartouche extérieure)
        STA    $E7C3
        BRA    ENM7_END

ENM7_TO8
        LDA    $E7C3
        ANDA   #$FB
        STA    $E7C3

        LDA    $E7E6
        ANDA   #$DF
        STA    $E7E6

ENM7_END
        PULS   A,PC


* ERASE
* Effacement d'un secteur de la flash
* In  : néant
* Out : CC.N=1 si l'opération a échoué
* Mod : néant

ERASE
        PSHS   A
        LDD    #$AA55
        STA    $0555
        STB    $02AA
        LDA    #$80
        STA    $0555
        LDD    #$AA55
        STA    $0555
        STB    $02AA
        LDA    #$30
        STA    $0555

WAITS   LDA    $0000
        EORA   $0000
        BNE    WAITS
        LDA    $0000
        ASLA
        ASLA
        PULS   A,PC


* P16K
* Programme une page sans vérification
* In : A = No. de page
*      Y = ptr vers la source en RAM
* Out: néant
* Mod: néant

P16K
        PSHS   A
        LDA    #$02
        JSR    SETMOD
        PULS   A
        JSR    SETPAG
        PSHS   A,X,Y
        LDX    #$0000

PROG    LDA    #$AA
        STA    $555
        LDA    #$55
        STA    $2AA
        LDA    #$A0
        STA    $555
        LDA    ,Y+
        STA    ,X+

        MUL                      ; Pour attendre
        CMPX   #$4000
        BLO    PROG

        LDA    #$F0
        STA    $0555
        PULS   Y,X,A,PC


* C16K (Bentoc adaptation du code de préhisto)
* Compare les 16K d'une page avec la RAM
* In  : A = page entre 0 et 127
*       Y = pointeur vers une zone RAM
* Out : CC.Z = 0 si les donnees sont identiques 
* Mod : néant

C16K
        PSHS   X,Y,D
        JSR    SETPAG
        LDX    #$0000
CMP1    LDD    ,X++
        CMPD   ,Y++
        BNE    CRTS
        CMPX   #$4000
        BLO    CMP1
CRTS    PULS   D,Y,X,PC


        end $8000

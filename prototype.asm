////////////////////////////////////////////////////
// meatloaf browser prototype
// for the commodore 64

#import "Constants.asm"

*=$0801 "BASIC"
 :BasicUpstart($0810)
*=$0810

.const X_POS = $6f
.const Y_POS = $55

begin_code:
    sei
    lda #BLACK
    sta BORDER_COLOR
    sta BACKGROUND_COLOR
    lda #$93
    jsr KERNAL_CHROUT

    lda #$01
    sta SPRITE_ENABLE
    lda #$00
    sta SPRITE_MULTICOLOR
    sta SPRITE_MSB_X

    lda #$2c
    sta SPRITE_0_POINTER
    
    lda #X_POS
    sta SPRITE_0_X
    lda #Y_POS
    sta SPRITE_0_Y
    
    lda #YELLOW
    sta SPRITE_0_COLOR

title_loop:
    ldx #$00

////////////////////////////////////////////////////
load_data:
    ClearScreen(BLACK)
    ldx #$00
!ld:
    lda load_loading,x
    beq !ld+
    sta SCREEN_RAM,x
    inx
    jmp !ld-
!ld:
    ldx #$00
!ld:
    lda filename,x
    beq !ld+
    cmp #27
    bcc cfn_dont_add_l
    sbc #$40
cfn_dont_add_l:
    sta SCREEN_RAM+8,x
    inx
    cpx #$10
    bne !ld-
!ld:
    lda #$0f
    ldx drive_number
    ldy #$ff
    jsr KERNAL_SETLFS
    lda filename_length
    ldx #<filename
    ldy #>filename
    jsr KERNAL_SETNAM
    ldx #00 // Set Load Address
    ldy #00 // 
    lda #00
    jsr KERNAL_LOAD
    lda #13
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr show_drive_status
    ldx #$00
!ld:
    lda dir_presskey_text,x
    beq !ld+
    jsr KERNAL_CHROUT
    inx
    jmp !ld-
!ld:
    jsr KERNAL_WAIT_KEY
    beq !ld-
    jsr viewdiskdata
    rts

load_loading:
.encoding "screencode_mixed"
.text "loading "
.byte 0

*=$0b00 "Sprites"
#import "sprites.asm"
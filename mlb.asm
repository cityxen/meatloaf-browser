////////////////////////////////////////////////////
// meatloaf browser prototype
// for the commodore 64

//.segmentdef sprites
//.file [name="_in.spr", segments="sprites"]

#import "Constants.asm"

*=$0801 "BASIC"
 :BasicUpstart($0810)
*=$0810

.const X_POS = $8f
.const Y_POS = $85

begin_code:
    sei
    ClearScreen(BLACK)

    lda #$01
    sta SPRITE_ENABLE
    lda #$00
    sta SPRITE_MULTICOLOR
    sta SPRITE_MSB_X

    lda #$c0
    sta SPRITE_0_POINTER
    
    lda #X_POS
    sta SPRITE_0_X
    lda #Y_POS
    sta SPRITE_0_Y
    
    lda #YELLOW
    sta SPRITE_0_COLOR

mainloop:
    lda #< top_bar_text
    sta $fb
    lda #> top_bar_text
    sta $fc
    jsr print_string_tbz

keyloop:

    jsr KERNAL_GETIN

!check_next_key:
    cmp #$31 // 1 hit
    bne !check_next_key+
    jsr set_filename_buffer
    ldx #27
    lda #$31
    sta filename,x
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$32 // 2 hit
    bne !check_next_key+
    jsr set_filename_buffer
    ldx #27
    lda #$32
    sta filename,x
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$33 // 3 hit
    bne !check_next_key+
    jsr set_filename_buffer
    ldx #27
    lda #$33
    sta filename,x
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #KEY_E // E hit
    bne !check_next_key+

    lda #0
    sta $d020

    jsr zeroize_filename_buffer

    lda #< enter_filename_text
    sta $fb
    lda #> enter_filename_text
    sta $fc
    jsr print_string_tbz

    lda #< dir_presskey_text
    sta $fb
    lda #> dir_presskey_text
    sta $fc
    jsr print_string_tbz

!kg:
    jsr KERNAL_GETIN
    beq !kg-
    ClearScreen(BLACK)
    inc $d020
    jmp mainloop


!check_next_key:
    cmp #KEY_Q // Q hit
    bne !check_next_key+
    rts

!check_next_key:
    jmp keyloop

color_byte:
.byte 4
color_byte_underline:
.byte 1

////////////////////////////////////////////////////
load_data:
    // Clear screen
    ClearScreen(BLACK)

    // write LOADING to screen
    lda #< load_loading
    sta $fb
    lda #> load_loading
    sta $fc
    jsr print_string_tbz

    // draw filename to screencode
    cld
    clc
!ld:
    ldx #0
!ld:
    lda filename,x
    beq !ld+
    cmp #96
    bcc poke_screen
    sbc #96
poke_screen:
    sta SCREEN_RAM+8,x
    lda color_byte
    sta COLOR_RAM+8,x
    inx
    jmp !ld-

    // Load the file
!ld:
    stx filename_length
    txa
    tay
    ldx #0
!ld:
    lda #43
    sta SCREEN_RAM+48,x
    lda color_byte_underline
    sta COLOR_RAM+48,x
    inx
    dey
    cpy #0
    bne !ld-
    lda #$01
    ldx drive_number
    ldy #$01
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
    lda #< dir_presskey_text
    sta $fb
    lda #> dir_presskey_text
    sta $fc
    jsr print_string_tbz
!ld:
    jsr KERNAL_GETIN
    beq !ld-

    ClearScreen(BLACK)
    rts

load_loading:
.encoding "screencode_mixed"
.text "LOADING "
.byte 0

////////////////////////////////////////////////////
show_drive_status:
    lda #$00
    sta $90 // clear status flags
    lda drive_number // device number
    jsr KERNAL_LISTEN
    lda #$6f // secondary address
    jsr KERNAL_SECLSN
    jsr KERNAL_UNLSTN
    lda $90
    bne sds_devnp // device not present
    lda drive_number
    jsr KERNAL_TALK
    lda #$6f // secondary address
    jsr KERNAL_SECTLK
sds_loop:
    lda $90 // get status flags
    bne sds_eof
    jsr KERNAL_IECIN
    jsr KERNAL_CHROUT
    jmp sds_loop
sds_eof:
    jsr KERNAL_UNTALK
    rts
sds_devnp:
    // handle device not present error handling
    rts

////////////////////////////////////////////////////
// Set filename buffer
set_filename_buffer:
    jsr zeroize_filename_buffer
    ldx #0
!sfb:
    lda filename1,x
    beq !sfb+
    sta filename,x
    inx
    jmp !sfb-
!sfb:
    stx filename_length
    rts

////////////////////////////////////////////////////
// Print string terminated by zero
// requires low byte in $fb (zero page)
// requires high byte in $fc
print_string_tbz:
    ldy #0
!pst:
    lda ($fb),y
    beq !pst+
    jsr KERNAL_CHROUT
    clc
    inc $fb
    bcc !pst2+
    inc $fc
!pst2:
    jmp !pst-
!pst:
    rts

////////////////////////////////////////////////////
// Zeroize filename buffer
zeroize_filename_buffer:
    ldx #0
!zfb:
    lda #0
    sta filename,x
    inx
    cmp #0
    bne !zfb-
    rts

////////////////////////////////////////////////////
// Some vars
*=$2a00 "Vars"
dir_presskey_text:
.encoding "screencode_mixed"
.byte $0d
.text "PRESS ANY KEY"
.byte 0
enter_filename_text:
.encoding "screencode_mixed"
.byte $0d
.text "ENTER MANUALLY:"
.byte 0
drive_number:
.byte 10
filename_length:
.byte 35
filename: // reserve space for filename buffer
.encoding "screencode_upper"
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
filename1:
.text "http://192.168.1.71/m64/ml.1.spr"
.byte 0

top_bar_text:
.encoding "screencode_mixed"
.text "MEATLOAF BROWSER BY DEADLINE - 1,2,3 or E"
.byte 0

// .segment sprites
*=$3000 "Sprites"
//#import "sprites/sprite-hg1.asm"
#import "sprites/cxn-sprite - Sprites.asm"

.macro ClearScreen(color) {
    lda #$93
    jsr KERNAL_CHROUT    // $FFD2
    lda #color
    sta BACKGROUND_COLOR // $D020
    sta BORDER_COLOR     // $D021
}

////////////////////////////////////////////////////
// meatloaf browser prototype
// for the commodore 64

#import "Constants.asm"
#import "macros.asm"
#import "DrawPetMateScreen.asm"

.segmentdef main
.segmentdef sprites
.segmentdef vars
.segmentdef help_screen
.file [name="mlb.all.prg", segments="Default,sprites,main,vars,help_screen"]
.file [name="mlb.spr", segments="sprites"]

.disk [filename="mlb.d64", name="MEATLOAF BROWSER", id="2022!" ] {
	[name="MLB", type="prg",  segments="Default,sprites,main,vars,help_screen"],
}

.segment help_screen
*=$c000 "Help Screen"
#import "screens/screen-help-1.asm"

.segment sprites
.const sprloc = $c800
*=sprloc "Sprites"
#import "sprites/meatloaf-sprites.asm"

.segment vars
*=$cd00 "Vars"
#import "version.asm"
#import "vars.asm"

////////////////////////////////////////////////////

.segment main
*=$0801 "BASIC"
 :BasicUpstart($0810)
*=$0810

.const X0_POS = $90
.const Y0_POS = $80
.const X1_POS = $19
.const Y1_POS = $e4
.const X2_POS = $19
.const Y2_POS = $e4
.const X3_POS = $19
.const Y3_POS = $e4
.const X4_POS = $19
.const Y4_POS = $e4
.const X5_POS = $19
.const Y5_POS = $e4
.const X6_POS = $19
.const Y6_POS = $e4

////////////////////////////////////////////////////

begin_code:

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Start main loop

mainloop:

    ClearScreen(BLACK)
    jsr InitSprites
    inc $d020

    lda #23
    sta 53272 // set lower case

    PrintString(top_bar_text)
    PrintStringLF(version)
    PrintString(drive_text)
    jsr draw_drive_number
    lda #$0d
    jsr KERNAL_CHROUT

    PrintString(drive_status_text)
    jsr show_drive_status
    lda #$0d
    jsr KERNAL_CHROUT


////////////////////////////////////////////////////////////////////////////////////////////////////////
// Check keys hit loop

keyloop:

    jsr KERNAL_GETIN

!check_next_key:
    cmp #$31 // 1 hit
    bne !check_next_key+
    SetFileName(filename1)
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$32 // 2 hit
    bne !check_next_key+
    SetFileName(filename2)
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$33 // 3 hit
    bne !check_next_key+
    SetFileName(filename3)
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$34 // 4 hit
    bne !check_next_key+
    SetFileName(filename_lan1)
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$35 // 5 hit
    bne !check_next_key+
    SetFileName(filename_lan2)
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$36 // 6 hit
    bne !check_next_key+
    SetFileName(filename_lan3)
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$37 // 7 hit
    bne !check_next_key+
    SetFileName(filename_disk1)
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$38 // 8 hit
    bne !check_next_key+
    SetFileName(filename_disk2)
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop

!check_next_key:
    cmp #$39 // 9 hit
    bne !check_next_key+
    SetFileName(filename_disk3)
    jsr load_data
    ClearScreen(BLACK)
    jmp mainloop    

!check_next_key:
    cmp #KEY_E // E hit
    bne !check_next_key+
    lda #$02
    sta $d020
    jsr zeroize_filename_buffer
    PrintString(enter_filename_text)
    PrintString(dir_presskey_text)

!kg:
    jsr KERNAL_GETIN
    beq !kg-
    ClearScreen(BLACK)
    inc $d020
    jmp mainloop

!check_next_key:
    cmp #KEY_Q // Q hit
    bne !check_next_key+
    rts // exit program

!check_next_key:
    cmp #KEY_R // R hit (restore meatloaf sprite)
    bne !check_next_key+
    ldx #$00
!restore_ml_sprite:
    lda sprite_image_6,x
    sta sprite_image_0,x
    inx
    cpx #64
    bne !restore_ml_sprite-
    jmp mainloop

!check_next_key:
    cmp #KEY_F1 // F1 hit
    bne !check_next_key+
    jsr show_help
    jmp mainloop

!check_next_key:
    jmp keyloop

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Show help

show_help:
    lda SPRITE_ENABLE // disable sprites
    sta sprite_enable_store
    lda #$00
    sta SPRITE_ENABLE
    DrawPetMateScreen(help_screen)
    WaitKey()
    lda sprite_enable_store // re-enable sprites
    sta SPRITE_ENABLE
    rts

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Init Sprites

InitSprites:
    jsr CopySprites

    lda #$ff
    sta SPRITE_ENABLE

    lda #$01
    sta SPRITE_EXPAND_X
    sta SPRITE_EXPAND_Y
    lda #$00
    sta SPRITE_MULTICOLOR
    sta SPRITE_MSB_X

    lda #$c0
    sta SPRITE_0_POINTER
    lda #$c1
    sta SPRITE_1_POINTER
    lda #$c2
    sta SPRITE_2_POINTER
    lda #$c3
    sta SPRITE_3_POINTER
    lda #$c4
    sta SPRITE_4_POINTER
    lda #$c5
    sta SPRITE_5_POINTER
    lda #$c6
    sta SPRITE_6_POINTER
    
    lda #X0_POS
    sta SPRITE_0_X
    lda #Y0_POS
    sta SPRITE_0_Y

    lda #X1_POS
    sta SPRITE_1_X
    lda #Y1_POS
    sta SPRITE_1_Y

    lda #X2_POS
    sta SPRITE_2_X
    lda #Y2_POS
    sta SPRITE_2_Y
    
    lda #X3_POS
    sta SPRITE_3_X
    lda #Y3_POS
    sta SPRITE_3_Y
    
    lda #X4_POS
    sta SPRITE_4_X
    lda #Y4_POS
    sta SPRITE_4_Y

    lda #X5_POS
    sta SPRITE_5_X
    lda #Y5_POS
    sta SPRITE_5_Y

    lda #X6_POS
    sta SPRITE_6_X
    lda #Y6_POS
    sta SPRITE_6_Y
        
    lda #YELLOW
    sta SPRITE_0_COLOR
    lda spriteset_attrib_data+1
    sta SPRITE_1_COLOR
    lda spriteset_attrib_data+2
    sta SPRITE_2_COLOR
    lda spriteset_attrib_data+3
    sta SPRITE_3_COLOR
    lda spriteset_attrib_data+4
    sta SPRITE_4_COLOR
    lda spriteset_attrib_data+5
    sta SPRITE_5_COLOR
    lda spriteset_attrib_data+6
    sta SPRITE_6_COLOR
    rts

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copy Sprites

CopySprites:
    ldx #$00
cpsloop:
    lda sprloc,x
    sta $3000,x
    lda sprloc+256,x
    sta $3000+256,x
    inx
    cpx #185
    bne cpsloop
    rts
    
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Load file

load_data:

    ClearScreen(BLACK)
    PrintString(load_loading)
    PrintString(color_white)
    PrintString(filename_buffer)

    ldx filename_length
    lda #$00
    sta filename_buffer,x
    inx
    sta filename_buffer,x

!ld: // Load the file

    lda filename_length
    ldx #<filename_buffer
    ldy #>filename_buffer
    jsr KERNAL_SETNAM

    lda #0
    ldx drive_number
    ldy #01 // 0 - Load address over ride 1 - secondary address
    jsr KERNAL_SETLFS

    // ldx #$ff // drive_override_load_address_lo // Set Load Address
    // ldy #$ff // drive_override_load_address_hi
    lda #$00 // 0 - load 1 - verify
    jsr KERNAL_LOAD

    inc $d020
    lda #$0d
    jsr KERNAL_CHROUT
    jsr KERNAL_CHROUT
    jsr show_drive_status
    ldx #$00
!ld:
    PrintString(dir_presskey_text)
    WaitKey()
    ClearScreen(BLACK)
    rts

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Show drive status

show_drive_status2:

    lda #$00
    ldx #$00
    ldy #$00
    jsr KERNAL_SETNAM
    lda #$0f
    ldx drive_number
    ldy #$0f
    jsr KERNAL_SETLFS
    jsr KERNAL_OPEN
    bcs sds2_error
    ldx #$0f
    jsr KERNAL_CHKIN
!sds2:
    jsr KERNAL_READST
    bne !sds2+
    jsr KERNAL_CHRIN
    jsr KERNAL_CHROUT

    jsr waiter_loop

    jmp !sds2-

!sds2:
    lda #$0f
    jsr KERNAL_CLOSE
    jsr KERNAL_CLRCHN

sds2_error:
    rts

waiter_loop:
    rts
!wl:
    inc $fb
    bne !wl-
    inc $fc
    bne !wl-
    rts




show_drive_status:

    lda #$00
    sta $90 // clear status flags
    lda drive_number // device number
    jsr KERNAL_LISTEN

    lda #$01 //6f // secondary address
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
    PrintString(device_not_present_text)
    jsr draw_drive_number
    PrintString(device_not_present_text2)
    rts

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Print string terminated by zero, requires low byte in $fb (zero page), high byte in $fc

print_string_tbz:
    ldy #$00
!pst:
    lda ($fb),y
    beq !pst+
    jsr KERNAL_CHROUT
    inc $fb
    bne !pst-
    inc $fc
    jmp !pst-
!pst:
    rts

print_string_tbz_lf:
    jsr print_string_tbz
    lda #$0d
    jsr KERNAL_CHROUT
    rts

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Zeroize filename buffer

zeroize_filename_buffer:

    ldx #$00
!zfb:
    lda #$00
    sta filename_buffer,x
    inx
    bne !zfb-
    rts

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Print Drive Number to screen

draw_drive_number:
    
    lda drive_number // Show Drive Number on Screen
    clc // clear carry flag so we don't rotate carry into a
    rol // rotate left (multiply by 2)
    sec // sec carry flag for subtract operation
    sbc #$10 // subtract 16
    tax
    lda drive_number_text,x // get text indexed by x
    jsr KERNAL_CHROUT
    lda drive_number_text+1,x
    jsr KERNAL_CHROUT
    rts


load_data2:

    ClearScreen(BLACK)
    PrintString(load_loading)
    PrintString(color_white)
    PrintString(filename_buffer)

!ld: // Load the file
    lda filename_length
    ldx #<filename_buffer
    ldy #>filename_buffer
    jsr KERNAL_SETNAM

    lda #01
    ldx drive_number
    ldy #96 // 0 - Load address over ride 1 - secondary address
    jsr KERNAL_SETLFS

    ldx #$ff // drive_override_load_address_lo // Set Load Address
    ldy #$ff // drive_override_load_address_hi
    lda #$00 // 0 - load 1 - verify
    jsr KERNAL_LOAD

    lda #$00
    jsr KERNAL_CLOSE

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

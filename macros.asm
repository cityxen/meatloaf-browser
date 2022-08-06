
.macro ClearScreen(color) {
    lda #$93
    jsr KERNAL_CHROUT    // $FFD2
    lda #color
    sta BACKGROUND_COLOR // $D020
    sta BORDER_COLOR     // $D021
}

.macro PrintString(x) {
    lda #< x
    sta $fb
    lda #> x
    sta $fc
    jsr print_string_tbz
}

.macro WaitKey() {
!wk:
    jsr KERNAL_GETIN
    beq !wk-
}

.macro SetFileName(infilename) {
    jsr zeroize_filename_buffer
    ldx #$00
!sfb:
    lda infilename,x
    beq !sfb+
    sta filename_buffer,x
    inx
    jmp !sfb-
!sfb:
    stx filename_length
}
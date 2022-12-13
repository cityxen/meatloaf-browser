
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

.macro PrintStringLF(x) {
    lda #< x
    sta $fb
    lda #> x
    sta $fc
    jsr print_string_tbz_lf
}

.macro PrintLF() {
    lda #$0d
    jsr KERNAL_CHROUT
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

.macro KeyFileLoad(key,file) {
    cmp #key
    bne !kfs+
    SetFileName(file)
    jsr load_data
    jmp mainloop
!kfs:
}

.macro KeySub(key,subroutine) {
    cmp #key
    bne !kfs+
    jsr subroutine
    jmp mainloop
!kfs:
}
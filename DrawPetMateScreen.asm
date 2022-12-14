//////////////////////////////////////////////////////////////////////////////////////
// CityXen - https://linktr.ee/cityxen
//////////////////////////////////////////////////////////////////////////////////////
// Deadline's C64 Assembly Language Library: Macros: DrawPetMateScreen Macro
//////////////////////////////////////////////////////////////////////////////////////

.macro DrawPetMateScreen(screen_name) {
    ////////////////////////////////////////////////
    // Draw the Petmate Screen... START
    lda screen_name
    sta BORDER_COLOR
    lda screen_name+1
    sta BACKGROUND_COLOR
    ldx #$00 // Draw the screen from memory location
!dpms_loop:
    lda screen_name+2,x // Petmate screen (+2 is to skip over background/border color)
    sta 1024,x
    lda screen_name+2+256,x
    sta 1024+256,x
    lda screen_name+2+512,x
    sta 1024+512,x
    lda screen_name+2+512+232,x
    sta 1024+512+232,x
    lda screen_name+1000+2,x // And now the colors
    sta COLOR_RAM,x
    lda screen_name+1000+2+256,x
    sta COLOR_RAM+256,x
    lda screen_name+1000+2+512,x
    sta COLOR_RAM+512,x
    lda screen_name+1000+2+512+232,x
    sta COLOR_RAM+512+232,x
    inx
    cpx #$00
    bne !dpms_loop-
    // Draw the Petmate Screen... END
    ////////////////////////////////////////////////
}
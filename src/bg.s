.include "../inc/nes.inc"
.include "../inc/global.inc"
.segment "CODE"
.proc draw_bg
  ; Start by clearing the first nametable
  ldx #$20
  lda #$00
  ldy #$00
  jsr ppu_clear_nt

  ; Draw game border
  ; Top left corner
  lda #$20
  sta PPUADDR
  lda #$20
  sta PPUADDR
  lda #$0A
  sta PPUDATA

  ; Top
  lda #$06
  ldx #22 ; decimal 22
:
  sta PPUDATA
  dex
  bne :-

  ; Top right corner
  lda #$07
  sta PPUDATA

  ; Bottom
  lda #$23
  sta PPUADDR
  lda #$00
  sta PPUADDR

  ; Bottom left corner
  lda #$09
  sta PPUDATA

  lda #$06
  ldx #22

:
  sta PPUDATA
  dex
  bne :-

  ; Bottom right corner
  lda #$08
  sta PPUDATA

  ; Set vertical drawing mode
  lda #VBLANK_NMI|VRAM_DOWN
  sta PPUCTRL

  ; Left side
  lda #$20
  sta PPUADDR
  lda #$40
  sta PPUADDR

  lda #$05
  ldx #22

:
  sta PPUDATA
  dex
  bne :-

  ; Right side
  lda #$20
  sta PPUADDR
  lda #$57
  sta PPUADDR

  lda #$05
  ldx #22

:
  sta PPUDATA
  dex
  bne :-

  ; The attribute table elements corresponding to these stacks are
  ; (0, 5) (VRAM $23E8) and (7, 5) (VRAM $23EF).  Set them to 0.
  ldx #$23
  lda #$E8
  ldy #$00
  stx PPUADDR
  sta PPUADDR
  sty PPUDATA
  lda #$EF
  stx PPUADDR
  sta PPUADDR
  sty PPUDATA

  rts
.endproc


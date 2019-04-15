.include "../inc/nes.inc"
.include "../inc/global.inc"

.segment "ZEROPAGE"
; Game variables
player_x:         .res 1
player_y:         .res 1
player_facing:    .res 1
player_frame:     .res 1

.segment "CODE"

.proc init_player
  lda #0
  sta player_facing
  lda #$04
  sta player_frame
  lda #48
  sta player_x
  lda #48
  sta player_y
  rts
.endproc

;;
; Moves the player character in response to controller 1.
.proc move_player

  ; Acceleration to right: Do it only if the player is holding right
  ; on the Control Pad and has a nonnegative velocity.
  lda cur_keys
  and #KEY_RIGHT
  beq :+

    ; right is pressed
    lda player_facing  ; Set the facing direction to not flipped 
    and #<~$40         ; turn off bit 6, leave all others on
    sta player_facing

  :

  lda cur_keys
  and #KEY_LEFT
  beq :+

    ; Left is pressed.  Add to velocity.
    lda player_facing  ; Set the facing direction to flipped
    ora #$40
    sta player_facing

  :
  ; In a real game, you'd respond to A, B, Up, Down, etc. here.

  ; Test for collision with side walls

  ; Additional checks for collision, if needed, would go here.
  :

.endproc

.proc draw_player_sprite
  ; start drawing after the last OAM sprite
  ldx oam_used

  lda player_y
  sta OAM,x

  lda player_frame
  sta OAM+1,x

  lda player_facing
  sta OAM+2,x

  lda player_x
  sta OAM+3,x

  inx
  stx oam_used
  rts
.endproc


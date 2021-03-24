; ZX-Gol
; Conway's Game of Life
; ------------------------------------------------------------------
; at every generation:
; a living cell stays alive if it has 2 or 3 living neighbours, or dies;
; a dead cell becomes alive at next generation if it has exaclty 3 living neighbours.
;
; the world lives in the ATTRIBUTES MEMORY
; dimensions: 22 rows x 32 columns
; each living cell is a yellow square (8x8 pixel)

; EDIT_LOOP
; user can move around with WASD
; user can paint a cell with SPACE at cursor position
; user can paint a cell with IJKL around cursor position
; user can erase a cell at cursor position with BACKSAPCE
; user can start the life simulation with R
; user can go back to main screen with X


; GAME_LOOP
; double buffering
; evaluate next generation 
; render world 
; user can stop the running simulation with H and go back to edit mode


                org 33000
                ld a,2                          ; set a 2 (upper screen)
                call 5633                       ; open channel (in a)
 Restart        call init_screen

                ld de, banner                   
                ld bc, eofbann-banner                 
                call 8252

                ld de, author                   
                ld bc, eofauth-author                 
                call 8252 

                ld de, subbanner                   
                ld bc, eofsubbann-subbanner                 
                call 8252  

                ld de, instructions1                   
                ld bc, eofinstr1-instructions1                 
                call 8252 

                ld de, instructions2                   
                ld bc, eofinstr2-instructions2                 
                call 8252 
                
                ld de, instructions3                   
                ld bc, eofinstr3-instructions3
                call 8252 
                
                ld de, instructions4         
                ld bc, eofinstr4-instructions4
                call 8252 
                
                ld de, instructions5         
                ld bc, eofinstr5-instructions5
                call 8252       
                
                ld de, instructions6
                ld bc, eofinstr6-instructions6
                call 8252 
                
                ld de, instructions7
                ld bc, eofinstr7-instructions7
                call 8252 
                
                ld de, instructions8
                ld bc, eofinstr8-instructions8
                call 8252 

                ld hl, LAST_K
                ld a,0
                ld (hl),a
WaitKey         ld a,(hl)
                cp 0
                jr z, WaitKey
                call init_screen
MainLoop
;PrintCursor    
                ld hl, LAST_K
                ld (hl), 0
                ld a,AT
                rst 16
                ld a,(row)
                rst 16
                ld a,(col)
                rst 16
		ld a,PAPER
		rst 16
		ld a,8
		rst 16
		ld a,INK
		rst 16
		ld a,2
		rst 16
                ld a,"@"
                rst 16
;ReadKeys
                ld hl, LAST_K                   ; load mem location for last key pressed 
                ld a, (hl)
                cp "d"
                jp z, MoveRight
                cp "a"
                jr z, MoveLeft
                cp "w"
                jp z, MoveUp
                cp "s"
                jp z, MoveDown
		cp " "
		jp z, Spawn
                cp "l"
                jp z, SpawnRight
		cp "j"
                jp z, SpawnLeft
		cp "i"
                jp z, SpawnUp
		cp "k"
                jp z, SpawnDown
                cp 12
                jp z, Delete
                cp "x"
                jp z, Restart
                cp "r"
                jp z, Run
                
                jp MainLoop

Delete          
                ld a,AT
                rst 16
                ld a,(row)
                rst 16
                ld a,(col)
                rst 16
                ld a,PAPER
                rst 16
                ld a,0
                rst 16
                ld a, 32
                rst 16
                jp MainLoop          

MoveRight       
                ld a,(col)
                cp 31                           ; rightmost col
                jp z, MainLoop                  ; guard movement
                call clear_cursor
                ld a,(col)
                inc a
                ld (col), a
                jp MainLoop

MoveLeft        
                ld a,(col)
                cp 0
                jp z, MainLoop                  ; guard movement
                call clear_cursor
                ld a,(col)
                dec a
                ld (col), a
                jp MainLoop

MoveUp          
                ld a,(row)
                cp 0                            
                jp z, MainLoop                  ; guard movement
                call clear_cursor
                ld a,(row)
                dec a
                ld (row), a
                jp MainLoop

MoveDown        ld a,(row)
                cp 21
                jp z, MainLoop                  ; guard movement
                call clear_cursor
                ld a,(row)
                inc a
                ld (row), a
                
                jp MainLoop


Spawn           
                ld a,AT
                rst 16
                ld a,(row)
                rst 16
                ld a,(col)
                rst 16
                ld a,PAPER
                rst 16
                ld a,6
                rst 16
                ld a, 32
                rst 16
                jp MainLoop




SpawnRight      ld a,(col)
		cp 31
		jp z,MainLoop
		ld a,AT
                rst 16
                ld a,(row)
                rst 16
                ld a,(col)
		inc a
                rst 16
                ld a,PAPER
                rst 16
                ld a,6
                rst 16
		ld a, 32
		rst 16
                
                jp MainLoop

SpawnLeft	ld a,(col)
		cp 0
		jp z,MainLoop
		ld a,AT
                rst 16
                ld a,(row)
                rst 16
                ld a,(col)
		dec a
                rst 16
                ld a,PAPER
                rst 16
                ld a,6
                rst 16
		ld a, 32
		rst 16
                
                jp MainLoop

SpawnUp         ld a,(row)
		cp 0
		jp z,MainLoop
		ld a,AT
                rst 16
                ld a,(row)
                dec a
                rst 16
                ld a,(col)
                rst 16
                ld a,PAPER
                rst 16
                ld a,6
                rst 16
		ld a, 32
		rst 16
                jp MainLoop

SpawnDown       ld a,(row)
		cp 21
		jp z,MainLoop
		ld a,AT
                rst 16
                ld a,(row)
                inc a
                rst 16
                ld a,(col)
                rst 16
                ld a,PAPER
                rst 16
                ld a,6
                rst 16
		ld a, 32
		rst 16
                jp MainLoop


Run             call clear_cursor

GameLoop        ld hl, LAST_K                   ; load mem location for last key pressed 
                ld a, (hl)
                cp "h"
                jp z, MainLoop
                cp "x"
                jp z, Restart
                ld bc,704
                ld hl,ATTRS
                ld de,BUFFER
Scan            ld a,0
                ld (nbcount), a
                push bc
                push hl
                ld bc,-33
                add hl,bc
                call inc_counter
                inc hl
                call inc_counter
                inc hl
                call inc_counter
                ld bc,30
                add hl,bc
                call inc_counter
                inc hl
                inc hl
                call inc_counter
                ld bc,30
                add hl,bc
                call inc_counter
                inc hl
                call inc_counter
                inc hl
                call inc_counter
                ld a,(nbcount)
                cp 3
                jr z, _Alive
                cp 2
                jr z, _Alive
                ld a,0
                ld (de),a
                jp _Next
_Alive          
                pop hl
                ld a,(hl)
                cp 48
                jr nz, _Rebirth
                ld (de),a
                jr _Inc
_Rebirth        ld a,(nbcount)
                cp 3
                jr nz, _Inc
                ld a, 48
                ld (de),a
                jr _Inc
_Next           pop hl
_Inc            pop bc
                inc hl
                inc de
                dec bc
                ld a,b
                or c 
                jp nz,Scan
                di
                exx
                ld hl,BUFFER
                ld de,ATTRS
                ld bc,704
                ldir
                exx
                ei
                jp GameLoop

inc_counter     ld a,(hl)
                cp 48
                jr z, _Increment
                jp _No_increment
_Increment      ld a,(nbcount)
                inc a
                ld (nbcount),a
_No_increment   ret

clear_cursor    
                ld a,22
                rst 16
                ld a,(row)
                rst 16
                ld a,(col)
                rst 16
                ld a,INK
                rst 16
                ld a,0
                rst 16
                ld a," "
                rst 16
                ret


init_screen     call ROM_CLS
                ld a,0
                out(254),a      ; border 0
                ld hl,ATTRS     ; paper 0
                ld de,ATTRS+1
                ld bc,768
                ld a,0
                ld (hl), a
                ldir
                ld a,0 
                ret


; variables
row             defb 12
col             defb 16
nbcount         defb 0

; constants
ATTRS                   EQU 0x5800       ;22528
BUFFER                  EQU 0xC350       ;50000
ROM_CLS                 EQU 0x0DAF       ; Clears the screen and opens channel 2
ROM_OPEN_CHANNEL        EQU 0x1601       ; Open a channel
INK                     EQU 0x10
PAPER                   EQU 0x11
FLASH                   EQU 0x12
BRIGHT                  EQU 0x13
INVERSE                 EQU 0x14
OVER                    EQU 0x15
AT                      EQU 0x16
TAB                     EQU 0x17
CR                      EQU 0x0C

CURSOR_INK              EQU 2
CURSOR_PAPER            EQU 0
LAST_K                  EQU 0x5C08      ;23560 <- last key pressed mem location


banner          defb 16, 2, 17, 0, 22, 0, 1, "ZX-GOL :: CONWAY'S GAME OF LIFE"
eofbann          equ $

author          defb 16, 2, 17, 0, 22, 2, 4, 127, " 2021 - 3PI RETROCODING"
eofauth          equ $ 

subbanner       defb 16, 6, 17, 0, 22, 7, 5, "PRESS ANY KEY TO START"
eofsubbann       equ $

instructions1   defb 16, 7, 17, 0, 22, 11, 0, " [ KEYS ]"
eofinstr1       equ $

instructions2   defb 16, 7, 17, 0, 22, 13, 0, " AWSD: MOVE CURSOR"
eofinstr2       equ $

instructions3   defb 16, 7, 17, 0, 22, 14, 0, " SPACE: DRAW CELL UNDER CURSOR "
eofinstr3       equ $

instructions4   defb 16, 7, 17, 0, 22, 15, 0, " IJKL: DRAW CELL AROUND CURSOR"
eofinstr4       equ $

instructions5   defb 16, 7, 17, 0, 22, 16, 0, " DELETE: ERASE CELL UNDER CURSOR"
eofinstr5       equ $

instructions6   defb 16, 7, 17, 0, 22, 17, 0, " R: RUN THE SIMULATION"
eofinstr6       equ $

instructions7   defb 16, 7, 17, 0, 22, 18, 0, " H: HALT THE SIMULATION"
eofinstr7       equ $

instructions8   defb 16, 7, 17, 0, 22, 19, 0, " X: EXIT TO MAIN SCREEN"
eofinstr8       equ $
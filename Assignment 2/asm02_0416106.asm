TITLE Spaceship					(main.asm)

; 
;========================================================
; Student Name: Wilbert
; Student ID: 0416106
; Email: wilbert.phen@gmail.com
;========================================================
; Instructor: Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Assembly Language 
; Date: 2017/03/28
;========================================================
; Description:
;
; 
; Display an option in the beginning
; Perform the option selected
; Repeat until quit
; 

INCLUDE Irvine32.inc
INCLUDE macros.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
buffer_dh = frame_col + 2
buffer_dl = op_start_row
first_ship_color = blue
second_ship_color = green
third_ship_color = yellow
op_start_row = 3
op_start_col = 2
ship_color_default = third_ship_color*16
text_color = white
frame_row = 100
frame_col = 25
default_delay = 50
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_frame	PROTO, :DWORD

.data
ship_color		DWORD	ship_color_default

.code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main PROC
beginning:
	mov		eax, text_color								;initialize color
	call	settextcolor								;set color for text
	call	clrscr										;clear screen
	invoke	print_frame, 0								;frame printing
	call	print_option								;option printing
	call	options										;option selection
	jmp		beginning									;infinite loop
quit_program::
	exit
main ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
change_ship_color PROC
	call	clrscr										;clear screen
	invoke	print_frame, 0								;print frame
	mov		dl, frame_row/2	- 15						;set on the middle parts of the screen
	mov		dh, op_start_col							;starting column
	call	gotoxy										;jump to wanted coordinate
	mwrite	"Please select a color for the ship"

	call	gettextcolor								;get former text color
	push	eax											;save color

	mov		dl,	frame_row/2 - 10						;coordinate for left rectangle
	mov		dh, op_start_col + 3						;coordinate for left rectangle
	call	gotoxy										;jump to wanted coordinate
	mov		eax, first_ship_color*16					;color for left rectangle
	call	settextcolor								;set color
	mwrite	"   "
	inc		dh											;next line
	call	gotoxy										;jump to wanted coordinate
	mwrite	"   "

	mov		dl,	frame_row/2 - 1							;coordinate for middle rectangle
	mov		dh, op_start_col + 3						;coordinate for middle rectangle
	call	gotoxy										;jump to wanted coordinate
	mov		eax, second_ship_color*16					;color for left rectangle
	call	settextcolor								;set color
	mwrite	"   "
	inc		dh											;next line
	call	gotoxy										;jump to wanted coordinate
	mwrite	"   "

	mov		dl,	frame_row/2 + 7							;coordinate for right rectangle
	mov		dh, op_start_col + 3						;coordinate for right rectangle
	call	gotoxy										;jump to wanted coordinate
	mov		eax, third_ship_color*16					;color for left rectangle
	call	settextcolor								;set color
	mwrite	"   "
	inc		dh											;next line
	call	gotoxy										;jump to wanted coordinate
	mwrite	"   "

	pop		eax											;returning former text color
	call	settextcolor								;set color
	mov		dl,	frame_row/2 - 9							;coordinate for number
	mov		dh, op_start_col + 5						;coordinate for number
	call	gotoxy										;jump to wanted coordinate
	mwrite	"1        2       3"
	
	call	change_ship_color_choices					;choose ship color
	ret
change_ship_color ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
change_ship_color_choices PROC
	call	ReadKeyFlush								;flush buffer
repetition:
	call	readkey										;readkey
	.IF		al == '1'
	mov		ship_color, first_ship_color*16				;change ship color
	.ELSEIF	al == '2'
	mov		ship_color, second_ship_color*16			;change ship color
	.ELSEIF	al == '3'
	mov		ship_color, third_ship_color*16				;change ship color
	.ELSE
	mov		eax, default_delay							;delay
	call	draw_delay_without_blink					;wait outside frame
	jmp		repetition									;wait the input
	.ENDIF
	mwrite	7											;bell sound
	ret
change_ship_color_choices ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
show_frame PROC
	call	clrscr										;clear screen
	invoke	print_frame, default_delay					;call print frame with delay
	call	block_program								;block program
	ret
show_frame ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
play_game PROC
	;ebx has previous coordinate
	;edx has present coordinate
	call	clrscr										;clear screen
	invoke	print_frame, 0								;print frame
	call	gettextcolor								;get former text color
	push	eax											;save color

	mov		dl, op_start_row							;ship initial location
	mov		dh, frame_col/2								;ship initial location
	mov		ebx, edx

repetition:
	.IF		dh == 2
	mov		dh, frame_col - 3							;keep inside frame
	.ELSEIF	dh == frame_col - 2						
	mov		dh, 3										;keep inside frame
	.ENDIF

	call	erase_previous_ship							;erase previous location
	
	.IF		dl == frame_row - 10
	jmp		quit_repetition
	.ELSE
	push	ebx
	push	edx
	call	readkey										;readkey
	pop		edx
	pop		ebx
	.IF		al == 'c'
	inc		dh											;move up
	.ELSEIF	al == 'e'
	dec		dh											;move down
	.ELSEIF al == ' '
	jmp		quit_repetition	
	.ENDIF

	call	move_ship_right_and_update					;move ship and update it previous location
	mov		eax, default_delay							;delay time
	call	draw_delay_without_blink					;move outside frame for a while

	jmp		repetition									;move forward
	.ENDIF

quit_repetition:
	pop		eax											;returning former text color
	call	settextcolor								;set color
	ret
play_game ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
erase_previous_ship PROC USES edx
	;ebx is previous location
	mov		edx, ebx									;setting coordinate
	call	gotoxy										;jump to wanted coordinate
	mov		eax, text_color								;initialize eraser color
	call	settextcolor								;set color for text
	mWrite	"      "
	ret
erase_previous_ship ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_ship_right_and_update PROC
	;ebx is previous location
	;edx is current location
	inc		dl											;move right
	mov		ebx, edx									;saving former value
	call	gotoxy										;jump to wanted coordinate
	mov		eax, ship_color								;initialize color
	call	settextcolor								;set color for text
	mwrite	"      "
	ret
move_ship_right_and_update ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
show_info PROC
	call	clrscr										;clear screen
	invoke	print_frame, 0								;print frame
	mov		dl, op_start_row							;set row coordinate
	mov		dh, op_start_col							;set column coordinate
	call	gotoxy										;jump to wanted coordinate
	mWrite	"My Student Name: Wilbert"
	inc		dh											;next line
	call	gotoxy										;jump to wanted coordinate
	mWrite	"My Student ID: 0416106"
	inc		dh											;next line
	call	gotoxy										;jump to wanted coordinate
	mWrite	"My Student Email: wilbert.phen@gmail.com"
	call	block_program								;block program
	ret
show_info ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
options PROC
repetition:
	call	readkey										;readkey
	.IF		al == '1'
	call	change_ship_color							;first option function call
	.ELSEIF	al == '2'
	call	show_frame									;second option function call
	.ELSEIF	al == '3'
	call	play_game									;third option function call
	.ELSEIF	al == '4'
	call	show_info									;fourth option function call
	.ELSEIF	al == '5'
	jmp		quit_program								;quit program
	.ELSE
	mov		eax, default_delay							;set delay time
	call	delay										;run delay
	jmp		repetition									;wait the input
	.ENDIF
	ret
options ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_frame PROC, 
	frame_delay: DWORD
	call	gettextcolor								;get former color
	push	eax											;save former color
	mov		eax, ship_color								;set frame color
	call	settextcolor								;set color
	mov		eax, frame_delay							;set delay duration
	
	mov		dl, 0										;initialize row
	mov		dh, 0										;initialize column
	mov		ecx, frame_col								;set counter
L1:	call	gotoxy										;jump to wanted line
	mwrite	" "											;print a space
	inc		dh											;next line
	call	draw_delay_without_blink					;move outside frame for a while
	loop	L1											;loop

	mov		ecx, frame_row								;set counter
L2:	call	gotoxy										;jump to wanted line
	mwrite	" "											;print a space
	inc		dl											;next line
	call	draw_delay_without_blink					;move outside frame for a while
	loop	L2											;loop

	mov		ecx, frame_col								;set counter
L3:	call	gotoxy										;jump to wanted line
	mwrite	" "											;print a space
	dec		dh											;next line
	call	draw_delay_without_blink					;move outside frame for a while
	loop	L3											;loop

	mov		ecx, frame_row								;set counter
L4:	call	gotoxy										;jump to wanted line
	mwrite	" "											;print a space
	dec		dl											;next line
	call	draw_delay_without_blink					;move outside frame for a while
	loop	L4											;loop

	pop		eax											;returning text color
	call	settextcolor								;set color
	ret
print_frame ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_option PROC
	mov		dl, op_start_row							;set row coordinate
	mov		dh, op_start_col							;set column coordinate
	call	gotoxy										;jump to wanted coordinate
	mwrite	"1) Change ship color"

	inc		dh											;go to next line
	call	gotoxy										;jump to wanted coordinate
	mwrite	"2) Show a frame around the screen rectangular area"

	inc		dh											;go to next line
	call	gotoxy										;jump to wanted coordinate
	mwrite	"3) Play now!!!"

	inc		dh											;go to next line
	call	gotoxy										;jump to wanted coordinate
	mwrite	"4) Show author informaton"

	inc		dh											;go to next line
	call	gotoxy										;jump to wanted coordinate
	mwrite	"5) Quit game"

	add		dh, 2										;go to next line
	call	gotoxy										;jump to wanted coordinate
	mwrite	"Please enter an option....."
	ret
print_option ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_delay_without_blink PROC
	;eax contains delay time
	mgotoxy	buffer_dl, buffer_dh						;move buffer outside frame
	call	delay										;set delay
	ret
draw_delay_without_blink ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
block_program PROC
	mgotoxy	buffer_dl, buffer_dh						;move buffer outside frame
	call	ReadKeyFlush								;flush buffer
	call	waitmsg										;wait message
	ret
block_program ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

END main
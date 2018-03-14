
;========================================================
; Student Name: Wilbert
; Student ID: 0416106
; Email: wilbert.phen#gmail.com
;========================================================
; Instructor: Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Room: EC706
; Assembly Language 
;========================================================
; Description:
;
; IMPORTANT: always save EBX, EDI and ESI as their
; values are preserved by the callers in C calling convention.
;

INCLUDE Irvine32.inc
INCLUDE Macros.inc

invisibleObjX  TEXTEQU %(-100000)
invisibleObjY  TEXTEQU %(-100000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rainbow_limit	= 21
default_snake_speed = 100
default_life_cycle	= 25
default_numObjects	= 1
max_sphere		= 1024
MOVE_LEFT		= 0
MOVE_LEFT_KEY	= 'a'
MOVE_RIGHT		= 1
MOVE_RIGHT_KEY	= 'd'
MOVE_UP			= 2
MOVE_UP_KEY		= 'w'
MOVE_DOWN		= 3
MOVE_DOWN_KEY	= 's'
MOVE_NOPE		= 4
RAINBOW_COLOR	= 'p'
RAINBOW_MODE	= 0
RANDOM_COLOR	= 'r'
RANDOM_MODE		= 1
CLEAR			= 'c'
SAVE			= 'v'
LOAD			= 'l'
TARGET_MODE		= 0
CONTROL_MODE	= 1
LEFT_MOUSE		= 0
RIGHT_MOUSE		= 1
PRESS_MOUSE		= 0
RELEASE_MOUSE	= 1
STOP_GROWTH		= 0
CONT_GROWTH		= 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; PROTO C is to make agreement on calling convention for INVOKE

c_updatePositionsOfAllObjects PROTO C

.data 

MY_INFO_AT_TOP_BAR	BYTE "My Student Name: Wilbert NCTU: Computer Science StudentID: 0416106",0 

MyMsg BYTE "Project Title: Assembly Programming...",0dh, 0ah
		BYTE "Student Name: Wilbert",0dh, 0ah
		BYTE "My Student ID is 0416106", 0dh, 0ah
		BYTE "My Email is: wilbert.phen@gmail.com", 0dh, 0ah, 0dh, 0ah
		BYTE "Control keys: a, d, w, s", 0dh, 0ah
		BYTE "Mouse left click to direct the snake head", 0dh, 0ah
		BYTE "ESC: quit the game", 0dh, 0ah, 0dh, 0ah, 0

CaptionString BYTE "Student Name: Wilbert",0
MessageString BYTE "Welcome to Wonderful World", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0416106", 0dh, 0ah, 0dh, 0ah
				BYTE "My Email is: wilbert.phen@gmail.com", 0dh, 0ah, 0dh, 0ah
				BYTE "Control keys: a, d, w, s", 0dh, 0ah, 0dh, 0ah
				BYTE "Mouse left click to direct the snake head", 0dh, 0ah, 0dh, 0ah
				BYTE "ESC: quit the game", 0dh, 0ah
				BYTE "Enjoy playing!", 0

CaptionString_EndingMessage BYTE "Student Name: Wilbert",0
MessageString_EndingMessage BYTE "My Student ID is 0416106", 0dh, 0ah, 0dh, 0ah
							BYTE "My Email is: wilbert.phen@gmail.com", 0dh, 0ah, 0dh, 0ah, 0
							
windowWidth		DWORD 8000
windowHeight	DWORD 8000

scaleFactor	DWORD	128
canvasMinX	DWORD -4000
canvasMaxX	DWORD 4000
canvasMinY	DWORD -4000
canvasMaxY	DWORD 4000
;
particleRangeMinX REAL8 0.0
particleRangeMaxX REAL8 0.0
particleRangeMinY REAL8 0.0
particleRangeMaxY REAL8 0.0
;
particleSize DWORD  1
numParticles DWORD 10000
particleMaxSpeed DWORD 3

moveDirection	DWORD	MOVE_RIGHT

flgQuit		DWORD	0
maxNumObjects	DWORD max_sphere
numObjects	DWORD	default_numObjects
objPosX		SDWORD	max_sphere DUP(0)
objPosY		SDWORD	max_sphere DUP(0)
objTypes	BYTE	max_sphere DUP(1)
objSpeedX	SDWORD	0
objSpeedY	SDWORD	0			
objColor	DWORD	max_sphere*3 DUP(128)
rainbow		DWORD	255, 0, 0, 
					255, 127, 0, 
					255, 255, 0, 
					0, 255, 0, 
					0, 0, 255, 
					75, 0, 130, 
					139, 0, 255
rainbow_pointer	DWORD	0
rainbow_objects	DWORD	0
lifecycle	DWORD	0
lifecount	DWORD	0
colormode	DWORD	RANDOM_MODE
growth		DWORD	CONT_GROWTH
playmode	DWORD	CONTROL_MODE
targetX		SDWORD	0
targetY		SDWORD	0

save_area	DWORD	4 DUP(?)
saved_objPosX	SDWORD max_sphere DUP(?)
saved_objPosY	SDWORD max_sphere DUP(?)
saved_objColor	DWORD max_sphere*3 DUP(?)

DIGIT_MO_0		BYTE 0, 0, 1, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
DIGIT_MO_SIZE = ($-DIGIT_MO_0)				

offsetImage DWORD 0

openingMsg	BYTE	"This program shows the student ID using bitmap and manipulates images....", 0dh, 0ah
			BYTE	"Great programming.", 0dh, 0ah, 0
state		BYTE	0

imagePercentage DWORD	1

mImageStatus DWORD 0
mImagePtr0 BYTE 200000 DUP(?)
mImagePtr1 BYTE 200000 DUP(?)
mImagePtr2 BYTE 200000 DUP(?)
mTmpBuffer	BYTE	200000 DUP(?)
mImageWidth DWORD 0
mImageHeight DWORD 0
mBytesPerPixel DWORD 0

.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ClearScreen()
;
;Clear the screen.
;We can set text color if you want.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ClearScreen PROC C
	mov al, 0
	mov ah, 0
	call SetTextColor
	call clrscr
	ret
asm_ClearScreen ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ShowTitle()
;
;Show the title of the program
;at the beginning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ShowTitle PROC C USES edx
	mov dx, 0
	call GotoXY
	xor eax, eax
	mov ah, 0h
	mov al, 0e1h
	call SetTextColor
	mov edx, offset MyMsg
	call WriteString
	ret
asm_ShowTitle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_InitializeApp()
;
;This function is called
;at the beginning of the program.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_InitializeApp PROC C USES ebx edi esi edx
	call initGame
	call AskForInput_Initialization
	ret
asm_InitializeApp ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_EndingMessage()
;
;This function is called
;when the program exits.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_EndingMessage PROC C USES ebx edx
	mov ebx, OFFSET CaptionString_EndingMessage
	mov edx, OFFSET MessageString_EndingMessage
	call MsgBox
	ret
asm_EndingMessage ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_updateSimulationNow()
;
;Update the simulation.
;For examples,
;we can update the positions of the objects.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_updateSimulationNow PROC C USES edi esi ebx edx
	;
	call updateGame
	;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;DO NOT REMOVE THIS FOLLOWING LINE
	call c_updatePositionsOfAllObjects 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ret
asm_updateSimulationNow ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void setCursor(int x, int y)
;
;Set the position of the cursor 
;in the console (text) window.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setCursor PROC C USES edx,
	x:DWORD, y:DWORD
	mov edx, y
	shl edx, 8
	xor edx, x
	call Gotoxy
	ret
setCursor ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumParticles PROC C
	mov eax, numParticles
	ret
asm_GetNumParticles ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleMaxSpeed PROC C
	mov eax, particleMaxSpeed
	ret
asm_GetParticleMaxSpeed ENDP

;int asm_GetParticleSize()
;
;Return the particle size.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleSize PROC C
	;modify this procedure
	mov eax, particleSize
	ret
asm_GetParticleSize ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMousePassiveEvent( int x, int y )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMousePassiveEvent PROC C USES eax ebx edx,
	x : DWORD, y : DWORD
	mov eax, x
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	ret
asm_handleMousePassiveEvent ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMouseEvent(int button, int status, int x, int y)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMouseEvent PROC C USES ebx,
	button : DWORD, status : DWORD, x : DWORD, y : DWORD
	
	mWriteln "asm_handleMouseEvent"
	mov eax, button
	mWrite "button:"
	call WriteDec
	mWriteln " "
	mov eax, status
	mWrite "status:"
	call WriteDec
	mov eax, x
	mWriteln " "
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "
	mov eax, windowWidth
	mWrite "windowWidth:"
	call WriteDec
	mWriteln " "
	mov eax, windowHeight
	mWrite "windowHeight:"
	call WriteDec
	mWriteln " "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, button
	mov ebx, status
	.IF eax == LEFT_MOUSE && ebx == RELEASE_MOUSE
	;;;;;;;;;;;calculate target and round the result to objSpeed
	mov playmode, TARGET_MODE
	mov eax, x
	mov ebx, scaleFactor
	mul ebx
	mov targetX, eax
	mov eax, y
	mov ebx, scaleFactor
	mul ebx
	mov targetY, eax
	.ENDIF
	ret
asm_handleMouseEvent ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_HandleKey(int key)
;
;Handle key events.
;Return 1 if the key has been handled.
;Return 0, otherwise.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_HandleKey PROC C USES ebx edx esi edi, 
	key : DWORD
	mov eax, key
	call WriteInt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call movement_handler
	call toggle_handler
	.IF eax == 27
	mov eax, 0
	.ELSE
	mov eax, 1
	.ENDIF
	ret
asm_HandleKey ENDP

movement_handler PROC
	.IF eax == MOVE_LEFT_KEY
	mov moveDirection, MOVE_LEFT
	.ELSEIF eax == MOVE_RIGHT_KEY
	mov moveDirection, MOVE_RIGHT
	.ELSEIF eax == MOVE_UP_KEY
	mov moveDirection, MOVE_UP
	.ELSEIF	eax == MOVE_DOWN_KEY
	mov moveDirection, MOVE_DOWN
	.ELSE
	ret
	.ENDIF
	mov playmode, CONTROL_MODE
	ret
movement_handler ENDP

toggle_handler PROC USES eax
	.IF eax == CLEAR
	call reset_all_data
	.ELSEIF eax == SAVE
	call saving_all_data
	.ELSEIF eax == LOAD
	call restore_all_data
	.ELSEIF eax == ' '
	call growth_change
	.ELSEIF eax == RAINBOW_COLOR
	mov colormode, RAINBOW_MODE
	.ELSEIF eax == RANDOM_COLOR
	mov colormode, RANDOM_MODE
	.ENDIF
	ret
toggle_handler ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
reset_all_data PROC USES eax
	call small_data_reset
	call array_data_reset
	ret
reset_all_data ENDP

small_data_reset PROC
	mov eax, 1
	mov growth, eax
	mov eax, default_numObjects
	mov numObjects, eax
	mov lifecount, 0
	mov eax, max_sphere
	mov maxNumObjects, eax
	ret
small_data_reset ENDP

array_data_reset PROC
	cld
	mov edi, OFFSET objPosX
	mov eax, [edi]
	add edi, 4
	mov ecx, max_sphere
	dec ecx
	rep stosd

	mov ecx, max_sphere
	dec ecx
	mov edi, OFFSET objPosY
	mov eax, [edi]
	add edi, 4
	rep stosd

	mov ecx, max_sphere*3
	sub ecx, 24
	mov eax, 128
	mov edi, OFFSET objColor
	add edi, 24
	rep stosd

	ret
array_data_reset ENDP

maintain_head_color PROC USES eax esi
	mov esi, OFFSET objColor
	mov eax, 255
	mov [esi], eax
	mov eax, 0
	mov [esi+4], eax
	mov eax, 0
	mov [esi+8], eax
	ret
maintain_head_color ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
saving_all_data PROC USES eax
	call small_data_saving
	call array_data_saving
	ret
saving_all_data ENDP

small_data_saving PROC
	mov esi, OFFSET save_area
	mov eax, moveDirection
	mov [esi], eax
	mov eax, numObjects
	mov [esi+4], eax
	mov eax, lifecount
	mov [esi+8], eax
	mov eax, maxNumObjects
	mov [esi+12], eax
	ret
small_data_saving ENDP

array_data_saving PROC
	mov esi, OFFSET objPosX
	mov edi, OFFSET saved_objPosX
	mov ecx, max_sphere
	rep movsd

	mov esi, OFFSET objPosY
	mov edi, OFFSET saved_objPosY
	mov ecx, max_sphere
	rep movsd

	mov esi, OFFSET objColor
	mov edi, OFFSET saved_objColor
	mov ecx, max_sphere*3
	rep movsd
	ret
array_data_saving ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
restore_all_data PROC USES eax
	call small_data_loading
	call array_data_loading
	ret
restore_all_data ENDP

small_data_loading PROC
	mov esi, OFFSET save_area
	mov eax, [esi]
	mov moveDirection, eax
	mov eax, [esi+4]
	mov numObjects, eax
	mov eax, [esi+8]
	mov lifecount, eax
	mov eax, [esi+12]
	mov maxNumObjects, eax
	ret
small_data_loading ENDP

array_data_loading PROC
	mov edi, OFFSET objPosX
	mov esi, OFFSET saved_objPosX
	mov ecx, max_sphere
	rep movsd

	mov edi, OFFSET objPosY
	mov esi, OFFSET saved_objPosY
	mov ecx, max_sphere
	rep movsd

	mov edi, OFFSET objColor
	mov esi, OFFSET saved_objColor
	mov ecx, max_sphere*3
	rep movsd
	ret
array_data_loading ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_SetWindowDimension(int w, int h, int scaledWidth, int scaledHeight)
;
;w: window resolution (i.e. number of pixels) along the x-axis.
;h: window resolution (i.e. number of pixels) along the y-axis. 
;scaledWidth : scaled up width
;scaledHeight : scaled up height

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_SetWindowDimension PROC C USES ebx,
	w: DWORD, h: DWORD, scaledWidth : DWORD, scaledHeight : DWORD
	mov ebx, offset windowWidth
	mov eax, w
	mov [ebx], eax
	mov eax, scaledWidth
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxX
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinX
	mov [ebx], eax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, offset windowHeight
	mov eax, h
	mov [ebx], eax
	mov eax, scaledHeight
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxY
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinY
	mov [ebx], eax
	;
	finit
	fild canvasMinX
	fstp particleRangeMinX
	;
	finit
	fild canvasMaxX
	fstp particleRangeMaxX
	;
	finit
	fild canvasMinY
	fstp particleRangeMinY
	;
	finit
	fild canvasMaxY
	fstp particleRangeMaxY	
	;
	call asm_RefreshWindowSize
	ret
asm_SetWindowDimension ENDP	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetNumOfObjects()
;
;Return the number of objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumOfObjects PROC C
	mov eax, maxNumObjects
	ret
asm_GetNumOfObjects ENDP	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetObjectType(int objID)
;
;Return the object type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjectType		PROC C USES ebx edx,
	objID: DWORD
	push ebx
	push edx
	xor eax, eax
	mov edx, offset objTypes
	mov ebx, objID
	mov al, [edx + ebx]
	pop edx
	pop ebx
	ret
asm_GetObjectType		ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetObjectColor (int &r, int &g, int &b, int objID)
;Input: objID, the ID of the object
;
;Return the color three color components
;red, green and blue.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjectColor  PROC C USES ebx edx edi esi,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD, objID: DWORD
	mov esi, OFFSET objColor

	mov edx, objID
	mov eax, 12
	mul edx
	mov edx, eax
	mov edi, r
	mov eax, [esi+edx]
	mov DWORD PTR [edi], eax

	mov edi, g
	add edx, 4
	mov eax, [esi+edx]
	mov DWORD PTR [edi], eax

	mov edi, b
	add edx, 4
	mov eax, [esi+edx]
	mov DWORD PTR [edi], eax
	ret
asm_GetObjectColor ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeRotationAngle(a, b)
;return an angle*10.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeRotationAngle PROC C USES ebx,
	a: DWORD, b: DWORD
	mov ebx, b
	shl ebx, 1
	mov eax, a
	add eax, 10
	ret
asm_ComputeRotationAngle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeObjPositionX(int x, int objID)
;
;Return the x-coordinate in eax.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeObjPositionX PROC C USES edi esi ebx edx,
	x: DWORD, objID: DWORD
	;modify this procedure
	mov ebx, objID
	mov esi, offset objPosX
	mov eax, [esi+ebx*4]
	ret
asm_ComputeObjPositionX ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeObjPositionY(int y, int objID)
;
;Return the y-coordinate in eax.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeObjPositionY PROC C USES ebx esi edx,
	y: DWORD, objID: DWORD
	;modify this procedure
	mov ebx, objID
	mov esi, offset objPosY
	mov eax, [esi+ebx*4]
	ret
asm_ComputeObjPositionY ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The input image's information:
; imageIndex : the index of an image, starting from 0
; imagePtr : the starting address of the image, i.e., the address of the first byte of the image
; (w, h) defines the dimension of the image.
; w: width
; h: height
; Thus, the image has w times h pixels.
; bytesPerPixel : the number of bytes used to represent one pixel
;
; Purpose of this procedure:
; Copy the image to our own database
;
asm_SetImageInfo PROC C USES esi edi ebx edx,
imageIndex : DWORD,
imagePtr : PTR BYTE, w : DWORD, h : DWORD, bytesPerPixel : DWORD
	mov mImageStatus, 1
	mov eax, w
	mov mImageWidth, eax
	mov ebx, h
	mov mImageHeight, ebx
	mov ecx, bytesPerPixel
	mov mBytesPerPixel, ecx
	mul ebx
	mul ecx
	mov ecx, eax

	mov esi, imagePtr
	mov eax, imageIndex
	.IF eax == 0
	mov edi, OFFSET mImagePtr0
	.ELSEIF eax == 1
	mov edi, OFFSET mImagePtr1
	.ELSE
	mov edi, OFFSET mImagePtr2
	.ENDIF
	rep movsb
	ret
asm_SetImageInfo ENDP

asm_GetImagePixelSize PROC C
	mov eax, windowWidth
	mov ebx, windowHeight
	.IF eax < ebx
	mov eax, ebx
	.ENDIF
	
	mov ebx, mImageWidth
	mov ecx, mImageHeight
	.IF ebx > ecx
	mov ebx, ecx
	.ENDIF

	cdq
	div ebx
	mov ebx, 2
	mul ebx

	ret
asm_GetImagePixelSize ENDP

asm_GetImageStatus PROC C
	mov eax, mImageStatus
	ret
asm_GetImageStatus ENDP

asm_getImagePercentage PROC C
	mov eax, imagePercentage
	ret
asm_getImagePercentage ENDP

;
;asm_GetImageColour(int imageIndex, int ix, int iy, int &r, int &g, int &b)
;
asm_GetImageColour PROC C USES ebx edx edi esi, 
imageIndex : DWORD,
ix: DWORD, iy : DWORD,
r: PTR DWORD, g: PTR DWORD, b: PTR DWORD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, mImageWidth
	mov ebx, iy
	mov ecx, mImageHeight
	dec ecx
	sub ecx, ebx
	mov ebx, ecx
	mul ebx
	mov ecx, ix
	add eax, ecx
	mov edx, mBytesPerPixel
	mul edx
	push eax
	mov eax, imageIndex
	.IF eax == 0
	mov esi, OFFSET mImagePtr0
	.ELSEIF eax == 1
	mov esi, OFFSET mImagePtr1
	.ELSE
	mov esi, OFFSET mImagePtr2
	.ENDIF
	pop eax

	mov edi, r
	mov edx, 0
	mov dl, [esi+eax]
	mov DWORD PTR [edi], edx
	mov edi, g
	mov edx, 0
	inc eax
	mov dl, [esi+eax]
	mov DWORD PTR [edi], edx
	mov edi, b
	mov edx, 0
	inc eax
	mov dl, [esi+eax]
	mov DWORD PTR [edi], edx
	ret
asm_GetImageColour ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;const char *asm_getStudentInfoString()
;
;return pointer in edx
asm_getStudentInfoString PROC C
	mov eax, offset MY_INFO_AT_TOP_BAR
	ret
asm_getStudentInfoString ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Return the particle system state in eax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleSystemState PROC C
	mov eax, 1
	ret
asm_GetParticleSystemState ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetImageDimension(int &iw, int &ih)
asm_GetImageDimension PROC C USES ebx,
iw : PTR DWORD, ih : PTR DWORD
	mov ebx, iw
	mov eax, mImageWidth
	mov DWORD PTR [ebx], eax
	mov ebx, ih
	mov eax, mImageHeight
	mov DWORD PTR [ebx], eax
	ret
asm_GetImageDimension ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Compute a position to place an image.
; This position defines the lower left corner
; of the image.
;
asm_GetImagePos PROC C USES ebx,
	x : PTR DWORD,
	y : PTR DWORD
	mov eax, canvasMinX
	mov ebx, scaleFactor
	cdq
	idiv ebx
	mov ebx, x
	mov [ebx], eax
;
	mov eax, canvasMinY
	mov ebx, scaleFactor
	cdq
	idiv ebx
	mov ebx, y
	mov [ebx], eax
	ret
asm_GetImagePos ENDP

AskForInput_Initialization PROC USES ebx edi esi
	mov edx, OFFSET openingMsg
	call writestring

	mov ebx, OFFSET CaptionString
	mov edx, OFFSET MessageString
	call MsgBox
	ret
AskForInput_Initialization ENDP

asm_RefreshWindowSize PROC
	ret
asm_RefreshWindowSize ENDP

initGame PROC
	call maintain_head_color

	mwrite <"Enter the speed of the snake (integer) [1,200]:">
	call readint
	.IF eax == 0 || eax > 200
	mov eax, default_snake_speed
	.ENDIF
	mov	objSpeedX, eax
	mov objSpeedY, eax

	mwrite <"Enter the snake life cycle (integer) [1,100]:">
	call readint
	.IF eax == 0 || eax > 100
	mov eax, default_life_cycle
	.ENDIF
	mov lifecycle, eax

	mov	eax, white*16+white
	call settextcolor
	call clrscr
	mov eax, white*16+black
	call settextcolor

	;;;;;;;;;;;;;;;;;;;;;;;;;;
	call rgb_random
	call saving_all_data
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	ret
initGame ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rgb_random PROC
	call Random32
	mov ecx, eax
	and ecx, 0ffh
	call Random32
	mov ebx, eax
	and ebx, 0ffh
	call Random32
	mov eax, eax
	and eax, 0ffh
	ret
rgb_random ENDP

rainbow_adjuster PROC USES eax
	mov eax, rainbow_pointer
	add eax, 3
	.IF eax == rainbow_limit
	mov eax, 0
	.ENDIF
	mov rainbow_pointer, eax
	ret
rainbow_adjuster ENDP

maintain_color PROC USES eax ebx ecx edx esi edi

	mov eax, colormode
	.IF eax == RANDOM_MODE
	call rgb_random
	mov rainbow_objects, 0

	.ELSEIF eax == RAINBOW_MODE
	call rainbow_adjuster
	mov edx, rainbow_pointer
	mov esi, OFFSET rainbow
	mov eax, [esi+edx*4]
	mov ebx, [esi+edx*4+4]
	mov ecx, [esi+edx*4+8]
	.ENDIF

	push eax
	mov edx, numObjects
	mov eax, 12
	mul edx
	mov edx, eax
	pop eax

	mov esi, OFFSET objColor
	mov [esi+edx], eax
	mov [esi+edx+4], ebx
	mov [esi+edx+8], ecx
	ret
maintain_color ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
growth_change PROC USES eax
	mov eax, growth
	.IF eax == STOP_GROWTH
	mov eax, CONT_GROWTH
	.ELSEIF eax == CONT_GROWTH
	mov eax, STOP_GROWTH
	.ENDIF
	mov growth, eax
	ret
growth_change ENDP

maintain_growth PROC USES eax ebx
	mov eax, lifecount
	mov ebx, numObjects
	mov ecx, maxNumObjects

	.IF eax == 0 && growth == CONT_GROWTH
		call maintain_color
		inc ebx
		.IF ebx == ecx
		mov ebx, default_numObjects
		.ENDIF
	mov numObjects, ebx
	.ENDIF
	ret
maintain_growth ENDP

maintain_lifecount PROC USES eax edx
	mov eax, lifecount
	mov edx, lifecycle

	.IF eax == edx
	mov eax, 0
	.ELSE
	inc eax
	.ENDIF
	mov	lifecount, eax
	
	ret
maintain_lifecount ENDP

absolute_value PROC USES edx
	cdq
	xor eax, edx
	sub eax, edx	
	ret
absolute_value ENDP

rounder PROC USES ecx edx
	mov ecx, objSpeedY
	cdq
	push eax
	idiv ecx
	pop eax
	sub eax, edx
	push eax

	mov eax, ebx
	mov ecx, objSpeedX
	cdq
	push eax
	idiv ecx
	pop eax
	sub eax, edx
	push eax

	pop ebx
	pop eax
	ret
rounder ENDP

direction_control PROC
	mov eax, targetX
	mov ebx, targetY
	mov esi, OFFSET objPosX
	mov ecx, [esi]
	push eax
	mov eax, canvasMinX
	sub ecx, eax
	mov esi, OFFSET objPosY
	mov edx, [esi]
	neg edx
	mov eax, canvasMinY
	sub edx, eax
	pop eax

	sub eax, ecx
	sub ebx, edx
	call absolute_value
	push eax				;difference in x
	mov eax, ebx
	call absolute_value
	pop ebx					;eax is y and ebx is x

	call rounder

	.IF eax == 0 && ebx == 0
	mov moveDirection, MOVE_NOPE
	ret
	.ELSEIF eax < ebx
		mov eax, targetX
		cmp eax, ecx
		jl skip1
		mov moveDirection, MOVE_RIGHT
		jmp quit1
	skip1:
		mov moveDirection, MOVE_LEFT
	quit1:
	.ELSE
		mov eax, targetY
		cmp eax, edx
		jl skip2
		mov moveDirection, MOVE_DOWN
		jmp quit2
	skip2:
		mov moveDirection, MOVE_UP
	quit2:
	.ENDIF

	ret
direction_control ENDP

updateGame PROC USES ebx edx edi esi
	.IF playmode == TARGET_MODE
	call direction_control
	.ENDIF

	.IF moveDirection == MOVE_NOPE
	ret
	.ENDIF

	call maintain_growth
	call maintain_lifecount

	mov ebx, numObjects
	mov esi, offset objPosX
	mov eax, [esi]
	.IF moveDirection == MOVE_RIGHT
		add eax, objSpeedX
		mov edx, canvasMaxX
		cmp eax, edx
		jl skip1
		mov moveDirection, MOVE_LEFT
	.ELSEIF  moveDirection == MOVE_LEFT
		sub eax, objSpeedX
		mov edx, canvasMinX
		cmp eax, edx
		jg skip1
		mov moveDirection, MOVE_RIGHT
	.ENDIF
skip1:
	mov [esi], eax
	mov [esi+ebx*4], eax

	mov esi, offset objPosY
	mov eax, [esi]
	.IF moveDirection == MOVE_UP
		add eax, objSpeedY
		mov edx, canvasMaxY
		cmp eax, edx
		jl skip2
		mov moveDirection, MOVE_DOWN
	.ELSEIF moveDirection == MOVE_DOWN
		sub eax, objSpeedY
		mov edx, canvasMinY
		cmp eax, edx
		jg skip2
		mov moveDIrection, MOVE_UP
	.ENDIF
skip2:
	mov [esi], eax
	mov [esi+ebx*4], eax
	ret
updateGame ENDP

END

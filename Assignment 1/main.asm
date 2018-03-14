TITLE Pi Calculation					(main.asm)

; 
;========================================================
; Student Name: Wilbert
; Student ID: 0416106
; Email: wilbert.phen@gmail.com
;========================================================
; Instructor: Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Assembly Language 
; Date: 2017/02/27
;========================================================
; Description:
;
; 
; Compute the estimated value of pi 1 - 1/3 + 1/5 - ...
; Maximum number of terms is 100 000.
;

INCLUDE Irvine32.inc
INCLUDE macros.inc

.data

MAX = 100000 ;maximum number of terms
ZERO	REAL8	0.0
ONE		REAL8	1.0
TWO		REAL8	2.0
FOUR	REAL8	4.0
ANS		REAL8	0.0
NUM		REAL8	1.0
SIGN	REAL8	1.0
.code
main PROC

	mWrite <"My Student Name: Wilbert", 0dh, 0ah>
	mWrite <"My Student ID: 0416106", 0dh, 0ah>
	mWrite <"My Student Email: wilbert.phen@gmail.com", 0dh, 0ah, 0dh, 0ah>
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Input an integer
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
L0:
	mWrite "Please enter the number of terms (1-100 000): "
	call ReadInt		; read an integer
	cmp EAX, 0			; compare eax to MAX
	jl L0				; go back to input an integer above
	je fin				; jump out of forever loop
	cmp EAX, MAX		; compare input with maximum n allowed
	jle set_appropriate_n			; input is accepted
	mov EAX, 100000					; if more than 100k then set it to 100k

set_appropriate_n:
	;
	mov ecx, eax		; move value of eax to ecx. ECX is the loop counter
	mov eax, 0			; set eax as ZERO

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Reset all re-used variable
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	fld ZERO			;load zero to ST(0)
	fstp ANS		;reset answer
	fld ONE			;load one to ST(0)
	fstp NUM		;reset number
	fld ONE			;load one to ST(0)
	fstp SIGN		;reset sign

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Calculation
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
L1:
	finit
	fld SIGN		;load last divisor to FPU
	fld NUM			;load one to be dividend
	fdiv			;do ST(1) / ST(0)
	fld ANS			;load ANS into ST(0)
	fadd			;add ANS and last calculated term
	fstp ANS		;store back answer

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Increase divisor
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	finit			;reset FPU
	fld NUM			;load NUM to ST(0)
	fld TWO			;load two to ST(0)
	fadd			;add last divisor number with two to results in next term
	fstp NUM		;store back next term

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Change sign
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	fld SIGN		;load sign into ST(0)
	fchs			;change he sign of variable sign
	fstp SIGN		;store back sign


	loop L1			;Loop for number of terms

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;print the sum
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mWrite "Estimated pi value: "
	finit
	fld ANS				;load ANS into ST(0)
	fld FOUR			;load 4 into ST(0)
	fmul				;multiply pi/4 with 4 to get pi estimation
	call WriteFloat		;show ST(0) to write pi
	mWrite <0dh, 0ah, 0dh, 0ah>	;go down a line
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;exit program
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	jmp L0				; forever loop

fin:
	INVOKE ExitProcess, 0
main ENDP

END main
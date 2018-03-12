.data
msg1:		.asciiz	"Enter first integers: "
msg2:		.asciiz	"Enter second integers: "
msg3:		.asciiz	"Greatest common divisor: "


.text
.globl main
#--------------------main------------------------------
main:
#print msg1 on the console interface
	li			$v0, 4			#call system call: print string
	la			$a0, msg1		#load adress of string into $a0
	syscall						#run the syscall
#read first integer
	li			$v0, 5			#read integer
	syscall						#run the syscall
	add			$a1, $v0, $zero	#move inputted int to $a1
	
#print msg2 on the console interface
	li			$v0, 4			#call system call: print string
	la			$a0, msg2		#load adress of string into $a0
	syscall						#run the syscall
#read second integer
	li			$v0, 5			#read integer
	syscall						#run the syscall
	add			$a2, $v0, $zero	#move inputted int to $a2
	
	jal			gcd				#call procedure gcd
	add			$a3, $v0, $zero	#save answer
	

#print msg3 on the console interface
	li			$v0, 4			#call system call: print string
	la			$a0, msg3		#load adress of string into $a0
	syscall						#run the syscall
#print answer on the console interface
	li			$v0, 1			#call system call: print string
	add			$a0, $a3, $zero	#load answer into $a0
	syscall						#run the syscall
#----------------exit----------------------
	li $v0, 10					# call system call: exit
	syscall						# run the syscall

	
	
#-----------------------------procedure for gcd--------------------------
#a1 is m and $a2 is n
.text
gcd:
	addi	$sp, $sp, -4				#open stack
	sw		$ra, 0($sp)					#save return address
	bne		$a2, $zero, end_condition	#if condition fails
	add		$v0, $zero, $a1				#return m
	j		returning					#preparation to return
end_condition:
	add		$t0, $a1, $zero				#old m value
	add		$a1, $a2, $zero				#new value of m
	div		$t0, $a2					#m/n
	mfhi	$a2							#new value for n
	jal		gcd							#recursive call
returning:
	lw		$ra, 0($sp)					#load back return address
	addi	$sp, $sp, 4					#pop stack
	jr		$ra							#return to caller

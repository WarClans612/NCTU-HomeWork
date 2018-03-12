.data
msg1:		.asciiz "Pascal Triangle \nPlease enter the number of levels(1~30): "
space:		.asciiz " "
enter:		.asciiz "\n"

.text
.globl main
#--------------------------------main-------------------------------
main:
#print msg1 on the console interface
	li			$v0, 4			#call system call: print string
	la			$a0, msg1		#load adress of string into $a1
	syscall						#run the syscall
	
#read an integer
	li			$v0, 5			#read integer
	syscall						#run the syscall
	add			$s0, $v0, $zero	#move inputted int to $a0
	
#------------------------------
	add			$s1, $zero, $zero	#$s1 is i(counter)
outer_loop:
	beq			$s1, $s0, quit_outer_loop	#quit_outer_loop
	
#--------------------
	add			$s2, $zero, $zero		#$s2 is j(counter)
inner_loop:
	bgt			$s2, $s1, quit_inner_loop		#quit_inner_loop
	beq			$s2, $zero, temp_continuation	#if(j==0) then continue
	beq			$s2, $s1, temp_continuation		#if(j==i) then continue
	j			temp_not_one					#if condition fails
temp_continuation:
	li			$t0, 1						#temp = 1
	j			temp_condition_ok			#skip else
temp_not_one:
	sub			$t1, $s1, $s2		#i - j
	addi		$t1, $t1, 1			#(i-j) + 1
	mul			$t0, $t0, $t1		#temp*(i-j+1)
	div			$t0, $t0, $s2		#temp/j
temp_condition_ok:

	li			$v0, 4				#call system call:print string
	la			$a0, space			#load space to be printed
	syscall							#run the syscall
	li			$v0, 1				#call system call:print int
	add			$a0, $t0, $zero		#load answer to be printed
	syscall							#run the syscall
	addi		$s2, $s2, 1				#increase j(counter)
	j			inner_loop				#loop back to inner_loop
quit_inner_loop:
#--------------------

	li			$v0, 4			#call system call:print string
	la			$a0, enter		#load addres to be printed
	syscall						#run the syscall
	addi		$s1, $s1, 1		#increase i(counter)
	j		outer_loop			#loop back to outer_loop
quit_outer_loop:
#------------------------------

#----------------exit----------------------
	li $v0, 10					# call system call: exit
	syscall						# run the syscall
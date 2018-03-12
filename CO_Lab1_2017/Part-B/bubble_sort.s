.data
msg1:	.asciiz	"The array before sort : "
msg2:	.asciiz	"The array after  sort : "
space:	.asciiz	" "
enter:	.asciiz "\n"

n:			.word	10
num:		.word	5, 3, 6, 7, 31, 23, 43, 12, 45, 1

.text
.globl main
#--------------------------------main-------------------------------
main:
#print msg1 on the console interface
	li		$v0, 4			#call system call: print string
	la		$a0, msg1		#load adress of string into $a1
	syscall					#run the syscall
	li		$v0, 4				#call system call:print string
	la		$a0, enter			#load addres to be printed
	syscall						#run the syscall
	
#print the unsorted array in variable number into console interface
	la		$a1, num			#load base address of num to register
	lw		$a2, n				#load n into register
	li		$t0, 0				#load index
print_unsorted:
	beq		$t0, $a2, quit_print_unsorted		#quit the loop if all have been iterated
	sll		$t1, $t0, 2			#$t1 = $t0 * 4 (number of bytes from the base)
	add		$t2, $a1, $t1		#set the pointer to the wanted address
	li		$v0, 1				#call system call: print interface
	lw		$a0, 0($t2)			#load address of number to be printed into $a1
	syscall						#run the syscall
	li		$v0, 4				#call system call:print string
	la		$a0, space			#load addres to be printed
	syscall						#run the syscall
	addi	$t0, $t0, 1			#add index number
	j		print_unsorted
quit_print_unsorted:
	li		$v0, 4				#call system call:print string
	la		$a0, enter			#load addres to be printed
	syscall						#run the syscall
	
	jal		bubblesort
#print msg2 on the console interface
	li		$v0, 4			#call system call: print string
	la		$a0, msg2		#load adress of string into $a1
	syscall
	li		$v0, 4				#call system call:print string
	la		$a0, enter			#load addres to be printed
	syscall						#run the syscall
	
#print the sorted array in variable number into console interface
	li		$t0, 0				#initialize $t0
print_sorted:
	beq		$t0, $a2, quit_print_sorted		#quit the loop if all have been iterated
	sll		$t1, $t0, 2			#$t1 = $t0 * 4 (number of bytes from the base)
	add		$t2, $a1, $t1		#set the pointer to the wanted address
	li		$v0, 1				#call system call: print interface
	lw		$a0, 0($t2)			#load address of number to be printed into $a1
	syscall						#run the syscall
	li		$v0, 4				#call system call:print string
	la		$a0, space			#load addres to be printed
	syscall						#run the syscall
	addi	$t0, $t0, 1			#add index number
	j		print_sorted
quit_print_sorted:	

#----------------exit----------------------
	li $v0, 10					# call system call: exit
	syscall						# run the syscall

	
#-----------------------procedure for bubble sort----------------------	
#The array base address located at $a1
#The max number located in $a2
.text
bubblesort:
	addi	$sp, $sp, -20				#open stack to store items
	sw		$ra, 0($sp)					#save return address into stack
	li		$s0, 0						#initialize counter for outer loop
outer_loop:
	beq		$s0, $a2, quit_outer_loop	#quit looping
	sw		$s0, 4($sp)					#save counter for outer loop into stack
	add		$s1, $s0, $zero				#initialize index for inner loop
	addi	$s1, $s1, -1				#j = i - 1 
#-----------------------
inner_loop:
	blt		$s1, $zero, quit_inner_loop	#quit loop if index less than zero
	sll		$t0, $s1, 2					#$t0 = $s1 * 4
	add		$t0, $a1, $t0				#set the pointer to wanted address
	lw		$t1, 0($t0)					#v[j]
	lw		$t2, 4($t0)					#v[j+1]
	ble		$t1, $t2, quit_inner_loop	#quit loop if v[j] <= v[j+1]
	
	sw		$s1, 8($sp)					#save inner loop index into stack
	sw		$a1, 12($sp)				#save array base addres into stack
	sw		$a2, 16($sp)				#save max number into stack
	add		$a2, $s1, $zero				#move inner loop index as argument for function call
	jal		swap
	lw		$a1, 12($sp)				#load array base addres from stack
	lw		$a2, 16($sp)				#load max number from stack
	lw		$s1, 8($sp)					#load back inner loop index
	
	addi	$s1, $s1, -1				#decrease inner loop index
	j		inner_loop
quit_inner_loop:
#-----------------------
	lw		$s0, 4($sp)					#load back outer loop counter
	addi	$s0, $s0, 1					#add outer loop counter
	j		outer_loop
quit_outer_loop:
	lw		$ra, 0($sp)					#load back return address
	addi	$sp, $sp, 20				#pop items from stack
	jr		$ra							#jump to caller
	
	
#---------------------procedure for swap----------------------------------
#The array base address located at $a1
#The index number located in $a2
.text
swap:
	sll		$t0, $a2, 2			#$t0 = $a2 * 4 (number of bytes from the base)
	add		$t0, $a1, $t0		#set the pointer to the wanted address
	lw		$t1, 0($t0)			#temp1 = v[k]
	lw		$t2, 4($t0)			#temp2 = v[k+1]
	sw		$t2, 0($t0)			#v[k] = v[k+1]
	sw		$t1, 4($t0)			#v[k+1] = temp1
	jr		$ra					#jump to caller
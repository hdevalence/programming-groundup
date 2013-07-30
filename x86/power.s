# Third example: using functions with the C ABI.

.section .data
.section .text
.globl _start
_start:
	# We're going to compute 2^3 + 5^2.

	# Call power to compute 2^3
	pushl	$3		# Push 2nd arg to stack
	pushl	$2 		# Push 1st arg to stack
	call 	power		# call function
	addl	$8, %esp 	# Move stack pointer back
	pushl 	%eax		# Save answer

	# Call power to compute 5^2
	pushl	$2		# Push 2nd arg to stack
	pushl	$5 		# Push 1st arg to stack
	call 	power		# call function
	addl	$8, %esp 	# Move stack pointer back

	popl 	%ebx		# Since the second answer is
				# in %eax already, we just
				# need to pop the first return
				# value (which we pushed to the
				# stack above).
	
	addl 	%eax, %ebx 	# Add %eax to %ebx

	movl 	$1, %eax 	# Exit (recall that exit syscall
				# reads retval from %ebx).
	int 	$0x80

#
# Function: 
# 	compute the value of a number raised to a given power.
#
# Input: 
#	arg 1: base
#	arg 2: exponent
#
# Output: returns the computed value.
#
# Variables:
# 	%ebx - base
#	%ecx - exponent
#	-4(%ebp) - holds the current result
.type power, @function
power:
	pushl 	%ebp 		# save base pointer
	movl 	%esp, %ebp 	# set base pointer to stack ptr
	subl 	$4, %esp 	# make room for local storage

	movl	8(%ebp), %ebx 	# load first arg in %eax
	movl	12(%ebp), %ecx	# load second arg in %ecx

	movl	%ebx, -4(%ebp)	# store current result
power_loop_start:
	cmpl	$1, %ecx	# if exponent is 1,
	je	end_power	# then quit.

	movl 	-4(%ebp), %eax 	# move current result into %eax
	imull 	%ebx, %eax 	# mul %eax by %ebx (the base)
	movl 	%eax, -4(%ebp)	# store current result
	decl 	%ecx 		# decrement exponent
	jmp 	power_loop_start
end_power:
	movl -4(%ebp), %eax 	# Store return val in %eax
	movl %ebp, %esp 	# restore stack pointer
	popl %ebp 		# restore base pointer
				# which we stored at the start
	ret


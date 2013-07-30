# Third example: using functions with the C ABI.
# This one is modified to use a binary exponentiation
# algorithm.

.section .data
.section .text
.globl _start
_start:
	# Call power to compute 3^5
	pushl	$5		# Push 2nd arg to stack
	pushl	$3 		# Push 1st arg to stack
	call 	power		# call function
	addl	$8, %esp 	# Move stack pointer back

	movl 	%eax, %ebx 	# 
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
# 	%ebx - base (x)
#	%ecx - exponent
#       -4(%ebp) - r
#	-8(%ebp) - y
.type power, @function
power:
	pushl 	%ebp
	movl 	%esp, %ebp
	subl	$8, %esp 	# Allocate stack memory

	movl	8(%ebp), %ebx 	# load first arg in %ebx
	movl	12(%ebp), %ecx	# load second arg in %ecx
	movl 	$1, -4(%ebp) 	# set r = 1
	movl 	%ebx, -8(%ebp)  # set y = x

power_loop_start:
	cmpl	$1, %ecx	# if exponent is 1,
	je	end_power	# then quit.
	movl 	%ecx, %edx
	and 	$1, %edx 	# set %edx to lsb of exponent
	movl 	-8(%ebp), %eax 	# load y into %eax
	jz 	power0		# if exponent even, skip odd part
	movl 	-4(%ebp), %edx 	# load r into %edx
	imull 	%eax, %edx 	# set r <- r * y
	movl 	%edx, -4(%ebp)
power0:	imull 	%eax, %eax 	# square y
	movl 	%eax, -8(%ebp)
	shr 	$1, %ecx 	# divide exponent by 2
	jmp 	power_loop_start
end_power:
	movl 	-8(%ebp), %eax
	movl 	-4(%ebp), %edx
	imull 	%edx, %eax 	# Set %eax = r*y for return
	movl	%ebp, %esp
	popl 	%ebp
	ret


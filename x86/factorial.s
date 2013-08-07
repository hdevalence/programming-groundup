# Compute the factorial of a number.

.section .text
.globl _start
.globl factorial 
_start:
	pushl 	$4		# factorial takes one argument,
				# so push it to the stack.
	call factorial
	addl	$4, %esp	# Move stack pointer back,
				# "erasing" the value we just pushed
	movl	%eax, %ebx	# factorial returns into eax,
				# and we pass ebx as the argument
				# to the exit() syscall
	movl 	$1, %eax 	# Set syscall id
	int 	$0x80

.type factorial, @function
factorial:
	pushl 	%ebp		# We need to be able to restore 
				# the base pointer when we return
				# so we push it to the stack
	movl 	%esp, %ebp 	# We don't want to modify the stack
				# pointer, so we use the base pointer
				# instead.
	movl 	8(%ebp), %eax 	# 4(%ebp) holds the return address,
				# and 8(%ebp) holds param 1. So this
				# loads param 1 into %eax.
	cmpl 	$1, %eax 	# Check base case n=1
	je 	end_factorial	# If n=1, then return %eax (which is 1)
	decl	%eax 		# Recurse with n-1
	pushl   %eax
	call 	factorial 
	movl 	8(%ebp), %ebx 	# Set %ebx to n
	imull 	%ebx, %eax 	# Multiply (n-1)! [in %eax] by n
				# and store it in %eax.
	end_factorial:
	movl 	%ebp, %esp 	# Restore stack pointer
	popl 	%ebp 		# Restore base pointer
	ret 			# return


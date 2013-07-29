#Second example: maximum.s
#Finds the maximum number of a set of items.
#
#Variables:
# %edi - index of current item
# %ebx - largest item so far
# %eax - current data item
#
#Memory:
# data_items - contains the data to search, terminated with 0.

	.section .data
	# This holds the data we'll process.
	# data_items refers to the address of the first item,
	# and .long is a 32-bit uint (Holdover from 16-bit 8086).
data_items:
	.long 3,52,25,32,38,64,45,3,49,83,77,39,38,93,0

	.section .text

	.globl _start
_start:
	movl $0, %edi			# set index register to 0
	movl data_items(,%edi,4), %eax 	# load first item of data
	movl %eax, %ebx 		# initialize the max item
					# with the first element
start_loop:
	cmpl $0, %eax 			# Test for end of data
	je loop_exit
	incl %edi 			# load next item
	movl data_items(,%edi,4), %eax
	cmpl %ebx, %eax 		# compare item with max
	jle start_loop 			# if item is smaller,
					# jump to loop beginning
	movl %eax, %ebx 		# update largest value
	jmp start_loop

loop_exit:
	# N.B. We don't need to set the %ebx register before 
	# making the system call to return the largest item,
	# since we are already storing it in the %ebx register.
	movl $1, %eax 			# 1 is exit() syscall
	int $0x80


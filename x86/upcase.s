# Convert an input file to an output file with all letters
# converted to uppercase.
#

.section .data

	## Constants
	.equ SYS_OPEN,	5
	.equ SYS_WRITE,	4
	.equ SYS_READ,	3
	.equ SYS_CLOSE,	6
	.equ SYS_EXIT,	1

	.equ O_RDONLY,	0
	.equ O_CREAT_WRONLY_TRUNC,	03101
	.equ STDIN,	0
	.equ STDOUT,	1
	.equ STDERR,	2

	.equ LINUX_SYSCALL,	0x80
	.equ END_OF_FILE,	0
	.equ NUMBER_ARGUMENTS,	2

.section .bss
	.equ BUFFER_SIZE,	512
	.lcomm BUFFER_DATA,	BUFFER_SIZE

.section .text
	# Stack positions
	.equ ST_SIZE_RESERVE,	8
	.equ ST_FD_IN,	-4
	.equ ST_FD_OUT,	-8
	.equ ST_ARGC,	0
	.equ ST_ARGV_0,	4
	.equ ST_ARGV_1,	8
	.equ ST_ARGV_2,	12

	.globl _start
_start:
	# Initialise.
	movl 	%esp, %ebp 		# Save stack pointer
	# Allocate space for file descriptors on the stack.
	subl	$ST_SIZE_RESERVE, %esp
	# Open input file
	movl 	$SYS_OPEN, %eax
	movl 	ST_ARGV_1(%ebp), %ebx 	# Set %ebx to first arg
	movl 	$O_RDONLY, %ecx 	# Set file mode
	movl 	$0666, %edx 		# Permissions (not really
					# needed for reading).
	int 	$LINUX_SYSCALL 
	movl 	%eax, ST_FD_IN(%ebp) 	# Save file descriptor.
	# Open output file
	movl 	$SYS_OPEN, %eax
	movl 	ST_ARGV_2(%ebp), %ebx 	# Set %ebx to first arg
	movl 	$O_CREAT_WRONLY_TRUNC, %ecx 	# Set file mode
	movl 	$0666, %edx 		# Permissions
	int 	$LINUX_SYSCALL 
	movl 	%eax, ST_FD_OUT(%ebp) 	# Save file descriptor.

read_loop_begin:
	# Read a block from the input file
	movl 	$SYS_READ, %eax
	movl 	ST_FD_IN(%ebp), %ebx
	movl 	$BUFFER_DATA, %ecx
	movl 	$BUFFER_SIZE, %edx
	int 	$LINUX_SYSCALL

	cmpl 	$END_OF_FILE, %eax 	# Check for EOF
	jle 	end_loop
	# Convert to upper case
	pushl 	$BUFFER_DATA 		# Location of buffer
	pushl 	%eax 			# size of buffer
	call 	convert_to_upper 
	popl 	%eax 			# Restore size
	addl 	$4, %esp 		# Restore stack pointer
	# write to output file
	movl 	%eax, %edx		# Size of buffer
	movl 	$SYS_WRITE, %eax 	# Syscall
	movl 	ST_FD_OUT(%ebp), %ebx 	# file descriptor
	movl 	$BUFFER_DATA, %ecx 	# location of buffer
	int 	$LINUX_SYSCALL
	# Continue the loop
	jmp 	read_loop_begin

end_loop:
	# Close the files
	movl 	$SYS_CLOSE, %eax
	movl 	ST_FD_OUT(%ebp), %ebx
	int 	$LINUX_SYSCALL

	movl 	$SYS_CLOSE, %eax
	movl 	ST_FD_IN(%ebp), %ebx
	int 	$LINUX_SYSCALL

	movl 	$SYS_EXIT, %eax
	movl 	$0, %ebx
	int 	$LINUX_SYSCALL

# Convert a block of memory to uppercase

# Constants
.equ LOWERCASE_A,	'a'
.equ LOWERCASE_Z,	'z'
.equ UPPER_CONVERSION,	'A'-'a'
.equ ST_BUFFER_LEN, 	8
.equ ST_BUFFER, 	12

convert_to_upper:
	pushl 	%ebp
	movl 	%esp, %ebp
	movl 	ST_BUFFER(%ebp), %eax
	movl 	ST_BUFFER_LEN(%ebp), %ebx
	movl 	$0, %edi
	cmpl 	$0, %ebx 		# Check for empty buffer
	je 	end_convert_loop

convert_loop:
	movb 	(%eax, %edi, 1), %cl 	# Get current byte

	cmpb 	$LOWERCASE_A, %cl 	# Skip if not in [a-z]
	jl 	next_byte
	cmpb 	$LOWERCASE_Z, %cl
	jg 	next_byte

	addb 	$UPPER_CONVERSION, %cl 	# convert to uppercase
	movb 	%cl, (%eax, %edi, 1) 	# store upcased byte

next_byte:
	incl 	%edi
	cmpl 	%edi, %ebx
	jne 	convert_loop 		# Resume loop if not at end

end_convert_loop:
	movl 	%ebp, %esp
	popl 	%ebp
	ret
















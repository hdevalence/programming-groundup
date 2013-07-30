# Program that returns an exit code.
# First example from the programming from the ground up book.

.section .data

.section .text
.globl _start
_start:
movl $1, %eax #syscall no. for exit
movl $0, %ebx #status number
int $0x80     #wakes kernel to run exit command



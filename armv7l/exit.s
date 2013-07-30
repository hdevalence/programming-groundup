/*
 * exit.s ported to arm
 */
.section .data

.section .text
.globl _start
_start:
	mov	    %r0, $0		/* Arguments are placed in r0,r1,...,r6 */
	mov	    %r7, $1		/* exit() has syscall no 1 */
	swi 	0	    	/* call kernel with swi 0 */


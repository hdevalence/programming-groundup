/*
 * port of maximum.s to ARM
 */
	.section .data
data_items:
	.int 3,52,25,32,38,64,45,3,49,83,77,39,38,93,0

	.section .text

	.globl _start
_start:
	ldr	r1,=data_items	/* set r1 to point to data */
	mov	r0,$0		/* init max item to 0 */
loop:	ldr	r2,[r1],#4	/* load next item and inc ptr */
	cmp	r2,r0		/* compare current item to max */
	movgt	r0,r2		/* update max if current item greater */
	cmp	r2,$0		/* check for end */
	bne	loop		/* if end nonzero, branch to loop */

	mov	r7,$1		/* we stored max in r0 already */
	swi	0		/* return max */

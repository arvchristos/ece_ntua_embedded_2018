.globl   strcmp
.p2align 2
.type    strcmp,%function

/*parameters in r0,r1*/
strcmp:
    push {r1-r4}  /* save des registres */
    mov r2,#0   /* counter */
1:      
    ldrb r3,[r0,r2]   /* byte string 1 */
    ldrb r4,[r1,r2]   /* byte string 2 */
    cmp r3,r4
    movlt r0,#-1         /* small */    
    movgt r0,#1  /* greather */         
    bne 100f     /* not equals */
    cmp r3,#0   /* 0 end string */
    moveq r0,#0    /* equals */         
    beq 100f     /*  end string */
    add r2,r2,#1 /* else add 1 in counter */
    b 1b         /* and loop */
100:
    pop {r1-r4}
    bx lr   

.globl strlen
.p2align 2
.type strlen,%function

strlen:
	push {r1-r4}
	mov r1,#0
1:
	ldrb r3,[r0,r1]
	cmp r3,#0
	beq 100f
	add r1,r1,#1
	b 1b
100:
	mov r0,r1
	pop {r1-r4}
	bx lr

.globl strcpy
.p2align 2
.type strcpy,%function

strcpy:
	push {r1-r4}
	mov r2, #0
1:
	ldrb r3,[r1,r2]   /* byte string 1 */
	cmp r3,#0
	beq 100f
	strb r3,[r0,r2]   /* byte string 2 */

   	add r2,r2,#1 /* else add 1 in counter */
   	b 1b         /* and loop */

100:	
	mov r3,#0
	strb r3, [r0,r2]
        pop {r1-r4}
        bx lr

.globl strcat
.p2align 2
.type strcat,%function

/* r0 ->dest r1 ->source */

strcat:
        push {r1-r5}
        mov r2, #0
1:
        ldrb r3,[r0,r2]   /* byte string 1 */
        cmp r3,#0
        beq 10f
        add r2,r2,#1 /* else add 1 in counter */
        b 1b         /* and loop */
10:
	mov r4,#0
100:
	ldrb r5,[r1,r4]
	strb r5,[r0,r2]
	cmp r5,#0
	beq 1000f
	add r2,r2,#1
	add r4,r4,#1
	b 100b
	  

1000:    
        pop {r1-r5}
        bx lr




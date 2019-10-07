.global main

main:
	mov r5, r0 /*r5 is the file descriptor of output.txt*/

	mov r0, #1 /* first argument -> stdout*/
	ldr r1, =output_string /*second argument -> memory where output string is stored*/
	mov r2, #len /* third argument -> number of bytes of output message. len is a constant and thus its valus is moved to r2 */

	mov r7, #4 /* number of write system call */
	swi 0

inp1:

	mov r0, #0 /* first argument -> stdin*/
	ldr r1, =inp_str /*second argument -> memory where input string will be stored*/
	mov r2, #33 /* third argument -> number of bytes to be read */
	mov r7, #3 /* number of read system call */
	swi 0

	/*
		check if more than expected characters in input 
		characters readed are returned in r0 register
	*/

	cmp r0,#32
	ble no_flush

	/* check thatthe last readed is not a newline. If it is advance else flysh the input buffer with another really long read */
	ldr r1,=inp_str
	ldr r0,[r1,#32]

	cmp r0, #10

	beq no_flush
	mov r0, #0
	ldr r1, =inp_str_f
	mov r2,#1000
	mov r7, #3
	swi 0 
no_flush:
	/*Check for Q */
	ldr r0, =check_1
	ldr r1, =inp_str

	bl comparStrings
	cmp r0,#0
	beq exiter

	/*Cheeck for q */
        ldr r0, =check_2
        ldr r1, =inp_str

        bl comparStrings
        cmp r0,#0
        beq exiter

	/*cmp r0, #8  read returns how many bytes have been read, compare it with 8 */
	/*bne inp1 if it is not equal to 8, read again */

	mov r0, #1
	ldr r1, =result_prompt
	mov r2, #len_res_prompt
	mov r7, #4
	swi 0

	/* Here starts the fun */
	ldr r0, =inp_str
	ldr r1, =inp_str_tran
	bl transform_string

        mov r0, #1
        ldr r1, =new_line
        mov r2, #len_new_line
        mov r7, #4
        swi 0

/*
        mov r0, #1
        ldr r1, =result_prompt
        mov r2, #len_res_prompt
        mov r7, #4
        swi 0
*/

	b main /*jump to main for continuous execution*/
exiter:	
	mov r0, #0 /* first argument -> status = 0, everything ok*/
	mov r7, #1 /* number of exit system call */
	swi 0


/************************************/	   
/* Strings case sensitive comparisons  */
/************************************/	  
/* r0 et r1 contains the address of strings */
/* return 0 in r0 if equals */
/* return -1 if string r0 < string r1 */
/* return 1  if string r0 > string r1 */
comparStrings:
    push {r1-r4}  /* save des registres */
    mov r2,#0   /* counter */
1:	
    ldrb r3,[r0,r2]   /* byte string 1 */
    ldrb r4,[r1,r2]   /* byte string 2 */
    cmp r3,r4
    movlt r0,#-1	 /* small */ 	
    movgt r0,#1	 /* greather */ 	
    bne 100f     /* not equals */
    cmp r3,#0   /* 0 end string */
    moveq r0,#0    /* equals */ 	
    beq 100f     /*  end string */
    add r2,r2,#1 /* else add 1 in counter */
    b 1b         /* and loop */
100:
    pop {r1-r4}
    bx lr   

transform_string:
	push {r1-r4}
	mov r2, #-1
	mov r6,#0
	mov r7,r0 /*input string */
	mov r8,r1/* output transformed string */
	ldr r9, =freq
	ldr r10,=arrow
start:
	add r2,r2,#1
	cmp r2, #33
	beq printert
	ldrb r3, [r7,r2]
	cmp r3, #32
	ble start
	
	sub r3,r3,#32
	ldrb r6, [r9,r3]
	add r6,r6,#1
	strb r6, [r9,r3]

	b start
printert:
        ldr r0, =filename
        movw r1, #1089 @ O_WRONLY | O_CREAT
        ldr r2, =0666
        mov r7, #5
        swi 0
        /*error checking*/
        cmp r0, #0
        blt exitert

        mov r5, r0 /*r5 is the file descriptor of output.txt*/
	ldr r10,=arrow

	mov r11, #-1
iterate_inp:
	ldr r7,=inp_str
        add r11,r11,#1
        cmp r11, #33
	beq exitert
	ldrb r3, [r7,r11]
	mov r4, #0
	strb r4, [r7,r11]
	cmp r3, #'\n'
	beq exitert

	sub r4,r3,#32
        ldrb r6, [r9,r4]

	cmp r6, #0
	beq iterate_inp

	/*add r6,r6,#48*/
/*	mov r1,r6
	bl f_division
*/

	ldr r0,=inp_str_tran
        mov r1,r3
        strb r1, [r0,#0]
        ldr r2, =inp_str_tran


	mov r0,r5
        mov r1, r2 
        mov r2,#1
        mov r7, #4
        swi 0

        mov r1,r6
f_division:
        push {r1-r8}
        ldr r7,=inp_str_tran
        cmp r1, #10
        bge tens
        add r1,r1,#48
        strb r1,[r7,#0]
        b exiter1
tens:
        cmp r1,#20
        bge twenties
        mov r3,#'1'
        strb r3, [r7,#0]
        add r1,r1,#38
        strb r1, [r7,#1]
        b exiter1
twenties:
        cmp r1,#30
        bge thirties
        mov r3,#'2'
        strb r3, [r7,#0]
        add r1,r1,#28
        strb r1, [r7,#1]
        b exiter1
thirties:
        mov r3,#'3'
        strb r3, [r7,#0]
        add r1,r1,#18
        strb r1, [r7,#1]

exiter1:
	pop {r1-r8}

        mov r0,r5
        mov r1,r10 @arrow symbol
        mov r2,#4 @length of arrow
        mov r7, #4
        swi 0

/*
	ldr r0,=inp_str_tran
	mov r1,r6
	strb r1, [r0,#0]
*/	ldr r2, =inp_str_tran


        mov r0,r5
        mov r1, r2 
        mov r2,#3
        mov r7, #4
        swi 0

/*
	mov r0,r5
	mov r1,r10 @arrow symbol
	mov r2,#4 @length of arrow
	mov r7, #4
	swi 0
*/
	mov r6,#0
	strb r6, [r9,r4]

	b iterate_inp
exitert:
    	pop {r1-r4}
   	bx lr

.data
	output_string: .ascii "Input a string of up to 32 char long: " /* location of output string in memory */
len = . - output_string /* length of output_string is the current memory indicated by (.) minus the memory location of the first element of string. Len does not occupy memory. It is a constant for the assembler. */
/* pre-allocate 8 bytes for input string, initialize them with null character '/0'*/
	result_prompt: .ascii "Result is: "
len_res_prompt = . - result_prompt

	inp_str: .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
	inp_str_tran: .ascii "\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
	new_line: .ascii "\n"
len_new_line = . - new_line
	check_1: .asciz "Q\n"
	check_2: .asciz "q\n"
	
	inp_str_f: .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

	filename: .asciz "output.txt"

	freq: .skip 400
	
	arrow: .ascii " -> "

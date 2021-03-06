.global main
.func main 

main:
	BL _scanf
	MOV R1, R0
	
	PUSH {R1}
	BL _scanf
	POP {R1}
	MOV R2, R0
	
	PUSH {R1}
	PUSH {R2}
	
	BL count_partitions
	
	POP {R2}
	POP {R1}
	
	MOV R3, R2
	MOV R2, R1
	MOV R1, R0
	
	BL _printf
	
_scanf: 
	PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC} 
	

count_partitions:
	PUSH {LR}
	
	CMP R1, #0
	MOVEQ R0, #1
	POPEQ {PC}
	
	CMP R1, #0
	MOVLT R0, #0
	POPLT {PC}
	CMP R2, #0
	MOVEQ R0, #0
	POPEQ {PC}
	
	PUSH {R2}
	SUB R2, R2, #1
	
	BL count_partitions
	POP {R2}
	PUSH {R1}
	PUSH {R0}
	SUB R1, R1, R2
	
	BL count_partitions
	POP {R3}
	ADD R0, R0, R3
	POP {R1}
	POP {PC}
	
_printf:
	PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}
.data
format_str:		.asciz		"%d"
exit_str:		.ascii		"Terminating program.\n"
printf_str:		.asciz		"There are %d partitions of %d using integers up to %d\n"

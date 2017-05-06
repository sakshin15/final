.global main
.func main

main:
 BL _scanf1
 MOV R1, R0
 PUSH {R1}
 BL _scanf2
 MOV R2, R0
 @POP {R1}
 PUSH {R1}
 PUSH {R2}
 BL _count_partitions
 POP {R2}
 POP {R1}
 MOV R3, R2
 MOV R2, R1
 MOV R1, R0
 BL _printf
 @BL main


_scanf1:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str1     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

_scanf2:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str2     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

_count_partitions:
    PUSH {LR}
    CMP R1, #0              @if n==0
    MOVEQ R0, #1
    POPEQ {PC}
     
    CMP R1, #0
    MOVLT R0, #0            @if n<0
    POPLT {PC}

    CMP R2, #0              @if m==0
    MOVEQ R0, #0
    POPEQ {PC}

   
    PUSH {R2}
    SUB R2,R2,#1
    BL _count_partitions     @count_partitions(n,m-1)

    POP {R2}
    PUSH {R1}
    PUSH {R0}
    SUB R1,R1,R2             @count_partitions(n-m,m)
    BL _count_partitions

    POP {R3}
    POP {R0}
    POP {R1}
    ADD R0,R0,R3
    POP {PC}

_printf:
    PUSH {LR}
    LDR R0, =printf_str
    BL printf
    POP {PC}

.data

   format_str1:  .asciz  "%d"
   format_str2:  .asciz  "%d"
   printf_str:   .asciz  "There are %d partitions of %d using integers upto %d\n"

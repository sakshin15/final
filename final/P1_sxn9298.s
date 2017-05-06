.global main
.func main
   
main:
   
    BL  _scanf_num1             @ branch to scanf procedure with return: for first number
    MOV R8, R0              @ move return value R0 to argument register R8 
    
    BL  _getchar            @ branch to scanf procedure with return
    MOV R9, R0              @ move return value R0 to argument register R9
    
    BL  _scanf_num2             @ branch to scanf procedure with return: for second number
    MOV R10, R0             @ move return value R0 to argument register R10
    
    BL  add                 @branch to add, and perform the add operation
       
    BL main                 @branch back to main to keep the loop going
    
_scanf_num1:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
   
_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return
 
add:
    MOV R5, LR
    CMP R9, #'+'            @ compare against the constant char '+'
    BNE subtract            @ branch to subtract if comparison doesn't match
    ADD R1,R8,R10           @ perform the add operation
    BL _printf              @ print the result
    MOV PC,R5
    
subtract:
    MOV R5, LR
    CMP R9, #'-'            @ compare against the constant char '-'
    BNE multiply            @ branch to multiply if comparison doesn't match
    SUB R1,R8,R10           @ perform the subtraction operation
    BL _printf
    MOV PC,R5
    
multiply:    
    MOV R5, LR
    CMP R9, #'*'            @ compare against the constant char '*'
    BNE max                 @ branch to max if comparison doesn't match
    MUL R1,R8,R10           @ perform the multiplication operation
    BL _printf
    MOV PC,R5
    
max:    
    MOV R5, LR
    CMP R8, R10             @ compare the values entered
    MOVGT R10, R8
    MOV R1,R10
    BL _printf
    MOV PC,R5    
 
_correct:
    MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =equal_str      @ R0 contains formatted string address
    BL _printf              @ call printf
    MOV PC, R5              @ return
 
_incorrect:
    MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =nequal_str     @ R0 contains formatted string address
    BL printf               @ call printf
    MOV PC, R5              @ return
 

_scanf_num2:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return

_printf:
    MOV R4, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R1              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R4              @ return
    
    
.data
format_str:     .asciz      "%d"
read_char:      .ascii      " "
prompt_str:     .ascii      "Enter the  characters: "
equal_str:      .asciz      ""
nequal_str:     .asciz      "INCORRECT: %c \n"
exit_str:       .ascii      "Terminating program.\n"
printf_str:     .asciz      "%d\n"
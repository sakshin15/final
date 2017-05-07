.global main
.func main
   
main:
    MOV R0, #0              @ initialze index variable
writeloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2		          @ R2 now has the element address
    PUSH {R1}
    PUSH {R0}
    PUSH {R2}   
    BL _scanf            @branch to scanf to get the user input
    POP {R2}
    STR R0, [R2]            @ populate the array with the scanf values
    POP {R0}
    POP {R1}
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #0              @ initialze index variable
readloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration

readdone:
    BL _prompt                 @branch to prompt to ask for the search value
    BL _scanf                  @get the user input
    MOV R8, R0                 @move R0 to R8 so that we can compare the value with R1
   @BL _printf1
    MOV R0, #0                
    MOV R9, #-99             
    @BL search_value
   @B exit

search_value:
    
    CMP R0, #10            @ check to see if we are done iterating
    BEQ _search_complete            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R8}
    CMP R1, R8              @compare the search value with the values in the array
    MOVEQ R9, #88         
    @BNE _prompt2
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
   @ CMP R2, R8
   @MOVEQ R9,#88
    BLEQ _printf            @prints all the values found. Note: we cannot use BEQ as it prints only the first instance found
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    POP {R8}
    ADD R0, R0, #1          @ increment index
    B   search_value            @ branch to next loop iteration
_search_complete:
   CMP R9, #-99
   BLEQ _prompt2            @value not found string
   POP {R8}                 @free R8
   B _exit
_prompt: 
    MOV R7, #4
    MOV R0, #1
    MOV R2, #22
    LDR R1, =prompt_str
    SWI 0 
    MOV PC, LR

_prompt2: 
    MOV R7, #4
    MOV R0, #1
    MOV R2, #39
    LDR R1, =prompt_str1
    SWI 0 
    MOV PC, LR


_exit:
             @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printf1:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str1     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
_printf2:
   PUSH {LR}
   LDR R0, =prompt_str1
   BL printf
   POP {PC}

_scanf:
    PUSH {LR}
    SUB SP, SP, #4
    LDR R0, =format_str
    MOV R1, SP
    BL scanf
    LDR R0, [SP]
    ADD SP, SP, #4
    POP {PC}

.data

.balign 4
a:              .skip       40
printf_str:     .asciz      "array_a[%d] = %d\n"
exit_str:       .ascii      "Terminating program.\n"
format_str:     .asciz      "%d"
prompt_str:     .asciz      "ENTER A SEARCH VALUE: "
printf_str1:     .asciz      "The number entered was: %d\n"
prompt_str1:     .asciz      "The value does not exist in the array!\n"


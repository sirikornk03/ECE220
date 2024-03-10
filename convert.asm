.ORIG x3000

LD R0,BITS
ADD R2,R0,#0
ADD R3,R0,#0
ADD R4,R0,#0
ADD R5,R0,#0
ADD R6,R0,#0

; let's try PRINT_DECIMAL ... "1230"
LD R1,EXAMPLE

; set a breakpoint here in the debugger, then use 'next' to
; execute your subroutine and see what happens to the registers;
; they're not supposed to change (except for R7)...
JSR PRINT_DECIMAL

; we're short on human time to test your code, so we'll do 
; something like the following instead (feel free to replicate)...
LD R7,BITS
NOT R7,R7
ADD R7,R7,#1
ADD R0,R0,R7
BRz R0_OK
LEA R0,R0_BAD
PUTS
R0_OK 

; this trap changes register values, so it's not sufficient
; to check that all of the registers are unchanged; HALT may
; also lead to confusion because the register values differ
; for other reasons (R7 differences, for example).
HALT

BITS .FILL xABCD ; something unusual
EXAMPLE .FILL   #1230
R0_BAD .STRINGZ "PRINT_DECIMAL changes R0!\n"


; Subroutine to find the length of a string
STRLEN:
    AND R1, R1, #0          ; Clear R1 to store the length
    BRzp STRLEN_DONE        ; If the string is empty, return 0 immediately

    ; Loop to count characters until NUL terminator (x0000) is found
STRLEN_LOOP:
    LDR R2, R0, #0           ; Load the character at the current address
    BRz STRLEN_DONE         ; If NUL terminator, we are done
    ADD R0, R0, #1          ; Move to the next character in the string
    ADD R1, R1, #1          ; Increment the length counter
    BRnzp STRLEN_LOOP       ; Repeat the loop

STRLEN_DONE:
    RET

; Subroutine to print a non-negative integer in R1 as a decimal
PRINT_DECIMAL:
    ; Save registers
    ST R7, SAVE_R7
    ST R6, SAVE_R6
    ST R5, SAVE_R5
    ST R4, SAVE_R4

    ; Ensure R3 is zero
    AND R3, R3, #0

    ; Load the base address of the ASCII digit table
    LEA R4, DIGIT_TABLE

PRINT_DIGIT_LOOP:
    ADD R2, R1, #0          ; Copy the number in R1 to R2
    ; Check if R2 is zero
    BRz PRINT_DONE

    ; Divide R2 by 10
    ADD R5, R2, #0          ; Copy the number to R5
    ADD R2, R2, #-10        ; Divide R2 by 10 (subtract 10 repeatedly)

    ; Convert the digit to ASCII ('0' to '9')
    LDR R6, R4, #0          ; Load the ASCII digit
    OUT                     ; Print the ASCII character

    BRnzp PRINT_DIGIT_LOOP  ; Repeat the loop

PRINT_DONE:
    ; Restore registers
    LD R4, SAVE_R4
    LD R5, SAVE_R5
    LD R6, SAVE_R6
    LD R7, SAVE_R7
    RET

SAVE_R7 .BLKW 1
SAVE_R6 .BLKW 1
SAVE_R5 .BLKW 1
SAVE_R4 .BLKW 1

; Lookup table to convert digits to ASCII values ('0' to '9')
DIGIT_TABLE .FILL x0030  ; '0'
            .FILL x0031  ; '1'
            .FILL x0032  ; '2'
            .FILL x0033  ; '3'
            .FILL x0034  ; '4'
            .FILL x0035  ; '5'
            .FILL x0036  ; '6'
            .FILL x0037  ; '7'
            .FILL x0038  ; '8'
            .FILL x0039  ; '9'

; HALT to end the program
HALT

.END

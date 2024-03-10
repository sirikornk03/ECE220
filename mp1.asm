.ORIG x3000

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
    ST R3, SAVE_R3
    ST R0, SAVE_R0

    ; Ensure R3, R5 is zero
    AND R3, R3, #0
    AND R5, R5, #0 

    ; Load the base address of the ASCII digit table
    LD R7, ASCIIZERO

    ; Check if the number is zero
    BRz PRINT_ZERO
    BRnzp PRINT_DIGIT_LOOP

PRINT_ZERO:
    ADD R0, R4, R7       ; Load '0'
    OUT                     ; Print '0'
    BRnzp PRINT_DONE

PRINT_DIGIT_LOOP:   
;R1 =negative value, R2 = tempoaray value, R3 = count loop, R5 = positive vallue, R6 = check

    ; Copy the number in R1 to R2
    ADD R2, R1, #0
    
    ;initialize R1 to zero
    AND R1, R1, #0
    
    ;load the -10000 into R1
    LD R1, NEG_10000

    CHECK
    AND R3, R3, #0	 ;initialize R3 to zero	
    ADD R6, R2, R1      ;R6 = R2 - R1 (TENTHOUSAND)
    BRn START_AGAIN

    CONVERT_TENTHOUSAND
    ADD R3, R3, #1          	;count the loop to get the divisor
    ADD R2, R2, R1          	;divide R2 by 10000
    BRzp CONVERT_TENTHOUSAND   ;continue the loop for + and 0
    ADD R3, R3, #-1         	;restore the number
    LD R5, POS_10000		;load 10000 into R5
    ADD R2, R2, R5          	;restore the remainder
    BRnzp CONVERT_ASCII

    START_AGAIN
    LD R1, NEG_1000	     ;load -1000 into R1
    AND R3, R3, #0          ;initialize R3 to zero
    ADD R6, R2, R1          ;R6 = R2 - R1(ONE THOUSAND)
    BRz PRINT_ZERO
    BRn CHECK_AGAIN
    
    CONVERT_THOUSAND
    ADD R3, R3, #1          ; count the loop to get the divisor
    ADD R2, R2, R1          ; Divide R2 by 1000
    BRzp CONVERT_THOUSAND
    ADD R3, R3, #-1	     ;restore the number
    LD R5, POS_1000	     ;load 1000 into R5
    ADD R2, R2, R5	     ;restore remainder
    BRnzp CONVERT_ASCII

    CHECK_AGAIN
    LD R1, NEG_100          ;load -100 into R1
    AND R3, R3, #0          ;initialize R3 to zero
    ADD R6, R2, R1          ;R6 = R2(HUNDREDS) - R1 (ONE HUNDREDS)
    BRn CHECK10OR1

    CONVERT_HUNDRED         ;Divide R2 by 100
    ADD R3, R3, #1	     ;increment loop	
    ADD R2, R2, R1	     ;Divide R2 by 100
    BRzp CONVERT_HUNDRED
    ADD R3, R3, #-1	     ;restore the number
    LD R5, POS_100	     ;load 100 into R5
    ADD R2, R2, R5	     ;restore remainder
    BRnzp CONVERT_ASCII

    CHECK10OR1
    AND R6, R6, #0
    ADD R6, R2, #-10
    BRn CONVERT_ONES

    CONVERT_TEN 	     ;Divide R2 by 10
    ADD R3, R3, #1	     ;increment loop
    ADD R2, R2, #-10	     ;Divide R2 by 10
    BRzp CONVERT_TEN
    ADD R3, R3, #-1	     ;restore the number
    ADD R2, R2, #10	     ;restore remainder
    BRnzp CONVERT_ASCII

    CONVERT_ONES
    ADD R3, R3, #1	      ;increment loop
    ADD R2, R2, #-1	      ;Divide R2 by 1
    BRp CONVERT_ONES
    ADD R3, R3, #-1	      ;restore the number 
    BRnzp CONVERT_ASCII

    CONVERT_ASCII           ; Convert the digit to ASCII ('0' to '9')
    ADD R0, R3, R7          ; Convert the numeric value to ASCII
    OUT                     ; Print the ASCII character
    
    ; Check if R2 is zero (end of digits)
    ADD R2, R2, #0
    BRz PRINT_DONE

    BRnzp START_AGAIN  ; Repeat the loop

PRINT_DONE:
    ; Restore registers
    LD R5, SAVE_R5
    LD R6, SAVE_R6
    LD R7, SAVE_R7
    LD R0, SAVE_R0
    LD R3, SAVE_R3
    LD R4, SAVE_R4
    RET

SAVE_R7 .BLKW 1
SAVE_R6 .BLKW 1
SAVE_R5 .BLKW 1
SAVE_R4 .BLKW 1
SAVE_R3 .BLKW 1
SAVE_R0 .BLKW 1

; HALT to end the program
HALT

ASCIIZERO .FILL x0030
NEG_10000 .FILL -10000
POS_10000 .FILL 10000
NEG_1000 .FILL -1000
NEG_100 .FILL -100
POS_1000 .FILL 1000
POS_100 .FILL 100

; HALT to end the program
HALT

.END

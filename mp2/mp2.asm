.ORIG x3000
;Main program
MAIN
    AND R1, R1, #0
    JSR FIND_M_N            ;jump to M and N subrountine

    ;Print the first output
    LD R1, M_PTR            ;load the address in M_PTR into R1

    STRING1
    LDR R0, R1 , #0         ;load the value from the address into R0
    BRz MOVE1               ;if it is zero go to MOVE1
    ADD R1, R1, #1          ;increment the address
    OUT
    BRnzp STRING1
    
    MOVE1
    LD R0, SPACE            ;print space
    OUT
    
    LD R0, HYPHEN           ;print hyphen
    OUT

    LD R0, GREATER_THAN     ;print greater than sign
    OUT

    LD R0, SPACE            ;print space
    OUT

    ;Print the second output
    LD R1, N_PTR            ;load the address from N_PTR into R1
    STRING2
    LDR R0, R1, #0          ;load the value from the address into R0
    BRz MOVE2               ;if it is zero go to MOVE2
    ADD R1, R1, #1          ;increment the address
    OUT
    BRnzp STRING2

    MOVE2
    LD R0, LINEFEED
    OUT

    LEA R0, DISTANCE_LABEL  ; Load and print the "Levenshtein distance"
    PUTS
    
    JSR START_PRINT_DECIMAL ;print the value in DISTANCE's address

    LD R0, LINEFEED         ;print newline         
    OUT

    JSR PRETTY_PRINT        ;jump to PRETTY_PRINT to print the transformation details

    ;Halt the program
    HALT


; Subroutine to calculate M and N
FIND_M_N
    ST R0, SAVE_R0          ;Save R0
    ST R1, SAVE_R1          ;Save R1
    ST R2, SAVE_R2          ;Save R2
    ST R3, SAVE_R3          ;Save R3
    ST R4, SAVE_R4          ;Save R4
    ST R5, SAVE_R5          ;Save R5
    ST R6, SAVE_R6          ;Save R6
    ST R7, SAVE_R7          ;Save R7

    ;Calculate M (length of string1)
    AND R1, R1, #0          ;initialize R1 to zero
    LD R0, M_PTR            ;load address of string1
    JSR STRLEN              ;jump STRLEN subroutine
    ADD R1, R1, #1          ;R1 = R1+1
    STI R1, M_STORE         ;store M at x38E0

    ;Calculate N (length of string2)
    AND R1, R1, #0          ;initialize R1 to zero
    LD R0, N_PTR            ;load address of string2
    JSR STRLEN              ;jump STRLEN subroutine
    ADD R1, R1, #1          ;R1 = R1+1
    STI R1, N_STORE         ;store N at x38E1

    ;Restore saved registers
    LD R7, SAVE_R7
    LD R6, SAVE_R6
    LD R5, SAVE_R5
    LD R4, SAVE_R4
    LD R3, SAVE_R3
    LD R2, SAVE_R2
    LD R1, SAVE_R1
    LD R0, SAVE_R0
    RET                     ;go back to the main program

;Subroutine STRLEN
STRLEN
    LDR R2, R0, #0          ;load the value from the address in R0
    BRz DONE                ;NULL go to DONE
    ADD R1, R1, #1          ;count number of character
    ADD R0, R0, #1          ;increment the address
    BRnzp STRLEN            ;continue loop
 
    DONE
    RET                     ;return to the FIND_M_N

START_PRINT_DECIMAL     ;credit: Thiwarin ID3220300391's PRINT_DECIMAL code
 ST R0, SAVE_R0     ; Save R0    print
 ST R1, SAVE_R1     ; Save R1    value   
 ST R2, SAVE_R2     ; Save R2    pointer address
 ST R3, SAVE_R3     ; Save R3
 ST R4, SAVE_R4     ; Save R4
 ST R5, SAVE_R5     ; Save R5
 ST R6, SAVE_R6     ; Save R6
 ST R7, SAVE_R7 ; Save R7
 LDI R1, DISTANCE 
 ADD R7,R1,#0 ; F = x
 ADD R3,R1,#0 ; A = x
 ADD R2,R2,#-1 ; n--
 
PRINT_DECIMAL
    AND R4,R0,#0 ; B = 0 Clear R4
    ADD R4,R4,#-1 ; B = -1
    AND R1,R0,#0 ; x = 0 Clear R1
    ADD R3,R7,#0 ; A = F
    ADD R7,R2,#0 ; F = n
    BRnz LOOPFOUR
    LOOPTWO
    ADD R5,R5,#9 ; C = 9
    ADD R6,R4,#0 ; E = B
    LOOPTHREE
    ADD R4,R4,R6 ; B = B + E
    ADD R5,R5,#-1 ; C--
    BRp LOOPTHREE ; for C positive
    ADD R7,R7,#-1 ; F--
    BRp LOOPTWO ; for F positive
 
    LOOPFOUR
    ADD R7,R3,#0 ; F = A
    ADD R1,R1,#1 ; x++
    ADD R3,R3,R4 ; A = A - B
    BRzp LOOPFOUR
    ADD R1,R1,#-1 ; x--
    LD R0, ASCIIZERO
    ADD R0,R0,R1 ; R0 = x
    OUT
    ;ADD R2,R2,#-1 ; n--
    ;BRzp PRINT_DECIMAL ; for n zero or positive
    ;LEA R0, FINPRINT

    ; Restore saved registers
    LD R7, SAVE_R7
    LD R6, SAVE_R6
    LD R5, SAVE_R5
    LD R4, SAVE_R4
    LD R3, SAVE_R3
    LD R2, SAVE_R2
    LD R1, SAVE_R1
    LD R0, SAVE_R0
 
    RET

;subroutine PRETTY_PRINT
PRETTY_PRINT
    ST R0, SAVE_R0          ;Save R0    
    ST R1, SAVE_R1          ;Save R1        
    ST R2, SAVE_R2          ;Save R2    
    ST R3, SAVE_R3          ;Save R3
    ST R4, SAVE_R4          ;Save R4
    ST R5, SAVE_R5          ;Save R5
    ST R6, SAVE_R6          ;Save R6
    ST R7, SAVE_R7          ;Save R7

    LDI R5, N_STORE         ;load the value from N_STORE (x38E1) (N)
    LDI R4, M_STORE         ;load the value from M_STORE (x38E0) (M)
    LD R6, BASE             ;x8000

    OFFSET
        AND R3, R3, #0      ;initialize R3 to zero
        ADD R5, R5, #-1     ;R = N - 1
        BRz PRINT_M
        ADD R4, R4, #-1     ;C = M - 1
        BRz PRINT_M
        LDI R2, M_STORE     ;load the value M into R2
    	MULTIPLY
        ADD R3, R3, R5      ;(R*M) R3 = R3(0) + R
        ADD R2, R2, #-1     ;decrement R2    
        BRp MULTIPLY        ;R2 is +ive continue multiply

        ADD R3, R3, R4      ;RM+C 
        ADD R1, R3, R3      ;2(RM+C)
        ADD R3, R3, R1      ;3(RM+C)
        LD R1, TAP_START    ;x4000
        ADD R3, R1, R3      ;x4000+3(RM+C)
    PREDECESSOR
        ADD R2, R3, #1      ;add 1 to the entry
        LDR R1, R2, #0      ;load the offset into R2
        ADD R2, R2, #1      ;find the predecessor type
        LDR R2, R2, #0      ;load the value from the R2's address to R2
        BRn PRINT_M         ;negative value, start print_m
        STR R2, R6, #0      ;store the predecessor type into R6's address
        ADD R6, R6, #-1     ;decrement the address
        ADD R3, R3, R1      ;R3's address plus the offset
        BRnzp PREDECESSOR 
       
    PRINT_M
        AND R3, R3, #0      ;initialize R3 to 0
        ADD R3, R3, #2      ;R3 = 2 check M or N
        ADD R6, R6, #1      ;restore the address before -1
        ADD R4, R6, #0      ;R4 = R6 keep the address of the R6 in R4
        LD R1, M_PTR        ;load the address of string M into R1
        BRnzp LOOP          ;continue loop
       
    PRINT_N
        ADD R6, R4, #0      ;R6 = R4 copy the address in R4 into R6
        LD R1, N_PTR        ;load the address of string N into R1
    
    ; Loop to process the stack
    LOOP
        LDR R0, R1, #0      ;load the value from R1's address into R0
        BRz BASE_OF_STACK   ;NULL go to BASE_OF_STACK
        LDR  R5, R6, #0     ;load the value from R6's address into R5     
        ADD R2, R3, #-1     ;check the status, M or N
    	BRz LOOPAGAIN       ;if R2 is 0 go to LOOPAGAIN   
        ADD R5, R5, #0
        ; Check the predecessor type and print accordingly
        BRz PRINT_HYPHEN    ;If 0 (Insertion), print a hyphen   
        BRp PRINT_CHARACTER ;If positive (Match/Substitution), print the character
       
    LOOPAGAIN
    	ADD R5, R5, #-1     ;R5 = R5-1
    	BRnp PRINT_CHARACTER ;if -ve/+ve, print character
    	BRz PRINT_HYPHEN    ;if 0, print hyphen
    
    PRINT_HYPHEN:
        LD R0, HYPHEN       ;load hyphen (ASCII x2D) into R0
        OUT
        BRnzp ADD_R6        ;continue processing the stack

    PRINT_CHARACTER:
        ADD R1, R1, #1      ;increment the address
        OUT
        BRnzp ADD_R6        ;continue processing the stack

    ADD_R6:
        ADD R6, R6, #1      ;move the stack pointer down (toward the base)
        BRnzp LOOP          ;process the next character

    BASE_OF_STACK:
        LD R0, LINEFEED     ;print a line feed (x0A) to complete the output
        OUT
        ADD R3,R3, #-1      ;check whether it is M or N
        BRp PRINT_N                     

    ; Restore saved registers
    LD R7, SAVE_R7
    LD R6, SAVE_R6
    LD R5, SAVE_R5
    LD R4, SAVE_R4
    LD R3, SAVE_R3
    LD R2, SAVE_R2
    LD R1, SAVE_R1
    LD R0, SAVE_R0

    RET
 
SAVE_R0 .FILL x0000   ; Memory location to save R0
SAVE_R1 .FILL x0000   ; Memory location to save R1
SAVE_R2 .FILL x0000   ; Memory location to save R2
SAVE_R3 .FILL x0000   ; Memory location to save R3
SAVE_R4 .FILL x0000   ; Memory location to save R4
SAVE_R5 .FILL x0000   ; Memory location to save R5
SAVE_R6 .FILL x0000   ; Memory location to save R6
SAVE_R7 .FILL x0000   ; Memory location to save R7
M_STORE .FILL x38E0   ; Memory location for M
N_STORE .FILL x38E1   ; Memory location for N
M_PTR .FILL x3800  ; Pointer to string1
N_PTR .FILL x3840  ; Pointer to string2
ASCIIZERO .FILL x0030   ; Ascii x0030 
HYPHEN .STRINGZ "-"     ;-
SPACE .STRINGZ " "      ;Space
GREATER_THAN .STRINGZ ">"   ;>
LINEFEED .FILL x000A        ;newline
DISTANCE_LABEL  .STRINGZ "Levenshtein distance = "  ; Label for the distance
DISTANCE .FILL x38C0
TAP_START .FILL x4000
BASE .FILL x8000           ; Address of the top of the stack

.END


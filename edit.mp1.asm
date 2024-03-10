.ORIG x3000
	LD	R0,BITS
	ADD	R2,R0,#0
	ADD	R3,R0,#0
	ADD	R4,R0,#0
	ADD	R5,R0,#0
	ADD	R6,R0,#0

	; let's try PRINT_DECIMAL ... "1230"
	LD	R1,EXAMPLE

	; set a breakpoint here in the debugger, then use 'next' to
	; execute your subroutine and see what happens to the registers;
	; they're not supposed to change (except for R7)...
	JSR	PRINT_DECIMAL

	; we're short on human time to test your code, so we'll do 
	; something like the following instead (feel free to replicate)...
	LD	R7,BITS
	NOT	R7,R7
	ADD	R7,R7,#1
	ADD	R0,R0,R7
	BRz	R0_OK
	LEA	R0,R0_BAD
	PUTS
R0_OK	

	; this trap changes register values, so it's not sufficient
	; to check that all of the registers are unchanged; HALT may
	; also lead to confusion because the register values differ
	; for other reasons (R7 differences, for example).
	HALT

BITS	.FILL	xABCD	; something unusual
EXAMPLE .FILL   #1230
R0_BAD	.STRINGZ "PRINT_DECIMAL changes R0!\n"

;Subroutine: STRLEN
STRLEN ST R7, SaveR7		;Save the return address

    	AND R1, R1, #0		;Initialize R1 to 0 (count)
    	AND R0, R0, #0		;Initialize R0 to 0
    	ADD R0, R0, R2		;Load the address of the string into R2	

Count_Loop
    	LDR R3, R2, #0		;Load a character from the string
    	BRz End_Count		;Check if it's NUL (end of string)
    	ADD R1, R1, #1		;Increment count
    	ADD R2, R2, #1		;Move to the next character
    	BRnzp Count_Loop

End_Count
    	LD R7, SaveR7		;Restore return address and return
    	RET

;Subroutine: PRINT_DECIMAL

PRINT_DECIMAL ST R7, SaveR7	;Save the return address

ConvertLoop
    	ADD R4, R1, #0		;Copy the number in R1 to R4
    	BRz IsZero		;Check if the number in R4 is zero

    	;Divide the number by 10
    	LD R5, Divisor		;Load the divisor = 10
    	JSR Divide		;Jump to the Divide subroutine
    	STR R4, R1, #0		;Store the quotient back in R1
    	ADD R5, R4, #0		;Move the remainder to R5

    	;Convert the remainder to ASCII and print it
    ADD R5, R5, R2	;Add the base address of the digit table
    OUT                ;Print the ASCII digit
    ADD R3, R3, #1	;Increment digit count
    BRnzp ConvertLoop

IsZero
    LD R7, SaveR7	;Restore return address and return
    RET

    ;BRz IsZero		;If it is 0, jump to IsZero subroutine

    ;Initialize variables
    LD R2, DigitTable	;Load the address of the digit table
    AND R3, R3, #0	;Initialize R3 to 0 (digit count)

EndConvert
    ; Restore return address and return
    LD R7, SaveR7
    RET

; Subroutine: Divide (helper subroutine for PRINT_DECIMAL)
; Description: Divides the value in R4 by the value in R5 (10) and stores the quotient in R1 and the remainder in R4.
; Inputs: R4 (dividend), R5 (divisor)
; Outputs: R1 (quotient), R4 (remainder)

Divide ST R7, SaveR7   ; Save the return address

    AND R1, R1, #0      ; Initialize quotient (R1) to 0
    AND R6, R6, #0      ; Initialize a counter (R6) to 0

DivLoop
    ADD R1, R1, #1      ; Increment quotient
    ADD R4, R4, #-1     ; Decrement dividend

    BRp DivLoop          ; Continue loop if dividend is positive

    ADD R4, R4, #1      ; Adjust dividend (add 1 back)
    ADD R1, R1, #-1     ; Adjust quotient (subtract 1)
    BRnzp EndDivide

EndDivide
    ; Restore return address and return
    LD R7, SaveR7
    RET

; Data Section

DigitTable .STRINGZ "0123456789"   ; Table for converting digits to ASCII
Divisor .FILL #10                    ; Divisor for dividing by 10

SaveR7 .BLKW 1

.END

.ORIG x3000
 LD R0,BITS ; x
 AND R2,R0,#0 ; n = 0 num of character
 AND R3,R0,#0 ; A = 0 to calculate x
 AND R4,R0,#0 ; B = 0 to minus
 AND R5,R0,#0 ; C = 0 to loop plus B
 AND R6,R0,#0 ; E = 0 to plus B
 AND R7,R0,#0 ; F = 0 Clear R7

 LD R1, EXAMPLE ; X Load

; >>> STRLEN
 ADD R4,R4,#-1 ; B = -1
STRLEN
 ADD R5,R5,#9 ; C = 9
 ADD R6,R4,#0 ; E = B
LOOPONE
 ADD R4,R4,R6 ; B = B + E
 ADD R5,R5,#-1 ; C--
 BRp LOOPONE ; for C positive
 ADD R2,R2,#1 ; n ++
 ADD R3,R1,#0 ; A = x
 ADD R3,R3,R4 ; A = A - B
 BRp STRLEN ; for A positive

 LD R0, NUM
 ADD R0,R0,R2 ; R0 = n
 OUT
 LEA R0, FINSTRLEN
 PUTS

; >>> PRINT_DECIMAL
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
 LD R0, NUM
 ADD R0,R0,R1 ; R0 = x
 OUT
 ADD R2,R2,#-1 ; n--
 BRzp PRINT_DECIMAL ; for n zero or positive
 LEA R0, FINPRINT
 PUTS
HALT


BITS .FILL xABCD ; something unusual
EXAMPLE .FILL #1230
NUM .FILL x0030 ; ASCII of 0
FINSTRLEN .STRINGZ " number of character\n"
FINPRINT .STRINGZ " is the answer\n"
.END
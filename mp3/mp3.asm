.ORIG x3000
INIT_WORK
;CI = x3880, CD = x3881, CS = x3882
;M = x3800, N = x3840
    ST R0, SAVE_R0          ;Save R0
    ST R1, SAVE_R1          ;Save R1
    ST R2, SAVE_R2          ;Save R2
    ST R3, SAVE_R3          ;Save R3
    ST R4, SAVE_R4          ;Save R4
    ST R5, SAVE_R5          ;Save R5
    ST R6, SAVE_R6          ;Save R6
    ST R7, SAVE_R7          ;Save R7
   
    ;initialize the value into the register
    LD R1, TAP_START        ;R1 <- x4000       
    LDI R4, M_STORE         ;R4 <- value of the address M_STORE
    LDI R5, N_STORE         ;R5 <- value of the address N_STORE
    ;ADD R5, R5, #-1         ;R5 (R) = N - 1
    ADD R4, R4, #-1         ;R4 (C) = M - 1

    ;initial (0,0)
    AND R0, R0, #0      
    STR R0, R1, #0          ;store 0 in x4000
    ADD R1, R1, #1          ;increment the address
    STR R0, R1, #0          ;store 0 in x4001
    ADD R1, R1, #1
    ADD R0, R0, #-1
    STR R0, R1, #0          ;store -1 in x4002
    AND R0, R0, #0          ;initial R0 -> 0
    ;ADD R1, R1, #-2


    ;initial (R,0)
    ROW_1 ;R0 = R, R1 = address to load the value, R2 = , R3 = number of column, R4 = C =(M-1), R5 = R total, R6 = counter for multiply
    ADD R1, R1, #1          ;increment address by 1
    ADD R0, R0, #1          ;R0 = R0+1
    AND R6, R6, #0          ;R6 = 0
    LDI R6, CI              ;counter (insertion cost)
    AND R2, R2, #0
    MULTIPLY
    ADD R2, R0, R2          ;R times the insertion cost
    ADD R6, R6, #-1         ;decrement counter
    BRp MULTIPLY
    STR R2, R1, #0          ;store value in R2 into R1's address
    ADD R1, R1, #1
    AND R2, R2, #0  
    ADD R2, R2, #-3         ;load -3 offset
    STR R2, R1, #0          ;store the offset into R1's address
    ADD R1, R1, #1          ;increment the R1's address
    AND R2, R2, #0
    LDI R2, CD              ;load the deletion cost
    STR R2, R1, #0
    ADD R4, R4, #-1         ;decrement R4
    BRp ROW_1
    ADD R1, R1, #1
    AND R2, R2, #0
    ADD R2, R2, #1
    STR R2, R1, #0

    AND R2, R2, #0   ;initialize R2 <- 0
    ADD R2, R2, #3   ;R2 <- 3
    AND R6, R6, #0   ;initialize R6 <- 0
    LDI R4, M_STORE
    TIMES_3     ;multiply loop
    ADD R6, R4, R6
    ADD R2, R2, #-1
    BRp TIMES_3
    ADD R1, R1, #1
    NOT R6, R6    ;convert to negative number
    ADD R6, R6, #1
    STR R6, R1, #0
    ADD R1, R1, #1

    ;initial (0,C)
    INIT_COLUMN_1 ;R0 = R, R1 = address to load the value, R2 = , R3 = number of column, R4 = R = (N-1) total, R5 = N, R6 = counter for multiply
    LDI R4, M_STORE
    ADD R3, R4, #-1
    LDI R5, N_STORE
    ADD R5, R5, #-1
    ST R5, R_STORE
    AND R0, R0, #0

    START_COLUMN_1
    ADD R1, R1, #1          ;increment address
    ADD R3, R3, #0
    BRz CALC_DIS
    ADD R0, R0, #1
    AND R6, R6, #0          ;R6 = 0
    ADD R6, R6, #1          ;counter (deletion cost)
    AND R2, R2, #0
    MULTIPLY_1
    ADD R2, R2, R0
    ADD R6, R6, #-1
    BRp MULTIPLY_1
    STR R2, R1, #0
    ADD R5, R5, #-1
    ;-3M offset
    LDI R5, R_STORE
    ADD R1, R1, #1
    AND R2, R2, #0
    ADD R2, R2, #3
    AND R6, R6, #0
    TIMES_3M
    ADD R6, R5, R6
    ADD R2, R2, #-1
    BRp TIMES_3M
    NOT R6, R6
    ADD R6, R6, #1
    STR R6, R1, #0
    ADD R1, R1, #0
    AND R2, R2, #0
    ADD R2, R2, #1   ;load the deletion cost into the address
    STR R1, R1, #1  
    ADD R3, R3, #-1
    BRp START_COLUMN_1

    CALC_DIS ;to fill the value into the tablee
    ;initialize the registar and the values
    ST R1, UPLEFT
    LDI R4, M_STORE          
    LDI R5, N_STORE
    ADD R1, R1, R4    ;x6000 + R4 -> R1
    ST R1, CURRENT   ;store address of row
    ADD R5, R5, #-1   ;R5 (R) = N - 1
    ADD R4, R4, #-1          ;R4 (C) = M - 1
    ST R5, R_STORE    ;store the value R4 -> R_STORE
    ST R4, C_STORE    ;store the value R5 -> C_STORE
    AND R5, R5, 0    ;initize R5 <- 0
    ADD R5, R5, #-1    ;R5 = R5 - 1
    ST R5, CHECK_C    ; -1 is stored in CHECK_C
    ST R5, CHECK_R    ; -1 is stored in CHECK_R
    AND R5, R5, #0
    ADD R5, R5, #1
    ST R5, LOCATION_R
    ;AND R2, R2, #0
    ;ADD R2, R2, #1
    ;ST R2, LOCATION_C   ;column initials at 1
    ;ST R2, LOCATION_R   ;row initials at 1

    ;check the location
    LDI R4, M_STORE
    CHECK_LOCATION   ;check the row
    LDI R5, N_STORE  
    LD R6, CHECK_R
    ADD R5, R5, R6    ;R5=R5+R6 (R5=R+(-1))
    ADD R6, R6, #-1
    ST R6, CHECK_R
    ADD R5, R5, #0
    BRz MOVE_NEXT_ROW
 
    ;ST R1, CURRENT  ;store the first column addres
    ;AND R2, R2, #0  
    ;LD R6, CHECK_C

    ;LOCATION_COLUMN    ;check the column
    LD R2, LOCATION_C
    ;ADD R4, R4, #-1    ;R4=R4+R6 (R4=R+(-1))
    ;BRz MOVE_NEXT_ROW
    ADD R2, R2, #1
    ST R2, LOCATION_C
    ;LD R1, CURRENT
    ;ADD R1, R1, #1       ;R1 <- x600M + 1
    ;ST R1, CURRENT
    ;AND R2, R2, #0
    BRnzp START_COMPARE

    MOVE_NEXT_ROW
    LD R1, CURRENT
    ADD R1, R1, #2  ;skip the column zero
    ST R1, CURRENT
    AND R6, R6, #0
    ADD R6, R6, #-1
    ST R6, CHECK_R
    ADD R2, R2, #1
    ST R2, LOCATION_C
    LD R2, LOCATION_R
    ADD R2, R2, #-1  ;decrement the row
    BRz SHORTEST_DIS
    ST R2, LOCATION_R ;
    BRnzp START_COMPARE

  START_CHECK     ;check if the character match
   ;start (M/S, D, I)
   LD R3, M_PTR
   LD R2, N_PTR
   LDR R4, R3, #0    ;load the string_m into R4
   LDR R5, R2, #0    ;load the string_n into R5
   AND R6, R5, R4    ;compare both string
   BRz MATCH

    START_COMPARE
    ;clear the registar
    AND R0, R0, #0
    AND R1, R1, #0
    AND R2, R2, #0
    AND R3, R3, #0
    AND R4,R4, #0
 
    COMPARE      ;find the minimum
    ;load the value into registar
    LD R1, UPLEFT
    ADD R5, R1, #0
    LDI R4, M_STORE
    ADD R2, R1, R4
    ADD R3, R1, #1
    LDR R1, R1, #0
    LDR R2, R2, #0
    LDR R3, R3, #0

    ;check1
    NOT R4,R2
    ADD R4,R4,#1
    ADD R4,R1,R4
    BRn NEG_1
    BRp THIRD_2

    NEG_1
    ADD R0,R0,R1
    ;THIRD_1 minimum number is in R1
    NOT R4,R3
    ADD R4,R4,#1
    ADD R4,R1,R4
    BRp POS
    AND R0, R0, #0
    ADD R0, R0, R1
    BRnzp SUBT

    THIRD_2 ;minimum number is in R2
    ADD R0,R0,R2
    NOT R4,R3
    ADD R4,R4,#1
    ADD R4,R2,R4
    BRp POS
    AND R0, R0, #0
    ADD R0,R0,R2
    BRnzp DELETION

    POS
    AND R0, R0, #0
    ADD R0, R0, R3
    BRnzp INSERTION
 
    SUBT
    LD R1, UPLEFT
    ADD R1, R1, #1
    ST R1, UPLEFT   ;move the upleft address
    ADD R5, R0, #1
    ADD R5, R5, #3   ;cost of subt
    LD R1, CURRENT
    LD R0, LOCATION_C
    ADD R1, R1, R0
    STR R5, R1, #0
    BRnzp CHECK_LOCATION

    INSERTION
    LD R1, UPLEFT
    ADD R1, R1, #1
    ST R1, UPLEFT   ;move the upleft address
    ADD R5, R0, #1
    ADD R5, R5, #2   ;cost of insert
    LD R1, CURRENT
    LD R0, LOCATION_C
    ADD R1, R1, R0
    STR R5, R1, #0
    BRnzp CHECK_LOCATION

    DELETION
    LD R1, UPLEFT
    ADD R1, R1, #1
    ST R1, UPLEFT   ;move the upleft address
    ADD R5, R0, #1
    ADD R5, R5, #2   ;cost of delete
    LD R1, CURRENT
    LD R0, LOCATION_C
    ADD R1, R1, R0
    STR R5, R1, #0
    BRnzp CHECK_LOCATION

    MATCH
    LD R1, UPLEFT
    LDR R4, R1, #0
    LD R1, CURRENT
    STR R4, R1, #0
    ADD R1, R1, #1
    ST R1, UPLEFT   ;move the upleft address
    BRnzp CHECK_LOCATION

    SHORTEST_DIS

    FINISH



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
 
SAVE_R0 .BLKW 1   ; Memory location to save R0
SAVE_R1 .BLKW 1    ; Memory location to save R1
SAVE_R2 .BLKW 1    ; Memory location to save R2
SAVE_R3 .BLKW 1    ; Memory location to save R3
SAVE_R4 .BLKW 1    ; Memory location to save R4
SAVE_R5 .BLKW 1    ; Memory location to save R5
SAVE_R6 .BLKW 1    ; Memory location to save R6
SAVE_R7 .BLKW 1    ; Memory location to save R7
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
R_STORE .BLKW 1
C_STORE .BLKW 1
CHECK_R .BLKW 1
CHECK_C .BLKW 1
LOCATION_R .BLKW 1
LOCATION_C .BLKW 1
CURRENT .BLKW 1
UPLEFT .BLKW 1
CI .FILL x3880
CD .FILL x3881
CS .FILL x3882
.END
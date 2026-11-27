;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x1e
;
; * * *
; 32-bit code requires x86 Native Tools Command Prompt for VS / ml.exe
; DAS instruction is invalid in CPU 64-bit mode.
; * * *
;
; Notes:
; AL must be 00h-0Fh
; AL values 00h to 09h results in AL = 0 through 9 ASCII
; AL values 0Ah to 0Fh results in AL = A through F ASCII
;
; DAS - Decimal Adjust After Subtraction (MASM 6.1 reference manual)
; Adjusts the result of a subtraction to a packed BCD number (less than 100 decimal).
; The previous subtraction instruction should place its 8-bit binary result in AL.
; DAS converts this binary sum to packed BCD format with the least significant
; decimal digit in the lower four bits and the most significant digit in the upper four
; bits. If the sum is greater than 99h after adjustment, the carry and auxiliary carry
; flags are set. Otherwise, the carry and auxiliary carry flags are cleared.
;
; OPERATION
; --------------------------------------
;  IF 64-Bit Mode
;      THEN
;          #UD;
;      ELSE
;          old_AL := AL;
;          old_CF := CF;
;          CF := 0;
;          IF (((AL AND 0FH) > 9) or AF = 1)
;              THEN
;                      AL := AL - 6;
;                      CF := old_CF or (Borrow from AL := AL − 6);
;                      AF := 1;
;              ELSE
;                      AF := 0;
;          FI;
;          IF ((old_AL > 99H) or (old_CF = 1))
;                  THEN
;                      AL := AL − 60H;
;                      CF := 1;
;          FI;
;  FI;
;
; --------------------------------------
; Example with AL = 0Fh
; --------------------------------------
; CMP 0Fh, 0Ah:
; CF := 0
;
; SBB 0Fh - 69h
; 15 - 105 = -90
; 90 in hex is 5Ah
;
; Two's complement of 5Ah (0101 1010) becomes:
; 1010 0101 + 1 = 1010 0110
; 1010 0110 in hex is A6h
;
; AL := A6h
; AF := 0
; CF := 1
;
; DAS
; old_AL := AL
; old_CF := CF
; CF := 0
;
; A6h AND 0Fh = 06h (test only, AL not updated)
; 06h < 09h and AF = 0, so...
; Continue...
;
; A6h (old_AL) > 99h OR old_CF=1, so...
; AL := A6h - 60h = 46h
; CF := 1
;
; 46h in ASCII is 'F'
;
; --------------------------------------
; Example with AL = 05h
; --------------------------------------
; CMP 05h, 0Ah:
; CF := 1
;
; SBB 05h - 6Ah (69h+CF)
; 5 - 106 = -101
; 101 in hex is 65h
;
; Two's complement of 65h (0110 0101) becomes:
; 1001 1010 + 1 = 1001 1011
; 1001 1011 in hex is 9Bh
;
; AL := 9Bh
; AF := 1
; CF := 1
;
; DAS
; old_AL := AL
; old_CF := CF
; CF := 0
;
; 9Bh AND 0Fh = 0Bh (test only, AL not updated)
; 0Bh > 09h or AF = 1, so...
; 9Bh - 6
; AL := 95h
;
; 9Bh (old_AL) > 99h OR old_CF=1, so...
; AL := 95h - 60h = 35h
; CF := 1
;
; 35h in ASCII is '5'
;======================================================================

.386
.MODEL FLAT, STDCALL

INCLUDELIB kernel32.lib

ExitProcess PROTO :DWORD

        .CODE
start   PROC
        xor     eax, eax    ; Zero EAX register
        mov     al, 05h     ; Initialize example value in AL

        cmp     al, 0Ah     ; Compare AL to 0Ah and set CF accordingly (this instruction is purely to determine CF state)
                            ; Digits 0-9: carry flag is set
                            ; Digits A-F: carry flag is cleared
        sbb     al, 69h     ; AL - (69h + CF)
                            ; 69h is the "magic" constant where subtracting adds 97h (A-F) or 96h (0-9)
                            ; DAS will subtract 60h from values A-F and 66h from values 0-9
                            ; This results in AL holding the corresponding ASCII offsets
        das                 ; Returns the initial hex value in AL as its corresponding ASCII character

        ; 32-bit exit code is passed to ExitProcess on the stack. INVOKE handles this, but could
        ; also be written as:
        ; push 0
        ; call ExitProcess
        invoke  ExitProcess, 0
start   ENDP
        END

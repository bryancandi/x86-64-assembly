;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x09
;
; Division by 8 rounding to the nearest whole number.
;
; SHR shifts all bits right and through the carry flag, filling in with
; zeroes on the left.
; Shifting any base right by N divides by that base to the power of N.
; Binary is base 2, if N = 3, 2³ = 8. So 3 shifts right divides by 8.
; 10000000 (128) ---> 00010000 (16) -- 128/8 = 16
;
; ADC adds zero (adc op, 0) plus the carry flag, if set, to RAX.
; If the remainder from division by 8 is greater than or equal to 4,
; CF = 1 and the result will be rounded up to the next whole number.
; If the remainder is less than 4, the result will be rounded down.
; Note: SHR result is the quotient, not the remainder.
;
; 32/8 = 4
; 33/8 = 4.125, final result = 4
; 36/8 = 4.5, final result = 5
;
; Examples of the lower 8 bits and carry flag following each
; instruction. The format is 00000000 CF (decimal):
;
;   RAX:    00100000    (32)
;   SHR:    00000100 0  (4)
;   ADC:    00000100    (4)
;
;   RAX:    00100001    (33)
;   SHR:    00000100 0  (4)
;   ADC:    00000100    (4)
;
;   RAX:    00100100    (36)
;   SHR:    00000100 1  (4)
;   ADC:    00000101    (5) 
;
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 128                ; Initialize RAX

        shr     rax, 3
        adc     rax, 0

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

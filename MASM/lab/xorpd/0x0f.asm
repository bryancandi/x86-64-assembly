;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x0f
;
; A CBC-like cipher
;
; Each byte in the buffer is XOR'd with the previously transformed byte
; in AL. The transformed byte in RSI is then loaded into AL before the
; the next iteration.
;
; AL is initialized to zero in this example, so the first byte in the
; buffer is XOR'd with zero.
;
;   A = A XOR AL
;   B = B XOR A
;   C = C XOR B
;   D = D XOR C
;   E = E XOR D
;   F = F XOR E
;   G = G XOR F
;   H = H XOR G
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

OPTION DOTNAME

        .DATA
buffer  BYTE    "ABCDEFGH"

        .CODE
start   PROC
        sub     rsp, 40

        lea     rsi, buffer
        ;mov     rax, 'A'
        ;mov     rax, 1
        xor     rax, rax                ; Initialize RAX to zero
        mov     rcx, LENGTHOF buffer    ; Initialize RCX to buffer size

.loop:
        xor     BYTE PTR [rsi], al      ; XOR byte at [RSI] with AL (lower 8-bits in RAX)
        lodsb                           ; Load byte at [RSI] into AL, then increment RSI
        loop    .loop

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

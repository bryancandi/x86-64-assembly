;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x0b
;
; 128-bit Negation
;
; Assuming there is a 128-bit value stored in two registers (RDX:RAX)
; RDX = high 64-bits, RAX = low 64-bits.
;
; If the low half in RAX is zero, no change to the low bits is required,
; only the high bits in RDX need negating, so the NOT becomes a NEG
; operation by subtracting -1 (add 1) from the value in RDX.
;
; If the low half in RAX is non-zero, RAX is negated by the NEG
; operation. The CF is set and added to the second operand of the SBB
; instruction, effectively making it SBB RDX, 0. Therefore RDX remains
; unchanged after the initial NOT operation.
;
; Performs either a NEG or NOT operation on RDX depending on the value
; in RAX.
; If RAX = 0, NEG RAX results in CF=0; -1 subtracted from RDX (NEG RDX)
; If RAX > 0, NEG RAX results in CF=1;  0 subtracted from RDX (NOT RDX)
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rdx, 0FFh               ; Initialize RDX
        mov     rax, 0FFh               ; Initialize RAX

        not     rdx
        neg     rax
        sbb     rdx, -1                 ; Add CF to 2nd operand; subtract from RDX

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x17
;
; RAX contains a signed integer
;
; If RAX is negative, this is equivalent to 'neg rax'
; If RAX is positive, it remains unchanged
;
; Example showing only the lower 8-bits of RAX and RDX:
; Sign-extend quadword in RAX into octaword in RDX:RAX (cqo)
;   RAX:    11111010   -6
;   RDX:    11111111   -1
;
; Invert bits in RAX (xor)
;   RAX:    00000101    5
;
; Subtract: 5 - (-1) = 6
;   RAX:    00000101    5
; - RDX:    11111111   -1
; = RAX:    00000110    6
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 0fffffffffffffffah                ; Initialize RAX

        cqo
        xor     rax, rdx
        sub     rax, rdx

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x0e
;
; De Morgan's Law
; NOT (A AND B) = (NOT A) OR (NOT B)
;
; RAX is copied into RCX. Both hold equal values after the operations.
; Final values differ from their initial values.
;
; Example showing only the lower 8 bits during each operation:
;
;   RAX:    00100000 (32)
;   RBX:    01100000 (96)
;   RCX:    00100000 (32)
;
;   AND:
;     RCX:  00100000 (32)
;   NOT:
;     RCX:  11011111 (223)
;
;   NOT:
;     RAX:  11011111 (223)
;   NOT:
;     RBX:  10011111 (159)
;   OR:
;     RAX:  11011111 (223)
;
;   CMP:
;     RAX:  11011111 (223)
;     RCX:  11011111 (223)
;     ZF = 1
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 32                 ; Initialize RAX
        mov     rbx, 96                 ; Initialize RBX

        mov     rcx, rax                ; Initialize RCX with the value in RAX
        and     rcx, rbx
        not     rcx

        not     rax
        not     rbx
        or      rax, rbx

        cmp     rax, rcx

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

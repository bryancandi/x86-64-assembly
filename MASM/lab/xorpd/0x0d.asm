;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x0d
;
; AND distributes over XOR
;
;   - RBX is copied into RDX
;
;   - RBX is xor'd with RCX
;   - RBX and RAX
;
;   - RDX and RAX (RDX is pre-xor'd value of RBX)
;   - RAX and RCX
;   - RAX is xor'd with RDX
;
;   - RAX is compared to RBX
;
; Since RDX and RBX have the same initial values, the final values in
; RAX and RBX will always be equal.
;
; Example showing only the lower 8 bits during each operation:
;
;   RAX:    01100000 (96)
;   RBX:    00100110 (38)
;   RCX:    01001000 (72)
;
;   MOV:
;     RDX:  00100110 (38)
;
;   XOR:
;     RBX:  01101110 (110)
;   AND:
;     RBX:  01100000 (96)
;
;   AND:
;     RDX:  00100000 (32)
;   AND:
;     RAX:  01000000 (64)
;   XOR:
;     RAX:  01100000 (96)
;
;   CMP:
;     RAX:  01100000 (96)
;     RBX:  01100000 (96)
;     ZF = 1
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 96                 ; Initialize RAX
        mov     rbx, 38                 ; Initialize RBX
        mov     rcx, 72                 ; Initialize RCX

        mov     rdx, rbx                ; Initialize RDX with the value in RBX

        xor     rbx, rcx
        and     rbx, rax

        and     rdx, rax
        and     rax, rcx
        xor     rax, rdx

        cmp     rax, rbx

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

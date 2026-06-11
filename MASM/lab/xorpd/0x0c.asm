;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x0c
;
; XOR and bit rotation are order-independent 
;
;   - RAX is copied into RCX so the starting values are equal
;   - RCX is xor'd with RBX
;   - Previously xor'd RCX is rotated 13 positions to the right
;
;   - RAX is rotated 13 positions to the right
;   - RBX is rotated 13 positions to the right
;   - RAX is xor'd with RBX
;
;   - RAX is compared to RCX
;
; When RAX is compared with RCX, and they will still be equal and zero
; flag will be set.
;
; This is because each bitwise operation acts on bits independently,
; therefore the order of operations does not change the final values.
; RCX was xor'd with RBX before rotation, and RAX xor'd with RBX after
; rotation, but the final values are the same.
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 16                 ; Initialize RAX
        mov     rbx, 8                  ; Initialize RBX

        mov     rcx, rax                ; Initialize RCX with the value in RAX
        xor     rcx, rbx
        ror     rcx, 0Dh

        ror     rax, 0Dh
        ror     rbx, 0Dh
        xor     rax, rbx

        cmp     rax, rcx

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

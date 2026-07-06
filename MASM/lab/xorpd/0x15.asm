;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x15
;
; Sign extend 32-bit negative integers into 64-bit register
; -5 (32-bit: FFFFFFFB)
; -5 (64-bit: FFFFFFFFFFFFFFFB)
;
; If EAX is positive
; 5 (32-bit: 00000005)
; 5 (64-bit: 0000000000000005)
;
; Comparable to MOVSX/MOVSXD - Move with Sign-Extend
;   Moves and sign-extends the value of the source operand to the
;   destination register.
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        ; MOVSXD demonstration:
        mov     eax, -5                 ; Initialize RAX
        movsxd  rax, eax

        mov     eax, -5                 ; Initialize RAX

        mov     rdx, 0ffffffff80000000h
        add     rax, rdx
        xor     rax, rdx

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

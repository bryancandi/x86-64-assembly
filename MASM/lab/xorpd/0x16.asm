;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x16
;
; Input: RAX, RBX, RCX
; Compares RAX to RSI after the following operations:
;
; RAX = (RAX ^ RBX) ^ (RBX ^ RCX)       no carry
; RAX = (RBX ^ RCX) ^ (RBX ^ RCX) = 0   w/ carry
;
; RSI = (RAX ^ RBX) + (RBX ^ RCX)
;
;----------------------------------------------------------------------
;
; It appears this code checks if a carry occurred with instruction:
; add rsi, rbx
; Which at this point in the code is equivalent to:
; (RAX ^ RBX) + (RBX ^ RCX)
;
; Without carry:
; RAX is equal to RSI, cmp returns 0
;
; With carry:
; RAX is not equal to RSI, cmp returns nz
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 64                 ; Initialize RAX
        mov     rbx, 32                 ; Initialize RBX
        mov     rcx, 16                 ; Initialize RCX

        xor     rax, rbx
        xor     rbx, rcx
        mov     rsi, rax
        add     rsi, rbx
        cmovc   rax, rbx
        xor     rax, rbx
        cmp     rax, rsi

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x14
;
; Calculate the average of two positive integers without taking the
; remainder into account.
;
; (RAX & RDX) + (RAX ^ RDX) / 2 is equivalent to (RAX + RDX) / 2
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 6                  ; Initialize RAX
        mov     rdx, 10                 ; Initialize RDX

        mov     rcx, rax                ; RCX = RAX
        and     rcx, rdx                ; RCX = RCX & RDX

        xor     rax, rdx                ; RAX = RAX ^ RDX
        shr     rax, 1                  ; RAX = RAX / 2

        add     rax, rcx                ; RAX = RAX + RCX

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

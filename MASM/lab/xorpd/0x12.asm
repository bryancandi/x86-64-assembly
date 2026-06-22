;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x12
;
; (RAX & RDX) + (RAX | RDX) = RAX + RDX
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 2                  ; Initialize RAX
        mov     rdx, 4                  ; Initialize RDX

        mov     rcx, rdx                ; Initialize RCX with value in RDX
        and     rdx, rax
        or      rax, rcx
        add     rax, rdx

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

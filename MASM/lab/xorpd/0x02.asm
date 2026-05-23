;======================================================================
; 0x02 - xorpd
;
; If initial RAX != 0, final RAX will = 1
; If initial RAX = 0, final RAX will = 0
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 10                 ; Initialize RAX

        neg     rax                     ; Two's compliment: 0 - RAX; CF = 1 (if RAX != 0, else CF = 0)
        sbb     rax, rax                ; RAX = RAX - RAX - CF
        neg     rax                     ; RAX = 1 or 0

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

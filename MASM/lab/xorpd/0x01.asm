;======================================================================
; 0x01 - xorpd
;
; Calculate Fibonacci Sequence
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

OPTION DOTNAME

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 0                  ; Initialize value 1 for Fibonacci sequence
        mov     rdx, 1                  ; Initialize value 2 for Fibonacci sequence
        mov     rcx, 20                 ; Initialize counter

.loop:
        xadd    rax, rdx                ; RDX = RAX; RAX += RDX
        loop    .loop                   ; Loop until RCX = 0

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

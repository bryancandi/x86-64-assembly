;======================================
; x64 - No Operation Encoding (test)
;
; AX  : 66h 90h
; EAX : 90h
; RAX : 48h 90h
; NOP : 90h
;======================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 28h

        mov     rax, 1111111122222222h
        xchg    ax, ax

        mov     rax, 3333333344444444h
        xchg    eax, eax

        mov     rax, 5555555566666666h
        xchg    rax, rax

        mov     rax, 7777777788888888h
        nop

        xor     eax, eax
        call    ExitProcess
start   ENDP
        END

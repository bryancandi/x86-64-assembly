;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x10
;
; Multiple methods to exchange the values of RAX and RCX
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 6                  ; Initialize RAX
        mov     rcx, 8                  ; Initialize RCX
        ; --> RAX = 6, RCX = 8

        push    rax                     ; Push the value in RAX onto the stack
        push    rcx                     ; Push the value in RCX onto the stack
        pop     rax                     ; Pop the top value on the stack into RAX
        pop     rcx                     ; Pop the top value on the stack into RCX
        ; --> RAX = 8, RCX = 6

        xor     rax, rcx                ; RAX = RAX^RCX
        xor     rcx, rax                ; RCX = RCX^(RAX^RCX) = original RAX
        xor     rax, rcx                ; RAX = RAX^(RAX^RCX) = original RCX
        ; --> RAX = 6, RCX = 8

        add     rax, rcx                ; RAX = RAX+RCX (14)
        sub     rcx, rax                ; RCX = RCX-RAX (-6)
        add     rax, rcx                ; RAX = RAX+RCX (8)
        neg     rcx                     ; RCX = ~RCX+1 (6)
        ; --> RAX = 8, RCX = 6

        xchg    rax, rcx                ; Exchange the values of RAX and RCX
        ; --> RAX = 6, RCX = 8

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

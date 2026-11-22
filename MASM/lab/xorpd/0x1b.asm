;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x1b
;
; Transfers control to the address stored in RAX.
; Similar to an unconditional jump instruction.
;   jmp rax
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

                                        ; RAX is never initialized in this example...
        push    rax                     ; Push the value in RAX onto the stack
        ret                             ; Pop the top of the stack into RIP and jump to that address

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x1c
;
; Pops the value at the top of the stack into the RSP register. Pop
; increments RSP by +8 but is then overwritten.
;
; Intel SDM note:
; The POP RSP instruction increments the stack pointer (RSP) before
; data at the old top of stack is written into the destination.
;
; Note: This example will crash in its current state as RSP will hold
; garbage when ExitProcess is called.
;
; Equivalent to move instruction (without popping top of the stack):
;   mov rsp, [rsp]
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        pop     rsp

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

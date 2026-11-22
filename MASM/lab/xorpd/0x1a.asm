;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x1a
;
; Pushes the address of the next instruction onto the stack and then
; pops it into RAX.
;
; This could also be achieved with a LEA instruction without touching
; the stack:
;   lea rax, next
;
; This code has the same effect as 64-bit PC-relative (or RIP-relative)
; addressing mode using the LEA instruction. This is a method to get
; the current instruction address without RIP-relative addressing.
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        call    next                    ; Pushes the address of the next instruction onto the stack
next:
        pop     rax                     ; RAX holds the address of the 'next' label and it is cleared from the stack

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

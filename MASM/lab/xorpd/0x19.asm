;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x19
;
; This code does not run as a standalone program at this time,
; it relies on an external 'print_str' function.
;
; 'call skip' never returns and is only used to push an address on the
; stack for the 'print_str' function to locate the string to print.
;======================================================================

INCLUDELIB kernel32.lib

EXTERN print_str:PROC                   ; External 'print_str' procedure

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        call    skip                    ; Pushes 8 byte return address of the next instruction on the stack
        byte    'hello, world!', 0      ; This string sits at the return address pushed by the previous call
                                        ; This data is never reached/executed; the above call jumps over it
skip:
        call    print_str               ; External function that prints the string located at the address below
                                        ; this call's return address and then returns
        add     rsp, 8                  ; Clears the 8 byte return address pushed on the stack by 'call skip'

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

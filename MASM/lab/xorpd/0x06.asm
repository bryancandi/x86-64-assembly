;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x06
;
; Effectively a no-operation.
;
; -(-rax) = rax
;
; The code is equivalent to:
;   neg rax
;   neg rax
;
; The NOT+INC sequence is equivalent to NEG (two's complement negation)
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 6                  ; Initialize RAX

        not     rax                     ; ~rax (one's complement negation)
        inc     rax                     ; ~rax + 1 (this is NEG RAX)
        neg     rax                     ; Negate RAX again -> back to original value

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

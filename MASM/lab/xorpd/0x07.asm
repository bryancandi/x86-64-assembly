;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x07
;
; Effectively a no-operation.
;
; -(-(rax+1)+1) = rax
;
; Example of the lower 8 bits when RAX equals 7:
;
;   RAX:    00000111
;
;   INC:    00001000
;   NEG:    11111000
;   INC:    11111001
;   NEG:    00000111
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 7                  ; Initialize RAX

        inc     rax
        neg     rax
        inc     rax
        neg     rax

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

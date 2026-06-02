;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x05
;
; Equivalent to a high-level statement such as:
;   if (x >=5 && x <= 9) { ... }
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 9

        sub     rax, 5
        cmp     rax, 4

        ; RAX = 9: result is 4, CMP sets equal (CF=0, ZF=1)
        ; RAX = 5 to 8: result is 0 to 3, CMP sets below (CF=1, ZF=0)
        ; RAX < 5 : SUB wraps RAX to huge unsigned value
        ;           CMP sets larger and clears flags (CF=0, ZF=0)
        ; RAX > 9 : Result is larger, CMP clears flags (CF=0, ZF=0)
        ;
        ; As long as the original value in RAX was 5 to 9, the unsigned result
        ; is below or equal to 4.
        ; Therefore we can use JBE to evaluate this expression.
        jbe     true

false:
        mov     ecx, 1
        jmp     exit
true:
        xor     ecx, ecx
exit:
        call    ExitProcess
start   ENDP
        END

;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x11
;
; Compare two strings one byte at a time
;
; Initialize RAX to zero for use in OR operation
; XOR byte in RSI against same byte in RDI
; Increment RSI and RDI for next loop iteration
; OR al, dl - RAX will equal zero as long as dl equals zero
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

OPTION DOTNAME

        .DATA
str1    BYTE    "AAAAAAAA"
str2    BYTE    "AABAABAA"

        .CODE
start   PROC
        sub     rsp, 40

        lea     rsi, str1
        lea     rdi, str2
        xor     rax, rax                ; Initialize RAX to zero for 'OR' in loop
        mov     rcx, LENGTHOF str1      ; Initialize RCX for loop counter

.loop:
        mov     dl, BYTE PTR [rsi]
        xor     dl, BYTE PTR [rdi]
        inc     rsi
        inc     rdi
        or      al, dl
        loop    .loop

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

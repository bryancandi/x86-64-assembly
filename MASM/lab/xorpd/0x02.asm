;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x02
;
; If initial RAX != 0, final RAX will = 1
; If initial RAX == 0, final RAX will = 0
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

; Example:
; RAX = 10 (00001010)
;
; neg 00001010 -> 11110101 + 1 = 11110110 ; CF = 1
; sbb: 11110110 - 11110110 - 1 = 11111111
; neg 11111111 -> 00000000 + 1 = 00000001

        mov     rax, 10                 ; Initialize RAX

        ; Two's complement negation:
        neg     rax                     ; RAX = 0 - RAX; (if RAX != 0, CF = 1; if RAX == 0, CF = 0)
        sbb     rax, rax                ; RAX = RAX - RAX - CF
        neg     rax                     ; RAX = 1 or 0

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

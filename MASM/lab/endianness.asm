;======================================================================
; endianness.asm
;
; Reverse byte order in different sized registers (16/32/64-bit).
; Demonstrates converting between little-endian and big-endian.
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess     PROTO

        .DATA
wStr    WORD    "AB"
dwStr   DWORD   "ABCD"
qwHex   QWORD   0102030405060708h

        .CODE
start   PROC
        sub     rsp, 28h

        mov     ax, wStr
        xchg    al, ah

        mov     eax, dwStr
        bswap   eax

        mov     rax, qwHex
        bswap   rax

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

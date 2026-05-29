;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x04
;
; Flips ASCII bit 5 (20h = 00100000b)
;
; Effects:
;   Removes spaces:
;       ' ' (20h) -> 00h
;
;   Toggles ASCII letter case:
;       'A' (41h) -> 'a' (61h)
;       'a' (61h) -> 'A' (41h)
;
;   The CR/LF characters written by ReadFile are also modified:
;       CR  (0Dh) -> '-' (2Dh)
;       LF  (0Ah) -> '*' (2Ah)
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess  PROTO uExitCode:DWORD
GetStdHandle PROTO nStdHandle:DWORD
ReadFile     PROTO hFile:QWORD, lpBuffer:PTR, nNumberOfBytesToRead:DWORD, lpNumberOfBytesRead:PTR, lpOverlapped:PTR
WriteFile    PROTO hFile:QWORD, lpBuffer:PTR, nNumberOfBytesToWrite:DWORD, lpNumberOfBytesWritten:PTR, lpOverlapped:PTR

        .DATA
stdin   QWORD ?
stdout  QWORD ?
nbrd    DWORD ?
nbwr    DWORD ?
inbuf   BYTE  128 DUP (?)
fmtbuf  BYTE  128 DUP (?)

        .CODE
start   PROC
        sub     rsp, 40

        mov     rcx, -10
        call    GetStdHandle
        mov     [stdin], rax

        mov     rcx, -11
        call    GetStdHandle
        mov     [stdout], rax

        mov     rcx, [stdin]
        lea     rdx, inbuf
        mov     r8, 128
        lea     r9, [nbrd]
        mov     QWORD PTR [rsp+32], 0
        call    ReadFile

        lea     rsi, [inbuf]
        lea     rdi, [fmtbuf]
        xor     r13, r13

xorpd_loop:
        mov     al, [rsi]

        ; xorpd (xor al, 0x20)
        xor     al, 20h

        mov     [rdi], al
        inc     rsi
        inc     rdi
        inc     r13
        cmp     [nbrd], r13d
        jne     xorpd_loop

        mov     rcx, [stdout]
        lea     rdx, fmtbuf
        mov     r8, LENGTHOF fmtbuf
        lea     r9, [nbwr]
        mov     QWORD PTR [rsp+32], 0
        call    WriteFile

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

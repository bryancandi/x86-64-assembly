;==============================================================
; Print Fibonacci sequence up to Fn (1-25).
; Author: Bryan C.
; Date  : 2026-04-14
;
; Assemble with MASM and link:
; ml64.exe fibonacci.asm /link /SUBSYSTEM:console /ENTRY:main
;==============================================================

INCLUDELIB kernel32.lib

ExitProcess         PROTO
GetStdHandle        PROTO
ReadConsoleA        PROTO
WriteConsoleA       PROTO

STD_INPUT_HANDLE    EQU -10
STD_OUTPUT_HANDLE   EQU -11
BufSiz              EQU 256
MinVal              EQU 1
MaxVal              EQU 25

        .DATA
msg     BYTE    "Enter a number (1 - 25): "
zero    BYTE    "0"
newln   BYTE    0Dh, 0Ah
buffer  BYTE    BufSiz DUP (?)
stdin   QWORD   ?
stdout  QWORD   ?
nbrd    DWORD   ?
nbwr    DWORD   ?

        .CODE
Int2Str PROC
        push    RBX
        push    RDI

        mov     RBX, 10                     ; Divisor (10)
        xor     R10, R10                    ; Initial string length = 0
        lea     RDI, buffer+BufSiz          ; RDI points to end of buffer.

convert_loop:
        xor     RDX, RDX
        div     RBX                         ; RAX = quotient, RDX = remainder.
        add     DL, '0'                     ; Remainder to ASCII digit.
        dec     RDI
        mov     [RDI], DL                   ; Store digit.
        inc     R10                         ; Length++
        test    RAX, RAX
        jnz     convert_loop

        mov     RAX, RDI                    ; Return pointer to first digit.

        pop     RDI
        pop     RBX
        ret
Int2Str ENDP

main    PROC
        sub     RSP, 40

        mov     RCX, STD_INPUT_HANDLE
        call    GetStdHandle
        mov     stdin, RAX

        mov     RCX, STD_OUTPUT_HANDLE
        call    GetStdHandle
        mov     stdout, RAX

prompt_loop:
        mov     RCX, stdout
        lea     RDX, msg
        mov     R8, LENGTHOF msg
        lea     R9, nbwr
        call    WriteConsoleA

        mov     RCX, stdin
        lea     RDX, buffer
        mov     R8, BufSiz
        lea     R9, nbrd
        call    ReadConsoleA

        mov     R8D, [nbrd]
        cmp     R8D, 2                      ; 2 = CRLF
        je      prompt_loop
        cmp     R8D, 4                      ; 4 = CRLF + 2 digits
        ja      prompt_loop

        movzx   RAX, BYTE PTR [buffer]
        sub     RAX, '0'
        cmp     RAX, MinVal
        jl      prompt_loop

        cmp     R8D, 3                      ; 3 = CRLF + 1 digit
        je      continue
        imul    RAX, RAX, 10
        movzx   RDX, BYTE PTR [buffer+1]
        sub     RDX, '0'
        add     RAX, RDX
        cmp     RAX, MaxVal
        jg      prompt_loop

continue:
        push    RAX
        push    RCX

        mov     RCX, stdout
        lea     RDX, zero
        mov     R8, LENGTHOF zero
        lea     R9, nbwr
        call    WriteConsoleA

        mov     RCX, stdout
        lea     RDX, newln
        mov     R8, LENGTHOF newln
        lea     R9, nbwr
        call    WriteConsoleA

        pop     RCX
        pop     RAX

        mov     R10, RAX                    ; Save value of RAX (Fn)
        xor     R11, R11                    ; Counter

        mov     RAX, 0
        mov     RCX, 1

fib_loop:
        xadd    RAX, RCX                    ; RCX = RAX, RAX = RAX + RCX

        push    RAX
        push    RCX
        push    R10
        push    R11

        call    Int2Str
        mov     RCX, stdout
        mov     RDX, RAX
        mov     R8, R10
        lea     R9, nbwr
        call    WriteConsoleA

        mov     RCX, stdout
        lea     RDX, newln
        mov     R8D, LENGTHOF newln
        lea     R9, nbwr
        call    WriteConsoleA

        pop     R11
        pop     R10
        pop     RCX
        pop     RAX

        inc     R11                         ; Counter++
        cmp     R10, R11
        jne     fib_loop

        xor     RCX, RCX
        call    ExitProcess
main    ENDP
        END

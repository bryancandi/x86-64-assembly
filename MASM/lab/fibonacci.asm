;==============================================================
; Print Fibonacci sequence up to Fn.
; Range: n=0 to n=93
; 64-bit unsigned addition using XADD (Exchange and Add).
;
; Author: Bryan C.
; Date  : 2026-04-14
;
; Assemble with MASM and link:
; ml64.exe fibonacci.asm /link /SUBSYSTEM:console /ENTRY:main
;==============================================================

INCLUDELIB kernel32.lib

ExitProcess         PROTO
GetStdHandle        PROTO
ReadFile            PROTO
WriteConsoleA       PROTO

STD_INPUT_HANDLE    EQU -10
STD_OUTPUT_HANDLE   EQU -11
BufSiz              EQU 256
MinVal              EQU 0
MaxVal              EQU 93

        .DATA
msg     BYTE    "Enter a number (0 - 93): "
newln   BYTE    0Dh, 0Ah
buffer  BYTE    BufSiz DUP (?)
stdin   QWORD   ?
stdout  QWORD   ?
nbrd    DWORD   ?
nbwr    DWORD   ?

        .CODE
Int2Str PROC
        push    rbx
        push    rdi

        mov     rbx, 10                     ; Divisor (10)
        xor     r10, r10                    ; Initial string length = 0
        lea     rdi, buffer+BufSiz          ; RDI points to end of buffer.

convert_loop:
        xor     rdx, rdx
        div     rbx                         ; RAX = quotient, RDX = remainder.
        add     dl, '0'                     ; Remainder to ASCII digit.
        dec     rdi
        mov     [rdi], dl                   ; Store digit.
        inc     r10                         ; Length++
        test    rax, rax
        jnz     convert_loop

        mov     rax, rdi                    ; Return pointer to first digit.

        pop     rdi
        pop     rbx
        ret
Int2Str ENDP

main    PROC
        sub     rsp, 40

        mov     rcx, STD_INPUT_HANDLE
        call    GetStdHandle
        mov     [stdin], rax

        mov     rcx, STD_OUTPUT_HANDLE
        call    GetStdHandle
        mov     [stdout], rax

prompt_loop:
        mov     rcx, [stdout]
        lea     rdx, msg
        mov     r8, LENGTHOF msg
        lea     r9, nbwr
        call    WriteConsoleA

        mov     rcx, [stdin]
        lea     rdx, buffer
        mov     r8, BufSiz
        lea     r9, nbrd
        call    ReadFile

        mov     r8d, [nbrd]
        cmp     r8d, 2                      ; 2 = CRLF
        je      prompt_loop
        cmp     r8d, 4                      ; 4 = CRLF + 2 digits
        ja      prompt_loop

        movzx   rax, BYTE PTR [buffer]
        sub     rax, '0'
        cmp     rax, MinVal
        jl      prompt_loop

        cmp     r8d, 3                      ; 3 = CRLF + 1 digit
        je      continue

        imul    rax, rax, 10
        movzx   rdx, BYTE PTR [buffer+1]
        sub     rdx, '0'
        add     rax, rdx

        cmp     rax, MaxVal
        jg      prompt_loop

continue:
        mov     r12, rax                    ; Save initial value of RAX (Fn)
        xor     r13, r13                    ; Counter = 0

        mov     rax, 0                      ; Initial values for Fibonacci in RAX and RCX.
        mov     rcx, 1

fib_loop:
        push    rax
        push    rcx

        call    Int2Str
        mov     rcx, [stdout]
        mov     rdx, rax
        mov     r8, r10
        lea     r9, nbwr
        call    WriteConsoleA

        mov     rcx, [stdout]
        lea     rdx, newln
        mov     r8d, LENGTHOF newln
        lea     r9, nbwr
        call    WriteConsoleA

        pop     rcx
        pop     rax

        test    r12, r12                    ; Was initial value 0?
        jz      exit                        ; Yes, exit.

        cmp     r13, r12                    ; Done iterating?
        je      exit                        ; Yes, exit.

        xadd    rax, rcx                    ; RCX = RAX, RAX = RAX + RCX
        inc     r13                         ; Counter++
        jmp     fib_loop

exit:
        xor     rcx, rcx
        call    ExitProcess
main    ENDP
        END

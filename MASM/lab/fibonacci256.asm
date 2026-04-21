;==============================================================
; Print Fibonacci sequence up to Fn.
; Range: n=0 to n=370
; Logic: 256-bit unsigned arithmetic using 4x64-bit registers.
;
; Author: Bryan C.
; Date  : 2026-04-20
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
MaxVal              EQU 370

        .DATA
msg     BYTE    "Enter a number (0 - 370): "
newln   BYTE    0Dh, 0Ah
buffer  BYTE    BufSiz DUP (?)
stdin   QWORD   ?
stdout  QWORD   ?
nbrd    DWORD   ?
nbwr    DWORD   ?

        .CODE
Int256S PROC
        push    RBX
        push    RDI
        push    R12
        push    R13
        push    R14
        push    R15

        mov     R12, RAX
        mov     R13, RBX
        mov     R14, RCX
        mov     R15, RDX

        mov     RBX, 10                     ; Divisor (10)
        xor     R10, R10                    ; Initial string length = 0
        lea     RDI, buffer+BufSiz          ; RDI points to end of buffer

convert_loop:
        xor     RDX, RDX                    ; Clear remainder
        mov     RAX, R15                    ; High 64-bits
        div     RBX                         ; RAX = quotient, RDX = remainder
        mov     R15, RAX                    ; R15 = new quotient

        mov     RAX, R14                    ; Next 64-bits
        div     RBX
        mov     R14, RAX

        mov     RAX, R13                    ; Next 64-bits
        div     RBX
        mov     R13, RAX

        mov     RAX, R12                    ; Low 64-bits
        div     RBX
        mov     R12, RAX

        add     DL, '0'                     ; Remainder to ASCII digit.
        dec     RDI
        mov     [RDI], DL                   ; Store digit.
        inc     R10                         ; Length++

        mov     RAX, R15                    ; All quotients zero?
        or      RAX, R14
        or      RAX, R13
        or      RAX, R12
        jnz     convert_loop                ; No, jump to loop start

        mov     RAX, RDI                    ; Return pointer to first digit

        pop     R15
        pop     R14
        pop     R13
        pop     R12
        pop     RDI
        pop     RBX
        ret
Int256S ENDP

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
        call    ReadFile

        mov     R8D, [nbrd]
        cmp     R8D, 2                      ; 2 = CRLF
        je      prompt_loop
        cmp     R8D, 5                      ; 5 = CRLF + 3 digits
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

        cmp     R8D, 4                      ; 4 = CRLF + 2 digits
        je      continue

        imul    RAX, RAX, 10
        movzx   RDX, BYTE PTR [buffer+2]
        sub     RDX, '0'
        add     RAX, RDX

        cmp     RAX, MaxVal
        jg      prompt_loop

continue:
        mov     RDI, RAX                    ; RDI = counter (initial value of Fn)

        ; Initial Fibonacci values each in four 64-bit registers (up to 256-bit integers)
        ; F0 = 0 (RAX:RBX:RCX:RDX)
        ; F1 = 1 (R8:R9:R10:R11)
        xor     RAX, RAX
        xor     RBX, RBX
        xor     RCX, RCX
        xor     RDX, RDX

        mov     R8, 1
        xor     R9, R9
        xor     R10, R10
        xor     R11, R11

fib_loop:
        push    RAX
        push    RBX
        push    RCX
        push    RDX
        push    R8
        push    R9
        push    R10
        push    R11

        call    Int256S
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
        pop     R9
        pop     R8
        pop     RDX
        pop     RCX
        pop     RBX
        pop     RAX

        test    RDI, RDI                    ; Was initial value 0?
        jz      exit                        ; Yes, exit

        mov     R12, RAX                    ; Store initial values of F0 registers
        mov     R13, RBX
        mov     R14, RCX
        mov     R15, RDX

        add     RAX, R8                     ; Low 64-bits (sets CF)
        adc     RBX, R9                     ; Next 64-bits + CF
        adc     RCX, R10                    ; Next 64-bits + CF
        adc     RDX, R11                    ; High 64-bits + CF

        mov     R8, R12                     ; Shift previous F0 into F1 registers
        mov     R9, R13
        mov     R10, R14
        mov     R11, R15

        dec     RDI                         ; Counter--
        jmp     fib_loop

exit:
        xor     RCX, RCX
        call    ExitProcess
main    ENDP
        END

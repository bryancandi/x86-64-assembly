;==============================================================
; Print Fibonacci sequence up to Fn.
; Range: n=0 to n=370
; 256-bit unsigned addition using ADC (Add with Carry) logic.
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
        push    rbx
        push    rdi
        push    r12
        push    r13
        push    r14
        push    r15

        mov     r12, rax
        mov     r13, rbx
        mov     r14, rcx
        mov     r15, rdx

        mov     rbx, 10                     ; Divisor (10)
        xor     r10, r10                    ; Initial string length = 0
        lea     rdi, buffer+BufSiz          ; RDI points to end of buffer

convert_loop:
        xor     rdx, rdx                    ; Clear remainder
        mov     rax, r15                    ; High 64-bits
        div     rbx                         ; RAX = quotient, RDX = remainder
        mov     r15, rax                    ; R15 = new quotient

        mov     rax, r14                    ; Next 64-bits
        div     rbx
        mov     r14, rax

        mov     rax, r13                    ; Next 64-bits
        div     rbx
        mov     r13, rax

        mov     rax, r12                    ; Low 64-bits
        div     rbx
        mov     r12, rax

        add     dl, '0'                     ; Remainder to ASCII digit.
        dec     rdi
        mov     [rdi], dl                   ; Store digit.
        inc     r10                         ; Length++

        mov     rax, r15                    ; All quotients zero?
        or      rax, r14
        or      rax, r13
        or      rax, r12
        jnz     convert_loop                ; No, jump to loop start

        mov     rax, rdi                    ; Return pointer to first digit

        pop     r15
        pop     r14
        pop     r13
        pop     r12
        pop     rdi
        pop     rbx
        ret
Int256S ENDP

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
        cmp     r8d, 5                      ; 5 = CRLF + 3 digits
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

        cmp     r8d, 4                      ; 4 = CRLF + 2 digits
        je      continue

        imul    rax, rax, 10
        movzx   rdx, BYTE PTR [buffer+2]
        sub     rdx, '0'
        add     rax, rdx

        cmp     rax, MaxVal
        jg      prompt_loop

continue:
        mov     rdi, rax                    ; RDI = counter (initial value of Fn)

        ; Initial Fibonacci values each in four 64-bit registers (up to 256-bit integers)
        ; F0 = 0 (RAX:RBX:RCX:RDX)
        ; F1 = 1 (R8:R9:R10:R11)
        xor     rax, rax
        xor     rbx, rbx
        xor     rcx, rcx
        xor     rdx, rdx

        mov     r8, 1
        xor     r9, r9
        xor     r10, r10
        xor     r11, r11

fib_loop:
        push    rax
        push    rbx
        push    rcx
        push    rdx
        push    r8
        push    r9
        push    r10
        push    r11

        call    Int256S
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

        pop     r11
        pop     r10
        pop     r9
        pop     r8
        pop     rdx
        pop     rcx
        pop     rbx
        pop     rax

        test    rdi, rdi                    ; Was initial value 0?
        jz      exit                        ; Yes, exit

        mov     r12, rax                    ; Store initial values of F0 registers
        mov     r13, rbx
        mov     r14, rcx
        mov     r15, rdx

        add     rax, r8                     ; Low 64-bits (sets CF)
        adc     rbx, r9                     ; Next 64-bits + CF
        adc     rcx, r10                    ; Next 64-bits + CF
        adc     rdx, r11                    ; High 64-bits + CF

        mov     r8, r12                     ; Shift previous F0 into F1 registers
        mov     r9, r13
        mov     r10, r14
        mov     r11, r15

        dec     rdi                         ; Counter--
        jmp     fib_loop

exit:
        xor     rcx, rcx
        call    ExitProcess
main    ENDP
        END

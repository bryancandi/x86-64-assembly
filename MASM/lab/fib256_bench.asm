;==============================================================
; Calculate Fibonacci sequence up to F370 in registers.
; 256-bit Fibonacci benchmark (no I/O overhead).
;
; Author: Bryan C.
; Date  : 2026-04-21
;
; Assemble with MASM and link:
; ml64.exe fibonacci.asm /link /SUBSYSTEM:console /ENTRY:main
;==============================================================

INCLUDELIB kernel32.lib

ExitProcess     PROTO

BufSiz          EQU 256
Fn              EQU 370

        .DATA

        .CODE
main    PROC
        sub     rsp, 40

        mov     rdi, Fn                     ; RDI = counter

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
        jnz     fib_loop

        xor     rcx, rcx
        call    ExitProcess
main    ENDP
        END

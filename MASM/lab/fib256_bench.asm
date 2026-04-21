;==============================================================
; 256-bit Fibonacci benchmark (no printing)
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
        sub     RSP, 40

        mov     RDI, Fn                     ; RDI = counter

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
        mov     R12, RAX                    ; Temp store initial values of F0 registers
        mov     R13, RBX
        mov     R14, RCX
        mov     R15, RDX

        add     RAX, R8                     ; Add low 64-bits (clears CF)
        adc     RBX, R9                     ; + CF
        adc     RCX, R10                    ; + CF
        adc     RDX, R11                    ; High 64-bits + CF

        mov     R8, R12                     ; Restore initial values of F0 to F1 registers
        mov     R9, R13
        mov     R10, R14
        mov     R11, R15

        dec     RDI                         ; Counter--
        jnz     fib_loop

exit:
        xor     RCX, RCX
        call    ExitProcess
main    ENDP
        END

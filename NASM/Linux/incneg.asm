;--------------------------------------------------------------------
; INCNEG: x64 inc and neg example.
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode
bits 64

section .data
    var dq 99;

section .text
global _start               ; Entry point for Linux executables.

_start:
    xor rcx, rcx            ; Clear rcx register.
    inc qword [var];        ; Increment variable 'var' by 1.
    mov rcx, 51             ; Move 51 into rcx register.
    dec rcx                 ; Decrement rcx by 1.
    neg rcx                 ; Negate value in rcx.

    mov     rdi, 0          ; exit code 0.
    mov     rax, 60         ; syscall number for exit.
    syscall

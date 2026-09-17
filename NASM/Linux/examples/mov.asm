;--------------------------------------------------------------------
; MOV: x64 mov example.
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode
bits 64

section .data
    var dq 100              ; Define a 64-bit variable initialized to 100.

section .text
global _start               ; Entry point for Linux executables.

_start:
    xor rcx, rcx            ; Clear rcx register.
    xor rdx, rdx            ; Clear rdx register.
    mov rcx, 33             ; Load 33 into rcx.
    mov rdx, rcx            ; Copy the value from rcx into rdx.
    mov rcx, [var]          ; Copy the value of 'var' into rcx.
    mov [var], rdx          ; Copy the value of rdx into 'var'.

    mov     rdi, 0          ; exit code 0.
    mov     rax, 60         ; syscall number for exit.
    syscall

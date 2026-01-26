;--------------------------------------------------------------------
; NASM: A barebones Linux x64 template
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode
bits 64

section .data
    ; Variable declarations go here.

section .text
global _start               ; Entry point for Linux executables.

_start:
    ; Assembly instructions go here.

    mov     rdi, 0          ; exit code 0.
    mov     rax, 60         ; syscall number for exit.
    syscall

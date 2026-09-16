;--------------------------------------------------------------------
; NASM: A barebones Linux x64 template
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode and RIP-relative addressing mode
bits 64
default rel

section .data
    ; Variable declarations go here.

section .text
global _start               ; Entry point for Linux executables.

_start:
    ; Assembly instructions go here.

    xor rdi, rdi            ; exit code 0.
    mov rax, 60             ; syscall number for exit.
    syscall

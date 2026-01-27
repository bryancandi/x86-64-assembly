;--------------------------------------------------------------------
; EQU: x64 equ example.
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode
bits 64

section .data
    con equ 12              ; Define a constant named 'con' with value 12.

section .text
global _start               ; Entry point for Linux executables.

_start:
    xor rcx, rcx            ; Clear rcx register.
    xor rdx, rdx            ; Clear rdx register.
    mov rcx, con            ; Move the value of constant 'con' into rcx register.
    mov rdx, con + 8        ; Move the value of constant 'con' + 8 into rdx register.
    mov rcx, con + 8 * 2    ; Move the value of constant 'con' + 16 into rcx register.
    mov rdx, (con + 8) * 2  ; Move the value of constant ('con' + 8) * 2 into rdx register.
    mov rcx, con % 5        ; Move the value of constant 'con' mod 5 into rcx register.
    mov rdx, (con - 3) / 3  ; Move the value of constant ('con' - 3) / 3 into rdx register.

    mov     rdi, 0          ; exit code 0.
    mov     rax, 60         ; syscall number for exit.
    syscall

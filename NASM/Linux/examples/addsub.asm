;--------------------------------------------------------------------
; ADDSUB: x64 add and sub example.
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode
bits 64

section .data
    var dq 64               ; Define a 64-bit variable initialized to 64.

section .text
global _start               ; Entry point for Linux executables.

_start:
    xor rcx, rcx            ; Clear rcx register.
    xor rdx, rdx            ; Clear rdx register.
    mov rcx, 36             ; Load 36 into rcx.
    add rcx, [var]          ; Add the value of 'var' to rcx.
    mov rdx, 400            ; Load 400 into rdx.
    add rdx, rcx,           ; Add the value of rcx to rdx.
    sub rcx, 100            ; Subtract 100 from rcx.

    mov     rdi, 0          ; exit code 0.
    mov     rax, 60         ; syscall number for exit.
    syscall

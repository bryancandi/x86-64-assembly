;--------------------------------------------------------------------
; XCHG: x64 xchg example.
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode
bits 64

section .data
    var dq 1                ; Reserve 1 quadword.

section .text
global _start               ; Entry point for Linux executables.

_start:
    xor rcx, rcx            ; Clear rcx register.
    xor rdx, rdx            ; Clear rdx register.
    mov rcx, 5              ; Load 5 into rcx.
    xchg rcx, [var]         ; Exchange the value in rcx with the value in 'var'.
    mov dl, 3               ; Load 3 into dl.
    xchg dh, dl             ; Exchange the value in dh with the value in dl.

    mov     rdi, 0          ; exit code 0.
    mov     rax, 60         ; syscall number for exit.
    syscall

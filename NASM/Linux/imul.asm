;--------------------------------------------------------------------
; IMUL: x64 imul example.
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode
bits 64

section .data
    var dq 4                ; Define a 64-bit variable 'var' initialized to 4.

section .text
global _start               ; Entry point for Linux executables.

_start:
    xor rax, rax            ; Clear rax register.
    xor rbx, rbx            ; Clear rbx register.
    mov rax, 10             ; Load 10 into rax.
    mov rbx, 2              ; Load 2 into rbx.
    imul rbx                ; Signed multiply rax by rbx (rax = rax * rbx).
    imul rax, [var]         ; Signed multiply rax by 'var' (rax = rax * var).
    imul rax, rbx, -3       ; Signed multiply rbx by -3 and store result in rax (rax = rbx * -3).

    mov     rdi, 0          ; exit code 0.
    mov     rax, 60         ; syscall number for exit.
    syscall

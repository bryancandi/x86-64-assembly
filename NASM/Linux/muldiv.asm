;--------------------------------------------------------------------
; MULDIV: x64 mul and div example.
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode
bits 64

section .data
    var dq 2                ; Define a 64-bit variable 'var' initialized to 2.

section .text
global _start               ; Entry point for Linux executables.

_start:
    xor rdx, rdx            ; Clear rdx register.
    mov rax, 10             ; Load 10 into rax.
    mov rbx, 5              ; Load 5 into rbx.
    mul rbx;                ; Unsigned multiply rax by rbx (rax = rax * rbx).
    mul qword [var]         ; Unsigned multiply rax by 'var' (rax = rax * var).
    mov rbx, 8              ; Load 8 into rbx.
    div rbx                 ; Unsigned divide rax by rbx (rax = rax / rbx), remainder in rdx.

    mov     rdi, 0          ; exit code 0.
    mov     rax, 60         ; syscall number for exit.
    syscall

;--------------------------------------------------------------------
; IDIV: x64 idiv example.
; Assemble with NASM and link:
;   nasm -f elf64 -o source.o source.asm
;   ld -o source source.o
;--------------------------------------------------------------------

; Set 64-bit mode
bits 64

section .data

section .text
global _start               ; Entry point for Linux executables.

_start:
    xor rax, rax            ; Clear rax register.
    xor rbx, rbx            ; Clear rbx register.
    xor rdx, rdx            ; Clear rdx register.
    mov rax, 100            ; Load dividend (100) into rax.
    mov rbx, 3              ; Load divisor (3) into rbx.
    idiv rbx                ; Signed divide rax by rbx. Quotient in rax, remainder in rdx.
    mov rax, -100           ; Load dividend (-100) into rax.
    cqo	                    ; Sign-extend rax into rdx:rax for signed division (quadword to octoword).
    idiv rbx                ; Signed divide rax by rbx. Quotient in rax, remainder in rdx.

    mov     rdi, 0          ; exit code 0.
    mov     rax, 60         ; syscall number for exit.
    syscall

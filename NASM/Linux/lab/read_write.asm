;====================================================================
; Linux syscalls: read and write
;
; Assemble with NASM and link with GCC:
;   nasm -f elf64 read_write.asm -o read_write.o
;   ld read_write.o -o read_write
;
; syscall number in rax, args in rdi, rsi, rdx, r10, r8, r9
;====================================================================

bits 64
default rel

section .bss
buf:        resb    256
len_buf:    equ     $ - buf
chars_read: resq    1

section .rodata
prompt:     db      "Enter some text:  "
len_prompt: equ     $ - prompt
output:     db      "You entered text: "
len_output: equ     $ - output
error:      db      "EOF or invalid input."
len_error:  equ     $ - error
newline:    db      10

section .text
global _start
_start:
    ; write prompt
    mov     rax, 1              ; write syscall
    mov     rdi, 1              ; stdout
    mov     rsi, prompt
    mov     rdx, len_prompt
    syscall

    ; read input
    mov     rax, 0              ; read syscall
    mov     rdi, 0              ; stdin
    mov     rsi, buf
    mov     rdx, len_buf
    syscall

    cmp     rax, 0
    jle     .error              ; EOF or read error

    ; save number of chars read
    mov     [chars_read], rax

    ; write output
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, output
    mov     rdx, len_output
    syscall

    mov     rax, 1
    mov     rdi, 1
    mov     rsi, buf
    mov     rdx, [chars_read]
    syscall

    jmp     .done

    ; write error
.error:
    mov     rax, 1
    mov     rdi, 2              ; stderr
    mov     rsi, newline
    mov     rdx, 1
    syscall

    mov     rax, 1
    mov     rdi, 2              ; stderr
    mov     rsi, error
    mov     rdx, len_error
    syscall

    mov     rax, 1
    mov     rdi, 2              ; stderr
    mov     rsi, newline
    mov     rdx, 1
    syscall
.done:
    ; exit
    mov     rax, 60             ; exit syscall
    xor     rdi, rdi
    syscall

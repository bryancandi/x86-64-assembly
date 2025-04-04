; x86-64 Assembly "Hello World" program for Linux
; Assemble with NASM and linker:
; nasm -f elf64 -o hello_world.o hello_world.s
; ld -o hello_world hello_world.o

global _start                       ; Define the program entry point for the linker

section .text                       ; Code section containing executable instructions
_start:
    ; Write the message to standard output (stdout)
    mov rax, 1                      ; System call number for write
    mov rdi, 1                      ; File descriptor for stdout (1)
    mov rsi, msg                    ; Pointer to the message string
    mov rdx, msglen                 ; Length of the message string
    syscall                         ; Invoke the system call to write

    ; Exit the program with a success code
    mov rax, 60                     ; System call number for exit
    mov rdi, 0                      ; Exit code 0 (indicating success)
    syscall                         ; Invoke the kernel to perform the system call

section .rodata                     ; Read-only data section for constant strings saving memory
    msg: db "Hello, World!", 10     ; Message string with a newline (LF = 10)
    msglen: equ $ - msg             ; Calculate the length of the message
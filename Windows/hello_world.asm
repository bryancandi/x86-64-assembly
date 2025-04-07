; x86-64 Assembly "Hello World" program for Windows CLI
; Assemble with NASM and link:
; nasm -f win64 -o hello_world.obj hello_world.asm
; link /subsystem:console hello_world.obj kernel32.lib legacy_stdio_definitions.lib msvcrt.lib

; Set 64-bit mode and use relative addressing by default
bits 64
default rel

; Section to define initialized data
section .data
    msg db "Hello, World!", 0xd, 0xa, 0     ; Message to be printed (with newline and null terminator)

; Section to define code (instructions)
section .text
global main                                 ; Entry point for the linker
extern ExitProcess                          ; External Windows API: Terminate process
extern printf                               ; External Windows API: Function for formatted output

main:
    push rbp                                ; Save base pointer (used for stack frame setup)
    mov rbp, rsp                            ; Set the base pointer to the current stack pointer
    sub rsp, 32                             ; Allocate 32 bytes of stack space for local variables

    lea rcx, [msg]                          ; Load the address of the message into RCX (first argument to printf)
    call printf                             ; Call the printf function to print the message

    xor rax, rax                            ; Set RAX to 0 (exit code for ExitProcess)
    call ExitProcess                        ; Call ExitProcess to terminate the program

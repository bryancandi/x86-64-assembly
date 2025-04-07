; x86-64 Assembly "Hello World" program for Windows GUI
; Assemble with NASM and link:
; nasm -f win64 -o hello_world_gui.obj hello_world_gui.asm
; link /entry:main /subsystem:windows hello_world_gui.obj kernel32.lib user32.lib

; Set 64-bit mode and use relative addressing by default
bits 64
default rel

; Section to define initialized data
section .data
    title db "ASM Greetings!", 0                        ; Title of the message box (null-terminated string)
    msg db "Hello, World!", 10, "Hello, Assembly!", 0   ; Message text with newline (10 = \n) (null-terminated string)

; Section to define code (instructions)
section .text
global main                                 ; Entry point for the linker
extern ExitProcess                          ; External Windows API: Terminate process
extern MessageBoxA                          ; External Windows API: Display message box

main:
    push rbp                                ; Save base pointer (used for stack frame setup)
    mov rbp, rsp                            ; Set the base pointer to the current stack pointer
    sub rsp, 32                             ; Allocate 32 bytes of stack space for local variables

    xor rcx, rcx                            ; HWND (NULL for no owner window) (first arg)
    lea rdx, [msg]                          ; Message text (second arg)
    lea r8, [title]                         ; Title text (third arg)
    mov r9d, 0x40                           ; Style for message box: MB_ICONINFORMATION (fourth arg)
    call MessageBoxA                        ; Call the MessageBoxA function

    xor rax, rax                            ; Set RAX to 0 (exit code for ExitProcess)
    call ExitProcess                        ; Call ExitProcess to terminate the program

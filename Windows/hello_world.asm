; x86-64 Assembly "Hello World" program for Windows CLI
; Assemble with NASM and linker:
; nasm.exe -f win64 -o hello_world.obj hello_world.asm
; link.exe /entry:_start /subsystem:console hello_world.obj kernel32.lib 

extern GetStdHandle                 ; External Windows API function to get console handles
extern WriteFile                    ; External Windows API function to write to files/handles
extern ExitProcess                  ; External Windows API function to terminate the process

global _start                       ; Define the program entry point for the Windows linker

section .text                       ; Code section containing executable instructions
_start:
    ; Get handle for standard output (stdout)
    mov rcx, -11                    ; -11 = STD_OUTPUT_HANDLE (Windows API constant)
    call GetStdHandle               ; Retrieve stdout handle (returned in rax)

    ; Save the handle in rbx for reuse
    mov rbx, rax                    ; Store stdout handle from rax into rbx

    ; Write the message to standard output
    mov rcx, rbx                    ; Handle to stdout (first argument)
    lea rdx, [rel msg]              ; Pointer to message string (RIP-relative, second argument)
    mov r8, msglen                  ; Length of message string (third argument)
    mov r9, 0                       ; lpOverlapped = NULL (fourth argument, not used)
    lea rax, [rel bytes_written]    ; Pointer to bytes_written variable (fifth argument)
    push rax                        ; Push fifth argument onto stack
    sub rsp, 32                     ; Allocate shadow space (32 bytes) for Windows x64 ABI
    call WriteFile                  ; Call WriteFile to output the message
    add rsp, 40                     ; Clean up stack (32 bytes shadow + 8 bytes for push)

    ; Exit the program with a success code
    mov ecx, 0                      ; Exit code 0 (indicating success)
    call ExitProcess                ; Terminate the process

section .const                      ; Read-only data section for constant strings
    msg db "Hello, World!", 13, 10  ; Message string with CRLF (Windows newline)
    msglen equ $ - msg              ; Calculate the length of the message

section .data                       ; Writable data section for variables
    bytes_written dd 0              ; Variable to store number of bytes written by WriteFile
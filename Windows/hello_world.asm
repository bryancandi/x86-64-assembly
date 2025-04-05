; x86-64 Assembly "Hello World" program for Windows CLI
; Assemble with NASM and link:
; nasm -f win64 -o hello_world.obj hello_world.asm
; link /entry:start /subsystem:console hello_world.obj kernel32.lib

extern GetStdHandle                 ; External Windows API: Get console handles
extern WriteFile                    ; External Windows API: Write to files/handles
extern ExitProcess                  ; External Windows API: Terminate process

global start                        ; Entry point

section .text                       ; Code section
start:
    ; Get handle for standard output (stdout)
    sub rsp, 32                     ; Reserve shadow space
    mov rcx, -11                    ; STD_OUTPUT_HANDLE constant
    call GetStdHandle               ; Get stdout handle (returned in rax)
    add rsp, 32                     ; Restore stack

    ; Write the message to standard output
    sub rsp, 40                     ; Reserve shadow space (32) + 8 for fifth argument
    mov rcx, rax                    ; Handle (1st argument)
    lea rdx, [rel msg]              ; Pointer to message (2nd argument)
    mov r8, msglen                  ; Length of message (3rd argument)
    xor r9, r9                      ; Set lpNumberOfBytesWritten to NULL (4th arg) to skip bytes-written output
    mov qword [rsp + 32], 0         ; Set lpOverlapped to NULL (5th arg) for synchronous write operation
    call WriteFile                  ; Call WriteFile
    add rsp, 40                     ; Restore stack

    ; Exit the program with a success code
    sub rsp, 32                     ; Reserve shadow space
    xor rcx, rcx                    ; Exit code 0
    call ExitProcess                ; Terminate the process

section .const                      ; Read-only data
    msg db "Hello, World!", 13, 10  ; Message string with CRLF (newline)
    msglen equ $ - msg              ; Length of message
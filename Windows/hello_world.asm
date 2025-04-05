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
    call GetStdHandle               ; Get stdout handle (returned in RAX)
    add rsp, 32                     ; Restore stack

    ; Write "Hello, World!" to standard output
    sub rsp, 40                     ; Reserve shadow space (32) + 8 for fifth argument
    mov rcx, rax                    ; RAX File handle: Move handle from GetStdHandle (RAX) to RCX (1st arg for WriteFile)
    lea rdx, [rel msg]              ; RDX: Pointer to data to write: msg (2nd argument)
    mov r8, msglen                  ; R8: Number of bytes to write: msglen (3rd argument)
    xor r9, r9                      ; R9: Pointer to variable for bytes written: Set lpNumberOfBytesWritten to NULL, skip output (4th arg)
    mov qword [rsp + 32], 0         ; [RSP + 32]: Overlapped structure for async I/O (5th arg)
    call WriteFile                  ; Call WriteFile
    add rsp, 40                     ; Restore stack

    ; Exit the program with a success code
    sub rsp, 32                     ; Reserve shadow space
    xor rcx, rcx                    ; Exit code 0
    call ExitProcess                ; Terminate the process

section .const                      ; Read-only data
    msg db "Hello, World!", 13, 10  ; Message string with CRLF (newline)
    msglen equ $ - msg              ; Length of message

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

    ; Write "Hello, World!" to standard output (WriteFile)
    sub rsp, 40                     ; Reserve shadow space (32) + 8 for 5th argument
    mov rcx, rax                    ; RCX: File handle (hFile): Move handle from GetStdHandle (RAX) to RCX (1st argument)
    lea rdx, [rel msg]              ; RDX: Pointer to data to write (lpBuffer): msg (2nd argument)
    mov r8, msglen                  ; R8: Number of bytes to write (nNumberOfBytesToWrite): msglen (3rd argument)
    xor r9, r9                      ; R9: Set to NULL (via xor) (lpNumberOfBytesWritten): don't need byte count (4th argument)
    mov qword [rsp + 32], 0         ; [RSP + 32] (lpOverlapped): Set to NULL for synchronous write (5th argument)
    call WriteFile                  ; Call WriteFile
    add rsp, 40                     ; Restore stack

    ; Exit the program with a success code
    sub rsp, 32                     ; Reserve shadow space
    xor rcx, rcx                    ; Exit code 0
    call ExitProcess                ; Terminate the process

section .const                      ; Read-only data
    msg db "Hello, World!", 13, 10  ; Message string with CRLF (newline)
    msglen equ $ - msg              ; Length of message

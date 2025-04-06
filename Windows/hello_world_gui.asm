; x86-64 Assembly "Hello World" program for Windows GUI
; Assemble with NASM and link:
; nasm -f win64 -o hello_world_gui.obj hello_world_gui.asm
; link /entry:start /subsystem:windows hello_world_gui.obj kernel32.lib user32.lib

extern MessageBoxA                  ; External Windows API: Show a message box (from user32.dll)
extern ExitProcess                  ; External Windows API: Terminate process (from kernel32.dll)

global start                        ; Entry point

section .text                       ; Code section
start:
    ; Display "Hello, World!" in a message box
    sub rsp, 40                     ; Reserve shadow space (32) + 8 for alignment
    xor rcx, rcx                    ; RCX: Parent window handle: hWnd = NULL (no parent)
    lea rdx, [rel msg]              ; RDX: Message text: lpText = Message string
    lea r8, [rel title]             ; R8: Window title: lpCaption = Window title string
    xor r9, r9                      ; R9: Message box style: uType = MB_OK (OK button only)
    call MessageBoxA                ; Call MessageBoxA to show the popup
    add rsp, 40                     ; Restore stack

    ; Exit the program with a success code
    sub rsp, 32                     ; Reserve shadow space
    xor rcx, rcx                    ; Exit code 0
    call ExitProcess                ; Terminate the process

section .const                      ; Read-only data (.const)
    msg db "Hello, World!", 10, "Hello, Assembly!", 0   ; Message string with newline (10 = \n), null-terminated
    title db "Greetings from ASM!", 0                   ; Window title, null-terminated
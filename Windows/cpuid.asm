; x86-64 Assembly "CPUID" program for Windows GUI
; Assemble with NASM and link:
; nasm -f win64 -o cpuid.obj cpuid.asm
; link /entry:main /subsystem:windows cpuid.obj kernel32.lib user32.lib

; Set 64-bit mode and use relative addressing by default
bits 64
default rel

; Section to define buffer for CPU name
section .data
    title db "CPUID", 0                     ; Title of the message box (null-terminated string)
    cpuName db 48 dup(0)                    ; Reserve 48 bytes for the CPU brand string (null-terminated)

; Section to define code (instructions)
section .text
global main                                 ; Entry point for the linker
extern ExitProcess                          ; External Windows API: Terminate process
extern MessageBoxA                          ; External Windows API: Display message box

main:
    ; Save stack frame
    push rbp                                ; Save base pointer
    mov rbp, rsp                            ; Set base pointer to stack pointer
    sub rsp, 32                             ; Allocate local stack space

    ; Use CPUID to get CPU brand string
    mov eax, 0x80000002                     ; First part of the brand string
    cpuid                                   ; Execute CPUID instruction
    mov [cpuName], eax                      ; Store first 4 characters in the buffer
    mov [cpuName + 4], ebx                  ; Store next 4 characters
    mov [cpuName + 8], ecx                  ; Store next 4 characters
    mov [cpuName + 12], edx                 ; Store last 4 characters

    mov eax, 0x80000003                     ; Second part of the brand string
    cpuid                                   ; Execute CPUID instruction
    mov [cpuName + 16], eax                 ; Store first 4 characters
    mov [cpuName + 20], ebx                 ; Store next 4 characters
    mov [cpuName + 24], ecx                 ; Store next 4 characters
    mov [cpuName + 28], edx                 ; Store last 4 characters

    mov eax, 0x80000004                     ; Third part of the brand string
    cpuid                                   ; Execute CPUID instruction
    mov [cpuName + 32], eax                 ; Store first 4 characters
    mov [cpuName + 36], ebx                 ; Store next 4 characters
    mov [cpuName + 40], ecx                 ; Store next 4 characters
    mov [cpuName + 44], edx                 ; Store last 4 characters

    ; Display CPU name using MessageBoxA
    xor rcx, rcx                            ; HWND (NULL for no owner)
    lea rdx, [cpuName]                      ; Pointer to CPU name buffer
    lea r8, [title]                         ; Title text (third argument)
    mov r9d, 0x40                           ; MB_ICONINFORMATION (style for message box)
    call MessageBoxA                        ; Call MessageBoxA function

    ; Exit program
    xor rax, rax                            ; Set RAX to 0 (exit code)
    call ExitProcess                        ; Call ExitProcess to terminate program

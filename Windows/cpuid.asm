; x86-64 Assembly "CPUID" program for Windows CLI
; Assemble with NASM and link:
; nasm -f win64 -o cpuid.obj cpuid.asm
; link /subsystem:console cpuid.obj kernel32.lib legacy_stdio_definitions.lib msvcrt.lib

; Set 64-bit mode and use relative addressing by default
bits 64
default rel

; Section to define buffer for CPU name
section .data
    processorText db 0xa, "Processor:", 0xa, 0  ; Label for processor info (null-terminated with LF (0xa) before and after)
    cpuName db 48 dup(0)                    ; Buffer for CPU brand string (null-terminated)
    endLine db 0xd, 0xa, " ", 0             ; Empty line for future use (null-terminated with CRLF (0xd, 0xa))
    formatString db "%s%s%s", 0             ; Format string for printf (three strings)

; Section to define code (instructions)
section .text
global main                                 ; Entry point for the linker
extern ExitProcess                          ; External Windows API: Terminate process
extern printf                               ; External Windows API: Function for formatted output

main:
    push rbp                                ; Save base pointer (used for stack frame setup)
    mov rbp, rsp                            ; Set the base pointer to the current stack pointer
    sub rsp, 32                             ; Allocate 32 bytes of stack space for local variables

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

    lea rcx, [formatString]                 ; First argument (RCX register): pointer to format string
    lea rdx, [processorText]                ; Second argument (RDX register): pointer to label text
    lea r8, [cpuName]                       ; Third argument (R8 register): pointer to CPU brand string
    lea r9, [endLine]                       ; Fourth argument (R9 register): pointer to empty string
    call printf                             ; Call printf to print the formatted output

    xor rax, rax                            ; Set RAX to 0 (exit code)
    call ExitProcess                        ; Call ExitProcess to terminate program

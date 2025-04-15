; x86-64 Assembly "SYSINFO" program for Intel CPUs on Windows CLI
; Assemble with NASM and link:
; nasm -f win64 -o sysinfo.obj sysinfo.asm
; link /subsystem:console sysinfo.obj kernel32.lib legacy_stdio_definitions.lib msvcrt.lib

; Set 64-bit mode and use relative addressing by default
bits 64
default rel

; Section to define variables and buffers
section .data
    processorText db 0xa, "--- Processor Info ---", 0xa, 0  ; Procesor label (null-terminated with LF (0xa) before and after)
    cpuName db 48 dup(0)                                    ; Buffer for CPU brand string (null-terminated)
    coreLabel db "Logical Processors: %d", 0xa, 0           ; Format string (null-terminated with LF)
    
    memoryText db "--- Memory Info ---", 0xa, 0             ; Memory label (null-terminated with LF)
    memInfoSize dq 64                                       ; Length of MEMORYSTATUSEX structure
    memInfo times 64 db 0                                   ; MEMORYSTATUSEX structure buffer
    totalRamLabel db "Total RAM: %llu bytes", 0xa, 0        ; Format string (null-terminated with LF)
    freeRamLabel db "Free RAM: %llu bytes", 0xa, 0          ; Format string (null-terminated with LF)

    newline db 0xa, 0                                       ; Print a new line

; Section to define code (instructions)
section .text
global main                                 ; Entry point for the linker
extern ExitProcess                          ; External Windows API: Terminate process
extern printf                               ; External Windows API: Function for formatted output
extern GlobalMemoryStatusEx                 ; External Windows API: Detailed memory info

main:
    push rbp                                ; Save base pointer (used for stack frame setup)
    mov rbp, rsp                            ; Set the base pointer to the current stack pointer
    sub rsp, 32                             ; Allocate 32 bytes of stack space for local variables

; Print processor text
    lea rcx, [processorText]
    call printf

; Use CPUID to get CPU brand string and print
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

    lea rcx, [cpuName]                      ; Load address of format string   
    call printf                             ; Call printf to print the formatted output

; Print a newline
    lea rcx, [newline]
    call printf

; Use CPUID to get logical processor count from CPUID leaf 0x0B and print
    mov eax, 0x0B                           ; Set EAX to 0x0B (the CPUID leaf for topology information)
    mov ecx, 1                              ; Set ECX to 1 (query the core level topology)
    cpuid                                   ; Execute CPUID instruction
    mov edx, ebx                            ; Total logical processors (second argument to printf)

    lea rcx, [coreLabel]                    ; Load address of format string
    call printf                             ; Call printf to print the formatted output

; Print a newline
    lea rcx, [newline]
    call printf

; Print memory text
    lea rcx, [memoryText]
    call printf

; Get total physical RAM and print
    lea rcx, [memInfo]                      ; RCX = pointer to MEMORYSTATUSEX struct
    mov dword [memInfo], 64                 ; Set dwLength = 64 (first 4 bytes)

    call GlobalMemoryStatusEx               ; Retrieve system memory information and populate MEMORYSTATUSEX structure

    mov rax, [memInfo + 8]                  ; RAX = ullTotalPhys (offset 8)
    mov rdx, rax                            ; RDX = %llu value for total RAM (bytes)

    lea rcx, [totalRamLabel]                ; Load address of format string
    call printf                             ; Call printf to print the formatted output

; Get free physical RAM and print
    lea rcx, [memInfo]                      ; RCX = pointer to MEMORYSTATUSEX struct
    mov dword [memInfo], 64                 ; Set dwLength = 64 (first 4 bytes)

    call GlobalMemoryStatusEx               ; Retrieve system memory information and populate MEMORYSTATUSEX structure

    mov rax, [memInfo + 16]                 ; RAX = ullAvailPhys (offset 16)
    mov rdx, rax                            ; RDX = %llu value for free RAM (bytes)

    lea rcx, [freeRamLabel]                 ; Load address of format string
    call printf                             ; Call printf to print the formatted output

; Print a newline
    lea rcx, [newline]
    call printf

; Terminate program
    xor rax, rax                            ; Set RAX to 0 (exit code)
    call ExitProcess                        ; Call ExitProcess to terminate program

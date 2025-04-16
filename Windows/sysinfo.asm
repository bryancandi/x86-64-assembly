; x86-64 Assembly "SYSINFO" program for Intel CPUs on Windows CLI
; Assemble with NASM and link:
; nasm -f win64 -o sysinfo.obj sysinfo.asm
; link /subsystem:console sysinfo.obj kernel32.lib legacy_stdio_definitions.lib msvcrt.lib

; Set 64-bit mode and use relative addressing by default
bits 64
default rel

; Section to define variables and buffers
section .data
    processorTitle db 0xa, "--- Processor Info ---", 0xa, 0 ; Procesor title text (null-terminated with LF (0xa) before and after)
    cpuName db 48 dup(0)                                    ; Buffer for CPU brand string (null-terminated)
    coreLabel db "Logical Processors: %d", 0xa, 0           ; Format string (null-terminated with LF)

    memoryTitle db "--- Memory Info ---", 0xa, 0            ; Memory title text (null-terminated with LF)
    memInfo times 64 db 0                                   ; MEMORYSTATUSEX structure buffer
    gibDivisor dq 1073741824                                ; Define (1024 * 1024 * 1024) as a QWORD (64-bit) integer
    totalRamLabel db "Total RAM: %llu bytes (%llu GiB)", 0xa, 0 ; Format string (null-terminated with LF)    
    freeRamLabel db "Free RAM: %llu bytes (%llu GiB)", 0xa, 0   ; Format string (null-terminated with LF)    

    newline db 0xa, 0                                       ; Print a new line

; Section to define code (instructions)
section .text
global main                                 ; Entry point for the linker
extern ExitProcess                          ; External Windows API: Terminate process
extern printf                               ; External Windows API: Function for formatted output
extern GlobalMemoryStatusEx                 ; External Windows API: Detailed memory info

; Function to convert bytes to GiB and round to the nearest whole number
bytesToGibRounded:
    mov rbx, [gibDivisor]                   ; Load the divisor into RBX
    xor rdx, rdx                            ; Clear RDX for the division
    div rbx                                 ; RAX = quotient (GiB), RDX = remainder

    cmp rdx, 536870912                      ; Check if remainder is >= 0.5 GiB (in bytes)
    jl .round_down_gib                      ; Jump if remainder is Less Than 0.5 GiB
    inc rax                                 ; Round up (remainder is >= 0.5 GiB)

.round_down_gib:
    ret                                     ; Return with rounded GiB in RAX

main:
    push rbp                                ; Save base pointer (used for stack frame setup)
    mov rbp, rsp                            ; Set the base pointer to the current stack pointer
    sub rsp, 32                             ; Allocate 32 bytes of stack space for local variables

; Print processor title text
    lea rcx, [processorTitle]
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

; Print memory title text
    lea rcx, [memoryTitle]
    call printf

; Get total physical RAM and print
    lea rcx, [memInfo]                      ; RCX = pointer to MEMORYSTATUSEX struct
    mov dword [memInfo], 64                 ; Set dwLength = 64 (first 4 bytes)

    call GlobalMemoryStatusEx               ; Retrieve system memory information and populate MEMORYSTATUSEX structure

    mov rax, [memInfo + 8]                  ; RAX = ullTotalPhys (offset 8)
    mov rsi, rax                            ; Save the original RAM value in RSI
    mov rdx, rax                            ; RDX = initial upper part of dividend (will be cleared)

    call bytesToGibRounded                  ; Get rounded GiB in RAX

    mov rdx, rsi                            ; Move the original RAM value from RSI to RDX for printf
    mov r8, rax                             ; Move the integer GiB value to R8 for printf
    lea rcx, [totalRamLabel]                ; Load address of format string
    call printf                             ; Call printf to print the formatted output

; Get free physical RAM and print
    lea rcx, [memInfo]                      ; RCX = pointer to MEMORYSTATUSEX struct
    mov dword [memInfo], 64                 ; Set dwLength = 64 (first 4 bytes)

    call GlobalMemoryStatusEx               ; Retrieve system memory information and populate MEMORYSTATUSEX structure

    mov rax, [memInfo + 16]                 ; RAX = ullAvailPhys (offset 16)
    mov rsi, rax                            ; Save the original RAM value in RSI
    mov rdx, rax                            ; RDX = initial upper part of dividend (will be cleared)

    call bytesToGibRounded                  ; Get rounded GiB in RAX

    mov rdx, rsi                            ; Move the original RAM value from RSI to RDX for printf
    mov r8, rax                             ; Move the integer GiB value to R8 for printf
    lea rcx, [freeRamLabel]                 ; Load address of format string
    call printf                             ; Call printf to print the formatted output

; Print a newline
    lea rcx, [newline]
    call printf

; Terminate program
    xor rax, rax                            ; Set RAX to 0 (exit code)
    call ExitProcess                        ; Call ExitProcess to terminate program

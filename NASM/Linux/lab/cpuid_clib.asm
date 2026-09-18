;====================================================================
; x86-64 Assembly "CPUID" program for Intel CPUs on Linux
; Uses C function: printf
;
; Assemble with NASM and link with GCC:
;   nasm -f elf64 cpuid.asm -o cpuid.o
;   gcc cpuid.o -o cpuid
;====================================================================

; Set 64-bit mode and use relative addressing by default
bits 64
default rel

; Section to define variables, buffers, constants
section .bss
cpubuf: resb    48              ; 48 byte buffer for CPU brand string

section .rodata
nl:     equ     10
dash:   db      "----------------------------------------", nl, 0
title:  db      "Processor", nl, 0
fmt0:   db      "%s", 0
fmt1:   db      "Model      : %s", nl, 0
fmt2:   db      "Threads    : %d", nl, 0

; Section to define code (instructions)
section .text
extern printf                   ; External printf function
global main                     ; Entry point for the linker

main:
    sub     rsp, 8              ; Realign stack to 16 byte boundary

    ; Print title text and separator line
    lea     rdi, [fmt0]
    lea     rsi, [title]
    xor     al, al              ; 0 floating-point registers used
    call    printf wrt ..plt

    lea     rdi, [fmt0]
    lea     rsi, [dash]
    xor     al, al
    call    printf wrt ..plt

    ; Use CPUID to get CPU brand string
    mov     eax, 0x80000002     ; First part of the brand string
    cpuid                       ; Execute CPUID instruction
    mov     [cpubuf], eax       ; Store the first 4 characters in the buffer
    mov     [cpubuf + 4], ebx   ; Store the next 4 characters
    mov     [cpubuf + 8], ecx   ; ...
    mov     [cpubuf + 12], edx

    mov     eax, 0x80000003     ; Second part of the brand string
    cpuid
    mov     [cpubuf + 16], eax
    mov     [cpubuf + 20], ebx
    mov     [cpubuf + 24], ecx
    mov     [cpubuf + 28], edx

    mov     eax, 0x80000004     ; Third part of the brand string
    cpuid
    mov     [cpubuf + 32], eax
    mov     [cpubuf + 36], ebx
    mov     [cpubuf + 40], ecx
    mov     [cpubuf + 44], edx

    lea     rsi, [cpubuf]       ; Second argument: pointer to CPU brand string
skip_space:                     ; CPU brand string sometimes starts with whitespace
    mov     al, [rsi]
    cmp     al, ' '
    jne     done
    inc     rsi
    jmp     skip_space
done:                           ; RSI now points to first non-space character in the buffer

    lea     rdi, [fmt1]         ; First argument: format string     
    xor     al, al  
    call    printf wrt ..plt

    ; Use CPUID to get logical processor count from CPUID leaf 0x0B; returns in EBX
    mov     eax, 0x0B           ; Set EAX to 0x0B (the CPUID leaf for topology information)
    mov     ecx, 1              ; Set ECX to 1 (query the core level topology)
    cpuid

    lea     rdi, [fmt2]         ; First argument: format string
    mov     esi, ebx            ; Second argument: logical processor count
    xor     al, al
    call    printf wrt ..plt

    ; Terminate program
    add     rsp, 8
    xor     eax, eax            ; EAX = 0 (exit code on return)
    ret

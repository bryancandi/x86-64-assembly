;====================================================================
; x86-64 Assembly "CPUID" program for Intel CPUs on Linux
;
; Assemble with NASM and link with GCC:
;   nasm -f elf64 cpuid.asm -o cpuid.o
;   ld cpuid.o -o cpuid
;
; syscall number in rax, args in rdi, rsi, rdx, r10, r8, r9
;====================================================================

; Set 64-bit mode and use relative addressing by default
bits 64
default rel

; Macros
%macro write_str 2
    ; Args loaded in reverse order (rdx/rsi first) so that %1/%2 can safely
    ; be rax/rdi themselves without being clobbered before they're read.
    mov     rdx, %2             ; 3rd argument: length of string
    mov     rsi, %1             ; 2nd argument: pointer to string
    mov     rdi, 1              ; 1st argument: file descriptor (stdout)
    mov     rax, 1              ; syscall number
    syscall
%endmacro

%macro write_nl 0
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, newline
    mov     rdx, 1
    syscall
%endmacro

; Section to define variables, buffers, constants
section .bss
cpubuf:     resb    48          ; 48 byte buffer for CPU brand string
len_cpubuf: equ     $ - cpubuf
tmpbuf:     resb    256         ; General purpose buffer
len_tmpbuf: equ     $ - tmpbuf

section .rodata
nl:         equ     10
newline:    db      10          ; For use with write_nl

dash:       db      "----------------------------------------", nl
len_dash:   equ     $ - dash
title:      db      "Processor", nl
len_title:  equ     $ - title
cpu_model:  db      "Model      : "
len_model:  equ     $ - cpu_model
cpu_threads:db      "Threads    : "
len_threads:equ     $ - cpu_threads

; Section to define code (instructions)
section .text
global _start                    ; Entry point for the linker

_start:
    ; Print title text and separator line
    write_str title, len_title
    write_str dash, len_dash

    write_str cpu_model, len_model

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
    xor     r8, r8              ; Count white spaces
.skip_space:                    ; CPU brand string sometimes starts with whitespace
    mov     al, [rsi]
    cmp     al, ' '
    jne     .done
    inc     rsi
    inc     r8
    jmp     .skip_space
.done:                          ; RSI now points to first non-space character in the buffer
    mov     rdx, len_cpubuf
    sub     rdx, r8             ; Subtract white spaces removed from length before writing
    write_str rsi, rdx

    write_nl

    write_str cpu_threads, len_threads

    ; Use CPUID to get logical processor count from CPUID leaf 0x0B; returns in EBX
    mov     eax, 0x0B           ; Set EAX to 0x0B (the CPUID leaf for topology information)
    mov     ecx, 1              ; Set ECX to 1 (query the core level topology)
    cpuid

    mov     edi, ebx
    mov     rsi, tmpbuf
    mov     rdx, len_tmpbuf
    call    int_to_string
    write_str rax, rdx

    write_nl

    ; Terminate program
    mov     rax, 60             ; exit syscall
    xor     rdi, rdi            ; exit code 0
    syscall

;--------------------------------------------------------------------
; int_to_string(unsigned int, buf, size)
; Converts an unsigned integer to a decimal ASCII string.
;
; input:  RDI = unsigned integer value
;         RSI = destination buffer for string
;         RDX = size of buffer
;
; output: RAX = pointer to first character in buffer
;         RDX = number of characters written to the buffer   
;--------------------------------------------------------------------
int_to_string:
    add     rsi, rdx            ; RSI now points to end of buffer
    mov     rax, rdi            ; Move dividend to RAX
    mov     r10, 10             ; Move divisor to R10
    xor     r8, r8              ; Zero counter
    mov     r9, rdx             ; Save buffer size

.convert_loop:
    cmp     r8, r9              ; Is the buffer full?
    jz      .done

    xor     rdx, rdx            ; Clear RDX for division
    div     r10                 ; RAX = quotient, RDX = remainder
    add     dl, '0'             ; Remainder to ASCII character
    dec     rsi
    mov     [rsi], dl           ; Write character to buffer
    inc     r8
    test    rax, rax
    jnz     .convert_loop
.done:
    mov     rax, rsi
    mov     rdx, r8
    ret

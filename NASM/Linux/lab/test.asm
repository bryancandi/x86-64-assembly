; Listing 2-2 (NASM / Linux, System V AMD64 ABI, standalone)
;
; Demonstrate AND, OR, XOR, and NOT logical instructions.
;
; nasm -f elf64 test.asm -o test.o
; gcc test.o -o test

default rel

section .data

nl          equ     10                  ; ASCII newline

leftOp      dd      0f0f0f0fh
rightOp1    dd      0f0f0f0f0h
rightOp2    dd      12345678h

fmtStr1     db      "%lx AND %lx = %lx", nl, 0
fmtStr2     db      "%lx OR  %lx = %lx", nl, 0
fmtStr3     db      "%lx XOR %lx = %lx", nl, 0
fmtStr4     db      "NOT %lx = %lx", nl, 0

section .text

extern      printf

global      main
main:

; Align the stack to a 16-byte boundary before any CALL.
; (No shadow space needed on Linux — that's a Windows-only requirement.)

    sub     rsp, 8

; Demonstrate the AND instruction
; SysV arg order: RDI, RSI, RDX, RCX, R8, R9

    lea     rdi, [fmtStr1]
    mov     esi, [leftOp]
    mov     edx, [rightOp1]
    mov     eax, esi            ; compute leftOp
    and     eax, edx            ;   AND rightOp1
    mov     ecx, eax
    xor     eax, eax            ; AL = # vector regs used (0, no float args)
    call    printf wrt ..plt

    lea     rdi, [fmtStr1]
    mov     esi, [leftOp]
    mov     edx, [rightOp2]
    mov     eax, edx
    and     eax, esi
    mov     ecx, eax
    xor     eax, eax
    call    printf wrt ..plt

; Demonstrate the OR instruction

    lea     rdi, [fmtStr2]
    mov     esi, [leftOp]
    mov     edx, [rightOp1]
    mov     eax, esi
    or      eax, edx
    mov     ecx, eax
    xor     eax, eax
    call    printf wrt ..plt

    lea     rdi, [fmtStr2]
    mov     esi, [leftOp]
    mov     edx, [rightOp2]
    mov     eax, edx
    or      eax, esi
    mov     ecx, eax
    xor     eax, eax
    call    printf wrt ..plt

; Demonstrate the XOR instruction

    lea     rdi, [fmtStr3]
    mov     esi, [leftOp]
    mov     edx, [rightOp1]
    mov     eax, esi
    xor     eax, edx
    mov     ecx, eax
    xor     eax, eax
    call    printf wrt ..plt

    lea     rdi, [fmtStr3]
    mov     esi, [leftOp]
    mov     edx, [rightOp2]
    mov     eax, edx
    xor     eax, esi
    mov     ecx, eax
    xor     eax, eax
    call    printf wrt ..plt

; Demonstrate the NOT instruction

    lea     rdi, [fmtStr4]
    mov     esi, [leftOp]
    mov     edx, esi            ; compute NOT leftOp
    not     edx
    xor     eax, eax
    call    printf wrt ..plt

    lea     rdi, [fmtStr4]
    mov     esi, [rightOp1]
    mov     edx, esi            ; compute NOT rightOp1
    not     edx
    xor     eax, eax
    call    printf wrt ..plt

    lea     rdi, [fmtStr4]
    mov     esi, [rightOp2]
    mov     edx, esi            ; compute NOT rightOp2
    not     edx
    xor     eax, eax
    call    printf wrt ..plt

    add     rsp, 8
    xor     eax, eax            ; return 0 from main
    ret

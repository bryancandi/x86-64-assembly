;======================================
; x64 - No Operation Encoding (test)
;
; AX  : 0x66 0x90
; EAX : 0x90
; RAX : 0x48 0x90
; NOP : 0x90
;======================================

bits 64
default rel

section .text
global _start

_start:
        mov     rax, 0x1111111122222222
        xchg    ax, ax

        mov     rax, 0x3333333344444444
        xchg    eax, eax

        mov     rax, 0x5555555566666666
        xchg    rax, rax

        mov     rax, 0x7777777788888888
        nop

        mov rax, 60
        mov rdi, 0
        syscall

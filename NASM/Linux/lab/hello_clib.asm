; hello, world!
; example with printf

; Set 64-bit mode and RIP-relative addressing mode
bits 64
default rel

section .data

msg:    db  "hello, world!", 10, 0
fmt1:   db  "%s", 0

section .text

extern printf

global main
main:
        sub     rsp, 8

        lea     rdi, fmt1
        lea     rsi, msg
        call    printf wrt ..plt

        add     rsp, 8
        ret

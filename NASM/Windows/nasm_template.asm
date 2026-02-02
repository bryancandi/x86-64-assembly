;--------------------------------------------------------------------
; NASM: A barebones Windows x64 template
; Assemble with NASM and link:
;   nasm -f win64 -o source.obj source.asm
;   link /SUBSYSTEM:CONSOLE /ENTRY:main source.obj kernel32.lib
;--------------------------------------------------------------------

extern ExitProcess          ; External Windows API function.

section .data
    ; Variable declarations go here.

section .text
global main                 ; Make 'main' visible to the linker.

main:
    ; Windows x64 calling convention requires 32-byte "shadow space".
    sub rsp, 40             ; 32 shadow + 8 alignment.

    ; Assembly instructions go here.

    xor rcx, rcx            ; Exit code 0.
    call ExitProcess        ; Exit the program.

    ; Restore stack pointer (optional, ExitProcess does not return).
    add rsp, 40

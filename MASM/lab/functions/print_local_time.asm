;--------------------------------------------------------------------
; Function that prints the current local time in the user's default
; locale to the Windows console.
;
; Depends on print.asm
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib
INCLUDE print.asm

EXTERN GetTimeFormatA:PROC

        .CODE
print_local_time PROC
        LOCAL   timeBuffer[16]:BYTE
        sub     rsp, 48

        mov     rcx, 0400h      ; LOCALE_USER_DEFAULT
        mov     edx, 0
        mov     r8, 0
        mov     r9, 0
        lea     rax, timeBuffer
        mov     QWORD PTR [rsp + 32], rax
        mov     QWORD PTR [rsp + 40], 16
        call    GetTimeFormatA  ; Returns characters in buffer in EAX

        lea     rcx, timeBuffer
        mov     edx, eax
        call    print

        xor     eax, eax
        add     rsp, 48
        ret
print_local_time ENDP

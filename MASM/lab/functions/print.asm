;--------------------------------------------------------------------
; x64 custom print function. Calls Win32 functions GetStdHandle
; and WriteFile to obtain the standard output handle and write a
; buffer to the console.
;
; Preserves all registers except RAX (and RFLAGS).
;
; Local stack frame = 56 bytes
;   [rsp +  0] 32 bytes - shadow space
;   [rsp + 32]  8 bytes - WriteFile 5th argument (lpOverlapped)
;   [rsp + 40]  4 bytes - bytes written (DWORD), plus 4 bytes padding
;   [rsp + 48]  8 bytes - alignment
;
; Depends:
; - kernel32.lib
;   - EXTERN GetStdHandle:PROC
;   - EXTERN WriteFile:PROC
;
; Input:  RCX = Pointer to buffer
;         EDX = Length of buffer (DWORD)
; Output: EAX = Number of bytes written on success (DWORD)
;               Zero on failure
;--------------------------------------------------------------------

; Include guard: skip this file if it was already pasted into this assembly
IFNDEF PRINT_ASM_INCLUDED
PRINT_ASM_INCLUDED EQU 1

INCLUDELIB kernel32.lib

EXTERN GetStdHandle:PROC
EXTERN WriteFile:PROC

        .CODE
print   PROC
        push    rbx
        push    rcx
        push    rdx
        push    r8
        push    r9
        push    r10
        push    r11
        push    r12
        sub     rsp, 56

        mov     rbx, rcx        ; Save pointer to buffer
        mov     r12d, edx       ; Save buffer length

        mov     ecx, -11        ; Standard output device (STDOUT)
        call    GetStdHandle    ; Handle to standard output device in RAX

        mov     rcx, rax        ; Arg 1: device handle
        mov     rdx, rbx        ; Arg 2: pointer to buffer
        mov     r8d, r12d       ; Arg 3: number of bytes to write to device
        lea     r9, [rsp + 40]  ; Arg 4: pointer to DWORD to receive bytes written
        mov     QWORD PTR [rsp + 32], 0 ; Arg 5: lpOverlapped = NULL
        call    WriteFile
        test    eax, eax        ; WriteFile successful?
        mov     eax, [rsp + 40] ; Load bytes written
        jnz     @F              ; WriteFile success: keep bytes written
        xor     eax, eax        ; WriteFile failure: return 0
@@:
        add     rsp, 56
        pop     r12
        pop     r11
        pop     r10
        pop     r9
        pop     r8
        pop     rdx
        pop     rcx
        pop     rbx
        ret
print   ENDP

ENDIF

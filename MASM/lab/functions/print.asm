;--------------------------------------------------------------------
; x64 custom print function. Calls Win32 functions GetStdHandle
; and WriteFile to obtain the standard output handle and write a
; buffer to the console.
;
; Preserves all registers except RAX (and RFLAGS).
;
; Depends:
; - kernel32.lib
;   - EXTERN GetStdHandle:PROC
;   - EXTERN WriteFile:PROC
;
; Input  :
;   RCX  : Pointer to buffer
;   EDX  : Length of buffer (DWORD)
; Return :
;   EAX  : Number of bytes written on success or zero on failure
;--------------------------------------------------------------------

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

        mov     rbx, rcx        ; Copy pointer to buffer
        mov     r12d, edx       ; Copy buffer length

        mov     ecx, -11        ; Standard output handle
        call    GetStdHandle    ; Stdout in RAX
        
        mov     rcx, rax
        mov     rdx, rbx
        mov     r8d, r12d
        lea     r9, [rsp + 40]
        mov     QWORD PTR [rsp + 32], 0
        call    WriteFile
        test    eax, eax
        jz      error
        mov     eax, [rsp + 40]
        jmp     done
error:
        xor     eax, eax        ; WriteFile failure; return 0
done:

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

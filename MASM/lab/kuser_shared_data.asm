; KUSER_SHARED_DATA
; 7FFE0000h
; Accessing structure values by offset

INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

MessageBoxW PROTO
ExitProcess PROTO

        .CODE
start   PROC
        sub     rsp, 30h

        push    rbx
        mov     rbx, 7FFE0000h

        mov     eax, DWORD PTR [rbx + 26Ch]     ; NtMajorVersion
        mov     eax, DWORD PTR [rbx + 270h]     ; NtMinorVersion
        mov     eax, DWORD PTR [rbx + 260h]     ; NtBuildNumber

        ; SystemTime - each part is 4 bytes (32 bits)
        ; Located at 7FFE0000h + 14h
read_loop:
        mov     eax, DWORD PTR [rbx + 14h]      ; LowPart
        mov     ecx, DWORD PTR [rbx + 14h + 4]  ; High1Time
        mov     edx, DWORD PTR [rbx + 14h + 8]  ; High2Time
        cmp     ecx, edx
        jne     read_loop                       ; Ensure we have the latest time provided by the kernel

        shl     rcx, 32                         ; Move High1Time into upper 32-bits of RCX
        or      rcx, rax                        ; Combine High1Time and LowPart into one complete
                                                ; FILETIME value in RCX

        ; NtSystemRoot WCHAR in a MessageBox
        xor     rcx, rcx                        ; hWnd = null
        lea     rdx, [rbx + 30h]                ; NtSystemRoot WCHAR pointer
        xor     r8, r8                          ; lpCaption = null (displays "Error")
        mov     r9, 40h                         ; uType = MB_ICONINFORMATION
        call    MessageBoxW

        pop     rbx
        sub     rsp, 8h
        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

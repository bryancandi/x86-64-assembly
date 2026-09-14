; 07FFE0000h
; Accessing values in KUSER_SHARED_DATA structure by offsets

INCLUDELIB kernel32.lib

ExitProcess PROTO

        .DATA

        .CODE
start   PROC
        sub rsp, 28h

        mov rbx, 07FFE0000h
        mov eax, [rbx + 026Ch]      ; NtMajorVersion
        mov ecx, [rbx + 0270h]      ; NtMinorVersion
        mov edx, [rbx + 0260h]      ; NtBuildNumber

        xor ecx, ecx
        call ExitProcess
start   ENDP
        END

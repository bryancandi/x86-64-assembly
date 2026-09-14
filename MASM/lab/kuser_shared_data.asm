; 7FFE0000h
; Accessing values in KUSER_SHARED_DATA structure by offsets

INCLUDELIB kernel32.lib

ExitProcess PROTO

        .DATA?
NtMajorVersion  DWORD   ?
NtMinorVersion  DWORD   ?
NtBuildNumber   DWORD   ?

        .CODE
start   PROC
        sub rsp, 28h

        mov rbx, 7FFE0000h

        mov eax, [rbx + 26Ch]
        mov NtMajorVersion, eax

        mov eax, [rbx + 270h]
        mov NtMinorVersion, eax

        mov eax, [rbx + 260h]
        mov NtBuildNumber, eax

        xor ecx, ecx
        call ExitProcess
start   ENDP
        END

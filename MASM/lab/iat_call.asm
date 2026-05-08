; Low-level (manual import address table usage)

INCLUDELIB kernel32.lib

EXTRN __imp_ExitProcess:PROC

.code
main PROC
    sub     rsp, 28h
    xor     ecx, ecx
    call    qword ptr [__imp_ExitProcess]
main ENDP
END

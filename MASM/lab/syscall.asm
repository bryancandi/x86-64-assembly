; syscall
;   RAX: syscall number
;   R10: first argument
;   RDX: second argument
;   R8:  third argument
;   R9:  fourth argument
;   Stack is used for arguments beyond the fourth

        .CODE
start   PROC
        sub rsp, 28h
        mov eax, 2Ch    ; NtTerminateProcess (0x002C)
        or r10, -1      ; Set all bits '1' in R10 (-1)
        xor rdx, rdx    ; Exit code
        syscall
start   ENDP
        END

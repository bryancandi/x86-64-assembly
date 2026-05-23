;======================================================================
; 0x00 - xorpd
;
; Zero Everything
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        xor     eax, eax                ; bitwise exclusive OR with self; zero all bits in EAX
        lea     rbx, [0]                ; load address 0 into RBX
        loop    $                       ; loop and decrement RCX until RCX is 0
        mov     rdx, 0                  ; load constant 0 into RDX
        and     esi, 0                  ; bitwise AND ESI with 0; set bits to 1 only if both are 1 (never)
        sub     edi, edi                ; EDI - EDI = 0
        push    0                       ; push 0
        pop     rbp                     ; pop 0 -> RBP = 0

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

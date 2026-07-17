;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x18
;
; Compare CPU time-stamp counter (TSC) between two RDTSC instructions
;
; RDTSC - Read Time-Stamp Counter
;         Read time-stamp counter into EDX:EAX
;         High order 32 bits of RDX and RAX on x64 are cleared
;
; - The first RDTSC call loads the counter values into EDX:EAX.
;
; - SHL 20h (32 bits) moves the low order 32 bits in RDX into the high
;   order 32 bits of RDX.
;
; - At this point, RDX contains half of the TSC value in the high order
;   bits, and RAX the other half in the low order bits, or the next
;   instruction OR RAX, RDX merges the two register values into a
;   complete 64-bit value in RAX.
;
; - The entire value of the CPU TSC is then moved into RCX so that the
;   instructions can be executed a second time and then compared.
;
; - The CMP instruction will likely return the same results each time
;   unless the TSC were to wrap in between the RDTSC instructions.
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        rdtsc
        shl     rdx, 20h
        or      rax, rdx
        mov     rcx, rax

        rdtsc
        shl     rdx, 20h
        or      rax, rdx

        cmp     rcx, rax

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

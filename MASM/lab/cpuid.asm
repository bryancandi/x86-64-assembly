; CPUID

INCLUDELIB kernel32.lib

EXTERN ExitProcess:PROC
EXTERN GetStdHandle:PROC
EXTERN WriteFile:PROC

        .DATA?
maxLeaf     DWORD   ?
featFlags   DWORD   ?
extFlags    DWORD   ?
vendorID    BYTE    12 DUP (?)

        .CONST
; Unused at this time...
AVX         BYTE    "AVX", 0Dh, 0Ah
AVX2        BYTE    "AVX2", 0Dh, 0Ah
SSE3        BYTE    "SSE3", 0Dh, 0Ah
SSSE3       BYTE    "SSSE3", 0Dh, 0Ah
SSE41       BYTE    "SSE4.1", 0Dh, 0Ah
SSE42       BYTE    "SSE4.2", 0Dh, 0Ah

        .CODE
start   PROC
        sub     rsp, 40
        push    rbx

        ; Return highest supported CPUID leaf in EAX (EAX = 0)
        ; Also returns CPU vendor string
        xor     eax, eax
        cpuid
        mov     maxLeaf, eax
        mov     DWORD PTR vendorID, ebx
        mov     DWORD PTR vendorID[4], edx
        mov     DWORD PTR vendorID[8], ecx

        ; Call custom print procedure to write output to console
        lea     rdx, vendorID
        mov     r8, LENGTHOF vendorID
        call    print

        ; Intel cpuid Feature Flags (EAX = 1)
        ; Bits set in ECX:
        ; 0  - SSE3 supported
        ; 1  - PCLMULQDQ support
        ; 9  - SSSE3 support
        ; 19 - SSE4.1 support
        ; 20 - SSE4.2 support
        ; 28 - AVX support
        mov     eax, 1h
        cpuid
        mov     featFlags, ecx

        ; Intel cpuid Extended Feature Flags (EAX = 7, ECX = 0)
        ; Bits set in EBX:
        ; 3 - Bit Manipulation Instruction Set 1
        ; 5 - AVX2 support
        ; 8 - Bit Manipulation Instruction Set 2
        cmp     maxLeaf, 7h     ; Leaf 7h supported by CPU?
        jb      skip7h
        xor     ecx, ecx
        mov     eax, 7h
        cpuid
        mov     extFlags, ebx
skip7h:

        pop     rbx
        mov     ecx, maxLeaf    ; Return maxLeaf in exit code
        call    ExitProcess
start   ENDP

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

        mov     rbx, rdx        ; Copy pointer to buffer
        mov     r12, r8         ; Copy buffer length

        mov     ecx, -11        ; Standard output handle
        call    GetStdHandle    ; Stdout in RAX
        
        mov     rcx, rax
        mov     rdx, rbx
        mov     r8, r12
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
        END

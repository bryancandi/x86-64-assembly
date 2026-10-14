; SIMD performance test

INCLUDELIB kernel32.lib
INCLUDE functions\print.asm
INCLUDE functions\print_local_time.asm

EXTERN ExitProcess:PROC

        .CONST
begin   BYTE    " - SIMD performance test beginning...", 0Dh, 0Ah
done    BYTE    " - Done.", 0Dh, 0Ah

dseg    SEGMENT ALIGN(64) 'DATA'
        ALIGN   64
sseData BYTE    64 DUP (0)
dseg    ENDS

        .CODE
start   PROC
        sub     rsp, 40
        push    rbx

        call    print_local_time

        lea     rcx, begin
        mov     edx, LENGTHOF begin
        call    print

        mov     rcx, 4000000000
        lea     rdx, sseData
        mov     rbx, 0
rptLp:  mov     rax, 11 ; 11 without AVX-512 or 15 with AVX-512 instructions (2 passes)
rptLp2: movaps  xmm0, xmmword ptr [rdx + rbx * 1]
        movapd  xmm0, real8 ptr [rdx + rbx * 1]
        movdqa  xmm0, xmmword ptr [rdx + rbx * 1]
        vmovaps ymm0, ymmword ptr [rdx + rbx * 1]
        vmovapd ymm0, ymmword ptr [rdx + rbx * 1]
        vmovdqa ymm0, ymmword ptr [rdx + rbx * 1]
        ; 512-bit (zmm) forms require AVX-512:
        ;vmovaps zmm0, zmmword ptr [rdx + rbx * 1]
        ;vmovapd zmm0, zmmword ptr [rdx + rbx * 1]

        dec     rax
        jns     rptLp2

        dec     rcx
        jnz     rptLp

        call    print_local_time

        lea     rcx, done
        mov     edx, LENGTHOF done
        call    print

        pop     rbx
        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

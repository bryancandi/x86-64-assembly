;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x08
;
; Returns the average of RAX and RDX in RAX.
; rax = (rax+rdx) / 2
;
; RCR (Rotate Carry Right) moves all bits the specified number of
; positions to the right. The carry flag is treated as an extra bit
; in the rotation.
;
; Examples of the lower 8 bits and carry flag following each
; instruction. The format is 00000000 CF (decimal):
;
; Example 1 - no carry - (96+48) / 2 = 72:
;
;   RAX:    01100000    (96)
;   RDX:    00110000    (48)
;
;   ADD:    10010000 0  (144)
;   RCR:    01001000 0  (72)
;
; ---------------------------------
;
; Example 2 - carry - (255+1) / 2 = 128:
; The largest 8-bit unsigned value is 255.
; In this example adding 255 and 1 results in an overflow. Had we used
; the instruction 'shr rax, 1' the overflow bit would have been lost.
; RCR effectively operates on 65-bit values (CF+RAX).
;
;   RAX:    11111111    (255)
;   RDX:    00000001    (1)
;
;   ADD:    00000001 1  (1)
;   RCR:    10000000 1  (128)
;
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 96                 ; Initialize RAX
        mov     rdx, 48                 ; Initialize RDX

        add     rax, rdx
        rcr     rax, 1

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

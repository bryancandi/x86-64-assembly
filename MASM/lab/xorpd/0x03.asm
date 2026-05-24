;======================================================================
; 0x03 - xorpd
;
; Smallest value in RAX
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 40                 ; Initialize RAX
        mov     rdx, 20                 ; Initialize RDX

; RAX will contain the smaller value of RAX and RDX.
; sub: if RAX > RDX, subtracting a larger number from a smaller one will set the Carry Flag (CF=1).
;      RDX now holds the (negative) difference value (RDX - RAX).
; sbb: RCX - RCX = 0, then subtracts CF. RCX becomes bitmask.
;      If RAX > RDX (CF=1): RCX = -1 (all bits 1)
;      If RAX < RDX (CF=0): RCX =  0 (all bits 0)
; and: apply bitmask in RCX:
;      RAX > RDX: RCX = RDX
;      RAX < RDX: RCX = 0
; add: RCX now either holds 0 or the value of (RDX - RAX).
;      RAX > RDX: RAX + (RDX - RAX) = RDX (RAX becomes the smaller value)
;      RAX < RDX: RAX + 0 = RAX (RAX stays the same)

        sub     rdx, rax
        sbb     rcx, rcx
        and     rcx, rdx
        add     rax, rcx

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x13
;
; Adding without "ADD"
;
; RAX = RAX + RBX
;
; Explanation:
; The loop counter starts at 40h (64) since we potentially will need to
; iterate over 64-bits to reach our result.
; Initial values:
;   A = 00000011 (3)
;   B = 00000101 (5)
;   C = A (a copy of A to use with AND)
;
; A XOR B: sum the bits where they differ in the two registers
;   A = 00000110 (6)
; B AND C: isolate the carry bits (bits that are both 1)
;   B = 00000001 (1)
; SHL, 1: shift the carry bits (B) one left into their proper position
;   B = 00000010 (2)
;
; Iterate again with the new values in A / B (C = new A)...
;   A = 00000110 (6)
;   B = 00000010 (2)
;   C = A
;
; A XOR B:
;   A = 00000100 (4)
; B AND C:
;   B = 00000010 (2)
; SHL, 1 (B)
;   B = 00000100 (4)
;
; Iterate again with the new values in A / B (C = new A)...
;   A = 00000100 (4)
;   B = 00000100 (4)
;   C = A
;
; A XOR B:
;   A = 00000000 (0)
; B AND C:
;   B = 00000100 (4)
; SHL, 1 (B)
;   B = 00001000 (8)
;
; Iterate again with the new values in A / B (C = new A)...
;   A = 00000000 (0)
;   B = 00001000 (8)
;   C = A
;
; A XOR B:
;   A = 00001000 (8)    A = 8 (A + B)
; B AND C:
;   B = 00000000 (0)
; SHL, 1 (B)
;   B = 00000000 (0)
;
; Iterate again with the new values in A / B (C = new A)...
;   A = 00001000 (8)    A = 8 (A + B)
;   B = 00000000 (0)
;   C = A
;
; A XOR B:
;   A = 00001000 (8)
; B AND C:
;   B = 00000000 (0)
; SHL, 1 (B)
;   B = 00000000 (0)
;
; The loop will run until RCX = 0, but we've reached our result and the
; value in A will not change after this point, so the explanation stops
; here.
;   A = 8 (A + B)
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

OPTION DOTNAME

        .CODE
start   PROC
        sub     rsp, 40

        mov     rax, 3                  ; Initialize RAX
        mov     rbx, 5                  ; Initialize RBX

        mov     rcx, 40h                ; Initialize RCX to 64 (bits for loop counter)
.loop:
        mov     rdx, rax
        xor     rax, rbx
        and     rbx, rdx
        shl     rbx, 1h
        loop    .loop

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

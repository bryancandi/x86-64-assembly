; Efficient Multi-Bit Extended-Precision Shifts
; Starting values fit in 32 bits.
;
; Lower 32 bits:
; [0] =	    0001 0010 0011 0100 0101 0110 0111 1000
; [8] =     1001 0000 0001 0010 0011 0100 0101 0110
; [16] =    0111 1000 1001 0000 0001 0010 0011 0100
;
; First shift example:
; mov     rax, ShiftMe[8]
; shld    ShiftMe[16], rax, 6
; After shift:
; ShiftMe[16] = 0000 0000 0000 0000 0000 0000 0001 1110 0010 0100 0000 0100 1000 1101 0000 0000
; Hexadecimal = 0000001E24048D00h

        .DATA
ShiftMe QWORD 012345678h, 90123456h, 78901234h

        .CODE
start   PROC
        sub     rsp, 32

        mov     rax, ShiftMe[8]
        shld    ShiftMe[16], rax, 6
        mov     rax, ShiftMe[0]
        shld    ShiftMe[8], rax, 6
        shl     ShiftMe[0], 6

        add     rsp, 32
        xor     eax, eax
        ret
start   ENDP
        END

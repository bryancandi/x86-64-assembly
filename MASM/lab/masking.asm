;======================================================================
; masking.asm
;
; Loop 1:
;   Swap ASCII letter case with bit masking (A - Z).
;
; Loop 2:
;   Convert single numeric digits to ASCII equivalent and back again
;   with bit masking (0 - 9).
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess     PROTO
GetStdHandle    PROTO
WriteConsoleA   PROTO

; Macro: write a string to the console. addr may be RAX or a label; len is copied into R8D.
StrOut  MACRO   addr, len
        mov     rcx, stdout                 ; Arg 1: output device handle
IFIDNI  <addr>, <rax>                       ; If addr is RAX, use it directly; otherwise LEA of the label
        mov     rdx, rax                    ; Arg 2: pointer to byte array in RAX register
ELSE
        lea     rdx, addr                   ; Arg 2: pointer to byte array label
ENDIF
        mov     r8d, len                    ; Arg 3: number of bytes to write
        lea     r9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written
        mov     QWORD PTR [rsp+32], 0       ; Arg 5: lpReserved, must be NULL
        call    WriteConsoleA
        ENDM

        .DATA
stdout  QWORD   ?
nbwr    DWORD   ?
outbuf  BYTE    ?
newln   BYTE    10                          ; New line

        .CODE
start   PROC
        sub     rsp, 28h

        mov     rcx, -11                    ; Std output handle
        call    GetStdHandle
        mov     stdout, rax

; Invert bit 5 of ASCII letter character code to swap case
        mov     bl, 41h                     ; Capital 'A'
bit5_mask_loop:
        mov     outbuf, bl
        StrOut  outbuf, LENGTHOF outbuf

        xor     outbuf, 00100000b           ; Invert bit 5 (20h)
        StrOut  outbuf, LENGTHOF outbuf

        cmp     bl, 5Ah                     ; Stop at capital 'Z'
        jz      next
        inc     bl
        jmp     bit5_mask_loop

next:
        StrOut  newln, LENGTHOF newln

; Convert a numerical value to its equivalent ASCII character code, print, then
; convert it back to a number by masking the high order nibble
; (and preserving the low order nibble).
; This only works on single digits, not for strings of digits.
; - Setting the HO nibble to 3 (0011) will convert a binary digit to its
;   corresponding ASCII code.
; - The LO nibble of the ASCII code is the binary equivalent of the represented
;   number, so clearing the HO nibble (set to 0000) converts it back to a binary
;   digit.

        mov     bl, 0                       ; Start with 0
binary_ascii_loop:
        ; Convert binary digit to corresponding ASCII character
        or      bl, 00110000b               ; Set HO nibble to 3 (0011)
        ; BL now holds the ASCII representation of the binary digit

        mov     outbuf, bl
        StrOut  outbuf, LENGTHOF outbuf

        ; Convert ASCII character back to a binary digit
        and     bl, 00001111b               ; Clear HO nibble, preserve LO nibble
        ; BL now holds the corresponding binary digit

        cmp     bl, 9                       ; Stop at 9
        jz      done
        inc     bl
        jmp     binary_ascii_loop

done:
        StrOut  newln, LENGTHOF newln
        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

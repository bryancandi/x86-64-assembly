;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x0a
;
; Little-endian big integer increment.
;
; Initial add increments the buffer if the first byte does not overflow,
; otherwise the carry flag is set and adc will attempt adding it to the
; next byte. This continues through each byte until CF=0.
;
; Initial buffer value:
;   FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF F7
;   Read as a 128-bit (16 byte) little-endian integer this becomes:
;   Hex: F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
;   Decimal: 329648542954659136480144150949525454847
;
; Incremented buffer value:
;   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 F8
;   Read as a 128-bit (16 byte) little-endian integer this becomes:
;   Hex: F8000000000000000000000000000000
;   Decimal: 329648542954659136480144150949525454848
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

OPTION DOTNAME

        .DATA
buffer  BYTE    0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh,
                0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0F7h

        .CODE
start   PROC
        sub     rsp, 40

        lea     rdi, buffer             ; RDI points to buffer
        mov     rcx, LENGTHOF buffer    ; Initialize counter for 'loop'
        dec     rcx                     ; RCX-1 to prevent out-of-bounds write at end of loop

        add     byte PTR [rdi], 1
.loop:
        inc     rdi
        adc     byte PTR [rdi], 0
        loop    .loop

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

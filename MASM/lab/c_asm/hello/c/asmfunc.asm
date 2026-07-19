;======================================================================
; asmfunc.asm
;
; Call C/C++ printf() function from assembly and return.
;======================================================================

; Make all identifiers case-sensitive for C.
OPTION CASEMAP:NONE

        .DATA
fmtStr  BYTE    "Hello, world!", 0Ah, 0

        .CODE
; External declaration so MASM knows about the C/C++ printf() function.
EXTERNDEF printf:PROC

; Declare asmMain as public.
PUBLIC asmMain

asmMain PROC
        sub     rsp, 40                 ; Reserve shadow space

        lea     rcx, fmtStr             ; First function argument
        call    printf                  ; Call external printf() function

        add     rsp, 40                 ; Restore shadow space
        ret                             ; Return to caller
asmMain ENDP
        END

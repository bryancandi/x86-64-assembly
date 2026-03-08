;--------------------------------------------------------------------
; SCALAR: x86-64 SSE - Handling Scalars.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    num REAL4 16.0              ; Declare a REAL4 (32-bit floating-point) variable.
    factor REAL4 2.5            ; Declare a REAL4 (32-bit floating-point) variable.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOVSS XMM0, num             ; Load the scalar REAL4 value from 'num' into the XMM0 register.
    MOVSS XMM1, factor          ; Load the scalar REAL4 value from 'factor' into the XMM1 register.

    ADDSS XMM0, XMM1            ; Perform a scalar addition of the two REAL4 values, storing the result in XMM0.
    MULSS XMM0, XMM1            ; Perform a scalar multiplication of the two REAL4 values, storing the result in XMM0.
    SUBSS XMM0, XMM1            ; Perform a scalar subtraction of the two REAL4 values, storing the result in XMM0.
    DIVSS XMM0, XMM1            ; Perform a scalar division of the two REAL4 values, storing the result in XMM0.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

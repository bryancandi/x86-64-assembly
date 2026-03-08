;--------------------------------------------------------------------
; FMA: x86-64 AVX - Fusing Operations.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    numA REAL4 2.0              ; Declare and initialize a REAL4 (32-bit floating-point) value.
    numB REAL4 8.0              ; Declare and initialize a REAL4 (32-bit floating-point) value.
    numC REAL4 5.0              ; Declare and initialize a REAL4 (32-bit floating-point) value.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOVSS XMM0, numA            ; Load the REAL4 value numA into the XMM0 register.
    MOVSS XMM1, numB            ; Load the REAL4 value numB into the XMM1 register.
    MOVSS XMM2, numC            ; Load the REAL4 value numC into the XMM2 register.

    ; Operation order variations for fused multiply-add operations.
    ; 132 = 1st x 3rd + 2nd
    ; 213 = 2nd x 1st + 3rd
    ; 231 = 2nd x 3rd + 1st.
    VFMADD132SS XMM0, XMM1, XMM2  ; Perform a fused multiply-add operation: (numA * numC) + numB, storing the result in XMM0.
    MOVSS XMM0, numA              ; Restore the REAL4 value numA into the XMM0 register.
    VFMADD213SS XMM0, XMM1, XMM2  ; Perform a fused multiply-add operation: (numB * numA) + numC, storing the result in XMM0.
    MOVSS XMM0, numA              ; Restore the REAL4 value numA into the XMM0 register.
    VFMADD231SS XMM0, XMM1, XMM2  ; Perform a fused multiply-add operation: (numB * numC) + numA, storing the result in XMM0.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

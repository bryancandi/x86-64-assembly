;--------------------------------------------------------------------
; ARRAY: x86-64 SSE - Handling Arrays.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    nums REAL4 12.5, 25.0, 37.5, 50.0 ; Declare an array of 4 REAL4 (32-bit floating-point) values.
    numf REAL4 2.0, 3.0, 4.0, 5.0     ; Declare an array of 4 REAL4 (32-bit floating-point) values.
    dubs REAL8 12.5, 25.0             ; Declare an array of 2 REAL8 (64-bit floating-point) values.
    dubf REAL8 2.0, 3.0               ; Declare an array of 2 REAL8 (64-bit floating-point) values.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOVAPS XMM0, XMMWORD PTR [nums] ; Load the array of REAL4 values into the XMM0 register.
    MOVAPS XMM1, XMMWORD PTR [numf] ; Load the array of REAL4 values into the XMM1 register.
    DIVPS XMM0, XMM1                ; Perform a packed division of the two arrays of REAL4 values, storing the results in XMM0.

    MOVAPD XMM2, XMMWORD PTR [dubs] ; Load the array of REAL8 values into the XMM2 register.
    MOVAPD XMM3, XMMWORD PTR [dubf] ; Load the array of REAL8 values into the XMM3 register.
    DIVPD XMM2, XMM3                ; Perform a packed division of the two arrays of REAL8 values, storing the results in XMM2.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

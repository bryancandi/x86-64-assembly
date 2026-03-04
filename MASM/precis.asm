;--------------------------------------------------------------------
; PRECIS: x86-64 SSE - Extracting Precision.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    nums REAL4 1.5, 2.5, 3.5, 3.1416 ; Declare an array of 4 REAL4 (32-bit floating-point) values.
    dubs REAL8 1.5, 3.1415926535897932 ; Declare an array of 2 REAL8 (64-bit floating-point) values.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOVAPS XMM0, XMMWORD PTR [nums] ; Load the array of REAL4 values into the XMM0 register.
    MOVAPD XMM1, XMMWORD PTR [dubs] ; Load the array of REAL8 values into the XMM1 register.

    SQRTPS XMM0, XMM0                 ; Compute the square root of each REAL4 value in XMM0, storing the results back in XMM0.
    SQRTPD XMM1, XMM1                 ; Compute the square root of each REAL8 value in XMM1, storing the results back in XMM1.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

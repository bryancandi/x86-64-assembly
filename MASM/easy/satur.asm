;--------------------------------------------------------------------
; SATUR: x86-64 SSE - Saturating Ranges.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    nums SBYTE 16 DUP (50)      ; Declare an array of 16 SBYTE (8-bit signed integer) values initialized to 50.
    tons SBYTE 16 DUP (100)     ; Declare an array of 16 SBYTE (8-bit signed integer) values initialized to 100.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOVAPS XMM0, XMMWORD PTR [nums] ; Load the array of SBYTE values into the XMM0 register.
    PADDSB XMM0, tons           ; Perform a packed addition of the two arrays of SBYTE values with saturation, storing the results in XMM0.

    MOVAPS XMM0, XMMWORD PTR [nums] ; Load the array of SBYTE values into the XMM0 register.
    PSUBSB XMM0, tons           ; Perform a packed subtraction of the two arrays of SBYTE values with saturation, storing the results in XMM0.
    PSUBSB XMM0, tons           ; Perform another packed subtraction of the two arrays of SBYTE values with saturation, storing the results in XMM0.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

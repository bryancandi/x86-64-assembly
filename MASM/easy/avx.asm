;--------------------------------------------------------------------
; AVX: x86-64 AVX - Managing Vectors.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    ; Declare and initialize an array of 8 REAL4 (32-bit floating-point) values.
    vec1 REAL4 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0
    ; Declare and initialize an array of 8 REAL4 (32-bit floating-point) values.
    vec2 REAL4 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    VMOVAPS YMM1, YMMWORD PTR [vec1] ; Load the array of REAL4 values into the YMM1 register.
    VMOVAPS YMM2, YMMWORD PTR [vec2] ; Load the array of REAL4 values into the YMM2 register.

    ; Perform non-destructive operations on the vectors, storing results in YMM0.
    VMULPS YMM0, YMM1, YMM2     ; Perform a packed multiplication of the two arrays of REAL4 values, storing the results in YMM0.
    VADDPS YMM0, YMM1, YMM2     ; Perform a packed addition of the two arrays of REAL4 values, storing the results in YMM0.
    VSUBPS YMM0, YMM1, YMM2     ; Perform a packed subtraction of the two arrays of REAL4 values, storing the results in YMM0.
    VDIVPS YMM0, YMM1, YMM2     ; Perform a packed division of the two arrays of REAL4 values, storing the results in YMM0.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

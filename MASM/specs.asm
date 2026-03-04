;--------------------------------------------------------------------
; SPECS: x86-64 SSE - Using Specials.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    nums1 REAL4 44.5, 58.25, 32.6, 19.8 ; Declare an array of 4 REAL4 (32-bit floating-point) values.
    nums2 REAL4 22.7, 73.2, 66.15, 12.3 ; Declare an array of 4 REAL4 (32-bit floating-point) values.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOVDQA XMM1, XMMWORD PTR [nums1] ; Load the array of REAL4 values into the XMM1 register.
    MOVDQA XMM2, XMMWORD PTR [nums2] ; Load the array of REAL4 values into the XMM2 register.
    MAXPS XMM1, XMM2            ; Perform a packed maximum operation on the two arrays of REAL4 values, storing the results in XMM1.

    MOVDQA XMM1, XMMWORD PTR [nums1] ; Load the array of REAL4 values into the XMM1 register.
    MINPS XMM1, XMM2            ; Perform a packed minimum operation on the two arrays of REAL4 values, storing the results in XMM1.

    ROUNDPS XMM1, XMM1, 00b     ; Round the packed REAL4 values in XMM1 to the nearest integer, storing the results in XMM1.
    ROUNDPS XMM2, XMM2, 01b     ; Round the packed REAL4 values in XMM2 towards zero, storing the results in XMM2.
    PAVGW XMM1, XMM2            ; Perform a packed average of the two arrays of REAL4 values, storing the results in XMM1.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

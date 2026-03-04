;--------------------------------------------------------------------
; SIMD: x86-64 SSE - Single Instruction Multiple Data Packing Lanes.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    nums0 DWORD 1, 2, 3, 4      ; Declare an array of 4 DWORDs initialized with values 1, 2, 3, and 4.
    nums1 DWORD 1, 3, 5, 7      ; Declare an array of 4 DWORDs initialized with values 1, 3, 5, and 7.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOVDQA XMM0, XMMWORD PTR [nums0] ; Load the first array of DWORDs into the XMM0 register.
    PADDD XMM0, XMMWORD PTR [nums1]  ; Perform a packed addition of the two arrays, storing the result in XMM0.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

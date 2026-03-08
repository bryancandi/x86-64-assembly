;--------------------------------------------------------------------
; ALIGN: x86-64 SSE - Aligning Data.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    nums0 DWORD 1, 2, 3, 4      ; Four DWORDs (16 bytes) initialized with values 1, 2, 3, and 4.
    snag BYTE 100               ; One BYTE with value 100; its starting address follows nums0 and is not 16-byte aligned.
    ALIGN 16                    ; Align the next label on a 16-byte boundary.
    nums1 DWORD 5, 5, 5, 5      ; Four DWORDs (16 bytes) initialized with values 5, 5, 5, and 5.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOVDQA XMM0, XMMWORD PTR [nums0] ; Load the first array of DWORDs into the XMM0 register.
    MOVDQA XMM1, XMMWORD PTR [nums1] ; Load the second array of DWORDs into the XMM1 register.
    PSUBD XMM0, XMM1                 ; Perform a packed subtraction of the two arrays, storing the result in XMM0.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

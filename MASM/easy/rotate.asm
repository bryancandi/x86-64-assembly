;--------------------------------------------------------------------
; ROTATE: x86-64 Rotating bits example.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RCX, RCX                ; Clear the RCX register.

    MOV CL, 65				    ; Move the ASCII character code 65 into CL.
    MOV CH, 90				    ; Move the ASCII character code 90 into CH.
    ROL CX, 8				    ; Rotate left the bits in CX by 8 positions.
    ROL CX, 8				    ; Rotate left the bits in CX by another 8 positions.
    SHR CX, 8				    ; Shift right the bits in CX by 8 positions to get back to original.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

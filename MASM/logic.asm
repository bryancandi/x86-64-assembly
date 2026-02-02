;--------------------------------------------------------------------
; LOGIC: x86-64 modifying bits example.
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
    XOR RDX, RDX                ; Clear the RDX register.
    MOV RCX, 0101b              ; Move the binary value 0101 into RCX.
    MOV RDX, 0011b              ; Move the binary value 0011 into RDX.
    XOR RCX, RDX                ; Perform bitwise XOR between RCX and RDX, result in RCX.
    AND RCX, RDX                ; Perform bitwise AND between RCX and RDX, result in RCX.
    OR RCX, RDX                 ; Perform bitwise OR between RCX and RDX, result in RCX.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

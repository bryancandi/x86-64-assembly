;--------------------------------------------------------------------
; SHIFT: x86-64 shifting bits example.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    unum BYTE 10011001b         ; Unsigned byte.
    sneg SBYTE 10011001b	    ; Signed negative byte.
    snum SBYTE 00110011b	    ; Signed positive byte.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RCX, RCX                ; Clear the RCX register.
    XOR RDX, RDX                ; Clear the RDX register.
    XOR R8, R8                  ; Clear the R8 register.

    MOV CL, unum                ; Move the unsigned byte into CL.
    MOV DL, sneg                ; Move the signed negative byte into DL.
    MOV R8B, snum               ; Move the signed positive byte into R8B.

    SHR CL, 2                   ; Logical right shift CL by 2 bits.
    SAR DL, 2                   ; Arithmetic right shift DL by 2 bits.
    SAR R8, 2				    ; Arithmetic right shift R8 by 2 bits.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

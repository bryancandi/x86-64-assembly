;--------------------------------------------------------------------
; IDIV: x86-64 IDIV example.
; Assemble with MASM and link:
; ml64.exe idiv.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RAX, RAX                ; Clear RAX register.
    XOR RBX, RBX                ; Clear RBX register.
    XOR RDX, RDX                ; Clear RDX register.
    MOV RAX, 100				; Load dividend (100) into RAX.
    MOV RBX, 3 				    ; Load divisor (3) into RBX.
    IDIV RBX                    ; Signed divide RAX by RBX. Quotient in RAX, remainder in RDX.
    MOV RAX, -100			    ; Load dividend (-100) into RAX.
    CQO						    ; Sign-extend RAX into RDX:RAX for signed division (quadword to octoword).
    IDIV RBX                    ; Signed divide RAX by RBX. Quotient in RAX, remainder in RDX.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

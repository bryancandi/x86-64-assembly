;--------------------------------------------------------------------
; PROC: x86-64 Calling Procedures.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
zeroRAX PROC                    ; A simple procedure to zero out the RAX register.
    XOR RAX, RAX                ; Set RAX to 0 by XORing it with itself.
    RET                         ; Return from the procedure.
zeroRAX ENDP                    ; End of the zeroRAX procedure.

main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV RAX, 64	                ; Move the value 64 into RAX.
    CALL zeroRAX                ; Call the zeroRAX procedure to set RAX to 0.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

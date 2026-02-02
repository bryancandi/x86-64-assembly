;--------------------------------------------------------------------
; JMP: x86-64 Unconditional Jump example.
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

    XOR R14, R14                ; Clear the R14 register.
    XOR R15, R15                ; Clear the R15 register.
    JMP next 				    ; Unconditional jump to the 'next' label.
    MOV R14, 100			    ; This instruction is skipped due to the jump.
    next:
    MOV R15, final			    ; Move the address of the 'final' label into R15.
    JMP R15                     ; Jump to the address stored in R15.
    MOV R14, 200			    ; This instruction is also skipped due to the jump.
    final:

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

;--------------------------------------------------------------------
; FLAGS: x86-64 Processor state flags example.
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
    MOV CL, 255				    ; Maximum unsigned 8-bit regierster value.
    ADD CL, 1				    ; Add 1 to CL, set carry flag (CY = 1).
    DEC CL				        ; Decrement CL by 1 to restore original (maximum) value.
    MOV CL, 127 			    ; Maximum signed 8-bit register value.
    ADD CL, 1				    ; Add 1 to CL, causing a signed overflow, assume negative signed register limit.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

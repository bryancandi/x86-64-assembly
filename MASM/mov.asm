;--------------------------------------------------------------------
; MOV: x86-64 MOV example.
; Assemble with MASM and link:
; ml64.exe mov.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    var QWORD 100               ; Define a 64-bit variable initialized to 100.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RCX, RCX                ; Clear the RCX register (set to 0).
    XOR RDX, RDX                ; Clear the RDX register (set to 0).
    MOV RCX, 33                 ; Move the value 33 into RCX.
    MOV RDX, RCX                ; Copy the value from RCX to RDX.
    MOV RCX, var                ; Load the address of 'var' into RCX.
    MOV var, RDX                ; Store the value from RDX into 'var'.

    XOR RCX, RCX                ; Exit code 0.
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

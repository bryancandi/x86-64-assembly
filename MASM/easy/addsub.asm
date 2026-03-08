;--------------------------------------------------------------------
; ADDSUB: x86-64 ADD and SUB example.
; Assemble with MASM and link:
; ml64.exe addsub.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    var QWORD 64 			    ; Define a 64-bit variable initialized to 64.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RCX, RCX                ; Clear RCX register.
    XOR RDX, RDX                ; Clear RDX register.
    MOV RCX, 36 			    ; Load 36 into RCX.
    ADD RCX, var				; Add the value of 'var' (64) to RCX.
    MOV RDX, 400			    ; Load 400 into RDX.
    ADD RDX, RCX				; Add the value in RCX to RDX.
    SUB RCX, 100			    ; Subtract 100 from RCX.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

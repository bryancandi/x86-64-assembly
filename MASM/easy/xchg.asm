;--------------------------------------------------------------------
; XCHG: x86-64 XCHG example.
; Assemble with MASM and link:
; ml64.exe xchg.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    var QWORD ? 			    ; Define an uninitialized variable named 'var'.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RCX, RCX                ; Clear RCX register.
    XOR RDX, RDX                ; Clear RDX register.

    MOV RCX, 5 			        ; Move the value 5 into RCX register.
    XCHG RCX, var			    ; Exchange the value in RCX with the value in 'var'.
    MOV DL, 3 			        ; Move the value 3 into DL register.
    XCHG DH, DL 		        ; Exchange the value in DH with the value in DL.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

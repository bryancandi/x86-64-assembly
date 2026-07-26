;--------------------------------------------------------------------
; INCNEG: x86-64 INC and NEG example.
; Assemble with MASM and link:
; ml64.exe incneg.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    var QWORD 99                ; Define a 64-bit variable 'var' initialized to 99.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).
    
    XOR RCX, RCX                ; Clear RCX register.
    INC var					    ; Increment the value at 'var' by 1 (car = car + 1).
    MOV RCX, 51				    ; Move 51 into RCX register.
    DEC RCX				        ; Decrement RCX by 1 (RCX = RCX - 1).
    NEG RCX				        ; Negate the value in RCX (RCX = -RCX).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

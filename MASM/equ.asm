;--------------------------------------------------------------------
; EQU: x86-64 EQU example.
; Assemble with MASM and link:
; ml64.exe equ.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    con EQU 12 				    ; Define a constant named 'con' with value 12.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RCX, RCX                ; Clear RCX register.
    XOR RDX, RDX                ; Clear RDX register.
    MOV RCX, con                ; Move the value of constant 'con' into RCX register.
    MOV RDX, con + 8			; Move the value of constant 'con' + 8 into RDX register.
    MOV RCX, con + 8 * 2		; Move the value of constant 'con' + 16 into RCX register.
    MOV RDX, (con + 8) * 2	    ; Move the value of (constant 'con' + 8) * 2 into RDX register.
    MOV RCX, con MOD 5		    ; Move the value of constant 'con' MOD 5 into RCX register.
    MOV RDX, (con - 3) / 3      ; Move the value of (constant 'con' - 3) / 3 into RDX register.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

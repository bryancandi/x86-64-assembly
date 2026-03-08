;--------------------------------------------------------------------
; JCOND: x86-64 Conditional Jump example.
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

    XOR RDX, RDX                ; Clear the RDX register.
    MOV CL, 255				    ; Move 255 into CL.
    ADD CL, 1				    ; Increment CL by 1 (carry flag set).
    JC carry                    ; Jump if carry flag is set.
    MOV RDX, 1				    ; Set RDX to 1 if no carry.
    carry:

    MOV CL, -128			    ; Move -128 into CL.
    SUB CL, 1				    ; Decrement CL by 1 (overflow flag set).
    JO overflow                 ; Jump if overflow flag is set.
    MOV RDX, 2				    ; Set RDX to 2 if no overflow.
    overflow:

    MOV CL, 255			        ; Move 255 into CL.
    AND CL, 10000000b		    ; AND CL with 10000000b (sign flag set).
    JS sign                     ; Jump if sign flag is set.
    MOV RDX, 3			        ; Set RDX to 3 if no sign.
    sign:

    JNZ notZero                 ; Jump if zero flag is not set.
    MOV RDX, 4			        ; Set RDX to 4 if zero.
    notZero:

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

;--------------------------------------------------------------------
; JSIGN: x86-64 Comparing signed values example.
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
    MOV RBX, -4                 ; Move -4 into RBX.
    MOV RCX, -1                 ; Move -1 into RCX.
    CMP RBX, RCX                ; Compare RBX with RCX.
    JG greater                  ; Jump if greater.
    MOV RDX, 1                  ; Set RDX to 1 if not greater.
    greater:

    MOV RCX, -16                ; Move -16 into RCX.
    CMP RBX, RCX                ; Compare RBX with RCX.
    JL less                     ; Jump if less.
    MOV RDX, 2                  ; Set RDX to 2 if not less.
    less:

    MOV RCX, -4                 ; Move -4 into RCX.
    CMP RBX, RCX                ; Compare RBX with RCX.
    JE equal                    ; Jump if equal.
    MOV RDX, 3                  ; Set RDX to 3 if not equal.
    equal:

    CMP RBX, RCX                ; Compare RBX with RCX.
    JNLE notLessOrEqual         ; Jump if not less or equal.
    MOV RDX, 4                  ; Set RDX to 4 if less or equal.
    notLessOrEqual:

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

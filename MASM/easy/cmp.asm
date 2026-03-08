;--------------------------------------------------------------------
; CMP: x86-64 Comparing unsigned values example.
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
    MOV RBX, 100                ; Move 100 into RBX.
    MOV RCX, 200                ; Move 200 into RCX.
    CMP RBX, RCX                ; Compare RBX with RCX.
    JA above                    ; Jump if above.
    MOV RDX, 1                  ; Set RDX to 1 if not above.
    above:

    MOV RCX, 50                 ; Move 50 into RCX.
    CMP RBX, RCX                ; Compare RBX with RCX.
    JB below                    ; Jump if below.
    MOV RDX, 2                  ; Set RDX to 2 if not below.
    below:

    MOV RCX, 100                ; Move 100 into RCX.
    CMP RBX, RCX                ; Compare RBX with RCX.
    JE equal                    ; Jump if equal.
    MOV RDX, 3                  ; Set RDX to 3 if not equal.
    equal:

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

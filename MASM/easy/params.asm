;--------------------------------------------------------------------
; PARAMS: x86-64 Passing Stack Arguments.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
max PROC
    MOV RCX, [RSP + 16]         ; Load the first argument (100) from the stack into RCX.
    MOV RDX, [RSP + 8]          ; Load the second argument (500) from the stack into RDX.
    CMP RCX, RDX                ; Compare the two arguments.
    JG  greater                 ; Jump to 'greater' if RCX > RDX.
    MOV RAX, RDX                ; Move RDX into RAX if RCX <= RDX.
    JMP finish                  ; Unconditionally jump to 'finish'.
    greater:
    MOV RAX, RCX                ; Move RCX into RAX if RCX > RDX.
    finish:
    RET                         ; Return from the procedure.
max ENDP                        ; End of the max procedure.

main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RAX, RAX                ; Initialize RAX to 0.
    PUSH 100                    ; Push the first argument (100) onto the stack.
    PUSH 500                    ; Push the second argument (500) onto the stack.
    CALL max                    ; Call the max procedure.
    ADD RSP, 16                 ; Clean up the stack after the call (2 arguments * 8 bytes each).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

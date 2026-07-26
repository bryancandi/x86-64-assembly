;--------------------------------------------------------------------
; FRAME: x86-64 Using Local Scope.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
total PROC
    PUSH RBP                    ; Save the base pointer.
    MOV RBP, RSP                ; Set the base pointer to the current stack pointer.
    SUB RSP, 16                 ; Allocate space for local variables (if needed).

    MOV RAX, [RBP + 16]         ; Load the first argument (100) from the stack into RAX.
    MOV [RBP - 8], RAX          ; Store the first argument in a local variable.
    MOV [RBP - 16], RAX         ; Store the first argument in another local variable.
    ADD RAX, [RBP - 8]          ; Add the first argument to itself (100 + 100).
    ADD RAX, [RBP - 16]         ; Add the first argument again (200 + 100).

    MOV RSP, RBP                ; Restore the original stack pointer.
    POP RBP                     ; Restore the base pointer.
    RET                         ; Return from the procedure.
total ENDP

main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RAX, RAX                ; Initialize RAX to 0.
    PUSH 100                    ; Push the first argument (100) onto the stack.
    CALL total                  ; Call the total procedure.
    ADD RSP, 8                  ; Clean up the stack after the call (1 (64-bit) argument * 8 bytes each).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

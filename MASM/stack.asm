;--------------------------------------------------------------------
; STACK: x86-64 Stacking Items.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    var WORD 256                ; Define a variable of type WORD (2 bytes) with an initial value of 256.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV RAX, 64	                ; Move the value 64 into RAX.
    PUSH RAX                    ; Push the value in RAX onto the stack.
    MOV RAX, 32	                ; Move the value 32 into RAX.

    PUSH var                    ; Push the address of the variable 'var' onto the stack.
    MOV var, 512                ; Move the value 512 into the variable 'var'.

    POP var                     ; Pop the top value from the stack into 'var', effectively restoring its original value (256).
    POP R10                     ; Pop the next value from the stack into R10, which will be 32 (the second value we pushed).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

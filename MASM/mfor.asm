;--------------------------------------------------------------------
; MFOR: x86-64 Iterating Loops (FOR loops).
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

nums MACRO arg1, arg2, arg3     ; Define a macro named 'nums' that takes three arguments.
    FOR arg, <arg1, arg2, arg3> ; Iterate over the arguments provided to the macro.
        PUSH arg                ; Push each argument onto the stack.
    ENDM
    POP RCX                     ; Pop the last argument into RCX (or any register).
    POP RBX                     ; Pop the second argument into RBX (or any register).
    POP RAX                     ; Pop the first argument into RAX (or any register).
ENDM

.DATA                           ; Start of the data section.
chars MACRO arglist             ; Define a macro named 'chars' that takes a list of arguments.
    FORC arg, arglist           ; Iterate over the arguments provided to the macro using FORC (which allows for a variable number of arguments).
        PUSH '&arg'             ; Push each argument onto the stack.
    ENDM
    POP RCX                     ; Pop the last argument into RCX (or any register).
    POP RBX                     ; Pop the second argument into RBX (or any register).
    POP RAX                     ; Pop the first argument into RAX (or any register).
ENDM

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    nums 1, 2, 3
    chars <ABC>

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

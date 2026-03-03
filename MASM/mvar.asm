;--------------------------------------------------------------------
; MVAR: x86-64 Varying Argument List.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

sumArgs MACRO arglist:VARARG    ; Define a macro named 'sumArgs' that takes a variable number of arguments (arglist).
    sum = 0                     ; Initialize a variable 'sum' to 0, which will hold the total of all arguments.
    i = 0                       ; Initialize a variable 'i' to 0, which will count the number of arguments processed.
    FOR arg, <arglist>          ; Iterate over each argument in 'arglist' using the FOR macro.
        i = i + 1               ; Increment the argument count 'i' by 1 for each argument processed.
        sum = sum + arg         ; Add the current argument 'arg' to 'sum' to accumulate the total.
    ENDM
    MOV RCX, i                  ; Move the total count of arguments processed into RCX (or any register).
    EXITM <sum>                 ; Exit the macro and return the value of 'sum' (the total of all arguments).
ENDM

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV RAX, sumArgs(1, 2, 3, 4)
    MOV RAX, sumArgs(1, 2, 3, 4, 5, 6, 7, 8)

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

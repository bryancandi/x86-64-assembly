;--------------------------------------------------------------------
; MRTN: x86-64 Returning Values.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

factorial MACRO num:REQ         ; Define a macro named 'factorial' that takes one required parameter 'num'.
    factor = num                ; Initialize a variable 'factor' with the value of 'num'.
    i = 1                       ; Initialize a variable 'i' to 1.
        WHILE factor GT 1       ; While 'factor' is greater than 1, execute the following block.
            i = i * factor      ; Multiply 'i' by 'factor' and store the result back in 'i'.
            factor = factor - 1 ; Decrement 'factor' by 1 in each iteration.
        ENDM
    EXITM <i>                   ; Exit the macro and return the value of 'i' (the factorial of 'num').
ENDM

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV RAX, factorial(4)       ; Call the 'factorial' macro with the argument 4, which will compute 4! and store the result in RAX.
    MOV RBX, factorial(5)       ; Call the 'factorial' macro with the argument 5, which will compute 5! and store the result in RBX.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

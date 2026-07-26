;--------------------------------------------------------------------
; MLBL: x86-64 Attaching Labels.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

power MACRO base:REQ, exponent:REQ ; Define a macro named 'power' that takes two required parameters: 'base' and 'exponent'.
    LOCAL start, finish         ; Define local labels for the loop.
    MOV RAX, 1                  ; Initialize RAX to 1, which will hold the result of base^exponent.
    MOV RCX, exponent           ; Move the exponent into RCX for counting.
    CMP RCX, 0                  ; Exit loop if the exponent is 0.
    JE finish
    MOV RBX, base               ; Move the base into RBX for multiplication.
    start:
        MUL RBX                 ; Multiply RAX by RBX (base) and store the result back in RAX.
        LOOP start              ; Loop until RCX (exponent) is decremented to 0.
    finish:
        ENDM

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    power 4, 2                  ; Call the 'power' macro with base 4 and exponent 2, which will compute 4^2 and store the result in RAX.
    power 5, 3                  ; Call the 'power' macro with base 5 and exponent 3, which will compute 5^3 and store the result in RAX.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

;--------------------------------------------------------------------
; MARGS: x86-64 Adding Parameters.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

clrReg MACRO reg                ; Macro to clear a specified register.
    XOR reg, reg
ENDM

sum MACRO reg:REQ, x:=<2>, y:=<8> ; Macro to sum two values and store the result in a register.
    MOV reg, x                    ; Default will be 2 if not specified.
    ADD reg, y                    ; Default will be 8 if not specified.
ENDM

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    clrReg RAX                  ; Use the clrReg macro to clear RAX register.

    sum RBX                     ; Use the sum macro with default values (2 and 8) to calculate the sum and store it in RBX.
    sum RBX, 12                 ; Use the sum macro again to add 12 to the existing value in RBX.
    sum RBX, 18, 12             ; Use the sum macro again to add 18 and 12 and overwrite the existing value in RBX.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

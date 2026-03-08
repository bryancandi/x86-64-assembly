;--------------------------------------------------------------------
; IMUL: x86-64 IMUL example.
; Assemble with MASM and link:
; ml64.exe imul.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    var QWORD 4 			    ; Define a 64-bit variable 'var' initialized to 4.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RAX, RAX                ; Clear RAX register.
    XOR RBX, RBX                ; Clear RBX register.
    MOV RAX, 10				    ; Load 10 into RAX.
    MOV RBX, 2				    ; Load 2 into RBX.
    IMUL RBX                    ; Signed multiply RAX by RBX (RAX = RAX * RBX).
    IMUL RAX, var			    ; Signed multiply RAX by 'var' (RAX = RAX * var).
    IMUL RAX, RBX, -3		    ; Signed multiply RBX by -3 and store result in RAX (RAX = RBX * -3).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

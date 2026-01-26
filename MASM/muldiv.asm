;--------------------------------------------------------------------
; MULDIV: x86-64 MUL and DIV example.
; Assemble with MASM and link:
; ml64.exe muldiv.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    var QWORD 2 			    ; Define a 64-bit variable 'var' initialized to 2.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RDX, RDX                ; Clear RDX register.
    MOV RAX, 10				    ; Load 10 into RAX.
    MOV RBX, 5				    ; Load 5 into RBX.
    MUL RBX                     ; Unsigned multiply RAX by RBX (RAX = RAX * RBX).
    MUL var					    ; Unsigned multiply RAX by 'var' (RAX = RAX * var).
    MOV RBX, 8				    ; Load 8 into RBX.
    DIV RBX                     ; Unsigned divide RAX by RBX (RAX = RAX / RBX).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

;--------------------------------------------------------------------
; MIF: x86-64 Making Decisions within MACROS (can also be in .CODE section).
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

scan MACRO num
IF num GT 50                    ; If the number is greater than 50, execute the following block.
    MOV RAX, 1
ELSEIF num LT 50                ; If the number is less than 50, execute the following block.
    MOV RAX, 0
ELSE                            ; If the number is equal to 50, execute the following block.
    MOV RAX, num
ENDIF
ENDM

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    scan 100
    scan 0
    scan 50

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

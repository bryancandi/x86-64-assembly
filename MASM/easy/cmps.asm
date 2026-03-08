;--------------------------------------------------------------------
; CMPS: x86-64 Comparing Strings.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    src BYTE 'abc'
    dst BYTE 'abc'
    match BYTE ?

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    LEA RSI, src                ; Load the effective address of the source string into RSI.
    LEA RDI, dst                ; Load the effective address of the destination string into RDI.
    MOV RCX, SIZEOF src         ; Move the size of the source string into RCX.
    CLD                         ; Clear the direction flag to ensure forward movement.
    REPE CMPSB                  ; Compare bytes at RSI and RDI, repeat while equal and RCX > 0.

    JNZ differ
    MOV match, 1                ; If the strings match, set match to 1.
    JMP finish

    differ:
    MOV match, 0                ; If the strings differ, set match to 0.
    finish:

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

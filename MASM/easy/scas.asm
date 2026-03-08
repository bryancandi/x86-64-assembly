;--------------------------------------------------------------------
; SCAS: x86-64 Scanning Strings.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    src BYTE 'abc'
    found BYTE ?

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RAX, RAX                ; Clear RAX register.
    MOV AL, 'b'                 ; Load the byte to search for ('b') into AL.
    LEA RDI, src                ; Load the effective address of the source string into RDI.
    MOV RCX, SIZEOF src         ; Move the size of the source string into RCX.
    CLD                         ; Clear the direction flag to ensure forward movement.
    REPNE SCASB                 ; Repeat scanning for the byte in AL until found or RCX is zero.

    JNZ absent
    MOV found, 1                ; If found, set found to 1.
    JMP finish

    absent:
    MOV found, 0                ; If not found, set found to 0.
    finish:

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

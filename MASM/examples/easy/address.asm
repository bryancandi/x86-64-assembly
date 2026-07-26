;--------------------------------------------------------------------
; ADDRESS: x86-64 Addressing Modes example.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    a BYTE 10                   ; a[0] or a
    b BYTE 20                   ; a[1] or a + 1
    c BYTE 30                   ; a[2] or a + 2
    d BYTE 40                   ; a[3] or a + 3

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RDX, RDX                ; Clear the RDX register.
    MOV AL, a                   ; Load the value of a[0] into AL register.
    MOV AH, a + 3			    ; Load the value of a[3] into AH register.
    LEA RCX, b                  ; Load the effective address of b into RCX register.
    MOV DL, [RCX]               ; Load the value of b[0] into DL register.
    MOV DH, [RCX + 1]           ; Load the value of b[1] into DH register.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

;--------------------------------------------------------------------
; MOVS: x86-64 Moving Characters.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    src BYTE 'abc'
    dst BYTE 3 DUP (?)

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RDX, RDX                ; Clear RDX register.
    XOR R8, R8                  ; Clear R8 register.
    XOR R9, R9                  ; Clear R9 register.
    LEA RSI, src                ; Load the effective address of the source string into RSI.
    LEA RDI, dst                ; Load the effective address of the destination string into RDI.
    MOV RCX, SIZEOF src         ; Move the size of the source string into RCX.
    CLD                         ; Clear the direction flag to ensure forward movement.
    REP MOVSB                   ; Repeat MOVSB instruction RCX times to copy bytes from source to destination.
    MOV DL, dst[0]              ; Move the first byte of the destination string into DL.
    MOV R8B, dst[1]             ; Move the second byte of the destination string into R8B.
    MOV R9B, dst[2]             ; Move the third byte of the destination string into R9B.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

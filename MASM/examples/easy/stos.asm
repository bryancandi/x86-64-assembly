;--------------------------------------------------------------------
; STOS: x86-64 Storing Contents.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    dst BYTE 3 DUP (?)          ; Reserve space for 3 bytes in the destination array.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RDX, RDX                ; Clear RDX register.
    XOR R8, R8                  ; Clear R8 register.
    XOR R9, R9                  ; Clear R9 register.
    MOV AL, 'A'                 ; Move the ASCII value of 'A' into AL.
    LEA RDI, dst                ; Load the effective address of the destination string into RDI.
    MOV RCX, SIZEOF dst         ; Move the size of the destination string into RCX.
    CLD                         ; Clear the direction flag to ensure forward movement.
    REP STOSB                   ; Repeat STOSB instruction RCX times to store bytes from AL into destination.
    MOV DL, dst[0]              ; Move the first byte of the destination string into DL.
    MOV R8B, dst[1]             ; Move the second byte of the destination string into R8B.
    MOV R9B, dst[2]             ; Move the third byte of the destination string into R9B.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

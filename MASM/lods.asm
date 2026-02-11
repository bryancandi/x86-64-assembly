;--------------------------------------------------------------------
; LODS: x86-64 Loading Contents.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    src BYTE 'abc'

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RDX, RDX                ; Clear RDX register.
    XOR R8, R8                  ; Clear R8 register.
    XOR R9, R9                  ; Clear R9 register.
    LEA RSI, src                ; Load the effective address of the source string into RSI.
    MOV RDI, RSI                ; Move the address of the source string into RDI for LODS.
    MOV RCX, SIZEOF src         ; Move the size of the source string into RCX.
    CLD                         ; Clear the direction flag to ensure forward movement.

    start:
    LODSB                       ; Load a byte from the source string into AL and increment RSI.
    SUB AL, 32                  ; Convert the loaded byte to uppercase by subtracting 32 (ASCII difference).
    STOSB                       ; Store the byte in AL back to the destination (which is the same as source in this case).
    DEC RCX                     ; Decrement the loop counter.
    JNZ start                   ; Jump back to the start of the loop if RCX is not zero.

    MOV DL, src[0]              ; Move the first byte of the source string (now modified) into DL.  
    MOV R8B, src[1]             ; Move the second byte of the source string (now modified) into R8B.
    MOV R9B, src[2]             ; Move the third byte of the source string (now modified) into R9B.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

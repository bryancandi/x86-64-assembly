;--------------------------------------------------------------------
; ARGS: x86-64 Passing Register Arguments.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    arr QWORD 100, 150, 200     ; An array of three 64-bit integers.

.CODE                           ; Start of the code section.
sum PROC                        ; A procedure to calculate the sum of an array of integers.
    XOR RAX, RAX                ; Initialize RAX to 0 to hold the sum.

    start:
    ADD RAX, [RDX]              ; Add the current array element pointed to by RDX to RAX.
    ADD RDX, 8                  ; Move the pointer to the next element (8 bytes for QWORD).
    DEC RCX                     ; Decrement the count of remaining elements in RCX.
    JNZ start                   ; Jump back to the start if there are more elements to process.
    RET                         ; Return from the procedure.
sum ENDP                        ; End of the sum procedure.

main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV RCX, LENGTHOF arr       ; Move the length of the array (3) into RCX.
    LEA RDX, arr                ; Load the effective address of the array into RDX.

    CALL sum                    ; Call the sum procedure to calculate the sum of the array elements.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

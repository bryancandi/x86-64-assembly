;--------------------------------------------------------------------
; FILL: x86-64 Addressing Destination Index example.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    arr QWORD 0, 0, 0           ; Define an array of 3 QWORDs (64-bit integers) initialized to 0.
    cpy QWORD 3 DUP(0)          ; Define another array of 3 QWORDs initialized to 0, which will be used for copying.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    LEA RDI, arr                ; Load the effective address of the 'arr' array into RDI (destination index).
    MOV RCX, 0                  ; Initialize RCX to 0, which will be used as a counter for the loop.
    MOV RDX, 10                 ; Set RDX to 10, which will be the value to store in the array.

    loop_start:
    MOV [RDI+RCX*8], RDX        ; Store the value in RDX (10) at the address calculated by RDI + RCX*8 (since each element is 8 bytes).
    ADD RDX, 10                 ; Increment RDX by 10 for the next value (20, 30, etc.).
    INC RCX                     ; Increment the counter RCX.
    CMP RCX, LENGTHOF arr       ; Compare RCX with the length of the array (3).
    JNE loop_start              ; If RCX is not equal to the length of the array, jump back to the start of the loop.

    MOV R10, arr[0*8]           ; Load the first element of the 'arr' array into R10.
    MOV R11, arr[1*8]           ; Load the second element of the 'arr' array into R11.
    MOV R12, arr[2*8]           ; Load the third element of the 'arr' array into R12.

    LEA RSI, arr                ; Load the effective address of the 'arr' array into RSI (source index).
    LEA RDI, cpy                ; Load the effective address of the 'cpy' array into RDI (destination index).
    MOV RCX, LENGTHOF arr       ; Set RCX to the length of the array (3) for the copy loop.
    CLD                         ; Clear the direction flag to ensure forward copying.
    REP MOVSQ                   ; Repeat MOVSQ (move quadword) RCX times to copy from RSI to RDI.

    MOV R13, cpy[0*8]           ; Load the first element of the 'cpy' array into R13.
    MOV R14, cpy[1*8]           ; Load the second element of the 'cpy' array into R14.
    MOV R15, cpy[2*8]           ; Load the third element of the 'cpy' array into R15.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

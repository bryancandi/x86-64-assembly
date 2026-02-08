;--------------------------------------------------------------------
; INDEX: x86-64 Addressing Source Index loop example.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    arr QWORD 10, 20, 30, 40    ; Declare an array of quad words with 4 elements.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    LEA RSI, arr                ; Load the effective address of the first element of arr into RSI register.
    MOV RCX, 0				    ; Initialize the index counter to 0.
    loop_start:
    MOV RDX, [RSI + RCX * 8]    ; Load the current element of arr into RDX register (8 bytes per element).
    ; Here you can perform operations with RDX, for example, print it or manipulate it.
    INC RCX                     ; Increment the index counter.
    CMP RCX, LENGTHOF arr       ; Compare the index counter with the number of elements in arr.
    JNE loop_start              ; If the index counter is not equal to the number of elements, jump back to the start of the loop.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

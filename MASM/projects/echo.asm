;--------------------------------------------------------------------
; ECHO: x86-64 Read console input and write it back to the console.
; Assemble with MASM and link:
; ml64.exe echo.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib                     ; Import a standard Windows library.

ExitProcess    PROTO                        ; Declare the ExitProcess function prototype.
GetStdHandle   PROTO
ReadConsoleA   PROTO
WriteConsoleA  PROTO

deviceCodeR EQU -10                         ; Code for console input.
deviceCodeW EQU -11                         ; Code for console output.

.DATA                                       ; Start of the data section.
    txt     BYTE 100 DUP (?)                ; Declare a byte array of size 100, initialized with zeros.
    handle  QWORD ?
    num     DWORD ?

.CODE                                       ; Start of the code section.
main PROC                                   ; Entry point of the program.
    XOR RAX, RAX                            ; Clear registers.
    XOR RCX, RCX
    XOR RDX, RDX
    XOR R8, R8
    XOR R9, R9

    SUB RSP, 40                             ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV RCX, deviceCodeR                    ; Console device code, to be passed to GetStdHandle.
    CALL GetStdHandle                       ; Receive the console input handle.
    MOV handle, RAX                         ; Store the device handle.

    MOV RCX, handle                         ; Pass device handle as argument 1.
    LEA RDX, txt                            ; Pass pointer to array as argument 2.
    MOV R8, LENGTHOF txt                    ; Pass array length as argument 3.
    LEA R9, num                             ; Pass pointer to variable as argument 4.
    MOV QWORD PTR [RSP+32], 0               ; Push a null pointer for argument 5 (reserved, must be NULL) onto the stack at the correct position.
    CALL ReadConsoleA                       ; Read input from the console into the array.

    MOV RCX, deviceCodeW                    ; Console device code, to be passed to GetStdHandle.
    CALL GetStdHandle                       ; Receive the console output handle.
    MOV handle, RAX                         ; Store the device handle.

    MOV RCX, handle                         ; Pass device handle as argument 1.
    LEA RDX, txt                            ; Pass pointer to array as argument 2.
    ; Pass the number of characters read (stored in 'num') as argument 3, using R8D to access the lower 32 bits of R8.
    MOV R8D, [num]
    LEA R9, num                             ; Pass pointer to variable as argument 4.
    MOV QWORD PTR [RSP+32], 0               ; Push a null pointer for argument 5 (reserved, must be NULL) onto the stack at the correct position.
    CALL WriteConsoleA                      ; Write the string into the console.

    XOR RCX, RCX                            ; Exit code 0.
    CALL ExitProcess                        ; Call the ExitProcess function to exit the program.
main ENDP                                   ; End of the main procedure.
END                                         ; End of the assembly program.

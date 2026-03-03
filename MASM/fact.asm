;--------------------------------------------------------------------
; Factorial example for Windows x64 (MASM / ml64).
; Change 'fnum' to try different input values.
;
; Assemble with MASM and link:
; ml64.exe fact.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.
GetStdHandle PROTO
WriteConsoleA PROTO

STD_OUTPUT_HANDLE EQU -11

.DATA
    txt BYTE 100 DUP (?)        ; Empty 100 byte buffer for output.
    handle QWORD ?              ; 64-bit storage for Windows HANDLE (returned by GetStdHandle).
    num DWORD ?                 ; 32-bit output variable for WriteConsoleA character count.
    fnum QWORD 5                ; Number to use in factorial calculation.

.CODE
int_to_str PROC
    LEA RDI, txt                ; Load address of 'txt' buffer into RDI register.
    ADD RDI, LENGTHOF txt - 1   ; Adjust pointer to end of 'txt' buffer.
    MOV RBX, 10                 ; Move divisor into RBX.

    div_loop:
    XOR RDX, RDX                ; Clear for remainder.
    DIV RBX                     ; Divide RAX by RBX (10).
    ADD RDX, '0'                ; Add ASCII '0' value to remainder in RDX to convert from integer to ASCII value.
    MOV [RDI], DL               ; Move one byte of RDX (DL) into RDI (RDI points to 'txt' buffer).
    DEC RDI                     ; Decrement RDI; we are writing to the buffer in reverse order (starting at the end).
    TEST RAX, RAX               ; Is RAX zero?
    JNZ div_loop                ; No; restart loop.
    LEA RAX, [RDI + 1]          ; Return value is stored in RAX. RAX + 1 because RDI was decremented before testing RAX for zero.
    RET
int_to_str ENDP

fact PROC
    MOV RAX, 1                  ; Initialize factorial result to 1. RAX will hold the running factorial result.
    CMP RCX, 1                  ; Check if RCX is less than or equal to 1 (fnum); return if true.
    JLE finish

    start:
    IMUL RAX, RCX               ; Multiply accumulator (RAX) by current RCX. RCX holds the value of 'fnum' initially.
    DEC RCX                     ; Decrement loop counter RCX (fnum) by 1.
    CMP RCX, 1                  ; Is RCX (fnum) still greater than 1? If so, continue multiplying.
    JG start

    finish:
    RET
fact ENDP

main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RAX, RAX                ; Clear return register. This will contain output from 'fact' and 'int_to_str' functions.

    MOV RCX, fnum               ; Move number to calculate the factorial of into RCX register.
    CALL fact                   ; 'fact' will store factorial integer in RAX register for division in 'int_to_str'.
    CALL int_to_str             ; 'int_to_str' will convert the integer in RAX to a string in 'txt' buffer.

    MOV RCX, STD_OUTPUT_HANDLE  ; Move STDOUT handle to RCX to be used by GetStdHandle call.
    CALL GetStdHandle           ; Receive console handle.
    MOV handle, RAX             ; Store console handle.

    MOV RCX, handle             ; 1st arg: handle to console screen buffer.
    LEA RDX, txt                ; 2nd arg: pointer to buffer that contain text to write.
    MOV R8, LENGTHOF txt        ; 3rd arg: number of characters to be written to console.
    LEA R9, num                 ; 4th arg: pointer to a variable to contain the number of characters actually written.
    MOV QWORD PTR [RSP+32], 0   ; 5th arg; NULL.
    CALL WriteConsoleA

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

;--------------------------------------------------------------------
; Factorial example for Windows x64 (MASM / ml64).
;
; Assemble with MASM and link:
; ml64.exe fact.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib
INCLUDELIB shell32.lib

ExitProcess PROTO
GetStdHandle PROTO
WriteConsoleA PROTO
GetCommandLineW PROTO
CommandLineToArgvW PROTO

STD_OUTPUT_HANDLE EQU -11

.DATA
    buf BYTE 100 DUP (?)        ; Empty 100 byte buffer to store ASCII digits of factorial result.
    handle QWORD ?              ; 64-bit storage for Windows HANDLE (returned by GetStdHandle).
    num DWORD ?                 ; 32-bit output variable for WriteConsoleA character count.
    argc DWORD ?                ; 32‑bit storage for the argument count returned by CommandLineToArgvW.
    argv QWORD ?                ; 64‑bit storage for the pointer to the argv array (LPWSTR*).

.CODE
IntToStr PROC
    LEA RDI, buf                ; Load address of 'buf' buffer into RDI register.
    ADD RDI, LENGTHOF buf - 1   ; Adjust pointer to end of 'buf' buffer.
    MOV RBX, 10                 ; Move divisor into RBX.

    div_loop:
    XOR RDX, RDX                ; Clear for remainder.
    DIV RBX                     ; Divide RAX by RBX (10).
    ADD RDX, '0'                ; Add ASCII '0' value to remainder in RDX to convert from integer to ASCII value.
    MOV [RDI], DL               ; Move one byte of RDX (DL) into RDI (RDI points to 'buf' buffer).
    DEC RDI                     ; Decrement RDI; we are writing to the buffer in reverse order (starting at the end).
    TEST RAX, RAX               ; Is RAX zero?
    JNZ div_loop                ; No; restart loop.
    LEA RAX, [RDI + 1]          ; Return value is stored in RAX. RAX + 1 because RDI was decremented before testing RAX for zero.
    RET
IntToStr ENDP

StrToInt PROC
    XOR RAX, RAX

    start:
    MOVZX RDX, WORD PTR [RCX]   ; Move wchar with zero-extend into RDX.
    TEST RDX, RDX               ; Is RDX zero?
    JZ finish                   ; Yes; return.
    SUB RDX, '0'                ; Subtract ASCII '0' value to convert from char to integer.
    IMUL RAX, RAX, 10           ; Multiply the current accumulated value by 10 to shift its decimal place left before adding the next digit.
    ADD RAX, RDX                ; Add the newly parsed digit (0–9) into the shifted accumulator to form the next partial value.
    ADD RCX, 2                  ; Advance pointer to next wide character (wchar = 2 bytes).
    JMP start

    finish:
    RET
StrToInt ENDP

Factorial PROC
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
Factorial ENDP

main PROC
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    CALL GetCommandLineW
    MOV RCX, RAX                ; LPWSTR cmdline.
    LEA RDX, argc               ; int argc.

    CALL CommandLineToArgvW
    MOV argv, RAX               ; LPWSTR* argv.
    MOV RCX, [argv]             ; Point to argv array in RCX.
    MOV RCX, [RCX+8]            ; Point to argv[1] (skip program name).

    CALL StrToInt               ; Convert the string in argv[1] to an integer to use in factorial calculation.
    MOV RCX, RAX                ; Move number to calculate the factorial of into RCX register.
    CALL Factorial              ; Store factorial integer in RAX register for division in 'IntToStr'.
    CALL IntToStr               ; Convert the integer in RAX to a string in 'buf' buffer.

    MOV RCX, STD_OUTPUT_HANDLE  ; Move STDOUT handle to RCX to be used by GetStdHandle call.
    CALL GetStdHandle           ; Receive console handle.
    MOV handle, RAX             ; Store console handle.

    MOV RCX, handle             ; 1st arg: handle to console screen buffer.
    LEA RDX, buf                ; 2nd arg: pointer to buffer that contain text to write.
    MOV R8, LENGTHOF buf        ; 3rd arg: number of characters to be written to console.
    LEA R9, num                 ; 4th arg: pointer to a variable to contain the number of characters actually written.
    MOV QWORD PTR [RSP+32], 0   ; 5th arg: lpReserved; NULL.
    CALL WriteConsoleA

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess
main ENDP
END

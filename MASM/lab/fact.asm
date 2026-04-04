;====================================================================
; x64 Factorial example for Windows console.
;
; Assemble with MASM and link:
; ml64.exe fact.asm /link /SUBSYSTEM:console /ENTRY:main
;====================================================================

INCLUDELIB kernel32.lib
INCLUDELIB shell32.lib

ExitProcess         PROTO
GetStdHandle        PROTO
WriteConsoleA       PROTO
GetCommandLineW     PROTO
CommandLineToArgvW  PROTO

Console             EQU    -11

; msgOut macro writes ASCII string 'msg' to console using stdout handle.
msgOut  MACRO   msg             ; One arg macro: msg
        mov     RCX, stdout     ; 1st arg: handle to console screen buffer.
        lea     RDX, msg        ; 2nd arg: pointer to buffer (macro) that contain text to write.
        mov     R8, LENGTHOF msg ; 3rd arg: number of characters to be written to console.
        lea     R9, num         ; 4th arg: pointer to a variable to contain the number of characters actually written.
        call    WriteConsoleA
        ENDM

        .DATA
buf     BYTE    100 DUP (?)     ; Empty 100 byte buffer to store ASCII digits of factorial result.
fact    BYTE    "Factorial: "
usage   BYTE    "Usage: fact.exe <num>"
newln   BYTE    0Dh, 0Ah        ; Carriage return and line feed.
stdout  QWORD   ?               ; 64-bit storage for stdout handle (returned by GetStdHandle).
num     DWORD   ?               ; 32-bit output variable for WriteConsoleA character count.
argc    DWORD   ?               ; 32-bit storage for the argument count returned by CommandLineToArgvW.
argv    QWORD   ?               ; 64-bit storage for the pointer to the argv array (LPWSTR*).

        .CODE
IntToStr PROC
        push    RDI             ; Preserve caller's RDI value on the stack.
        lea     RDI, buf        ; Load address of 'buf' buffer into RDI register.
        add     RDI, LENGTHOF buf - 1 ; Adjust pointer to end of 'buf' buffer.
        mov     R10, 10         ; Move divisor (10) into R10.

divlp:  xor     RDX, RDX        ; Clear for remainder.
        div     R10             ; Divide RAX by R10.
        add     RDX, '0'        ; Add ASCII '0' value to remainder in RDX to convert from integer to ASCII value.
        mov     [RDI], DL       ; Move one byte of RDX (DL) into RDI (RDI points to 'buf' buffer).
        dec     RDI             ; Decrement RDI; we are writing to the buffer in reverse order (starting at the END).
        test    RAX, RAX        ; Is RAX zero?
        jnz     divlp           ; No; restart loop.
        lea     RAX, [RDI + 1]  ; Pointer to start of resulting string in RAX. RDI was decremented after writing last digit, so add 1.
        pop     RDI             ; Restore RDI.
        ret
IntToStr ENDP

StrToInt PROC
        xor     RAX, RAX

start:  movzx   RDX, WORD PTR [RCX] ; Move wchar with zero-extend into RDX.
        test    RDX, RDX        ; Is RDX zero?
        jz      finish          ; Yes; return.
        sub     RDX, '0'        ; Subtract ASCII '0' value to convert from char to integer.
        imul    RAX, RAX, 10    ; Multiply the current accumulated value by 10 to shift its decimal place left before adding the next digit.
        add     RAX, RDX        ; Add the newly parsed digit (0-9) into the shifted accumulator to form the next partial value.
        add     RCX, 2          ; Advance pointer to next wide character (wchar = 2 bytes).
        jmp     start

finish: ret
StrToInt ENDP

CalcFact PROC
        mov     RAX, 1          ; Initialize factorial result to 1. RAX will hold the running factorial result.
        cmp     RCX, 1          ; Is RCX (argv[1]) is less than or equal to 1?
        jle     finish          ; Yes; return.

start:  imul    RAX, RCX        ; Multiply accumulator (RAX) by current RCX. RCX holds the value of argv[1] initially.
        dec     RCX             ; Decrement loop counter RCX by 1.
        cmp     RCX, 1          ; Is RCX still greater than 1?
        jg      start           ; Yes; continue.

finish: ret
CalcFact ENDP

main    PROC
        sub     RSP, 40         ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

        mov     RCX, Console    ; Move STDOUT handle to RCX to be used by GetStdHandle call.
        call    GetStdHandle    ; Receive console handle.
        mov     stdout, RAX     ; Store console handle.

        call    GetCommandLineW ; Stores pointer to command-line string in RAX.
        mov     RCX, RAX        ; Copy pointer to command-line string into RCX for next call.
        lea     RDX, argc       ; Pointer to argc to store argument count in the next call.

        call    CommandLineToArgvW ; Parse command line: RAX = LPWSTR* argv array, stores arg count into [RDX] (argc).
        cmp     argc, 2         ; Was a second arg provided?
        jne     error           ; No; print usage and exit.
        mov     argv, RAX       ; Store LPWSTR* argv array in argv.
        mov     RCX, [argv]     ; Load argv[0] (first argument - program name) into RCX.
        mov     RCX, [RCX + 8]  ; Load argv[1] (first user argument) into RCX.

        call    StrToInt        ; Convert string in argv[1] to integer; result returned in RAX.
        mov     RCX, RAX        ; Move the integer into RCX for factorial calculation.
        call    CalcFact        ; Compute factorial of RCX; result returned in RAX.
        call    IntToStr        ; Convert RAX (factorial result) to ASCII string in 'buf'.

        msgOut  fact            ; Write to console.
        msgOut  buf
        msgOut  newln

exit:   xor     RCX, RCX        ; Exit code 0.
        call    ExitProcess

error:  msgOut  usage           ; Write error to console.
        msgOut  newln
        jmp     exit
main    ENDP
        END

;====================================================================
; x64 ECHO program for Windows console.
; Repeatedly reads a line of input and echoes it back to the console.
; Terminates when an empty line (CRLF only) is entered.
;
; Assemble with MASM and link:
; ml64.exe echo.asm /link /SUBSYSTEM:console /ENTRY:main
;====================================================================

INCLUDELIB kernel32.lib                     ; Import Kernel32 library (Windows API).

ExitProcess     PROTO                       ; Terminate the current process.
GetStdHandle    PROTO                       ; Retrieve a handle to a standard device (input/output).
ReadConsoleA    PROTO                       ; Read characters from the console input buffer.
WriteConsoleA   PROTO                       ; Write a buffer of characters to the console.

STD_INPUT_HANDLE  EQU    -10                ; Device code for keyboard input.
STD_OUTPUT_HANDLE EQU    -11                ; Device code for console output.
MaxBuf            EQU    100                ; Maximum input buffer size.

        .DATA
pmsg    BYTE    "Enter text: "              ; User prompt message.
inbuf   BYTE    MaxBuf DUP (?)              ; Input buffer of MaxBuf size.
stdin   QWORD   ?                           ; Handle to standard input device.
stdout  QWORD   ?                           ; Handle to standard output device.
nbwr    DWORD   ?                           ; Number of bytes (characters) actually written.
nbrd    DWORD   ?                           ; Number of bytes (characters) actually read.

        .CODE
main    PROC
        sub     RSP, 40                     ; Reserve "shadow space" on stack for 4 args (32 shadow + 8 alignment).

;       Obtain handle for standard input (keyboard).
        mov     RCX, STD_INPUT_HANDLE       ; Standard input device code for GetStdHandle.
        call    GetStdHandle                ; Return handle to standard input.
        mov     stdin, RAX                  ; Store the handle for keyboard input.

;       Obtain handle for standard output (console).
        mov     RCX, STD_OUTPUT_HANDLE      ; Standard output device code for GetStdHandle.
        call    GetStdHandle                ; Return handle to standard output.
        mov     stdout, RAX                 ; Store the handle for console output.

;       Print prompt to console.
next:   mov     RCX, stdout                 ; Arg 1: output device handle.
        lea     RDX, pmsg                   ; Arg 2: pointer to byte array.
        mov     R8, LENGTHOF pmsg           ; Arg 3: number of bytes to write (length of prompt string).
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleA               ; Function call to write text to console.

;       Read user input.
        mov     RCX, stdin                  ; Arg 1: input device handle.
        lea     RDX, inbuf                  ; Arg 2: pointer to a buffer that receives the data read from the console input buffer.
        mov     R8, MaxBuf                  ; Arg 3: maximum number of bytes to be read.
        lea     R9, nbrd                    ; Arg 4: pointer to variable that receives number of bytes read.
        call    ReadConsoleA                ; Function call to read user keyboard input.

;       Exit if empty line, otherwise continue.
        mov     R8d, [nbrd]                 ; Copy length in bytes of input message (32-bit DWORD).
        cmp     R8d, 2                      ; If only CRLF (2 chars) was entered, treat as empty line.
        je      exit                        ; Jump to exit if equal.

;       Print to console.
        mov     RCX, stdout                 ; Arg 1: output device handle.
        lea     RDX, inbuf                  ; Arg 2: pointer to byte array.
        mov     R8d, [nbrd]                 ; Arg 3: number of bytes to write (DWORD returned by ReadConsoleA).
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleA               ; Function call to write text to console.

;       Get next input from user.
        jmp     next                        ; Repeat loop.

;       Program exit.
exit:   xor     RCX, RCX                    ; Set exit status code to zero.
        call    ExitProcess                 ; Call the ExitProcess function to exit the program.
main    ENDP
        END

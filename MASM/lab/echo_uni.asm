;====================================================================
; x64 ECHO (v2) program for Windows console.
; Uses macros and ReadConsoleW/WriteConsoleW for UTF-16 I/O.
; Repeatedly reads a line of input and echoes it back to the console.
; Terminates when an empty line (CRLF only) is entered.
;
; Assemble with MASM and link:
; ml64.exe echo_uni.asm /link /SUBSYSTEM:console /ENTRY:main
;====================================================================

INCLUDELIB kernel32.lib                     ; Import Kernel32 library (Windows API).

ExitProcess     PROTO                       ; Terminate the current process.
GetStdHandle    PROTO                       ; Retrieve a handle to a standard device (input/output).
ReadConsoleW    PROTO                       ; Read characters from the console input buffer.
WriteConsoleW   PROTO                       ; Write a buffer of characters to the console.

STD_INPUT_HANDLE  EQU    -10                ; Device code for keyboard input.
STD_OUTPUT_HANDLE EQU    -11                ; Device code for console output.
MaxBuf            EQU    256                ; Maximum input buffer size.

ReadIn  MACRO   buf                         ; Single argument macro to read user input into a buffer (ReadConsoleW).
        mov     RCX, [stdin]                ; Arg 1: input device handle.
        lea     RDX, buf                    ; Arg 2: pointer to a buffer that receives the data read from the console input buffer.
        mov     R8, MaxBuf                  ; Arg 3: number of UTF‑16 characters to read.
        lea     R9, nbrd                    ; Arg 4: pointer to variable that receives number of characters read.
        call    ReadConsoleW                ; Function call to read user input.
        ENDM

StrOut  MACRO   msg                         ; Single argment macro to call write a string to console (WhiteConsoleW).
        mov     RCX, [stdout]               ; Arg 1: output device handle.
        lea     RDX, msg                    ; Arg 2: pointer to character array.
        mov     R8, LENGTHOF msg            ; Arg 3: number of UTF‑16 characters to write.
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleW               ; Function call to write to console.
        ENDM

BufOut  MACRO   buf                         ; Single argment macro to call write contents of a buffer to console (WhiteConsoleW).
        mov     RCX, [stdout]               ; Arg 1: output device handle.
        lea     RDX, buf                    ; Arg 2: pointer to character array.
        mov     R8d, [nbrd]                 ; Arg 3: number of UTF‑16 characters to write.
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleW               ; Function call to write to console.
        ENDM

        .DATA
pmsg    WORD    "E","n","t","e","r"," ","t","e","x","t",":"," " ; User prompt message.
inbuf   WORD    MaxBuf DUP (?)              ; Input buffer of MaxBuf size.
stdin   QWORD   ?                           ; Handle to standard input device.
stdout  QWORD   ?                           ; Handle to standard output device.
nbwr    DWORD   ?                           ; Number of UTF‑16 characters actually written.
nbrd    DWORD   ?                           ; Number of UTF‑16 characters actually read.

        .CODE
main    PROC
        sub     RSP, 40                     ; Reserve "shadow space" on stack for 4 args (32 shadow + 8 alignment).

;       Obtain handle for standard input (keyboard).
        mov     RCX, STD_INPUT_HANDLE       ; Standard input device code for GetStdHandle.
        call    GetStdHandle                ; Return handle to standard input.
        mov     [stdin], RAX                ; Store the handle for keyboard input.

;       Obtain handle for standard output (console).
        mov     RCX, STD_OUTPUT_HANDLE      ; Standard output device code for GetStdHandle.
        call    GetStdHandle                ; Return handle to standard output.
        mov     [stdout], RAX               ; Store the handle for console output.

;       Print prompt to console.
next:   StrOut  pmsg

;       Read user input.
        ReadIn  inbuf

;       Exit if empty line, otherwise continue.
        mov     R8d, [nbrd]                 ; Number of UTF-16 characters read (DWORD; use R8d to load a 32-bit value).
        cmp     R8d, 2                      ; CRLF (2 chars) only?
        je      exit

;       Print buffer to console.
        BufOut  inbuf

;       Get next input from user.
        jmp     next

;       Program exit.
exit:   xor     RCX, RCX
        call    ExitProcess
main    ENDP
        END

;--------------------------------------------------------------------
; x86-64 Assembly ECHO program for Windows console.
; Assemble with MASM and link:
; ml64.exe echo.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

includelib kernel32.lib                     ; Windows kernel interface.
ExitProcess     proto                       ; Declare the ExitProcess function prototype.
GetStdHandle    proto                       ; Function to retrieve I/O handle.
ReadConsoleA    proto                       ; Reads character input from the input buffer.
WriteConsoleA   proto                       ; Writes a buffer of characters to the console.
Console         equ    -11                  ; Device code for console output.
Keyboard        equ    -10                  ; Device code for keyboard input.
MaxBuf          equ    100                  ; Maximum input buffer size.

        .data
prmpt   byte    "Enter text to echo: "      ; User prompt message.
inbuf   byte    MaxBuf DUP (?)              ; Input buffer of MaxBuf size.
;crlf    byte    0DH, 0AH                   ; Carriage return and line feed characters.
stdout  qword   ?                           ; Handle to standard output device.
stdin   qword   ?                           ; Handle to standard input device.
nbwr    dword   ?                           ; Number of bytes (characters) actually written.
nbrd    dword   ?                           ; Number of bytes (characters) actually read.

        .code
main    proc
        sub     RSP, 40                     ; Reserve "shadow space" on stack for 4 args (32 shadow + 8 alignment).

;       Obtain "handle" for console display.
        mov     RCX, Console                ; Console device code, to be passed to GetStdHandle.
        call    GetStdHandle                ; Receive the console output handle.
        mov     stdout, RAX                 ; Store the handle for console output.

;       Obtain "handle" for keyboard input.
        mov     RCX, Keyboard               ; Keyboard device code, to be passed to GetStdHandle.
        call    GetStdHandle                ; Receive the keyboard input handle.
        mov     stdin, RAX                  ; Store the handle for keyboard input.

;       Print prompt to console.
        mov     RCX, stdout                 ; Arg 1: output device handle.
        lea     RDX, prmpt                  ; Arg 2: pointer to byte array.
        mov     R8, lengthof prmpt          ; Arg 3: number of bytes to write (array length).
        lea     R9, nbwr                    ; Arg 4: pointer to variable to contain number of bytes written.
        call    WriteConsoleA               ; Function call to write text to console.

;       Read user input.
        mov     RCX, stdin                  ; Arg 1: input device handle.
        lea     RDX, inbuf                  ; Arg 2: pointer to a buffer that receives the data read from the console input buffer.
        mov     R8, MaxBuf                  ; Arg 3: maximum number of bytes to be read.
        lea     R9, nbrd                    ; Arg 4: pointer to variable to contain number of bytes read.
        call    ReadConsoleA                ; Function call to read user keyboard input.

;       Print to console.
        mov     RCX, stdout                 ; Arg 1: output device handle.
        lea     RDX, inbuf                  ; Arg 2: pointer to byte array.
        mov     R8d, [nbrd]                 ; Arg 3: 32-bit DWORD containing number of bytes to write (bytes read in nbrd).
        lea     R9, nbwr                    ; Arg 4: pointer to variable to contain number of bytes written.
        call    WriteConsoleA               ; Function call to write text to console.

;       Exit.
        xor     RCX, RCX                    ; Set exit status code to zero.
        call    ExitProcess                 ; Call the ExitProcess function to exit the program.
        add     RSP, 40                     ; Restore "shadow space" on stack (never reached; ExitProcess does not return).
main    endp
        end

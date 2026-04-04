;====================================================================
; x64 "Hello, world!" program for Windows console.
;
; Assemble with MASM and link:
; ml64.exe hello.asm /link /SUBSYSTEM:console /ENTRY:main
;====================================================================

INCLUDELIB kernel32.lib                     ; Windows kernel interface.

ExitProcess     PROTO                       ; Declare the ExitProcess function prototype.
GetStdHandle    PROTO                       ; Function to retrieve I/O handle.
WriteConsoleA   PROTO                       ; Writes a buffer of characters to the console.

Console         EQU     -11                 ; Device code for console output.

        .DATA
txt     BYTE    "Hello, world!", 0Dh, 0Ah   ; Message, carriage return, line feed.
stdout  QWORD   ?                           ; Handle to standard output device.
nbwr    DWORD   ?                           ; Number of bytes actually written.

        .CODE
main    PROC
        sub     RSP, 40                     ; Reserve "shadow space" on stack for 4 args (32 shadow + 8 alignment).

;       Obtain "handle" for console display.
        mov     RCX, Console                ; Console device code, to be passed to GetStdHandle.
        call    GetStdHandle                ; Receive the console output handle.
        mov     stdout, RAX                 ; Store the handle for console output.

;       Print to console.
        mov     RCX, stdout                 ; Arg 1: device handle.
        lea     RDX, txt                    ; Arg 2: pointer to byte array.
        mov     R8, LENGTHOF txt            ; Arg 3: number of characters to write (array length).
        lea     R9, nbwr                    ; Arg 4: pointer to variable to contain number of bytes written.
        call    WriteConsoleA               ; Function call to write text to console.

;       Program exit.
        xor     RCX, RCX                    ; Set exit status code to zero.
        call    ExitProcess                 ; Call the ExitProcess function to exit the program.
main    ENDP
        END

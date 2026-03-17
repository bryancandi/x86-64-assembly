;--------------------------------------------------------------------
; x86-64 Assembly "Hello, world!" program for Windows console.
; Assemble with MASM and link:
; ml64.exe hello.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

includelib kernel32.lib                     ; Windows kernel interface.
ExitProcess     proto                       ; Declare the ExitProcess function prototype.
GetStdHandle    proto                       ; Function to retrieve I/O handle.
WriteConsoleA   proto                       ; Writes a buffer of characters to the console.
Console         equ    -11                  ; Device code for console output.

        .data
txt     byte    "Hello, world!", 0DH, 0AH   ; Message, carriage return, line feed.
stdout  qword   ?                           ; Handle to standard output device.
nbwr    dword   ?                           ; Number of bytes actually written.

        .code
main    proc
        sub     RSP, 40                     ; Reserve "shadow space" on stack for 4 args (32 shadow + 8 alignment).

;       Obtain "handle" for console display.
        mov     RCX, Console                ; Console device code, to be passed to GetStdHandle.
        call    GetStdHandle                ; Receive the console output handle.
        mov     stdout, RAX                 ; Store the handle for console output.

;       Print to console.
        mov     RCX, stdout                 ; Arg 1: device handle.
        lea     RDX, txt                    ; Arg 2: pointer to byte array.
        mov     R8, lengthof txt            ; Arg 3: number of characters to write (array length).
        lea     R9, nbwr                    ; Arg 4: pointer to variable to contain number of bytes written.
        call    WriteConsoleA               ; Function call to write text to console.

;       Exit.
        xor     RCX, RCX                    ; Set exit status code to zero.
        call    ExitProcess                 ; Call the ExitProcess function to exit the program.
        add     RSP, 40                     ; Restore "shadow space" on stack (never reached; ExitProcess does not return).
main    endp
        end

includelib kernel32.lib         ; Windows kernel interface
GetStdHandle    proto           ; Function to retrieve I/O handle
WriteConsoleW   proto           ; Function that writes to command window
Console         equ     -11     ; Device code for console text output.
ExitProcess     proto

        .code
main    proc

        sub     RSP, 40         ; Reserve "shadow space" on stack.

;   Obtain "handle" for console display monitor I/O streams

        mov     RCX, Console    ; Console standard output handle
        call    GetStdHandle    ; Returns handle in register RAX
        mov     stdout, RAX     ; Save handle for text display.

;   Display the "Hello World" message.

        mov     RCX, stdout     ; Handle to standard output device 
        lea     RDX, hwm        ; Pointer to message (byte array).
        mov     R8, lengthof hwm; Number of characters to display
        lea     R9, nbwr        ; Number of bytes actually written.
        call    WriteConsoleW   ; Write text string to window.

        mov     RCX, 0          ; Set exit status code to zero.
        call    ExitProcess     ; Return control to Windows.
        add     RSP, 40         ; Restore "shadow space" on stack (never reached; ExitProcess does not return).

main    endp

        .data
hwm     word    "H", "e", 03BBh, 03BBh, "o", " ", "W", "o", "r", "l", "d", " ", 0D83Dh, 0DE00h
stdout  qword   ?               ; Handle to standard output device
nbwr    qword   ?               ; Number of bytes actually written

        end
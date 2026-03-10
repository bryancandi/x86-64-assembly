includelib kernel32.lib         ; Windows kernel interface.
GetStdHandle    proto           ; Function to retrieve I/O handles..
ReadConsoleA    proto           ; Function that reads from command window.
Keyboard        equ    -10      ; Device code for console text input.
MaxBuf          equ    20       ; Maximum input buffer size.
ExitProcess     proto
v_asc           proto           ; Function writes ASCII string.
v_asc1          proto           ; Function writes one ASCII character.
v_opn           proto           ; Function opens display stream.

;    Macro "msgOut msg" displays a character string in command window.
;        msg:    Label of ASCII message for command window.

msgOut  macro   msg             ; One argument: msg
        lea     RDX, msg        ; Pointer to message to display.
        mov     R8, lengthof msg ; Number of characters to display.
        call    v_asc           ; Write text string to command window.
        endm

        .code

;    Main program that reads text message from user through command
;    window keyin and displays it in same command window.
;        1. Multiple lines are input until only "Enter" key pushed.
;        2. Each character input will be echoed on a separate line.

main    proc

        sub     RSP, 40         ; Reserve "shadow space" on stack.

;    Obtain "handles" for console I/O streams.

        call    v_opn           ; Open text display stream.
        mov     RCX, Keyboard   ; Console standard input handle.
        call    GetStdHandle    ; Returns handle in register RAX.
        mov     stdin, RAX      ; Save handle for keyboard input.

;    Display the prompt message.

nxtlin: msgOut  pmsg            ; Write text string to command box.

;    Read input line from user keyboard.

        mov     RCX, stdin      ; Handle to standard input device.
        mov     R8, MaxBuf      ; Maximum length to receive.
        lea     RDX, keymsg     ; Memory address to receive input.
        lea     R9, nbrd        ; Number of bytes actually read.
        call    ReadConsoleA    ; Read text string from command box.

;    Echo line just input back to the user one character at a time.

        lea     R12, keymsg     ; Memory buffer containing input.
        mov     R13, nbrd       ; Number of characters actually read.
inloop: call    v_asc1
        msgOut  newln           ; Write CR/LF to command box.
        inc     R12             ; Set pointer to next character.
        dec     R13             ; Decrement number of bytes remaining.
        jg      inloop          ; Continue loop until message complete.

;    Go get another line, but exit if only "Enter" key was input.

        mov     R8, nbrd        ; Length (bytes) of input message.
        cmp     R8, 2           ; Test if only CR and LF characters.
        jg      nxtlin          ; Loop back around to get another input.

        mov     RCX, 0          ; Set exit status code to zero.
        call    ExitProcess     ; Return control to Windows.
        add     RSP, 40         ; Restore "shadow space" on stack (never reached; ExitProcess does not return).

main    endp

        .data
stdin   qword   ?               ; Handle to standard input device.
nbrd    qword   ?               ; Number of bytes actually read.
pmsg    byte    "Please enter text message: "
keymsg  byte    MaxBuf DUP (?)  ; Memory buffer for keyboard input.
newln   byte    0DH, 0AH        ; Carriage return and line feed.

        end

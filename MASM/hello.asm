;--------------------------------------------------------------------
; x86-64 Assembly "Hello" program for Windows console
; Assemble with MASM and link:
; ml64.exe hello.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib	                    ; Import a standard Windows library.

ExitProcess    PROTO                        ; Declare the ExitProcess function prototype.
GetStdHandle   PROTO
WriteConsoleA  PROTO

deviceCode EQU -11                          ; Code for console output.

.DATA                                       ; Start of the data section.
    txt     BYTE "Hello, World!", 10, 0     ; 10 is ASCII line feed, 0 is null terminator.
    handle  QWORD ?
    num     DWORD ?

.CODE						                ; Start of the code section.
main PROC					                ; Entry point of the program.
    XOR RAX, RAX                            ; Clear registers.
    XOR RCX, RCX
    XOR RDX, RDX
    XOR R8, R8
    XOR R9, R9

    SUB RSP, 40                             ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV RCX, deviceCode                     ; Console device code, to be passed to GetStdHandle.
    CALL GetStdHandle                       ; Receive the console output handle.
    MOV handle, RAX                         ; Store the device handle.

    MOV RCX, handle                         ; Pass device handle as argument 1.
    LEA RDX, txt                            ; Pass pointer to array as argument 2.
    MOV R8, LENGTHOF txt                    ; Pass array length as argument 3.
    LEA R9, num                             ; Pass pointer to variable as argument 4.
    CALL WriteConsoleA                      ; Write the string into the console.

    XOR RCX, RCX                            ; Exit code 0.
    CALL ExitProcess                        ; Call the ExitProcess function to exit the program.
main ENDP					                ; End of the main procedure.
END     					                ; End of the assembly program.

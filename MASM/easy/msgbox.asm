;--------------------------------------------------------------------
; MSGBOX: x86-64 Opening Dialogs.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.
MessageBoxA PROTO               ; Declare the MessageBoxA function prototype.

.DATA                           ; Start of the data section.
    msg BYTE "Are you ready to continue...", 0  ; Declare a null-terminated string for the message box text.
    ttl BYTE "Assembly x64 Programming", 0      ; Declare a null-terminated string for the message box title.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RAX, RAX                ; Clear registers.

    MOV RCX, 0                  ; Pass no owner window (NULL) as argument 1.
    LEA RDX, msg                ; Load the address of the message text into RDX as argument 2.
    LEA R8, ttl                 ; Load the address of the title text into R8 as argument 3.
    MOV R9, 35                  ; Pass combined types for the message box (MB_OK | MB_ICONQUESTION) as argument 4.
    CALL MessageBoxA            ; Call the MessageBoxA function to display the message box.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

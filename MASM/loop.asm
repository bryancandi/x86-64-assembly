;--------------------------------------------------------------------
; LOOP: x86-64 Looping Structure example.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    XOR RDX, RDX                ; Clear the RDX register.
    MOV RCX, 0                  ; Initialize loop counter to 0.
    loop_start:
    MOV RDX, RCX                ; Move loop counter to RDX.
    INC RCX                     ; Increment loop counter.
    CMP RCX, 10                 ; Compare loop counter with 10.
    JE loop_end                 ; If equal, exit loop.
    JMP loop_start              ; Repeat the loop.
    loop_end:

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

;--------------------------------------------------------------------
; LOOP_ALT2: x86-64 Looping Structure alternate example 2.
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

    ; The LOOP instruction expects the counter will always be the RCX register.
    ; Each time the loop iterates the RCX register is decremented automatically.
    XOR RDX, RDX                ; Clear the RDX register.
    MOV RCX, 10                 ; Initialize loop counter to 10.
    loop_start:
    INC RDX                     ; Increment RDX register.
    LOOP loop_start             ; Decrement RCX and loop if RCX != 0.

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

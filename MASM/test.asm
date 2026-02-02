;--------------------------------------------------------------------
; TEST: x86-64 TEST instruction example.
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

    XOR RCX, RCX                ; Clear the RCX register.
    MOV RCX, 0111b			    ; Move binary 0111 into RCX.
    TEST RCX, 0001b             ; Test if the least significant bit is set (ZR = 0, ODD).
    MOV RCX, 1000b              ; Move binary 1000 into RCX.
    TEST RCX, 0001b             ; Test if the least significant bit is set (ZR = 1, EVEN).
    MOV RCX, 0111b			    ; Move binary 0111 into RCX.
    TEST RCX, 0100b             ; Test if the third bit is set (ZR = 0, THIRD BIT SET).
    MOV RCX, 1000b              ; Move binary 1000 into RCX.
    TEST RCX, 0100b             ; Test if the third bit is set (ZR = 1, THIRD BIT NOT SET).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

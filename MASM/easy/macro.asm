;--------------------------------------------------------------------
; MACRO: x86-64 Injecting Text Items.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

clrRAX TEXTEQU <XOR RAX, RAX>   ; Single-line Macro to clear RAX register.

clrRCX MACRO                    ; Multi-line Macro to clear RCX register.
    XOR RCX, RCX
ENDM

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    clrRAX                      ; Use the clrRAX macro to clear RAX register.
    clrRCX                      ; Use the clrRCX macro to clear RCX register.

    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

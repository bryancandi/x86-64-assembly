;--------------------------------------------------------------------
; MASM: A barebones template for Assembly programming.
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib	    ; Import a standard Windows library.
ExitProcess PROTO           ; Declare the ExitProcess function prototype.

.DATA                       ; Start of the data section.
                            ; Variable declarations go here.

.CODE						; Start of the code section.
main PROC					; Entry point of the program.
                            ; Assembly instructions go here.
CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP					; End of the main procedure.

END     					; End of the assembly program.

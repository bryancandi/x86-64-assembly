;--------------------------------------------------------------------
; MRPT: x86-64 Repeating Loops.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

rpt MACRO reg, num              ; Define a macro named 'rpt' that takes a register and a number as parameters.
    REPEAT num                  ; Repeat the following block 'num' times.
        INC reg                 ; Increment the value in the specified register.
    ENDM
ENDM

itr MACRO reg, num              ; Define a macro named 'itr' that takes a register and a number as parameters.
    count = num                 ; Initialize a variable 'count' with the value of 'num'.
    WHILE count LE 100          ; While 'count' is less than or equal to 100, execute the following block.
        count = count + 27      ; Increment 'count' by 27 in each iteration.
        MOV reg, count          ; Move the current value of 'count' into the specified register.
        IF count MOD 2 EQ 0     ; Test count for evenness (if 'count' modulo 2 equals 0), execute the following block.
            EXITM               ; Exit the loop if 'count' is even.
        ENDIF
    ENDM
ENDM

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV RAX, 10
    MOV RCX, 10
    rpt RAX, 10
    itr RCX, 10

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

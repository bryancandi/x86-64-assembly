;--------------------------------------------------------------------
; ARR: x86-64 Addressing by Offset with arrays example.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    arrA BYTE 1, 2, 3           ; Declare an array of bytes with 3 elements.
    arrB WORD 10, 20, 30		; Declare an array of words with 3 elements.
    arrC DWORD 100, 200, 300	; Declare an array of double words with 3 elements.
    arrD QWORD 1000, 2000, 3000	; Declare an array of quad words with 3 elements.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV CL, arrA                ; Load the first element of arrA into CL register.
    MOV DX, arrB                ; Load the first element of arrB into DX register.
    MOV R8D, arrC               ; Load the first element of arrC into R8D register.
    MOV R9, arrD                ; Load the first element of arrD into R9 register.

    MOV CL, arrA + 1            ; Load the second element of arrA into CL register (+1 for 1 BYTE).
    MOV DX, arrB + 2            ; Load the second element of arrB into DX register (+2 because WORD = 2 BYTES).
    MOV R8D, arrC + 4           ; Load the second element of arrC into R8D register (+4 because DWORD = 4 BYTES).
    MOV R9, arrD + 8            ; Load the second element of arrD into R9 register (+8 because QWORD = 8 BYTES).

    MOV CL, arrA + (2 * 1)      ; Load the third element of arrA into CL register (+2 for 2 BYTE).
    MOV DX, arrB + (2 * 2)      ; Load the third element of arrB into DX register (+4 for 2 WORD).
    MOV R8D, arrC + (2 * 4)     ; Load the third element of arrC into R8D register (+8 for 2 DWORD).
    MOV R9, arrD + (2 * 8)      ; Load the third element of arrD into R9 register (+16 for 2 QWORD).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

;--------------------------------------------------------------------
; ARR2D: x86-64 Addressing by Order with arrays example.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
    rows BYTE 0, 1, 2, 3,   10, 11, 12, 13,   20, 21, 22 , 23
    cols BYTE 0, 10, 20,   1, 11, 21,   2, 12, 22,   3, 13, 23
    arrA DWORD 0, 1, 2, 3,   10, 11, 12, 13,   20, 21, 22 , 23
    arrB DWORD 0, 10, 20,   1, 11, 21,   2, 12, 22,   3, 13, 23

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV CL, rows                ; Load the first element of rows into CL register.
    MOV CH, cols				; Load the first element of cols into CH register.
    MOV R8D, arrA               ; Load the first element of arrA into R8D register.
    MOV R9D, arrB               ; Load the first element of arrB into R9D register.

    MOV CL, rows + 5            ; Load the second element of rows into CL register (+5 for 5 BYTE).
    MOV CH, cols + 4            ; Load the second element of cols into CH register (+4 for 4 BYTE).

    MOV R8D, arrA + (8 * 4)     ; Load the second element of arrA into R8D register (+32 for 8 DWORD).
    MOV R9D, arrB + (2 * 4)     ; Load the second element of arrB into R9D register (+8 for 2 DWORD).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

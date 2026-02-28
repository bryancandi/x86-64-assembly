;--------------------------------------------------------------------
; RECUR: x86-64 Calling Recursively (Fibonacci sequence).
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.

.DATA                           ; Start of the data section.
                                ; Variable declarations go here.

.CODE                           ; Start of the code section.
fib PROC
    MOV RCX, RDX                ; Move the input value from RDX to RCX for comparison.
    XADD RAX, RDX               ; Swap RAX and RDX, place the value of RAX + RDX in RAX, and store the original value of RAX in RDX.

    CMP RAX, 13                 ; Stop recursion when RAX reaches 13.
    JG finish
    CALL fib
    finish:
    RET
fib ENDP                        ; End of the fib procedure.

main PROC                       ; Entry point of the program.
    SUB RSP, 40                 ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

    MOV RAX, 1                  ; Initialize RAX to 1 (base case for Fibonacci).
    MOV RDX, 1                  ; Initialize RDX to 1 (base case for Fibonacci).
    CALL fib                    ; Call the fib procedure to compute Fibonacci(1).

    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

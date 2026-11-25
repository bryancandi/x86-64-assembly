;======================================================================
; Source : xchg rax,rax (xorpd)
; Index  : 0x1d
;
; MASM reference:
; ENTER: Creates a stack frame for a procedure that receives parameters
; passed on the stack. ENTER IMMED16, IMMED8
; When immed16 is 0, ENTER is equivalent to push rbp, followed by mov rbp, rsp.
; The first operand of the ENTER instruction specifies the number of bytes to
; reserve for local variables. The second operand specifies the nesting level
; for the procedure. The nesting level should be 0 for languages that do
; not allow access to local variables of higher-level procedures (such as C,
; Basic, and FORTRAN).
; See the complementary instruction LEAVE for a method of exiting from a procedure.
;
; Intel SDM note:
; If the nesting level is 0, the processor pushes the frame pointer from the BP/EBP/RBP register onto the stack,
; copies the current stack pointer from the SP/ESP/RSP register into the BP/EBP/RBP register, and loads the
; SP/ESP/RSP register with the current stack-pointer value minus the value in the size operand. For nesting levels of
; 1 or greater, the processor pushes additional frame pointers on the stack before adjusting the stack pointer. These
; additional frame pointers provide the called procedure with access points to other nested frames on the stack. See
; “Procedure Calls for Block-Structured Languages” in Chapter 6 of the Intel® 64 and IA-32 Architectures Software
; Developer’s Manual, Volume 1, for more information about the actions of the ENTER instruction.
;
;======================================================================

INCLUDELIB kernel32.lib

ExitProcess PROTO uExitCode:DWORD

n       EQU     1                       ; Index

        .DATA?
buff1   QWORD   64 DUP (0)
buff2   QWORD   64 DUP (0)

        .CODE
start   PROC
        sub     rsp, 40

                                        ; element_address = base_address + index * element_size
;       mov     rsp, buff2 + n*8 + 8    ; NASM versions from XORPD book, ported to MASM below with LEA
;       mov     rbp, buff1 + n*8

        lea     rsp, buff2 + n*8 + 8    ; RSP = address of element 'n' + 1 in the buff2 array
        lea     rbp, buff1 + n*8        ; RBP = address of element 'n' in the buff1 array
        enter   0, n+1                  ; Copies the first 'n' elements in buff1 into buff2 at the same indices

        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

; Pseudo code walkthrough
; enter 0, n+1 :
;
; Operands are 64-bit
; AllocSize = 0
; n = 1
;
; rbp points to buff1 element 1
; rsp points to buff2 element 2
;
; push rbp (rsp decrements by 8)
; FrameTemp := RSP
;
; NestingLevel = 2 (n + 1)
; For i := 1 (NestingLevel - 1)
; rbp := rbp - 8
; push [rbp] (qword value push)
;
; push FrameTemp (rsp decrements by 8)
;
; rbp := FrameTemp
; rsp := rsp - AllocSize (0)
;
; --------------------------------------
; Demonstration:
;
; buff2 = 0x2000
; buff1 = 0x1000
;
; After the two LEA instructions:
; rsp = 0x2010 (0x2000 + 8 + 8)
; rbp = 0x1008 (0x1000 + 8)
;
; push rbp:
; rsp = 0x2008 (0x2010 - 8)
;
; FrameTemp := 0x2008 (rsp)
; rbp := 0x1000 (rbp - 8)
;
; push [rbp] (value at rbp)
; rsp is decremented, and the value that was at rbp (0x1000)
; is then written to the address rsp points to (0x2000)
; effectively copying the value at buff1[0] into buff2[0]
; rsp = 0x2000 (rsp - 8)
;
; push 0x2008 (FrameTemp):
; rsp = 0x1FF8 (rsp - 8)
;
; rbp := 0x2008 (FrameTemp)
; rsp := 0x1FF8 (rsp - 0 (AllocSize))

;==========================================
; Win x64 - parsing command-line arguments
;==========================================

INCLUDELIB kernel32.lib
INCLUDELIB shell32.lib

ExitProcess         PROTO uExitCode:DWORD
GetStdHandle        PROTO nStdHandle:DWORD
WriteConsoleW       PROTO hConsoleOutput:QWORD, lpBuffer:PTR, nNumberOfCharsToWrite:DWORD, lpNumberOfCharsWritten:PTR, lpReserved:PTR
GetCommandLineW     PROTO
CommandLineToArgvW  PROTO lpCmdLine:QWORD, pNumArgs:QWORD

        .DATA
crlf    WORD    0Dh, 0Ah
stdout  QWORD   ?
nbrd    DWORD   ?
argc    QWORD   ?
argv    QWORD   ?

        .CODE
start   PROC
        sub     rsp, 40

        mov     rcx, -11                    ; STDOUT handle
        call    GetStdHandle
        mov     [stdout], rax

        call    GetCommandLineW             ; RAX = pointer to the command-line string

        mov     rcx, rax                    ; 1st arg: pointer to the command-line string
        mov     rdx, OFFSET argc            ; 2nd arg: pointer to where arg count will be written (argc)
        call    CommandLineToArgvW          ; RAX = pointer to an array of LPWSTR values, similar to argv

        mov     [argv], rax                 ; Store pointer to array in 'argv'

        mov     r12, [argc]                 ; R12 = arg counter
        cmp     r12, 1                      ; No args (1 = only program name)?
        je      exit                        ; Yes, exit

        cld                                 ; Clear direction flag to ensure forward direction
        dec     r12                         ; Decrement argc to skip past program name (argv[0])
        mov     r13, 8                      ; R13 = 8-byte offset into argv pointer array
print_argv:
        test    r12, r12                    ; Any args left to print?
        jz      exit                        ; No, exit
        mov     rdi, [argv]                 ; RDI = argv
        mov     rdi, [rdi+r13]              ; RDI = argv[1...]
        mov     rdx, rdi                    ; RDX = beginning of current arg string for WriteCosnoleW

        mov     ax, 0                       ; AX = WCHAR 0 (null terminator)
        mov     rcx, -1                     ; RCX decrements for each WCHAR scanned (-1 prevents early termination)
        repne   scasw                       ; Scan string for null terminator (AX); repeate while not equal

        ; After REPNE SCASW scans the string:
        ;   1. RCX starts at -1 and is decremented once per scan loop:
        ;      (final RCX = -1 - number of WCHARS scanned)
        ;   2. NOT RCX performs a bitwise inversion (one’s complement):
        ;      (~RCX = number of WCHARS scanned), effectively canceling the initial -1 setup
        ;   3. The result includes the terminating match, so subtract 1 for exact character count
        not     rcx                         ; Flip all bits
        dec     rcx                         ; Decrement one to remove 0 (null terminator)
        mov     r10, rcx                    ; R10 = WCHAR count

        mov     rcx, [stdout]
        ; RDX already contains the correct string
        mov     r8, r10
        mov     r9, OFFSET nbrd
        mov     QWORD PTR [rsp+32], 0
        call    WriteConsoleW

        mov     rcx, [stdout]
        mov     rdx, OFFSET crlf
        mov     r8, LENGTHOF crlf
        mov     r9, OFFSET nbrd
        mov     QWORD PTR [rsp+32], 0
        call    WriteConsoleW

        add     r13, 8                      ; Advance to next argv[i] (each entry is 8-byte pointer)
        dec     r12                         ; Decrement argc counter
        jmp     print_argv

exit:
        xor     ecx, ecx
        call    ExitProcess
start   ENDP
        END

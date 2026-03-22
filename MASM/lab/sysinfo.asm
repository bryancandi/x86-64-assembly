;-------------------------------------------------------------------------
; x64 System Information program for Windows console.
;
; Assemble with MASM and link:
; ml64.exe echo.asm /link /SUBSYSTEM:console /ENTRY:main
;-------------------------------------------------------------------------

includelib kernel32.lib                     ; Import Kernel32 library (Windows API).

ExitProcess     proto                       ; Terminate the current process.
GetStdHandle    proto                       ; Retrieve a handle to a standard device (input/output).
WriteConsoleA   proto                       ; Write a buffer of characters to the console.

STD_OUTPUT_HANDLE equ    -11                ; Device code for console output.
MaxBuf            equ    100                ; Maximum input buffer size.

strOut  macro   msg                         ; Single argment macro to call write a string to console (WhiteConsoleW).
        mov     RCX, stdout                 ; Arg 1: output device handle.
        lea     RDX, msg                    ; Arg 2: pointer to byte array.
        mov     R8, lengthof msg            ; Arg 3: number of bytes to write.
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleA               ; Function call to write to console.
        endm

bufOut  macro   buf                         ; Single argment macro to call write contents of a buffer to console (WhiteConsoleW).
        mov     RCX, stdout                 ; Arg 1: output device handle.
        lea     RDX, buf                    ; Arg 2: pointer to byte array.
        mov     R8d, [nbrd]                 ; Arg 3: number of bytes to write.
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleA               ; Function call to write to console.
        endm

        .data
tmsg    byte    "System Information Utility", 0DH, 0AH ; User prompt message.
cpuven  byte    "CPU Vendor : "
cpunam  byte    "CPU Model  : "
newln   byte    0DH, 0AH                    ; Carriage return and line feed.
tab     byte    09H                         ; Tab character.
cpubuf  dword   MaxBuf DUP (?)              ; Input buffer of MaxBuf size.
stdin   qword   ?                           ; Handle to standard input device.
stdout  qword   ?                           ; Handle to standard output device.
nbwr    dword   ?                           ; Number of bytes (characters) actually written.
nbrd    dword   ?                           ; Number of bytes (characters) actually read.

        .code
GetCpuVend  proc
        push    RBX                         ; Preserve RBX register.

        mov     EAX, 0                      ; CPUID leaf 0 = vendor.
        cpuid                               ; CPUID instruction.
        mov     [cpubuf], EBX
        mov     [cpubuf + 4], EDX
        mov     [cpubuf + 8], ECX

        mov     byte ptr [cpubuf + 12], 0   ; Null terminate string (not needed for WriteConsoleA; remove?).
        mov     nbrd, 12                    ; Set number of bytes to write for WriteConsoleA.

        pop     RBX                         ; Restore RBX.
        ret
GetCpuVend  endp

GetCpuBrand  proc
        push    RBX

        mov     EAX, 80000002h              ; 80000002h - 80000004h = processor brand string.
        cpuid
        mov     [cpubuf], EAX
        mov     [cpubuf + 4], EBX
        mov     [cpubuf + 8], ECX
        mov     [cpubuf + 12], EDX

        mov     EAX, 80000003h
        cpuid
        mov     [cpubuf + 16], EAX
        mov     [cpubuf + 20], EBX
        mov     [cpubuf + 24], ECX
        mov     [cpubuf + 28], EDX

        mov     EAX, 80000004h
        cpuid
        mov     [cpubuf + 32], EAX
        mov     [cpubuf + 36], EBX
        mov     [cpubuf + 40], ECX
        mov     [cpubuf + 44], EDX

        mov     byte ptr [cpubuf + 48], 0
        mov     nbrd, 48

        pop     RBX
        ret
GetCpuBrand  endp

main    proc
        sub     RSP, 40                     ; Reserve "shadow space" on stack for 4 args (32 shadow + 8 alignment).

;       Obtain handle for standard output (console).
        mov     RCX, STD_OUTPUT_HANDLE      ; Standard output device code for GetStdHandle.
        call    GetStdHandle                ; Return handle to standard output.
        mov     stdout, RAX                 ; Store the handle for console output.

;       Print title message.
        strOut  tmsg
        strOut  newln

;       Print CPU data strings.
        call    GetCpuVend                  ; Call function to write CPU vendor to buffer.
        strOut  cpuven
        bufOut  cpubuf
        strOut  newln

        call    GetCpuBrand
        strOut  cpunam
        bufOut  cpubuf
        strOut  newln

;       Program exit.
exit:   xor     RCX, RCX                    ; Set exit status code to zero.
        call    ExitProcess                 ; Call the ExitProcess function to exit the program.
main    endp
        end

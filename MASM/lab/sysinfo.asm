;-------------------------------------------------------------------------
; x64 System Information program for Windows console.
;
; Assemble with MASM and link:
; ml64.exe echo.asm /link /SUBSYSTEM:console /ENTRY:main
;-------------------------------------------------------------------------

includelib kernel32.lib                     ; Import Kernel32 library (Windows API).

ExitProcess             proto               ; Terminate the current process.
GetStdHandle            proto               ; Retrieve a handle to a standard device (input/output).
WriteConsoleA           proto               ; Write a buffer of characters to the console.
GlobalMemoryStatusEx    proto               ; Retrieve information about the system's memory usage.
GetTickCount64          proto               ; Returns 64-bit tick count in RAX.

STD_OUTPUT_HANDLE equ    -11                ; Device code for console output.
MaxBuf            equ    100                ; Maximum buffer size.
BytesInGB         equ    1024 * 1024 * 1024 ; 1 GB in bytes.

strOut  macro   msg                         ; Single argment macro to write a string to the console.
        mov     RCX, stdout                 ; Arg 1: output device handle.
        lea     RDX, msg                    ; Arg 2: pointer to byte array.
        mov     R8, lengthof msg            ; Arg 3: number of bytes to write.
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleA
        endm

bufOut  macro   buf                         ; Single argment macro to write 'nbrd' bytes of a buffer to the console.
        mov     RCX, stdout                 ; Arg 1: output device handle.
        lea     RDX, buf                    ; Arg 2: pointer to byte array.
        mov     R8d, [nbrd]                 ; Arg 3: number of bytes to write.
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleA
        endm

byte2g  macro                               ; Convert bytes in RAX to GB, rounding up (clobbers: RAX, RDX, R8).
        xor     RDX, RDX
        mov     R8, BytesInGB               ; R8 = 1 GB in bytes.
        add     RAX, R8                     ; Add 1 GB to value to achieve rounding up.
        dec     RAX                         ; Subtract 1 so integer division gives ceiling.
        div     R8                          ; RAX = bytes / GB.
        endm

fmttime macro                               ; Convert from milliseconds to seconds (clobbers: RAX, RDX, R8).
        xor     RDX, RDX
        mov     R8, 1000                    ; 1 sec = 1000 ms.
        div     R8                          ; RAX = RAX/1000.
        endm

copyStr macro   dest                        ; Copy string from [RAX] (length in R8D) into destination buffer (clobbers: RSI, RDI, RCX).
        mov     nbrd, R8D                   ; Store length of string in 'nbrd'.
        mov     RSI, RAX                    ; Source pointer.
        lea     RDI, dest                   ; Destination buffer.
        mov     ECX, R8D                    ; Number of bytes to copy.
        rep     movsb                       ; Copy ECX bytes from [RSI] to [RDI].
endm

MEMORYSTATUSEX STRUCT
    dwLength                    dword   ?
    dwMemoryLoad                dword   ?
    ullTotalPhys                qword   ?
    ullAvailPhys                qword   ?
    ullTotalPageFile            qword   ?
    ullAvailPageFile            qword   ?
    ullTotalVirtual             qword   ?
    ullAvailVirtual             qword   ?
    ullAvailExtendedVirtual     qword   ?
MEMORYSTATUSEX ENDS

        .data
msEx    MEMORYSTATUSEX <>                   ; Allocate and zero-initialize an instance
tmsg    byte    "--- Processor Information ---", 0DH, 0AH
cpuven  byte    "CPU Vendor : "
cpunam  byte    "CPU Model  : "
cpucor  byte    "CPU Cores  : "
mmsg    byte    "--- Memory Information ---", 0DH, 0AH
memtot  byte    "RAM Total : "
memfre  byte    "RAM Free  : "
gbyte   byte    " GB"
umsg    byte    "--- System Uptime ---", 0DH, 0AH
secs    byte    " seconds"
errmsg  byte    "Error", 0DH, 0AH
newln   byte    0DH, 0AH                    ; Carriage return and line feed.
tab     byte    09H                         ; Tab character.
cpubuf  dword   MaxBuf DUP (?)              ; CPU strings buffer.
membuf  dword   MaxBuf DUP (?)              ; Memory data buffer.
tickbuf dword   MaxBuf DUP (?)              ; Formatted uptime buffer.
stdin   qword   ?                           ; Handle to standard input device.
stdout  qword   ?                           ; Handle to standard output device.
nbwr    dword   ?                           ; Number of bytes (characters) actually written.
nbrd    dword   ?                           ; Number of bytes (characters) actually read.

        .code
; Convert integer value to a string.
Int2Str  proc
        push    RBX                         ; Preserve RBX register.

        mov     RBX, 10                     ; Divisor (10).
        xor     R8D, R8D                    ; Initial string length = 0

convert_loop:
        xor     RDX, RDX                    ; Clear RDX for division.
        div     RBX                         ; RAX = quotient, RDX = remainder.
        add     DL, '0'                     ; Remainder to ASCII digit.
        dec     RDI
        mov     [RDI], DL                   ; Store digit.
        inc     R8D                         ; Length + 1
        test    RAX, RAX
        jnz     convert_loop

        mov     RAX, RDI                    ; Return pointer to first digit.

        pop     RBX                         ; Restore RBX.
        ret
Int2Str  endp

GetCpuVend  proc
        push    RBX

        mov     EAX, 0                      ; CPUID leaf 0 = vendor.
        cpuid                               ; CPUID instruction.
        mov     [cpubuf], EBX
        mov     [cpubuf + 4], EDX
        mov     [cpubuf + 8], ECX

        mov     byte ptr [cpubuf + 12], 0   ; Null terminate string (not needed for WriteConsoleA; remove?).
        mov     nbrd, 12                    ; Set number of bytes to write for WriteConsoleA.

        pop     RBX
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

; Return CPU core count as integer in EAX.
GetCpuCores  proc
        push    RBX

        mov     EAX, 0                      ; Load vendor string.
        cpuid
        cmp     EBX, 'Auth'                 ; Check for the first part of "AuthenticAMD" in vendor string.
        je      amd_proc

;       Intel processor
        mov     EAX, 4
        xor     ECX, ECX                    ; Sub-leaf: 0
        cpuid
        shr     EAX, 26                     ; Shift bits 31:26 to bottom
        inc     EAX                         ; Core count in EAX.
        jmp     done

;       AMD Processor
amd_proc:
        mov     EAX, 80000008h
        cpuid
        and     ECX, 0FFh                   ; Mask bits 7:0
        inc     ECX                         ; Core count in ECX.
        mov     EAX, ECX                    ; Normalize: core count in EAX.

done:
        pop     RBX
        ret
GetCpuCores  endp

main    proc
        sub     RSP, 40                     ; Reserve "shadow space" on stack for 4 args (32 shadow + 8 alignment).

;       Obtain handle for standard output (console).
        mov     RCX, STD_OUTPUT_HANDLE      ; Standard output device code for GetStdHandle.
        call    GetStdHandle                ; Return handle to standard output.
        mov     stdout, RAX                 ; Store the handle for console output.

;       Print title message.
        strOut  tmsg

;       Print CPU data strings.
        call    GetCpuVend
        strOut  cpuven
        bufOut  cpubuf
        strOut  newln

        call    GetCpuBrand
        strOut  cpunam
        bufOut  cpubuf
        strOut  newln

        call    GetCpuCores
        lea     RDI, cpubuf + MaxBuf
        call    Int2Str
        copyStr cpubuf                      ; Copy result in RAX to cpubuf.
        ; Print
        strOut  cpucor
        bufOut  cpubuf
        strOut  newln

;       Print memory data.
        mov     msEx.dwLength, SIZEOF MEMORYSTATUSEX
        lea     RCX, msEx
        call    GlobalMemoryStatusEx        ; Fills MEMORYSTATUSEX struct (after dwLength is set and RCX = pointer).
        test    RAX, RAX                    ; 0 = failure; 1 = success
        jz      mem_fail

;       RAM total
        mov     RAX, msEx.ullTotalPhys      ; Load qword from struct.
        byte2g                              ; Call macro to convert from bytes to GB.
        lea     RDI,    membuf + MaxBuf
        call    Int2Str
        copyStr membuf                      ; Copy result in RAX to membuf.
        ; Print
        strOut  newln
        strOut  mmsg
        strOut  memtot
        bufOut  membuf
        strOut  gbyte

;       RAM available
        mov     RAX, msEx.ullAvailPhys      ; Load qword from struct.
        byte2g
        lea     RDI,    membuf + MaxBuf
        call    Int2Str
        copyStr membuf                      ; Copy result in RAX to membuf.
        ; Print
        strOut  newln
        strOut  memfre
        bufOut  membuf
        strOut  gbyte
        strOut  newln

;       Print system uptime.
        call    GetTickCount64
        fmttime                             ; Call macro to format milliseconds into formatted time.
        call    Int2Str
        copyStr tickbuf                     ; Copy result in RAX to tickbuf.
        ; Print
        strOut  newln
        strOut  umsg
        bufOut  tickbuf
        strOut  secs
        strOut  newln

;       Program exit.
exit:
        xor     RCX, RCX
        call    ExitProcess

;       GlobalMemoryStatusEx failure.
mem_fail:
        strOut  errmsg
        jmp     exit

;       Program end.
main    endp
        end

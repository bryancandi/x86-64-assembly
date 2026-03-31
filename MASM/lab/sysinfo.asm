;-------------------------------------------------------------------------
; x64 System Information utility for Windows console.
; Author: Bryan C.
; Date: 2026
;
; Assemble with MASM and link:
; ml64.exe sysinfo.asm /link /SUBSYSTEM:console /ENTRY:main
;-------------------------------------------------------------------------

includelib kernel32.lib                     ; Win32 API functions.
includelib ntdll.lib                        ; NT native system calls.

ExitProcess             proto               ; Terminate the current process.
GetStdHandle            proto               ; Retrieve a handle to a standard device (input/output).
WriteConsoleA           proto               ; Write a buffer of characters to the console.
GlobalMemoryStatusEx    proto               ; Retrieve information about the system's memory usage.
GetTickCount64          proto               ; Returns 64-bit tick count in RAX.
RtlGetVersion           proto               ; Returns version information about the currently running operating system.

STD_OUTPUT_HANDLE equ   -11                 ; Device code for console output.
MaxBuf            equ   100                 ; Maximum buffer size.
BytesPerGib       equ   1024 * 1024 * 1024  ; Bytes per Gibibyte.
MsPerSecond       equ   1000                ; Milliseconds per second.
SecPerDay         equ   86400               ; Seconds per day.
SecPerHour        equ   3600                ; Seconds per hour.
SecPerMinute      equ   60                  ; Seconds per minute.

; Write a string to the console. addr may be RAX or a label; len is copied into R8D.
strOut  macro   addr, len
        mov     RCX, stdout                 ; Arg 1: output device handle.
IFIDNI  <addr>, <RAX>                       ; If addr is RAX, use it directly; otherwise LEA of the label.
        mov     RDX, RAX                    ; Arg 2: pointer to byte array in register.
ELSE
        lea     RDX, addr                   ; Arg 2: pointer to byte array label.
ENDIF
        mov     R8D, len                    ; Arg 3: number of bytes to write.
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleA
        endm

; Print the Windows 11 version string for the given build number.
verOut  macro  reg
    LOCAL Win11_26H1, Win11_25H2, Win11_24H2
    LOCAL Win11_23H2, Win11_22H2, Win11_21H2
    LOCAL done

        cmp     reg, 28000
        jae     Win11_26H1
        cmp     reg, 26200
        jae     Win11_25H2
        cmp     reg, 26100
        jae     Win11_24H2
        cmp     reg, 22631
        jae     Win11_23H2
        cmp     reg, 22621
        jae     Win11_22H2
        cmp     reg, 22000
        jae     Win11_21H2

Win11_26H1: strOut W11_26H1, lengthof W11_26H1
        jmp     done
Win11_25H2: strOut W11_25H2, lengthof W11_25H2
        jmp     done
Win11_24H2: strOut W11_24H2, lengthof W11_24H2
        jmp     done
Win11_23H2: strOut W11_23H2, lengthof W11_23H2
        jmp     done
Win11_22H2: strOut W11_22H2, lengthof W11_22H2
        jmp     done
Win11_21H2: strOut W11_21H2, lengthof W11_21H2
        jmp     done
done:
        endm

; Structure used by GlobalMemoryStatusEx; contains both physical and virtual memory state.
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

; Structure used by RtlGetVersion; contains operating system version information.
RTL_OSVERSIONINFOW STRUCT
    dwOSVersionInfoSize         dword   ?
    dwMajorVersion              dword   ?
    dwMinorVersion              dword   ?
    dwBuildNumber               dword   ?
    dwPlatformId                dword   ?
    szCSDVersion                word    128 DUP(?)
RTL_OSVERSIONINFOW ENDS

        .data
msEx            MEMORYSTATUSEX <>           ; Allocate and zero-initialize an instance of struct MEMORYSTATUSEX.
osVer           RTL_OSVERSIONINFOW <>       ; Same for RTL_OSVERSIONINFOW.
osbuf           dword   MaxBuf DUP (?)      ; OS version string buffer.
cpubuf          dword   MaxBuf DUP (?)      ; CPU strings buffer.
membuf          dword   MaxBuf DUP (?)      ; Memory data buffer.
timebuf         dword   MaxBuf DUP (?)      ; Uptime buffer.
newln           byte    0DH, 0AH            ; Carriage return and line feed.
tab             byte    09H                 ; Tab character.
os_title        byte    "--- Operating System ---", 0DH, 0AH
os_version      byte    "Version : "
os_build        byte    "Build   : "
os_error        byte    "Error: Unable to retrieve OS version information.", 0DH, 0AH
W11_26H1        byte    "Windows 11 26H1 "
W11_25H2        byte    "Windows 11 25H2 "
W11_24H2        byte    "Windows 11 24H2 "
W11_23H2        byte    "Windows 11 23H2 "
W11_22H2        byte    "Windows 11 22H2 "
W11_21H2        byte    "Windows 11 21H2 "
cpu_title       byte    "--- Processor ---", 0DH, 0AH
cpu_vendor      byte    "Vendor : "
cpu_name        byte    "Model  : "
cpu_cores       byte    "Cores  : "
mem_title       byte    "--- Memory ---", 0DH, 0AH
mem_total       byte    "RAM Total : "
mem_free        byte    "RAM Free  : "
mem_error       byte    "Error: Unable to retrieve memory information.", 0DH, 0AH
gibi_whole      qword   ?                   ; Store whole portion of RAM size.
gibi_fract      qword   ?                   ; Store fractional portion of RAM size.
gib_label       byte    " GiB"
decimal_pt      byte    "."
uptime_title    byte    "--- System Uptime ---", 0DH, 0AH
days            qword   ?                   ; Uptime days value.
days_label      byte    " days, "
hours           qword   ?                   ; Uptime hours value.
hours_label     byte    " hours, "
minutes         qword   ?                   ; Uptime minutes value.
minutes_label   byte    " minutes, "
seconds         qword   ?                   ; Uptime seconds value.
seconds_label   byte    " seconds"
stdin           qword   ?                   ; Handle to standard input device.
stdout          qword   ?                   ; Handle to standard output device.
nbwr            dword   ?                   ; Number of bytes (characters) actually written.
nbrd            dword   ?                   ; Number of bytes (characters) actually read.

        .code
; Convert integer in RAX to ASCII string in buffer pointed to by RDI; digits are stored in reverse order.
Int2Str  proc
        push    RBX                         ; Preserve RBX register.

        mov     RBX, 10                     ; Divisor (10)
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

; Convert bytes in RAX to GiB; store whole and fractional parts in gibi_whole and gibi_fract.
Byte2GiB  proc
        ; RAX = bytes
        xor     RDX, RDX
        mov     R8, BytesPerGib             ; R8 = 1 GiB in bytes.
        div     R8                          ; RAX = RAX/R8, RDX = remainder.

        ; RAX = whole portion of result, RDX = fractional portion of result.
        mov     [gibi_whole], RAX           ; Store whole portion.

        ; Scale remainder to 2 decimal digits: (remainder * 100) / GiB
        mov     RAX, RDX                    ; Move remainder into RAX.
        mov     R8, 100
        mul     R8                          ; Multiply by 100 to convert fractional GiB into a 2-digit integer (shift decimal right).
        mov     R8, BytesPerGib
        div     R8                          ; (remainder * 100) / GiB
        mov     [gibi_fract], RAX           ; Store fractional portion.

        ret
Byte2GiB  endp

; Convert milliseconds in RAX to a human-readable format.
FormatTime  proc
        ; RAX = uptime milliseconds
        xor     RDX, RDX                    ; Clear RDX for division.
        mov     R8, MsPerSecond             ; Divisor in R8 = milliseconds per second.
        div     R8                          ; RAX = seconds.

        ; Seconds can now be divided out into Days, Hours, Minutes.
        ; Days:
        xor     RDX, RDX
        mov     R8, SecPerDay
        div     R8                          ; RAX = days, RDX = remaining seconds.
        mov     [days], RAX                 ; Store result.
        mov     RAX, RDX                    ; Carry remainder forward.

        ; Hours:
        xor     RDX, RDX
        mov     R8, SecPerHour
        div     R8
        mov     [hours], RAX
        mov     RAX, RDX

        ; Minutes
        xor     RDX, RDX
        mov     R8, SecPerMinute
        div     R8
        mov     [minutes], RAX
        mov     RAX, RDX

        ; Seconds:
        mov     [seconds], RAX

        ret
FormatTime  endp

; Get CPU vendor string and store it in a buffer.
GetCpuVend  proc
        push    RBX

        mov     EAX, 0                      ; CPUID leaf 0 = vendor.
        cpuid                               ; CPUID instruction.
        mov     [cpubuf], EBX
        mov     [cpubuf + 4], EDX
        mov     [cpubuf + 8], ECX

        ;mov     byte ptr [cpubuf + 12], 0   ; Null terminate string (not required by WriteConsoleA; remove?).

        lea     RAX, cpubuf                 ; RAX: point to buffer address.
        mov     R8D, 12                     ; Return length in R8D.

        pop     RBX
        ret
GetCpuVend  endp

; Get CPU brand string and store it in a buffer.
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

        ;mov     byte ptr [cpubuf + 48], 0

        lea     RAX, cpubuf                 ; RAX: point to buffer address.
        mov     R8D, 48                     ; Return length in R8D.

        pop     RBX
        ret
GetCpuBrand  endp

; Return CPU core count as an integer in EAX.
GetCpuCores  proc
        push    RBX

        mov     EAX, 0                      ; Load vendor string.
        cpuid
        cmp     EBX, 'Auth'                 ; Check for the first part of "AuthenticAMD" in vendor string.
        je      amd_proc

        ; Intel processor
        mov     EAX, 4
        xor     ECX, ECX                    ; Sub-leaf: 0
        cpuid
        shr     EAX, 26                     ; Shift bits 31:26 to bottom
        inc     EAX                         ; Core count in EAX.
        jmp     done

        ; AMD Processor
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

        ; Obtain handle for standard output.
        mov     RCX, STD_OUTPUT_HANDLE      ; Standard output device code for GetStdHandle.
        call    GetStdHandle                ; Return handle to standard output.
        mov     stdout, RAX                 ; Store the handle for console output.

;       Operating system section:
        strOut  newln, lengthof newln
        strOut  os_title, lengthof os_title

        mov     osVer.dwOSVersionInfoSize, SIZEOF RTL_OSVERSIONINFOW
        lea     RCX, osVer
        call    RtlGetVersion
        test    EAX, EAX                    ; 0 = success; nz = failure
        jz      rtl_success
        strOut  os_error, lengthof os_error
        jmp     rtl_fail

rtl_success:
        ; Version string:
        strOut  os_version, lengthof os_version
        mov     EAX, osVer.dwBuildNumber
        verOut  EAX
        strOut  newln, lengthof newln

        ; Build number:
        strOut  os_build, lengthof os_build
        mov     EAX, osVer.dwBuildNumber
        lea     RDI, osbuf + MaxBuf         ; Destination buffer + end position.
        call    Int2Str
        strOut  RAX, R8D
        strOut  newln, lengthof newln

;       Processor section:
        strOut  newln, lengthof newln
        strOut  cpu_title, lengthof cpu_title

        strOut  cpu_vendor, lengthof cpu_vendor
        call    GetCpuVend
        strOut  RAX, R8D
        strOut  newln, lengthof newln

        strOut  cpu_name, lengthof cpu_name
        call    GetCpuBrand
        strOut  RAX, R8D
        strOut  newln, lengthof newln

        strOut  cpu_cores, lengthof cpu_cores
        call    GetCpuCores
        lea     RDI, cpubuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  newln, lengthof newln
rtl_fail:

;       Memory section:
        strOut  newln, lengthof newln
        strOut  mem_title, lengthof mem_title

        mov     msEx.dwLength, SIZEOF MEMORYSTATUSEX
        lea     RCX, msEx
        call    GlobalMemoryStatusEx        ; Fills MEMORYSTATUSEX struct (after dwLength is set and RCX = pointer).
        test    RAX, RAX                    ; 1 = success; 0 = failure
        jnz     mem_success
        strOut  mem_error, lengthof mem_error
        jmp     mem_fail

mem_success:
        ; RAM total
        strOut  mem_total, lengthof mem_total
        mov     RAX, msEx.ullTotalPhys      ; Load qword from struct.
        call    Byte2GiB                    ; Convert bytes to GiB.

        ; Whole portion:
        mov     RAX, [gibi_whole]           ; Move first part of size into RAX to convert to string.
        lea     RDI, membuf + MaxBuf        ; Destination buffer + end position.
        call    Int2Str
        strOut  RAX, R8D                    ; Print whole portion of RAM size.
        strOut  decimal_pt, lengthof decimal_pt

        ; Fractional portion:
        mov     RAX, [gibi_fract]           ; Move second part of size into RAX to convert to string.
        lea     RDI, membuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  gib_label, lengthof gib_label
        strOut  newln, lengthof newln

        ; RAM available
        strOut  mem_free, lengthof mem_free
        mov     RAX, msEx.ullAvailPhys      ; Load qword from struct.
        call    Byte2GiB

        ; Whole portion:
        mov     RAX, [gibi_whole]           ; Move first part of size into RAX to convert to string.
        lea     RDI, membuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D                    ; Print whole portion of RAM size.
        strOut  decimal_pt, lengthof decimal_pt

        ; Fractional portion:
        mov     RAX, [gibi_fract]           ; Move second part of size into RAX to convert to string.
        lea     RDI, membuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  gib_label, lengthof gib_label
        strOut  newln, lengthof newln
mem_fail:

;       Uptime section:
        strOut  newln, lengthof newln
        strOut  uptime_title, lengthof uptime_title

        call    GetTickCount64              ; RAX = uptime in milliseconds.
        call    FormatTime                  ; Convert milliseconds and store in 'days', 'hours', 'minutes', 'seconds'.

        mov     RAX, [days]
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  days_label, lengthof days_label

        mov     RAX, [hours]
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  hours_label, lengthof hours_label

        mov     RAX, [minutes]
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  minutes_label, lengthof minutes_label

        mov     RAX, [seconds]
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  seconds_label, lengthof seconds_label
        strOut  newln, lengthof newln
        strOut  newln, lengthof newln

exit:
        xor     RCX, RCX
        call    ExitProcess
main    endp
        end

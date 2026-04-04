;====================================================================
; x64 System Information utility for Windows console.
; Author: Bryan C.
; Date  : 2026
;
; Assemble with MASM and link:
; ml64.exe sysinfo.asm /link /SUBSYSTEM:console /ENTRY:main
;====================================================================

INCLUDELIB kernel32.lib                     ; Win32 API functions.
INCLUDELIB ntdll.lib                        ; NT native system calls.

ExitProcess             PROTO               ; Terminate the current process.
GetStdHandle            PROTO               ; Retrieve a handle to a standard device (input/output).
WriteConsoleA           PROTO
GlobalMemoryStatusEx    PROTO :PTR MEMORYSTATUSEX
GetTickCount64          PROTO
RtlGetVersion           PROTO :PTR RTL_OSVERSIONINFOEXW
GetProductInfo          PROTO :DWORD, :DWORD, :DWORD, :DWORD, :PTR DWORD

STD_OUTPUT_HANDLE EQU   -11                 ; Device code for console output.
MaxBuf            EQU   100
BytesPerGib       EQU   1024 * 1024 * 1024
MsPerSecond       EQU   1000
SecPerDay         EQU   86400
SecPerHour        EQU   3600
SecPerMinute      EQU   60

; Write a string to the console. addr may be RAX or a label; len is copied into R8D.
StrOut  MACRO   addr, len
        mov     RCX, stdout                 ; Arg 1: output device handle.
IFIDNI  <addr>, <RAX>                       ; If addr is RAX, use it directly; otherwise LEA of the label.
        mov     RDX, RAX                    ; Arg 2: pointer to byte array in RAX register.
ELSE
        lea     RDX, addr                   ; Arg 2: pointer to byte array label.
ENDIF
        mov     R8D, len                    ; Arg 3: number of bytes to write.
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleA
        ENDM

; Print the Windows 11 version string for the given build number.
VerOut  MACRO   reg
    LOCAL Win11_26H1, Win11_25H2, Win11_24H2, Win11_23H2, Win11_22H2, Win11_21H2, done

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

Win11_26H1: StrOut W11_26H1, LENGTHOF W11_26H1
        jmp     done
Win11_25H2: StrOut W11_25H2, LENGTHOF W11_25H2
        jmp     done
Win11_24H2: StrOut W11_24H2, LENGTHOF W11_24H2
        jmp     done
Win11_23H2: StrOut W11_23H2, LENGTHOF W11_23H2
        jmp     done
Win11_22H2: StrOut W11_22H2, LENGTHOF W11_22H2
        jmp     done
Win11_21H2: StrOut W11_21H2, LENGTHOF W11_21H2
        jmp     done
done:
        ENDM

; Compare the value returned by GetProductInfo; store current Windows edition in edbuf.
GetEdi  MACRO   reg
    LOCAL home, home_sl, home_n, pro, pro_n, pro_edu, pro_ws, edu, ent, ent_n, done

        cmp     reg, 00000065h
        je      home
        cmp     reg, 00000064h
        je      home_sl
        cmp     reg, 00000062h
        je      home_n
        cmp     reg, 00000030h
        je      pro
        cmp     reg, 00000031h
        je      pro_n
        cmp     reg, 000000A4h
        je      pro_edu
        cmp     reg, 000000A1h
        je      pro_ws
        cmp     reg, 00000079h
        je      edu
        cmp     reg, 00000004h
        je      ent
        cmp     reg, 0000001Bh
        je      ent_n

; Write edition label into edbuf via little-endian DWORD literals:
home:   mov     [edbuf], 'emoH'
        jmp     done
home_sl:mov     [edbuf], 'emoH'
        mov     [edbuf + 4], 'LS '
        jmp     done
home_n: mov     [edbuf], 'emoH'
        mov     [edbuf + 4], 'N '
        jmp     done
pro:    mov     [edbuf], 'orP'
        jmp     done
pro_n:  mov     [edbuf], 'orP'
        mov     [edbuf + 4], 'N '
        jmp     done
pro_edu:mov     [edbuf], 'orP'
        mov     [edbuf + 4], 'udE '
        jmp     done
pro_ws: mov     [edbuf], 'orP'
        mov     [edbuf + 4], 'SW '
        jmp     done
edu:    mov     [edbuf], 'edE'
        jmp     done
ent:    mov     [edbuf], 'tnE'
        jmp     done
ent_n:  mov     [edbuf], 'tnE'
        mov     [edbuf + 4], 'N '
        jmp     done
done:
        ENDM

; Structure used by GlobalMemoryStatusEx; contains both physical and virtual memory state.
MEMORYSTATUSEX STRUCT
    dwLength                    DWORD   ?
    dwMemoryLoad                DWORD   ?
    ullTotalPhys                QWORD   ?
    ullAvailPhys                QWORD   ?
    ullTotalPageFile            QWORD   ?
    ullAvailPageFile            QWORD   ?
    ullTotalVirtual             QWORD   ?
    ullAvailVirtual             QWORD   ?
    ullAvailExtendedVirtual     QWORD   ?
MEMORYSTATUSEX ENDS

; Structure used by RtlGetVersion; contains operating system version information.
RTL_OSVERSIONINFOEXW STRUCT
    dwOSVersionInfoSize         DWORD   ?
    dwMajorVersion              DWORD   ?
    dwMinorVersion              DWORD   ?
    dwBuildNumber               DWORD   ?
    dwPlatformId                DWORD   ?
    szCSDVersion                WORD    128 DUP (?)
    wServicePackMajor           WORD    ?
    wServicePackMinor           WORD    ?
    wSuiteMask                  WORD    ?
    wProductType                WORD    ?
    wReserved                   WORD    ?
RTL_OSVERSIONINFOEXW ENDS

        .DATA
msEx            MEMORYSTATUSEX <>           ; Allocate and zero-initialize struct.
osEx            RTL_OSVERSIONINFOEXW <>
osbuf           DWORD   MaxBuf DUP (?)      ; OS version buffer.
edbuf           DWORD   MaxBuf DUP (?)      ; OS edition buffer.
cpubuf          DWORD   MaxBuf DUP (?)      ; CPU strings buffer.
membuf          DWORD   MaxBuf DUP (?)      ; Memory data buffer.
timebuf         DWORD   MaxBuf DUP (?)      ; Uptime buffer.
newln           BYTE    0Dh, 0Ah            ; CRLF
os_title        BYTE    "--- Operating System ---", 0Dh, 0Ah
os_version      BYTE    "Version : "
os_build        BYTE    "Build   : "
os_error        BYTE    "Error: Unable to retrieve OS version information.", 0Dh, 0Ah
W11_26H1        BYTE    "Windows 11 (26H1) "
W11_25H2        BYTE    "Windows 11 (25H2) "
W11_24H2        BYTE    "Windows 11 (24H2) "
W11_23H2        BYTE    "Windows 11 (23H2) "
W11_22H2        BYTE    "Windows 11 (22H2) "
W11_21H2        BYTE    "Windows 11 (21H2) "
productType     DWORD   ?                   ; Store return value from GetProductInfo function.
cpu_title       BYTE    "--- Processor ---", 0Dh, 0Ah
cpu_vendor      BYTE    "Vendor : "
cpu_name        BYTE    "Model  : "
cpu_cores       BYTE    "Cores  : "
mem_title       BYTE    "--- Memory ---", 0Dh, 0Ah
mem_total       BYTE    "RAM Total : "
mem_free        BYTE    "RAM Free  : "
mem_error       BYTE    "Error: Unable to retrieve memory information.", 0Dh, 0Ah
gibi_whole      QWORD   ?                   ; Store whole portion of RAM size.
gibi_fract      QWORD   ?                   ; Store fractional portion of RAM size.
gib_label       BYTE    " GiB"
decimal_pt      BYTE    "."
uptime_title    BYTE    "--- System Uptime ---", 0Dh, 0Ah
comma_sp        BYTE    ", "
days            QWORD   ?                   ; Uptime days value.
days_label      BYTE    " days"
day_label       BYTE    " day"
hours           QWORD   ?                   ; Uptime hours value.
hours_label     BYTE    " hours"
hour_label      BYTE    " hour"
minutes         QWORD   ?                   ; Uptime minutes value.
minutes_label   BYTE    " minutes"
minute_label    BYTE    " minute"
seconds         QWORD   ?                   ; Uptime seconds value.
seconds_label   BYTE    " seconds"
second_label    BYTE    " second"
stdin           QWORD   ?                   ; Handle to standard input device.
stdout          QWORD   ?                   ; Handle to standard output device.
nbwr            DWORD   ?                   ; Number of bytes (characters) actually written.
nbrd            DWORD   ?                   ; Number of bytes (characters) actually read.

        .CODE
; Convert integer in RAX to ASCII string in buffer pointed to by RDI; digits are stored in reverse order.
Int2Str PROC
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
Int2Str ENDP

; Convert bytes in RAX to GiB; store whole and fractional parts in gibi_whole and gibi_fract.
Byte2GiB PROC
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
Byte2GiB ENDP

; Convert milliseconds in RAX to a human-readable format.
FormatTime PROC
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
FormatTime ENDP

; Get CPU vendor string and store it in a buffer.
GetCpuVend PROC
        push    RBX

        mov     EAX, 0                      ; CPUID leaf 0 = vendor.
        cpuid                               ; CPUID instruction.
        mov     [cpubuf], EBX
        mov     [cpubuf + 4], EDX
        mov     [cpubuf + 8], ECX

        lea     RAX, cpubuf                 ; RAX: point to buffer address.
        mov     R8D, 12                     ; Return length in R8D.

        pop     RBX
        ret
GetCpuVend ENDP

; Get CPU brand string and store it in a buffer.
GetCpuBrand PROC
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

        lea     RAX, cpubuf                 ; RAX: point to buffer address.
        mov     R8D, 48                     ; Return length in R8D.

        pop     RBX
        ret
GetCpuBrand ENDP

; Return CPU core count as an integer in EAX.
GetCpuCores PROC
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
        jmp     cores_done

        ; AMD Processor
amd_proc:
        mov     EAX, 80000008h
        cpuid
        and     ECX, 0FFh                   ; Mask bits 7:0
        inc     ECX                         ; Core count in ECX.
        mov     EAX, ECX                    ; Normalize: core count in EAX.

cores_done:
        pop     RBX
        ret
GetCpuCores ENDP

main    PROC
        sub     RSP, 40                     ; Reserve "shadow space" on stack for 4 args (32 shadow + 8 alignment).

        ; Obtain handle for standard output.
        mov     RCX, STD_OUTPUT_HANDLE      ; Standard output device code for GetStdHandle.
        call    GetStdHandle                ; Return handle to standard output.
        mov     stdout, RAX                 ; Store the handle for console output.

;       Operating system section:
        StrOut  newln, LENGTHOF newln
        StrOut  os_title, LENGTHOF os_title

        mov     osEx.dwOSVersionInfoSize, SIZEOF RTL_OSVERSIONINFOEXW
        lea     RCX, osEx
        call    RtlGetVersion
        test    EAX, EAX                    ; 0 = success; nz = failure
        jz      rtl_success
        StrOut  os_error, LENGTHOF os_error
        jmp     rtl_fail

rtl_success:
        ; Set values for GetProductInfo
        mov     ECX, osEx.dwMajorVersion
        mov     EDX, osEx.dwMinorVersion
        movzx   R8D, osEx.wServicePackMajor ; Copy 16-bit WORD; zero-extend to 32-bit DWORD in R8D.
        movzx   R9D, osEx.wServicePackMinor
        lea     RAX, productType
        mov     [RSP + 32], RAX             ; Shadow space + 5th arg.
        call    GetProductInfo

        mov     EAX, [productType]
        GetEdi  EAX

        ; Version string:
        StrOut  os_version, LENGTHOF os_version
        mov     EAX, osEx.dwBuildNumber
        VerOut  EAX
        StrOut  edbuf, LENGTHOF edbuf
        StrOut  newln, LENGTHOF newln

        ; Build number:
        StrOut  os_build, LENGTHOF os_build
        mov     EAX, osEx.dwBuildNumber
        lea     RDI, osbuf + MaxBuf         ; Destination buffer + end position.
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  newln, LENGTHOF newln

;       Processor section:
        StrOut  newln, LENGTHOF newln
        StrOut  cpu_title, LENGTHOF cpu_title

        StrOut  cpu_vendor, LENGTHOF cpu_vendor
        call    GetCpuVend
        StrOut  RAX, R8D
        StrOut  newln, LENGTHOF newln

        StrOut  cpu_name, LENGTHOF cpu_name
        call    GetCpuBrand
        StrOut  RAX, R8D
        StrOut  newln, LENGTHOF newln

        StrOut  cpu_cores, LENGTHOF cpu_cores
        call    GetCpuCores
        lea     RDI, cpubuf + MaxBuf
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  newln, LENGTHOF newln
rtl_fail:

;       Memory section:
        StrOut  newln, LENGTHOF newln
        StrOut  mem_title, LENGTHOF mem_title

        mov     msEx.dwLength, SIZEOF MEMORYSTATUSEX
        lea     RCX, msEx
        call    GlobalMemoryStatusEx        ; Fills MEMORYSTATUSEX struct (after dwLength is set and RCX = pointer).
        test    RAX, RAX                    ; 1 = success; 0 = failure
        jnz     mem_success
        StrOut  mem_error, LENGTHOF mem_error
        jmp     mem_fail

mem_success:
        ; RAM total
        StrOut  mem_total, LENGTHOF mem_total
        mov     RAX, msEx.ullTotalPhys      ; Load QWORD from struct.
        call    Byte2GiB                    ; Convert bytes to GiB.

        ; Whole portion:
        mov     RAX, [gibi_whole]           ; Move first part of size into RAX to convert to string.
        lea     RDI, membuf + MaxBuf        ; Destination buffer + end position.
        call    Int2Str
        StrOut  RAX, R8D                    ; Print whole portion of RAM size.
        StrOut  decimal_pt, LENGTHOF decimal_pt

        ; Fractional portion:
        mov     RAX, [gibi_fract]           ; Move second part of size into RAX to convert to string.
        lea     RDI, membuf + MaxBuf
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  gib_label, LENGTHOF gib_label
        StrOut  newln, LENGTHOF newln

        ; RAM available
        StrOut  mem_free, LENGTHOF mem_free
        mov     RAX, msEx.ullAvailPhys      ; Load QWORD from struct.
        call    Byte2GiB

        ; Whole portion:
        mov     RAX, [gibi_whole]           ; Move first part of size into RAX to convert to string.
        lea     RDI, membuf + MaxBuf
        call    Int2Str
        StrOut  RAX, R8D                    ; Print whole portion of RAM size.
        StrOut  decimal_pt, LENGTHOF decimal_pt

        ; Fractional portion:
        mov     RAX, [gibi_fract]           ; Move second part of size into RAX to convert to string.
        lea     RDI, membuf + MaxBuf
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  gib_label, LENGTHOF gib_label
        StrOut  newln, LENGTHOF newln
mem_fail:

;       Uptime section:
        StrOut  newln, LENGTHOF newln
        StrOut  uptime_title, LENGTHOF uptime_title

        call    GetTickCount64              ; RAX = uptime in milliseconds.
        call    FormatTime                  ; Convert milliseconds and store in 'days', 'hours', 'minutes', 'seconds'.

        xor     R10D, R10D                  ; Comma flag: 0 = first unit, 1 = comma before next unit.

        mov     RAX, [days]
        cmp     RAX, 0                      ; Days = 0?
        je      hours_out                   ; Yes, skip to hours.
        cmp     RAX, 1                      ; Days = 1?
        je      single_day                  ; Yes, jump.

        lea     RDI, timebuf + MaxBuf       ; No, continue with plural.
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  days_label, LENGTHOF days_label
        jmp     days_done

single_day:
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  day_label, LENGTHOF day_label

days_done:
        mov     R10D, 1                     ; Set comma flag.

hours_out:
        mov     RAX, [hours]
        cmp     RAX, 0                      ; Hours = 0?
        je      minutes_out                 ; Yes, skip to minutes.

        cmp     R10D, 0                     ; Already printed a previous value?
        je      hours_no_comma              ; No, do not print a comma.
        push    RAX                         ; Preserve RAX before StrOut macro call.
        StrOut  comma_sp, LENGTHOF comma_sp ; Yes, print a comma.
        pop     RAX                         ; Restore RAX for next function call.
hours_no_comma:

        cmp     RAX, 1                      ; Hours = 1?
        je      single_hour                 ; Yes, jump.

        lea     RDI, timebuf + MaxBuf       ; No, continue with plural.
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  hours_label, LENGTHOF hours_label
        jmp     hours_done

single_hour:
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  hour_label, LENGTHOF hour_label

hours_done:
        mov     R10D, 1                     ; Set comma flag.

minutes_out:
        mov     RAX, [minutes]
        cmp     RAX, 0                      ; Minutes = 0?
        je      seconds_out                 ; Yes, skip to seconds.

        cmp     R10D, 0                     ; Already printed a previous value?
        je      minutes_no_comma            ; No, do not print comma.
        push    RAX                         ; Preserve RAX before StrOut macro call.
        StrOut  comma_sp, LENGTHOF comma_sp ; Yes, print a comma.
        pop     RAX                         ; Restore RAX for next function call.
minutes_no_comma:

        cmp     RAX, 1                      ; Minutes = 1?
        je      single_minute               ; Yes, jump.

        lea     RDI, timebuf + MaxBuf       ; No, continue with plural.
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  minutes_label, LENGTHOF minutes_label
        jmp     minutes_done

single_minute:
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  minute_label, LENGTHOF minute_label

minutes_done:
        mov     R10D, 1                     ; Set comma flag.

seconds_out:
        mov     RAX, [seconds]
        cmp     RAX, 0                      ; Seconds = 0?
        je      uptime_done

        cmp     R10D, 0                     ; Already printed a value?
        je      seconds_no_comma            ; No, do not print comma.
        push    RAX                         ; Preserve RAX before StrOut macro call.
        StrOut  comma_sp, LENGTHOF comma_sp ; Yes, print a comma.
        pop     RAX                         ; Restore RAX for next function call.
seconds_no_comma:

        cmp     RAX, 1                      ; Seconds = 1?
        je      single_second               ; Yes, jump.

        lea     RDI, timebuf + MaxBuf       ; No, continue with plural.
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  seconds_label, LENGTHOF seconds_label
        jmp     uptime_done

single_second:
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        StrOut  RAX, R8D
        StrOut  second_label, LENGTHOF second_label

uptime_done:
        StrOut  newln, LENGTHOF newln
        StrOut  newln, LENGTHOF newln

exit:
        xor     RCX, RCX
        call    ExitProcess
main    ENDP
        END

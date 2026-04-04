;-------------------------------------------------------------------------
; x64 System Information utility for Windows console.
; Author: Bryan C.
; Date  : 2026
;
; Assemble with MASM and link:
; ml64.exe sysinfo.asm /link /SUBSYSTEM:console /ENTRY:main
;-------------------------------------------------------------------------

includelib kernel32.lib                     ; Win32 API functions.
includelib ntdll.lib                        ; NT native system calls.

ExitProcess             proto               ; Terminate the current process.
GetStdHandle            proto               ; Retrieve a handle to a standard device (input/output).
WriteConsoleA           proto
GlobalMemoryStatusEx    proto :ptr MEMORYSTATUSEX
GetTickCount64          proto
RtlGetVersion           proto :ptr RTL_OSVERSIONINFOEXW
GetProductInfo          proto :dword, :dword, :dword, :dword, :ptr dword

STD_OUTPUT_HANDLE equ   -11                 ; Device code for console output.
MaxBuf            equ   100
BytesPerGib       equ   1024 * 1024 * 1024
MsPerSecond       equ   1000
SecPerDay         equ   86400
SecPerHour        equ   3600
SecPerMinute      equ   60

; Write a string to the console. addr may be RAX or a label; len is copied into R8D.
strOut  macro   addr, len
        mov     RCX, stdout                 ; Arg 1: output device handle.
IFIDNI  <addr>, <RAX>                       ; If addr is RAX, use it directly; otherwise LEA of the label.
        mov     RDX, RAX                    ; Arg 2: pointer to byte array in RAX register.
ELSE
        lea     RDX, addr                   ; Arg 2: pointer to byte array label.
ENDIF
        mov     R8D, len                    ; Arg 3: number of bytes to write.
        lea     R9, nbwr                    ; Arg 4: pointer to variable that receives number of bytes written.
        call    WriteConsoleA
        endm

; Print the Windows 11 version string for the given build number.
verOut  macro   reg
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

; Compare the value returned by GetProductInfo; store current Windows edition in edbuf.
getEdi  macro   reg
    LOCAL home, home_sl, home_n, pro, pro_n, pro_edu, pro_ws, edu, ent, ent_n, done

        cmp     reg, 00000065H
        je      home
        cmp     reg, 00000064H
        je      home_sl
        cmp     reg, 00000062H
        je      home_n
        cmp     reg, 00000030H
        je      pro
        cmp     reg, 00000031H
        je      pro_n
        cmp     reg, 000000A4H
        je      pro_edu
        cmp     reg, 000000A1H
        je      pro_ws
        cmp     reg, 00000079H
        je      edu
        cmp     reg, 00000004H
        je      ent
        cmp     reg, 0000001BH
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
RTL_OSVERSIONINFOEXW STRUCT
    dwOSVersionInfoSize         dword   ?
    dwMajorVersion              dword   ?
    dwMinorVersion              dword   ?
    dwBuildNumber               dword   ?
    dwPlatformId                dword   ?
    szCSDVersion                word    128 DUP (?)
    wServicePackMajor           word    ?
    wServicePackMinor           word    ?
    wSuiteMask                  word    ?
    wProductType                word    ?
    wReserved                   word    ?
RTL_OSVERSIONINFOEXW ENDS

        .data
msEx            MEMORYSTATUSEX <>           ; Allocate and zero-initialize struct.
osEx            RTL_OSVERSIONINFOEXW <>
osbuf           dword   MaxBuf DUP (?)      ; OS version buffer.
edbuf           dword   MaxBuf DUP (?)      ; OS edition buffer.
cpubuf          dword   MaxBuf DUP (?)      ; CPU strings buffer.
membuf          dword   MaxBuf DUP (?)      ; Memory data buffer.
timebuf         dword   MaxBuf DUP (?)      ; Uptime buffer.
newln           byte    0DH, 0AH            ; CRLF
os_title        byte    "--- Operating System ---", 0DH, 0AH
os_version      byte    "Version : "
os_build        byte    "Build   : "
os_error        byte    "Error: Unable to retrieve OS version information.", 0DH, 0AH
W11_26H1        byte    "Windows 11 (26H1) "
W11_25H2        byte    "Windows 11 (25H2) "
W11_24H2        byte    "Windows 11 (24H2) "
W11_23H2        byte    "Windows 11 (23H2) "
W11_22H2        byte    "Windows 11 (22H2) "
W11_21H2        byte    "Windows 11 (21H2) "
productType     dword   ?                   ; Store return value from GetProductInfo function.
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
comma_sp        byte    ", "
days            qword   ?                   ; Uptime days value.
days_label      byte    " days"
day_label       byte    " day"
hours           qword   ?                   ; Uptime hours value.
hours_label     byte    " hours"
hour_label      byte    " hour"
minutes         qword   ?                   ; Uptime minutes value.
minutes_label   byte    " minutes"
minute_label    byte    " minute"
seconds         qword   ?                   ; Uptime seconds value.
seconds_label   byte    " seconds"
second_label    byte    " second"
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

        mov     osEx.dwOSVersionInfoSize, SIZEOF RTL_OSVERSIONINFOEXW
        lea     RCX, osEx
        call    RtlGetVersion
        test    EAX, EAX                    ; 0 = success; nz = failure
        jz      rtl_success
        strOut  os_error, lengthof os_error
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
        getEdi  EAX

        ; Version string:
        strOut  os_version, lengthof os_version
        mov     EAX, osEx.dwBuildNumber
        verOut  EAX
        strOut  edbuf, lengthof edbuf
        strOut  newln, lengthof newln

        ; Build number:
        strOut  os_build, lengthof os_build
        mov     EAX, osEx.dwBuildNumber
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

        xor     R10D, R10D                  ; Comma flag: 0 = first unit, 1 = comma before next unit.

        mov     RAX, [days]
        cmp     RAX, 0                      ; Days = 0?
        je      hours_out                   ; Yes, skip to hours.
        cmp     RAX, 1                      ; Days = 1?
        je      single_day                  ; Yes, jump.

        lea     RDI, timebuf + MaxBuf       ; No, continue with plural.
        call    Int2Str
        strOut  RAX, R8D
        strOut  days_label, lengthof days_label
        jmp     days_done

single_day:
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  day_label, lengthof day_label

days_done:
        mov     R10D, 1                     ; Set comma flag.

hours_out:
        mov     RAX, [hours]
        cmp     RAX, 0                      ; Hours = 0?
        je      minutes_out                 ; Yes, skip to minutes.

        cmp     R10D, 0                     ; Already printed a previous value?
        je      hours_no_comma              ; No, do not print a comma.
        push    RAX                         ; Preserve RAX before strOut macro call.
        strOut  comma_sp, lengthof comma_sp ; Yes, print a comma.
        pop     RAX                         ; Restore RAX for next function call.
hours_no_comma:

        cmp     RAX, 1                      ; Hours = 1?
        je      single_hour                 ; Yes, jump.

        lea     RDI, timebuf + MaxBuf       ; No, continue with plural.
        call    Int2Str
        strOut  RAX, R8D
        strOut  hours_label, lengthof hours_label
        jmp     hours_done

single_hour:
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  hour_label, lengthof hour_label

hours_done:
        mov     R10D, 1                     ; Set comma flag.

minutes_out:
        mov     RAX, [minutes]
        cmp     RAX, 0                      ; Minutes = 0?
        je      seconds_out                 ; Yes, skip to seconds.

        cmp     R10D, 0                     ; Already printed a previous value?
        je      minutes_no_comma            ; No, do not print comma.
        push    RAX                         ; Preserve RAX before strOut macro call.
        strOut  comma_sp, lengthof comma_sp ; Yes, print a comma.
        pop     RAX                         ; Restore RAX for next function call.
minutes_no_comma:

        cmp     RAX, 1                      ; Minutes = 1?
        je      single_minute               ; Yes, jump.

        lea     RDI, timebuf + MaxBuf       ; No, continue with plural.
        call    Int2Str
        strOut  RAX, R8D
        strOut  minutes_label, lengthof minutes_label
        jmp     minutes_done

single_minute:
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  minute_label, lengthof minute_label

minutes_done:
        mov     R10D, 1                     ; Set comma flag.

seconds_out:
        mov     RAX, [seconds]
        cmp     RAX, 0                      ; Seconds = 0?
        je      uptime_done

        cmp     R10D, 0                     ; Already printed a value?
        je      seconds_no_comma            ; No, do not print comma.
        push    RAX                         ; Preserve RAX before strOut macro call.
        strOut  comma_sp, lengthof comma_sp ; Yes, print a comma.
        pop     RAX                         ; Restore RAX for next function call.
seconds_no_comma:

        cmp     RAX, 1                      ; Seconds = 1?
        je      single_second               ; Yes, jump.

        lea     RDI, timebuf + MaxBuf       ; No, continue with plural.
        call    Int2Str
        strOut  RAX, R8D
        strOut  seconds_label, lengthof seconds_label
        jmp     uptime_done

single_second:
        lea     RDI, timebuf + MaxBuf
        call    Int2Str
        strOut  RAX, R8D
        strOut  second_label, lengthof second_label

uptime_done:
        strOut  newln, lengthof newln
        strOut  newln, lengthof newln

exit:
        xor     RCX, RCX
        call    ExitProcess
main    endp
        end

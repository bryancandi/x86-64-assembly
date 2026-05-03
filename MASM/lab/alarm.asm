;==============================================================
; ALARM.ASM - Command-line alarm clock.
; Alarm will sound at the next occurrence of the entered time.
;
; Author: Bryan C.
; Date  : 2026-04-29
;==============================================================

INCLUDELIB kernel32.lib

ExitProcess         PROTO
GetStdHandle        PROTO
ReadFile            PROTO
WriteConsoleA       PROTO
GetLocalTime        PROTO :PTR SYSTEMTIME
Beep                PROTO :DWORD, :DWORD
Sleep               PROTO :DWORD

STD_INPUT_HANDLE    EQU -10
STD_OUTPUT_HANDLE   EQU -11
MaxSize             EQU 64

; SYSTEMTIME structure
SYSTEMTIME STRUCT
    wYear           WORD ?
    wMonth          WORD ?
    wDayOfWeek      WORD ?
    wDay            WORD ?
    wHour           WORD ?
    wMinute         WORD ?
    wSecond         WORD ?
    wMilliseconds   WORD ?
SYSTEMTIME ENDS

        .DATA
SysTime SYSTEMTIME <>
prompt  BYTE    "Enter Alarm Time (24 Hour HH:MM): "
inval_t BYTE    "Invalid time entered.", 0Dh, 0Ah
alset   BYTE    "Alarm is set for "
wake    BYTE    "Alarm!"
blank   BYTE    "      "
cr      BYTE    0Dh
lf      BYTE    0Ah
newln   BYTE    0Dh, 0Ah
buffer  BYTE    MaxSize DUP (?)
fmtbuf  BYTE    MaxSize DUP (?)
stdin   QWORD   ?
stdout  QWORD   ?
nbrd    DWORD   ?
nbwr    DWORD   ?
nbws    DWORD   ?
nbdg    DWORD   ?
alarm_t DWORD   ?

        .CODE
main    PROC
        sub     rsp, 40

        mov     rcx, STD_INPUT_HANDLE
        call    GetStdHandle
        mov     [stdin], rax

        mov     rcx, STD_OUTPUT_HANDLE
        call    GetStdHandle
        mov     [stdout], rax

        ; Prompt and read input.
time_prompt:
        mov     rcx, [stdout]
        lea     rdx, prompt
        mov     r8, LENGTHOF prompt
        lea     r9, nbwr
        call    WriteConsoleA

        mov     rcx, [stdin]
        lea     rdx, buffer
        mov     r8, MaxSize
        lea     r9, nbrd
        call    ReadFile

        ; Validate user input; acceptable formats: HHMM and HH:MM
        lea     rsi, buffer                 ; RSI = pointer to source buffer
        lea     rdi, fmtbuf                 ; RDI = pointer to destination buffer
        xor     r8d, r8d                    ; R8D = white space counter
        xor     r9d, r9d                    ; R9D = digit counter (this should always = 4)

hour_first_digit:
        ; H position 1 / leading white space check:
        ; Acceptable range is 0 to 2.
        mov     al, [rsi]
        cmp     al, ' '
        je      consume_leading_space       ; Consume leading white space
        cmp     al, '0'
        jb      time_invalid
        cmp     al, '2'
        ja      time_invalid
        mov     [rdi], al
        mov     cl, al                      ; Store first hour digit in CL
        inc     rsi
        inc     rdi
        inc     r9d

        ; H position 2:
        ; If hour starts with 0 or 1, range is 0-9 (10:00 to 19:00).
        ; If hour starts with 2, range is 0-3 (20:00 to 23:00).
        mov     al, [rsi]
        cmp     al, '0'
        jb      time_invalid
        cmp     cl, '2'                     ; Is time after 20:00?
        je      hour_20_to_23               ; Yes
        cmp     al, '9'                     ; No
        ja      time_invalid
        mov     [rdi], al
        inc     rsi
        inc     rdi
        inc     r9d
        jmp     minute_first_digit
hour_20_to_23:
        cmp     al, '3'
        ja      time_invalid
        mov     [rdi], al
        inc     rsi
        inc     rdi
        inc     r9d

minute_first_digit:
        ; M position 1 / colon check:
        ; Skip over colon if present.
        ; Acceptable range is 0-5.
        mov     al, [rsi]
        cmp     al, ':'
        je      consume_digit
        cmp     al, '0'
        jb      time_invalid
        cmp     al, '5'
        ja      time_invalid
        mov     [rdi], al
        inc     rsi
        inc     rdi
        inc     r9d

        ; M positon 2:
        ; Acceptable range is 0-9.
        mov     al, [rsi]
        cmp     al, '0'
        jb      time_invalid
        cmp     al, '9'
        ja      time_invalid
        mov     [rdi], al
        inc     r9d
        mov     [nbws], r8d
        mov     [nbdg], r9d

        ; Trailing character check:
        ; Continue only if the next character is NULL, space, CR, or LF.
        ; Otherwise consider the value invalid.
        inc     rsi
        mov     al, [rsi]
        cmp     al, 0
        je      time_valid
        cmp     al, ' '
        je      time_valid
        cmp     al, 0Dh
        je      time_valid
        cmp     al, 0Ah
        je      time_valid
        jmp     time_invalid

consume_leading_space:
        inc     rsi
        inc     r8d
        jmp     hour_first_digit

consume_digit:
        inc     rsi
        jmp     minute_first_digit

time_invalid:
        mov     rcx, [stdout]
        lea     rdx, inval_t
        mov     r8d, LENGTHOF inval_t
        lea     r9, nbwr
        call    WriteConsoleA
        jmp     time_prompt
time_valid:

        ; Convert user input to an integer for comparison.
        mov     ebx, [nbdg]                 ; Number of characters in the string
        xor     r8, r8                      ; Initial buffer position index = 0
        xor     rax, rax
        lea     rcx, fmtbuf                 ; RCX = pointer to formatted buffer
convert_loop:
        movzx   rdx, BYTE PTR [rcx + r8]    ; RDX = digit character at buffer[index], zero-extended
        sub     rdx, '0'
        imul    rax, rax, 10
        add     rax, rdx
        inc     r8                          ; Increment buffer position
        dec     ebx                         ; Decrement digit counter
        test    ebx, ebx
        jnz     convert_loop
        mov     [alarm_t], eax              ; Store alarm time in 'alarm_t'

        ; Alarm is set.
        mov     rcx, [stdout]
        lea     rdx, alset
        mov     r8, LENGTHOF alset
        lea     r9, nbwr
        call    WriteConsoleA

        mov     eax, [nbws]                 ; Number of white spaces to skip in the buffer
        mov     rcx, [stdout]
        lea     rdx, buffer
        add     rdx, rax                    ; Advance to buffer past white spaces
        mov     r8d, [nbrd]
        lea     r9, nbwr
        call    WriteConsoleA

        ; Keep comparing local time and alarm time until they match.
compare_loop:
        lea     rcx, SysTime
        call    GetLocalTime
        movzx   eax, SysTime.wHour
        movzx   ecx, SysTime.wMinute
        imul    eax, eax, 100               ; EAX = hours * 100 (12 to 1200)
        add     eax, ecx                    ; EAX = hours + minutes
        mov     edx, [alarm_t]
        cmp     eax, edx                    ; Have we reached the alarm set time?
        je      alarm                       ; Yes, sound the alarm
        mov     ecx, 10000                  ; No, sleep 10 seconds and check again
        call    Sleep
        jmp     compare_loop

        ; Sound the alarm!
alarm:
        mov     ebx, 10                     ; Number of alarm cycles
beep_loop:
        mov     rcx, [stdout]
        lea     rdx, wake
        mov     r8, LENGTHOF wake
        lea     r9, nbwr
        call    WriteConsoleA               ; Write alarm message
        mov     ecx, 700                    ; Beep frequency (Hz)
        mov     edx, 1000                   ; Beep duration (ms)
        call    Beep
        mov     ecx, 500                    ; Sleep duration (ms)
        call    Sleep
        dec     ebx                         ; Decrement cycles
        test    ebx, ebx
        jz      exit
        jmp     beep_loop

exit:
        xor     rcx, rcx
        call    ExitProcess
main    ENDP
        END

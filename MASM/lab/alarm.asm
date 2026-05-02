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
alset   BYTE    "Alarm is set for "
wake    BYTE    "Alarm!", 0Dh, 0Ah
newln   BYTE    0Dh, 0Ah
buffer  BYTE    MaxSize DUP (?)
outbuf  BYTE    MaxSize DUP (?)
stdin   QWORD   ?
stdout  QWORD   ?
nbrd    DWORD   ?
nbwr    DWORD   ?
nbcp    DWORD   ?
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
prompt_loop:
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

        ; Remove unwanted character (:)
        lea     rsi, buffer                 ; Source buffer
        lea     rdi, outbuf                 ; Destination buffer
        mov     r8d, [nbrd]                 ; R8D = number of characters in buffer
        xor     r9d, r9d                    ; R9D = number of characters copied to outbuf
rem_loop:
        mov     al, [rsi]                   ; Load current character in source into AL
        cmp     al, ':'                     ; Is it a colon?
        je      skip_char                   ; Yes, skip it
        mov     [rdi], al                   ; No, write character into destination buffer
        inc     r9d                         ; Increment copy counter
        dec     r8d                         ; Decrement character counter
        test    r8d, r8d                    ; Any characters left to check?
        jz      rem_done                    ; No, we are done
        inc     rsi                         ; Yes, Move to next char in source
        inc     rdi                         ; Yes, Move to next char in destination
        jmp     rem_loop
skip_char:
        inc     rsi                         ; Move source index forward one position
        dec     r8d                         ; Decrement counter
        jmp     rem_loop
rem_done:
        mov     [nbcp], r9d                 ; Store count of characters copied

        mov     r8d, [nbcp]
        cmp     r8d, 2                      ; 2 = CRLF
        je      prompt_loop
        cmp     r8d, 6                      ; 6 = CRLF + HHMM
        jne     prompt_loop

        ; Convert user input to an integer for comparison.
        mov     ebx, [nbcp]                 ; Number of characters in the string
        sub     ebx, 2                      ; Subtract 2 for CRLF chars
        xor     r8, r8                      ; Initial buffer position index = 0
        xor     rax, rax
        lea     rcx, outbuf                 ; RCX = pointer to buffer
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

        mov     rcx, [stdout]
        lea     rdx, buffer
        mov     r8d, [nbrd]
        lea     r9, nbwr
        call    WriteConsoleA

        ; Keep comparing local time and alarm time until they match.
poll_loop:
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
        jmp     poll_loop

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

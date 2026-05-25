;======================================================================
; Message Box Infinite Loop - Threaded MessageBox Spawner
;
; Press and hold ESC to terminate execution.
;
; Author : Bryan C.
; Date   : May 25, 2026
;======================================================================

INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

ExitProcess      PROTO uExitCode:DWORD
GetStdHandle     PROTO nStdHandle:DWORD
CreateThread     PROTO lpThreadAttributes:PTR, dwStackSize:QWORD, lpStartAddress:QWORD, lpParameter:QWORD, dwCreationFlags:DWORD, lpThreadId:QWORD
CloseHandle      PROTO hObject:QWORD
WriteFile        PROTO hFile:QWORD, lpBuffer:PTR, nNumberOfBytesToWrite:DWORD, lpNumberOfBytesWritten:PTR, lpOverlapped:PTR
MessageBoxA      PROTO hWnd:QWORD, lpText:QWORD, lpCaption:QWORD, uType:DWORD
GetAsyncKeyState PROTO vKey:DWORD
Sleep            PROTO dwMilliseconds:DWORD
wsprintfA        PROTO C :PTR BYTE, :PTR BYTE, :VARARG

STD_OUTPUT_HANDLE EQU -11
SLEEP_MS          EQU 650
VK_ESCAPE         EQU 1Bh

        .DATA
exitMsg BYTE    0Ah, 0Dh, "Press and hold ESC to terminate.", 0Ah, 0Dh
stdout  QWORD   ?
nbwr    DWORD   ?
counter DWORD   0
format  BYTE    "This is message box number %d.", 0
mbCapt  BYTE    "System Alert", 0

        .CODE
start   PROC
        ; Allocate 56 bytes (38h) of shadow space on the stack. 
        ; 32 bytes for 4 arguments + 16 bytes for CreateThread's 5th and 6th arguments + 8 bytes for alignment.
        sub     rsp, 38h

        ; Get stdout handle.
        mov     rcx, STD_OUTPUT_HANDLE
        call    GetStdHandle
        cmp     eax, -1
        je      exit
        mov     [stdout], rax

        ; Write exit message to stdout.
        mov     rcx, [stdout]
        lea     rdx, exitMsg
        mov     r8, LENGTHOF exitMsg
        lea     r9, nbwr
        mov     QWORD PTR [rsp+32], 0
        call    WriteFile

msg_box_loop:
        ; Exit if ESC key is down.
        mov     ecx, VK_ESCAPE
        call    GetAsyncKeyState
        test    ax, 8000h               ; MSB is set if key is held down
        jnz     exit

        ; Increment shared message counter (thread-safe).
        lock    inc DWORD PTR [counter]

        ; Create a new message box thread.
        xor     rcx, rcx
        xor     rdx, rdx
        lea     r8, msgWorker
        mov     r9d, [counter]          ; Pass value of counter to thread via 'lpParameter' (RCX)
        mov     QWORD PTR [rsp+32], 0
        mov     QWORD PTR [rsp+40], 0
        call    CreateThread
        test    rax, rax
        jz      exit

        ; Close handle created by CreateThread.
        mov     rcx, rax
        call    CloseHandle

        ; Sleep.
        mov     ecx, SLEEP_MS
        call    Sleep

        jmp     msg_box_loop

exit:
        xor     eax, eax
        call    ExitProcess
start   ENDP

msgWorker PROC
        ; Preserve RDI on stack, this pushes 8 bytes on to the stack.
        push    rdi

        ; Allocate 128 bytes (80h) of shadow space on the stack.
        ; 32 bytes for 4 arguments + 96 bytes for local buffer.
        sub     rsp, 80h

        mov     rax, rcx                ; RCX contains the counter value passed from CreateThread function
        lea     rdi, [rsp+20h]          ; Create local buffer after shadow space (32 (20h) bytes) on the stack

        ; Write formatted string to local buffer.
        lea     rcx, [rdi]
        lea     rdx, format
        mov     r8, rax
        call    wsprintfA

        ; Display the message box.
        xor     rcx, rcx
        mov     rdx, rdi
        lea     r8, mbCapt
        mov     r9, 40h
        call    MessageBoxA

        add     rsp, 80h
        pop     rdi

        ret
msgWorker ENDP

        END

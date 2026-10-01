;------------------------------------------------------------------
; HELLOWIN.ASM -- Displays "Hello, Windows 11!" in client area
;                 MASM implementation of `HELLOWIN.C` 
; Programming Windows: 5th Edition by Charles Petzold, 1998
;------------------------------------------------------------------

INCLUDELIB kernel32.lib
INCLUDELIB user32.lib
INCLUDELIB gdi32.lib
INCLUDELIB winmm.lib

EXTERN GetModuleHandleA:PROC
EXTERN LoadIconA:PROC
EXTERN LoadCursorA:PROC
EXTERN GetStockObject:PROC
EXTERN RegisterClassA:PROC
EXTERN MessageBoxA:PROC
EXTERN CreateWindowExA:PROC
EXTERN ShowWindow:PROC
EXTERN UpdateWindow:PROC
EXTERN GetMessageA:PROC
EXTERN TranslateMessage:PROC
EXTERN DispatchMessageA:PROC
EXTERN PlaySoundA:PROC
EXTERN BeginPaint:PROC
EXTERN GetClientRect:PROC
EXTERN DrawTextA:PROC
EXTERN EndPaint:PROC
EXTERN PostQuitMessage:PROC
EXTERN DefWindowProcA:PROC
EXTERN ExitProcess:PROC

CS_VREDRAW          EQU 1
CS_HREDRAW          EQU 2
IDI_APPLICATION     EQU 32512
IDC_ARROW           EQU 32512
WHITE_BRUSH         EQU 0
MB_ICONERROR        EQU 10h
WS_OVERLAPPEDWINDOW EQU 00CF0000h
CW_USEDEFAULT       EQU 80000000h
SW_SHOWDEFAULT      EQU 10
WM_CREATE           EQU 0001h
WM_DESTROY          EQU 0002h
WM_PAINT            EQU 000Fh
SND_ASYNC           EQU 0001h
SND_FILENAME        EQU 00020000h
DT_CENTER           EQU 01h
DT_VCENTER          EQU 04h
DT_SINGLELINE       EQU 20h

        .DATA
szAppName   BYTE "HelloWin", 0
szCaption   BYTE "The Hello Program", 0
szErrMsg    BYTE "This program requires Windows NT!", 0
szWav       BYTE "hellowin.wav", 0
szHello     BYTE "Hello, Windows 11!", 0

        .CODE
WinMain PROC
        ; TO-DO: finish implementation of ASM version of hellowin.c functions

        xor     ecx, ecx
        call    ExitProcess
WinMain ENDP

WndProc PROC
        ret
WndProc ENDP
        END

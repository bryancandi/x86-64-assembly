;--------------------------------------------------------------------
; myincludes.inc - Header file entries extracted from MASM32 header
;                  files (placed here rather than including the 
;                  ful MASM32 headers to avoid namespace pollution
;                  and speed up assemblies).
;--------------------------------------------------------------------

STD_INPUT_HANDLE                    EQU -10
STD_OUTPUT_HANDLE                   EQU -11
STD_ERROR_HANDLE                    EQU -12
CREATE_NEW                          EQU 1
CREATE_ALWAYS                       EQU 2
OPEN_EXISTING                       EQU 3
OPEN_ALWAYS                         EQU 4
FILE_ATTRIBUTE_READONLY             EQU 1h
FILE_ATTRIBUTE_HIDDEN               EQU 2h
FILE_ATTRIBUTE_SYSTEM               EQU 4h
FILE_ATTRIBUTE_DIRECTORY            EQU 10h
FILE_ATTRIBUTE_ARCHIVE              EQU 20h
FILE_ATTRIBUTE_NORMAL               EQU 80h
FILE_ATTRIBUTE_TEMPORARY            EQU 100h
FILE_ATTRIBUTE_COMPRESSED           EQU 800h
FILE_SHARE_READ                     EQU 1h
FILE_SHARE_WRITE                    EQU 2h
GENERIC_READ                        EQU 80000000h
GENERIC_WRITE                       EQU 40000000h
GENERIC_EXECUTE                     EQU 20000000h
GENERIC_ALL                         EQU 10000000h
INVALID_HANDLE_VALUE                EQU -1

HKEY_LOCAL_MACHINE                  EQU 80000002h
RRF_RT_REG_SZ                       EQU 2h
RRF_RT_REG_DWORD                    EQU 10h
ERROR_BUFFER_OVERFLOW               EQU 6Fh

MAX_ADAPTER_ADDRESS_LENGTH          EQU 8
MAX_ADAPTER_DESCRIPTION_LENGTH      EQU 128
MAX_ADAPTER_NAME_LENGTH             EQU 256
IP_STRING_LENGTH                    EQU 16

; System
ExitProcess                         PROTO uExitCode:DWORD
GetProcessHeap                      PROTO
HeapAlloc                           PROTO hHeap:QWORD, dwFlags:DWORD, dwBytes:QWORD
HeapFree                            PROTO hHeap:QWORD, dwFlags:DWORD, lpMem:PTR
RegGetValueA                        PROTO hkey:QWORD, lpSubKey:PTR BYTE, lpValue:PTR BYTE, dwFlags:DWORD, pdwType:PTR DWORD, pvData:PTR, pcbData:PTR DWORD
Sleep                               PROTO dwMilliseconds:DWORD
SetThreadExecutionState             PROTO esFlags:DWORD

; Console I/O
GetStdHandle                        PROTO nStdHandle:DWORD
WriteConsoleA                       PROTO hConsoleOutput:QWORD, lpBuffer:PTR, nNumberOfCharsToWrite:DWORD, lpNumberOfCharsWritten:PTR DWORD, lpReserved:PTR
GetFileType                         PROTO hFile:QWORD
ReadFile                            PROTO hFile:QWORD, lpBuffer:PTR, nNumberOfBytesToRead:DWORD, lpNumberOfBytesRead:PTR, lpOverlapped:PTR
WriteFile                           PROTO hFile:QWORD, lpBuffer:PTR, nNumberOfBytesToWrite:DWORD, lpNumberOfBytesWritten:PTR, lpOverlapped:PTR
ReadConsoleInputW                   PROTO hConsoleInput:QWORD, lpBuffer:PTR INPUT_RECORD, nLength:DWORD, lpNumberOfEventsRead:PTR
GetNumberOfConsoleInputEvents       PROTO hConsoleInput:QWORD, lpcNumberOfEvents:PTR

; System Information
GetAdaptersInfo                     PROTO AdapterInfo:QWORD, SizePointer:QWORD
GetComputerNameA                    PROTO lpBuffer:PTR BYTE, nSize:PTR DWORD
GetDiskFreeSpaceExA                 PROTO lpDirectoryName:PTR BYTE, lpFreeBytesAvailableToCaller:PTR QWORD, lpTotalNumberOfBytes:PTR QWORD, lpTotalNumberOfFreeBytes:PTR QWORD
GetLogicalDriveStringsA             PROTO nBufferLength:DWORD, lpBuffer:PTR BYTE
GetNativeSystemInfo                 PROTO lpSystemInfo:PTR SYSTEM_INFO
GetProductInfo                      PROTO dwOSMajorVersion:DWORD, dwOSMinorVersion:DWORD, dwSpMajorVersion:DWORD, dwSpMinorVersion:DWORD, pdwReturnedProductType:PTR DWORD
GetTickCount64                      PROTO
GlobalMemoryStatusEx                PROTO lpBuffer:PTR MEMORYSTATUSEX
RtlGetVersion                       PROTO lpVersionInformation:PTR RTL_OSVERSIONINFOEXW

; Device
Beep                                PROTO dwFreq:DWORD, dwDuration:DWORD
mouse_event                         PROTO dwFlags:DWORD, dwDx:DWORD, dwDy:DWORD, dwData:DWORD, dwExtraInfo:QWORD

; Time & Date
GetLocalTime                        PROTO lpSystemTime:PTR SYSTEMTIME

;--------------------------------------------------------------------
; CREATE: x86-64 Creating files.
; Assemble with MASM and link:
; ml64.exe source.asm /link /SUBSYSTEM:console /ENTRY:main
; ml64.exe source.asm /link /SUBSYSTEM:windows /ENTRY:main
;--------------------------------------------------------------------

INCLUDELIB kernel32.lib         ; Import a standard Windows library.
ExitProcess PROTO               ; Declare the ExitProcess function prototype.
CreateFileA PROTO               ; Declare the CreateFileA function prototype.

GENERIC_READ            EQU 080000000h ; Access mode for reading.
GENERIC_WRITE           EQU 040000000h ; Access mode for writing.
FILE_SHARE_READ         EQU 1          ; Share mode for reading.
FILE_SHARE_WRITE        EQU 2          ; Share mode for writing.
OPEN_ALWAYS             EQU 4          ; Creation disposition to open a file, or create it if it doesn't exist.
FILE_ATTRIBUTE_NORMAL   EQU 128        ; Attribute for normal files.

.DATA                           ; Start of the data section.
    filePath BYTE "C:\Users\bryan\Desktop\testfile.txt", 0  ; Declare a null-terminated string for the file path.
    fileHandle QWORD ?                                      ; Declare a variable to store the file handle.

.CODE                           ; Start of the code section.
main PROC                       ; Entry point of the program.
    SUB RSP, 56                 ; Create shadow space for arguments.

    XOR RAX, RAX                ; Clear registers.
    XOR RCX, RCX
    XOR RDX, RDX
    XOR R8, R8
    XOR R9, R9

    LEA RCX, filePath                           ; Load the address of the file path into RCX (argument 1).
    MOV RDX, GENERIC_READ OR GENERIC_WRITE      ; Set desired access to read/write (argument 2).
    MOV R8, FILE_SHARE_READ OR FILE_SHARE_WRITE ; Set share mode to allow read/write sharing (argument 3).
    MOV R9, 0                                   ; No security attributes (argument 4).
    MOV QWORD PTR [RSP+32], OPEN_ALWAYS         ; Set creation disposition to open or create (argument 5).
    MOV QWORD PTR [RSP+40], FILE_ATTRIBUTE_NORMAL ; Set file attributes to normal (argument 6).
    MOV QWORD PTR [RSP+48], 0                   ; No template file (argument 7).

    CALL CreateFileA                            ; Call the CreateFileA function to create or open the file.
    MOV fileHandle, RAX                         ; Store the returned file handle.

    ADD RSP, 56                 ; Clean up the stack by restoring the original stack pointer.
    XOR RCX, RCX                ; Exit code 0;
    CALL ExitProcess            ; Call the ExitProcess function to exit the program.
main ENDP                       ; End of the main procedure.
END                             ; End of the assembly program.

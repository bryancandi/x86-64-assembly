## Shadow Space and Stack Alignment in Windows x64

Shadow space (32 bytes) must be reserved on the stack before making any Windows API call.
Because the CALL instruction pushes an 8‑byte return address, the stack pointer must also
be adjusted to maintain 16‑byte alignment at the moment of the call.
Subtracting 40 bytes (32 shadow + 8 alignment) satisfies both requirements.

The x64 Application Binary Interface (ABI) uses a four-register calling convention by default.
Space is allocated on the call stack as a shadow store for callees to save those registers.
It allows the called function (callee) to temporarily save (spill) its first four register arguments
(`RCX`, `RDX`, `R8`, `R9`) to the stack.

```asm
main    PROC
        sub     rsp, 40             ; 32 bytes shadow space + 8 bytes for alignment.

; The stack only needs to be restored before returning to the caller.
; Since ExitProcess never returns, no stack restoration is required.

        xor     rcx, rcx            ; Set exit status code to zero.
        call    ExitProcess         ; Call the ExitProcess function to exit the program.
main    ENDP
```

This example function does return, so the stack must be restored.

```asm
Write   PROC
        sub     rsp, 40             ; 32 bytes shadow space + 8 bytes for alignment.

        mov     rcx, handle         ; HANDLE  hConsole
        lea     rdx, msg            ; LPCSTR  lpBuffer
        mov     r8, LENGTHOF msg    ; DWORD   nNumberOfCharsToWrite
        lea     r9, bytesWritten    ; LPDWORD lpNumberOfCharsWritten
        call    WriteConsoleA       ; Requires shadow space + alignment.

        add     rsp, 40             ; Restore stack before returning.
        ret
Write   ENDP
```

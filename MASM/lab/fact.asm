;--------------------------------------------------------------------
; Factorial example for Windows x64 (MASM / ml64).
;
; Assemble with MASM and link:
; ml64.exe fact.asm /link /SUBSYSTEM:console /ENTRY:main
;--------------------------------------------------------------------

includelib kernel32.lib
includelib shell32.lib

ExitProcess         proto
GetStdHandle        proto
WriteConsoleA       proto
GetCommandLineW     proto
CommandLineToArgvW  proto

STD_OUTPUT_HANDLE   equ    -11

msgOut  macro   msg             ; One arg macro: msg
        mov     RCX, handle     ; 1st arg: handle to console screen buffer.
        lea     RDX, msg        ; 2nd arg: pointer to buffer (macro) that contain text to write.
        mov     R8, lengthof msg ; 3rd arg: number of characters to be written to console.
        lea     R9, num         ; 4th arg: pointer to a variable to contain the number of characters actually written.
        call    WriteConsoleA
        endm

        .data
buf     byte    100 DUP (?)     ; Empty 100 byte buffer to store ASCII digits of factorial result.
fact    byte    "Factorial: "
usage   byte    "Usage: fact.exe <num>"
newln   byte    0DH, 0AH        ; Carriage return and line feed.
handle  qword   ?               ; 64-bit storage for Windows HANDLE (returned by GetStdHandle).
num     dword   ?               ; 32-bit output variable for WriteConsoleA character count.
argc    dword   ?               ; 32-bit storage for the argument count returned by CommandLineToArgvW.
argv    qword   ?               ; 64-bit storage for the pointer to the argv array (LPWSTR*).

        .code
IntToStr proc
        push    RDI             ; Preserve caller's RDI value on the stack.
        lea     RDI, buf        ; Load address of 'buf' buffer into RDI register.
        add     RDI, lengthof buf - 1 ; Adjust pointer to end of 'buf' buffer.
        mov     R10, 10         ; Move divisor into R10.

divlp:  xor     RDX, RDX        ; Clear for remainder.
        div     R10             ; Divide RAX by R10 (10).
        add     RDX, '0'        ; Add ASCII '0' value to remainder in RDX to convert from integer to ASCII value.
        mov     [RDI], DL       ; Move one byte of RDX (DL) into RDI (RDI points to 'buf' buffer).
        dec     RDI             ; Decrement RDI; we are writing to the buffer in reverse order (starting at the end).
        test    RAX, RAX        ; Is RAX zero?
        jnz     divlp           ; No; restart loop.
        lea     RAX, [RDI + 1]  ; Return value is stored in RAX. RAX + 1 because RDI was decremented before testing RAX for zero.
        pop     RDI             ; Restore RDI.
        ret
IntToStr endp

StrToInt proc
        xor     RAX, RAX

start:  movzx   RDX, word ptr [RCX] ; Move wchar with zero-extend into RDX.
        test    RDX, RDX        ; Is RDX zero?
        jz      finish          ; Yes; return.
        sub     RDX, '0'        ; Subtract ASCII '0' value to convert from char to integer.
        imul    RAX, RAX, 10    ; Multiply the current accumulated value by 10 to shift its decimal place left before adding the next digit.
        add     RAX, RDX        ; Add the newly parsed digit (0-9) into the shifted accumulator to form the next partial value.
        add     RCX, 2          ; Advance pointer to next wide character (wchar = 2 bytes).
        jmp     start

finish: ret
StrToInt endp

Factorial proc
        mov     RAX, 1          ; Initialize factorial result to 1. RAX will hold the running factorial result.
        cmp     RCX, 1          ; Check if RCX is less than or equal to 1 (fnum); return if true.
        jle     finish

start:  imul    RAX, RCX        ; Multiply accumulator (RAX) by current RCX. RCX holds the value of 'fnum' initially.
        dec     RCX             ; Decrement loop counter RCX (fnum) by 1.
        cmp     RCX, 1          ; Is RCX (fnum) still greater than 1? If so, continue multiplying.
        jg      start

finish: ret
Factorial endp

main    proc
        sub     RSP, 40         ; Create shadow space for 4 arguments (32 shadow + 8 alignment).

        mov     RCX, STD_OUTPUT_HANDLE ; Move STDOUT handle to RCX to be used by GetStdHandle call.
        call    GetStdHandle    ; Receive console handle.
        mov     handle, RAX     ; Store console handle.

        call    GetCommandLineW
        mov     RCX, RAX        ; LPWSTR cmdline.
        lea     RDX, argc       ; int argc.

        call    CommandLineToArgvW
        cmp     argc, 2         ; Was a second arg provided?
        jne     error           ; No; Exit.
        mov     argv, RAX       ; LPWSTR* argv.
        mov     RCX, [argv]     ; Point to argv array in RCX.
        mov     RCX, [RCX+8]    ; Point to argv[1] (skip program name).

        call    StrToInt        ; Convert the string in argv[1] to an integer to use in factorial calculation.
        mov     RCX, RAX        ; Move number to calculate the factorial of into RCX register.
        call    Factorial       ; Store factorial integer in RAX register for division in IntToStr.
        call    IntToStr        ; Convert the integer in RAX to a string in 'buf' buffer.

        msgOut  fact            ; Write to console.
        msgOut  buf
        msgOut  newln

exit:   xor     RCX, RCX        ; Exit code 0.
        call    ExitProcess
        add     RSP, 40         ; Restore "shadow space" on stack (never reached; ExitProcess does not return).

error:  msgOut  usage           ; Write error to console.
        msgOut  newln
        jmp exit

main    endp
        end

; x86-64 Assembly program to display CPU name and logical processor cores (threads)
; Compile with: nasm -f win64 processor_info.asm -o processor_info.obj
; Link with: link processor_info.obj user32.lib kernel32.lib /subsystem:windows /entry:main /out:processor_info.exe /LARGEADDRESSAWARE:NO

section .data
    msg_title      db 'Processor Information', 0        ; Title for the message box.
    intro_line     db 'Processor:', 0xA, 0              ; Introductory line with newline (0xA). Length = 16 bytes including newline.
    cpu_name       db 48 dup(0)                         ; Buffer for CPU brand string (fetched via CPUID).
    cpu_name_end db 0                                   ; Null terminator for CPU name.
    cores_label    db 'Logical Cores: ', 0              ; Label for logical processors. Length = 15 bytes.

section .bss
    sysinfo        resb 48                              ; Reserved space for SYSTEM_INFO structure.
    final_msg      resb 256                             ; Buffer for the complete formatted message. (Size should be enough for intro + cpu name + cores info)

section .text
extern MessageBoxA
extern GetSystemInfo
extern ExitProcess

global main
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32                                         ; Shadow space for function calls.

    ; Fetch CPU brand string using CPUID.
    mov eax, 0x80000002                                 ; Load the first part of the CPU brand string identifier into EAX.
    cpuid                                               ; Execute CPUID instruction, filling EAX, EBX, ECX, EDX.
    mov [cpu_name], eax                                 ; Store the first 16 bytes of the brand string in the buffer.
    mov [cpu_name+4], ebx
    mov [cpu_name+8], ecx
    mov [cpu_name+12], edx

    mov eax, 0x80000003                                 ; Load the second part identifier into EAX.
    cpuid
    mov [cpu_name+16], eax                              ; Store the next 16 bytes in the buffer.
    mov [cpu_name+20], ebx
    mov [cpu_name+24], ecx
    mov [cpu_name+28], edx

    mov eax, 0x80000004                                 ; Load the third part identifier into EAX.
    cpuid
    mov [cpu_name+32], eax                              ; Store the last 16 bytes in the buffer.
    mov [cpu_name+36], ebx
    mov [cpu_name+40], ecx
    mov [cpu_name+44], edx

    mov byte [cpu_name_end], 0                          ; Ensure CPU name is null-terminated.

    ; Get logical processor count.
    lea rcx, [sysinfo]
    call GetSystemInfo
    mov eax, [sysinfo + 32]                             ; dwNumberOfProcessors (offset 32 on x64). Store count in EAX.
    mov r11d, eax                                       ; Preserve core count in R11D.

    ; Build the final message in final_msg buffer.
    lea rdi, [final_msg]                                ; RDI = destination pointer (start of final_msg).

    ; 1. Copy the introductory line.
    lea rsi, [intro_line]                               ; RSI = source pointer (intro_line).
    mov rcx, 11                                         ; Length of "Processor:\n" = 11.
    rep movsb                                           ; Copy string. RDI now points after the copied intro line.

    ; 2. Find the actual end of the fetched CPU name in cpu_name buffer.
    lea rsi, [cpu_name]                                 ; RSI = pointer to start of cpu_name.
    mov r10, rsi                                        ; R10 = also pointer to start of cpu_name.
.find_cpu_end:
    mov bl, [rsi]
    test bl, bl
    jz .cpu_end_found
    inc rsi                                             ; RSI moves forward, eventually pointing to the null terminator or buffer end.
    cmp rsi, cpu_name+48
    jl .find_cpu_end
.cpu_end_found:
    ; RSI now points to the null terminator or cpu_name+48
    ; R10 points to the start of cpu_name

    ; 3. Calculate length and copy the CPU name to final_msg.
    mov rcx, rsi                                        ; Copy end pointer (from RSI) to RCX temporarily.
    sub rcx, r10                                        ; RCX = end_pointer - start_pointer = length of CPU name string.
    mov rsi, r10                                        ; Set RSI back to the start address of cpu_name (which we saved in R10).
    rep movsb                                           ; Copy CPU name. RDI points after the copied name in final_msg.

    ; 4. Append a newline character after the CPU name.
    mov byte [rdi], 0xA
    inc rdi                                             ; Advance destination pointer.

    ; 5. Append the "Logical Cores: " label.
    lea rsi, [cores_label]                              ; RSI = source pointer (cores_label).
    mov rcx, 15                                         ; Length of "Logical Cores: " = 15.
    rep movsb                                           ; Copy label. RDI points after the label.

    ; 6. Convert and append processor count (from R11D).
    mov eax, r11d                                       ; Restore core count into EAX.
    mov ebx, 10                                         ; Divisor for decimal conversion.
    xor edx, edx                                        ; Clear EDX for division.
    div ebx                                             ; EAX = quotient (tens), EDX = remainder (units).

    test eax, eax                                       ; Check if tens digit exists (quotient > 0).
    jz .single_digit                                    ; If not, jump to handle only the units digit.
    add al, '0'                                         ; Convert tens digit (quotient) to ASCII.
    mov [rdi], al                                       ; Store ASCII tens digit in final_msg.
    inc rdi                                             ; Advance destination pointer.
.single_digit:
    add dl, '0'                                         ; Convert units digit (remainder) to ASCII.
    mov [rdi], dl                                       ; Store ASCII units digit in final_msg.
    inc rdi                                             ; Advance destination pointer.

    ; 7. Null-terminate the final message string.
    mov byte [rdi], 0

    ; Display the message box using the final_msg buffer.
    xor ecx, ecx                                        ; hWnd = NULL.
    lea rdx, [final_msg]                                ; RDX = pointer to the text (our final_msg).
    lea r8, [msg_title]                                 ; R8 = pointer to the title.
    xor r9d, r9d                                        ; R9D = uType = MB_OK (0).
    call MessageBoxA

    ; Exit the program cleanly (unchanged).
    xor ecx, ecx                                        ; Set exit code to 0.
    call ExitProcess                                    ; Terminate process.
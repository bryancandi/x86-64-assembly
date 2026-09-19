;====================================================================
; Search buffer for a labeled quoted string (e.g. PRETTY_NAME="...")
; and print its value.
;
; Two step process:
;   1. Locate the label text and first quote, the value begins
;      immediately after it.
;   2. Scan forward to closing quote (or nl/EOF) to determine the
;      value length.
;====================================================================

bits 64
default rel

section .bss
buf:        resb    4096
len_buf:    equ     $ - buf
str_start:  resq    1
str_len:    resq    1

section .rodata
search:     db      'PRETTY_NAME="'
len_search: equ     $ - search
pretty:     db      ' PRETTY_NAME="Debian GNU/Linux forky/sid" NAME=""'
len_pretty: equ     $ - pretty
str_nf:     db      'Unknown'
len_str_nf: equ     $ - str_nf

section .text
global _start
_start:
    ; copy "pretty name" into buffer
    lea     rsi, [pretty]
    lea     rdi, [buf]
    mov     rcx, len_pretty
    cld
    rep movsb

    ; isolate search string: PRETTY_NAME="
    ; r8 will contain the number of characters to skip to reach quoted value
    xor     r8, r8              ; counter within buffer
    xor     r9, r9              ; counter within search string
    mov     rcx, len_search     ; 13 characters in search string         
.search_start_loop:
    cmp     r8, len_buf         ; end of buffer?
    jz      .not_found
    mov     rax, [buf + r8]
    cmp     al, [search + r9]
    jne     .next_char
    inc     r8
    inc     r9
    cmp     r9, rcx             ; all characters matched?
    jz      .found_start
    jmp     .search_start_loop
.next_char:
    xor     r9, r9              ; reset search string counter
    inc     r8                  ; advance buffer to continue search
    jmp     .search_start_loop
.found_start:
    mov     [str_start], r8     ; position of the first character inside quotes

    ; scan for closing quote, 10 (newline), and 0 (null/EOF)
    ; r8 will contain the length of the quoted value
.search_end_loop:
    cmp     r8, len_buf
    jz      .not_found
    mov     rax, [buf + r8]
    cmp     al, '"'             ; closing quote
    jz      .found_end
    cmp     al, 10              ; newline
    jz      .found_end
    cmp     al, 0               ; null/eof
    jz      .found_end
    inc     r8
    jmp     .search_end_loop
.found_end:
    sub     r8, [str_start]     ; value length: total chars scanned minus chars to skip
    mov     [str_len], r8       ; store value length inside the quotes

    ; write buffer to stdout
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, buf
    add     rsi, [str_start]    ; advance pointer past search string
    mov     rdx, [str_len]      ; only print the length of the string inside quotes
    syscall
    jmp     .exit

    ; string not found or error
.not_found:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, str_nf
    mov     rdx, len_str_nf
    syscall

.exit:
    mov     rax, 60
    xor     rdi, rdi
    syscall

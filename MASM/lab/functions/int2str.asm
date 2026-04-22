; char *int2str( char *buffer, size_t size, int value );
; Entry: RCX = buffer ptr (must point to an array at lease 11 bytes long).
;        RDX = size of the array (not the length of the string).
;        R8D = value to convert to a decimal string.
; Exit:  RAX = buffer ptr where the string starts.
int2str:
  ; I would avoid using registers that needed to be preserved.
  ; 'size' isn't the same as 'length'. The last byte is NUL char,
  ; by C standard.
  lea  rcx,[rcx + rdx - 1]
  mov  byte [rcx],0 ; put the NUL char in the string.

  mov  eax, r8d   ; dividend.
  mov  r8d, 10    ; divisor.
.loop:
  dec  rcx
  xor  edx, edx   ; unsigned division, so zero EDX.
  div  r8d
  add  edx,'0'    ; EDX to avoid partial register update stalls.
  mov  [rcx],dl   ; store the remainder + '0' in the buffer.
  test eax, eax   ; quotient is zero?
  jnz  .loop      ; no, it is the new dividend then.

  mov  rax, rcx   ; return where the string starts.
  ret
  
includelib kernel32.lib
ExitProcess	proto

        .code
main    proc                    ; Program external name.
        sub	    RSP, 40         ; Reserve "shadow space" on stack.
        mov     RCX, 1          ; Immediate load of register RCX.
        add 	RCX, 100        ; Immediate add to contents of RCX.
        mov	    RDX, 200        ; Register RDX loaded with decimal 200.
        sub	    RCX, RDX        ; Subtract register RDX from RCX.
        call    ExitProcess     ; Return CPU control to Windows.
main    endp
        end

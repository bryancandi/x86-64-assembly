## WinDbg - Windows Debugger

### Microsoft Macro Assembler (MASM)

To assemble 64-bit assembly code while generating debugging information use /Zi flag:

```powershell
ml64.exe .\main.asm /Zi /link /SUBSYSTEM:console /ENTRY:main
```

- Run WinDbg

- Load .exe file

In command window:

- `bp main` - set breakpoint (e.g. main)
- `g` - go

Display memory (buffers, etc.):

- `d [Options] [Range] ` e.g. `da 7ff6914e4000`
- `da` - ASCII characters
- `db` - Byte values and ASCII characters
- `dc` - Double-word values (4 bytes) and ASCII characters
- `qd` - Quad-word values (8 bytes)
- `du` - Unicode characters
- `dW` - Word values (2 bytes) and ASCII characters
- [View all](https://learn.microsoft.com/en-us/windows-hardware/drivers/debuggercmds/d--da--db--dc--dd--dd--df--dp--dq--du--dw--dw--dyb--dyd--display-memor)


Step in/over, etc.

All WinDbg [Debugger Commands](https://learn.microsoft.com/en-us/windows-hardware/drivers/debuggercmds/debugger-commands)

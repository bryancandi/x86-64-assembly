## WinDbg - Windows Debugger

### Microsoft Macro Assembler (MASM)

To assemble 64-bit assembly code while generating debugging information use /Zi flag:

```powershell
ml64.exe .\main.asm /Zi /link /SUBSYSTEM:console /ENTRY:main
```

- Run WinDbg

- Load .exe file

- In command window:
    - `bp main` - set breakpoint (e.g. main)
    - `g` - go

- Step in/over, etc.

All WinDbg commands:\
https://learn.microsoft.com/en-us/windows-hardware/drivers/debuggercmds/debugger-commands

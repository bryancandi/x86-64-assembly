## Debugging Assembly with GNU gdb - Quick Reference

### Breakpoints and Monitoring

`gdb ./prog` &mdash; start debugger from terminal.

`layout regs` &mdash; open register layout (TUI mode).

`break _start` &mdash; set a breakpoint at `_start`.

`run` &mdash; begin program execution.

`si` or `stepi` &mdash; step one instruction.

### Additional Useful Commands

`display *(long long*)&var` &mdash; watch variable `var` as a 64-bit value.

`display $rcx` &mdash; watch a specific register, such as `rcx`.

`info registers` &mdash; view all registers.

`x/g &var` &mdash; examine variable `var`.

`print &var` &mdash; check address of variable `var`.

`stepi [N]` &mdash; step N instructions.

`ni` or `nexti` &mdash; step one instruction (proceed through subroutine calls).

`x/i $rip` &mdash; examine instruction at `rip`.

`set $rax = 5` &mdash; manually modify a register, such as `rax`.

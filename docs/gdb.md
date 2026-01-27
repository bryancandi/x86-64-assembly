## Debugging with GNU gdb

### GDB register layout

`gdb ./source` &mdash; start debugger from terminal.

`layout regs`

`break _start` &mdash; set a breakpoint at `_start`.

`run` &mdash; begin program execution.

`si` or `stepi` &mdash; single-instruction stepping.

### Other useful commands

`display *(long long*)&var` &mdash; watch variable `var` as a 64-bit value.

`display $rcx` &mdash; watch a specific register, such as `rcx`.

`info registers` &mdash; view all registers.

`x/g &var` &mdash; examine variable `var`.

`print &var` &mdash; check address of variable `var`.

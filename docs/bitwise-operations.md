### Assembly Bitwise Operations

| Instruction | Binary Number Operations |
| :----:      | ----                     |
| AND         | Return a **1** in each bit where both of two compared bits are a **1**. Example: **1010 AND 1000** becomes **1000**. |
| OR          | Return a **1** in each bit where either of two compared bits are a **1**. Example: **1010 OR 0101** becomes **1111**. |
| XOR         | Return a **1** in each bit only when the two compared bits differ, otherwise return a **0**. Examples: **1110 XOR 0100** becomes **1010** and **1111 XOR 1111** becomes **0000**. |
| NOT         | Return a **1** in each bit that is **0**, and return a **0** in each bit that is **1** (reversing the bit values). Example: **NOT 1100** becomes **0011**. |
| SHL         | Shift Left: Move all bits a specified number of positions to the left, inserting 0s on the right. Example: **SHL 00011000, 1** becomes **00110000**. |
| SHR         | Shift Right: Move all bits a specified number of positions to the right, inserting 0s on the left. |
| SAL         | Shift Arithmetic Left (same as SHL on x86): Move all bits left, inserting 0s on the right. |
| SAR         | Shift Arithmetic Right: Move each bit except the **MSB** (sign bit) a specified number of bits to the right, inserting copies of the **MSB** on the left. Example: **SAR 11100000, 1** becomes **11110000**. |
| ROL         | Rotate Left: Move all bits a specified number of positions to the left; bits shifted out of the left end re-enter on the right. Example: **ROL 10011000, 1** becomes **00110001**. |
| ROR         | Rotate Right: Move all bits a specified number of positions to the right; bits shifted out of the right end re-enter on the left. Example: **ROR 10011000, 1** becomes **01001100**. |
| RCL         | Rotate Carry Left: Rotate left as **ROL**, treating the carry flag as an extra bit in the rotation. 8-bit example (*RCL 10011000, 1*): CF=**1** **10011000** becomes CF=**1** **00110001**. **MSB** moves into **CF**, **CF** moves into **LSB**. |
| RCR         | Rotate Carry Right: Rotate right as **ROR**, treating the carry flag as an extra bit in the rotation. 8-bit example (*RCR 10011000, 1*): **10011000** CF=**1**, becomes **11001100** CF=**0**. **LSB** moves into **CF**, **CF** moves into **MSB**. |

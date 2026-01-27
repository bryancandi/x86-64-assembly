## Assembly Data Types

### Integer Data Sizes

| Name  | Bits  | Bytes | Unsigned Range | Signed Range      |
| ----  | ----: | ----: | ----:          | ----:             |
| BYTE  | 8     | 1     | 0 to 255       | -128 to 127       |
| WORD  | 16    | 2     | 0 to 65,535    | -32,768 to 32,767 |
| DWORD | 32    | 4     | 0 to 2³²−1     | −2³¹ to 2³¹−1     |
| QWORD | 64    | 8     | 0 to 2⁶⁴−1     | −2⁶³ to 2⁶³−1     |

### Assembler Data Directives

Assemblers use different syntax to define data of the same size in memory.

| Size    | MASM    | NASM | Bytes |
| ----    | ----    | ---- | ----: |
| 8-bit   | `BYTE`  | `db` |     1 |
| 16-bit  | `WORD`  | `dw` |     2 |
| 32-bit  | `DWORD` | `dd` |     4 |
| 64-bit  | `QWORD` | `dq` |     8 |
| 80-bit  | `TBYTE` | `dt` |    10 |
| 128-bit | `OWORD` | `do` |    16 |

### Denoting Numbers in Assembly

- Decimal: **21**
- Binary: **00010101b**
- Hexadecimal (MASM-style): **15h**
- Hexadecimal (C / NASM-style): **0x15**

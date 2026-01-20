## Binary Numbers

- **Unsigned binary numbers** &mdash; positive values only.

- **Signed binary numbers** &mdash; positive or negative values.

- **MSB** *(Most Significant Bit)* is the left-most bit.

- **LSB** *(Least Significant Bit)* is the right-most bit.

### 1 Byte (8-bit) binary number minimum and maximum values:

|          | Minimum | Maximum |
| ----     | ----:   | ----:   |
| Unsigned | 0       | 255     |
| Signed   | -128    | 127     |

### Unsigned Binary Example:

| 1    | 1    | 1    | 1    | 1    | 1    | 1    | 1    |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |

**255** in decimal.

### Signed Binary Example:

Signed numbers use two’s complement representation, where the MSB (most significant bit) indicates the sign.
- **0** indicates a positive number.
- **1** indicates a negative number.

| 0     | 1    | 1    | 1    | 1    | 1    | 1    | 1     |
| ----: | ---- | ---- | ---- | ---- | ---- | ---- | :---- |
| MSB   |      |      |      |      |      |      |       |

**+127** in decimal.

To convert a negative signed binary number to decimal, invert all bits, then add **1** (two’s complement). Then negate the decimal result.

| 1     | 1    | 1    | 1    | 1    | 1    | 1    | 0     |
| ----: | ---- | ---- | ---- | ---- | ---- | ---- | :---- |
| MSB   |      |      |      |      |      |      | LSB   |

*Inverted:*

| 0     | 0    | 0    | 0    | 0    | 0    | 0    | 1     |
| ----: | ---- | ---- | ---- | ---- | ---- | ---- | :---- |
| MSB   |      |      |      |      |      |      | LSB   |

*Add 1; negate the decimal result:*

| 0     | 0    | 0    | 0    | 0    | 0    | 1    | 0     |
| ----: | ---- | ---- | ---- | ---- | ---- | ---- | :---- |
| MSB   |      |      |      |      |      |      | LSB   |

**-2** in decimal.

### Memory Addressing

| Address  | MSB   |      |      |      |      |      |      | LSB   |
| ----     | ----: | ---- | ---- | ---- | ---- | ---- | ---- | :---- |
| 00000000 | 1     | 0    | 0    | 1    | 1    | 1    | 0    | 1     |
| 00000001 | 1     | 1    | 1    | 0    | 0    | 1    | 0    | 0     |
| 00000002 | 0     | 0    | 1    | 1    | 0    | 1    | 1    | 1     |
...

### Binary Number Lengths:

**Bit**:&nbsp;&nbsp;`0` or `1`\
**Nibble**:&nbsp;&nbsp;`0101`\
**Byte**:&nbsp;&nbsp;`01010101`
- A **nibble** *(or nybble)* is a group of 4-bits.
- A **byte** is a group of 8-bits.

### Assembly Data Types:

**BYTE** &mdash; Byte (8-bits) range 0 to 255, or -128 to 127\
**WORD** &mdash; Word (16-bits) range 0 to 65,535, or -32,768 to 32,767\
**DWORD** &mdash; Double word (32-bits) 0 to 2<sup>32</sup>-1, or -2<sup>31</sup> to 2<sup>31</sup>-1\
**QWORD** &mdash; Quad word (64-bits) 0 to 2<sup>64</sup>-1, or -2<sup>63</sup> to 2<sup>63</sup>-1

### Denoting Numbers in Assembly:

Decimal:&nbsp;&nbsp;**21**\
Binary:&nbsp;&nbsp;**00010101b**\
Hexadecimal:&nbsp;&nbsp;**15h**

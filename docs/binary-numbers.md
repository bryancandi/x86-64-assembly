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

Signed numbers use two’s complement representation, where the MSB indicates the sign.
- **0** indicates a positive number.
- **1** indicates a negative number.

| 0     | 1    | 1    | 1    | 1    | 1    | 1    | 1     |
| ----: | ---- | ---- | ---- | ---- | ---- | ---- | :---- |
| MSB   |      |      |      |      |      |      |       |

**+127** in decimal.

To convert a negative signed binary number to decimal, invert all bits, then add **1** (two’s complement). Then negate the decimal result.

| 1     | 1    | 1    | 1    | 1    | 1    | 1    | 0    |
| ----: | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| MSB   |      |      |      |      |      |      |      |

*Inverted:*

| 0     | 0    | 0    | 0    | 0    | 0    | 0    | 1    |
| ----: | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| MSB   |      |      |      |      |      |      |      |

*Add 1; negate the decimal result:*

| 0     | 0    | 0    | 0    | 0    | 0    | 1    | 0    |
| ----: | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| MSB   |      |      |      |      |      |      |      |

**-2** in decimal.

### Memory Addressing Example:

| Address  | MSB   |      |      |      |      |      |      | LSB   |
| ----     | ----: | ---- | ---- | ---- | ---- | ---- | ---- | :---- |
| 00000000 | 1     | 0    | 0    | 1    | 1    | 1    | 0    | 1     |
| 00000001 | 1     | 1    | 1    | 0    | 0    | 1    | 0    | 0     |
| 00000002 | 0     | 0    | 1    | 1    | 0    | 1    | 1    | 1     |
| 00000003 | 0     | 1    | 0    | 1    | 0    | 1    | 0    | 1     |  
...

### Binary Number Lengths:

Bit: **0** or **1**\
Nibble: **0101**\
Byte: **01010101**
- A **nibble** *(or nybble)* is a group of 4-bits.
- A **byte** is a group of 8-bits.

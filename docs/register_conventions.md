### Windows x64 Calling Convention

|**Register**|**Hardware**       |**Calling Convention** |**Volatility**|
| :----:     | :----             | :----                 | :----        |
| RAX        | Accumulator       | Function Return Value | Volatile     |
| RBX        | Base              |                       | Non-volatile |
| RCX        | Counter           | 1st Function Argument | Volatile     |
| RDX        | Data              | 2nd Function Argument | Volatile     |
| RSI        | Source Index      |                       | Non-volatile |
| RDI        | Destination Index |                       | Non-volatile |
| RBP        | Base Pointer      |                       | Non-volatile |
| RSP        | Stack Pointer     |                       | Non-volatile |
| R8         | General-purpose   | 3rd Function Argument | Volatile     |
| R9         | General-purpose   | 4th Function Argument | Volatile     |
| R10        | General-purpose   |                       | Volatile     |
| R11        | General-purpose   |                       | Volatile     |
| R12        | General-purpose   |                       | Non-volatile |
| R13        | General-purpose   |                       | Non-volatile |
| R14        | General-purpose   |                       | Non-volatile |
| R15        | General-purpose   |                       | Non-volatile |

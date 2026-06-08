### Windows x64 Calling Convention

|**Register**|**Description**    |**Role**               |**Volatility**|
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

### System V AMD64 Calling Convention (Linux)

|**Register**|**Description**    |**Role**               |**Volatility**|
| :----:     | :----             | :----                 | :----        |
| RAX        | Accumulator       | Function Return Value | Volatile     |
| RBX        | Base              |                       | Non-volatile |
| RCX        | Counter           | 4th Function Argument | Volatile     |
| RDX        | Data              | 3rd Function Argument | Volatile     |
| RSI        | Source Index      | 2nd Function Argument | Volatile     |
| RDI        | Destination Index | 1st Function Argument | Volatile     |
| RBP        | Frame Pointer     |                       | Non-volatile |
| RSP        | Stack Pointer     |                       | Non-volatile |
| R8         | General-purpose   | 5th Function Argument | Volatile     |
| R9         | General-purpose   | 6th Function Argument | Volatile     |
| R10        | General-purpose   |                       | Volatile     |
| R11        | General-purpose   |                       | Volatile     |
| R12        | General-purpose   |                       | Non-volatile |
| R13        | General-purpose   |                       | Non-volatile |
| R14        | General-purpose   |                       | Non-volatile |
| R15        | General-purpose   |                       | Non-volatile |

- Volatile: a function can modify the contents of the register without preserving its value.
    - Volatile registers are caller saved **if needed**. The value is not guaranteed to survive function calls.

- Non-volatile: a function must preserve a register’s value if it modifies that value.
    - Non-volatile registers are callee saved. The called function is responsible for preserving the register, so the caller can rely on its value being intact after the call returns.

### x86-64 Processor State Flags (RFLAGS register)

| **Flag Alias** | **CPU Flag Name**    | **1 Indicates**     | **0 Indicates**     |
| ----           | ----                 | ----                | ----                |
| AC             | AF (Auxiliary Carry) | Auxiliary Carry     | No Auxiliary Carry  |
| CY             | CF (Carry)           | Carry               | No Carry            |
| EI             | IF (Interrupt Flag)  | Interrupts Enabled  | Interrupts Disabled |
| OV             | OF (Overflow)        | Signed Overflow     | No Overflow         |
| PE             | PF (Parity)          | Even Parity         | Odd Parity          |
| PL             | SF (Sign)            | Negative            | Positive            |
| UP             | DF (Direction)       | Decrement / Down    | Increment / Up      |
| ZR             | ZF (Zero)            | Result is Zero      | Result Is Not Zero  |

- **Carry Flag** &mdash; This flag gets set if the result of the previous unsigned arithmetic operation was too large to fit within the register.
- **Overflow Flag** &mdash; This flag gets set if the result of the previous signed arithmetic operation changes the sign bit (sign overflow).
- **Sign Flag** &mdash; This flag gets set if the result of the previous instruction was a negative value.
- **Zero Flag** &mdash; This flag gets set if the result of the previous instruction was zero.

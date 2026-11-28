\# Full-Duplex UART Design and Verification



A modular UART transmitter and receiver implemented in Verilog HDL.



This project was developed as part of my ASIC design studies,

covering RTL design, finite state machines, serial communication,

and functional verification using ModelSim.



\## Features



\- Full-duplex UART communication

\- 8-bit serial data transmission (LSB first)

\- Configurable even and odd parity

\- Optional parity enable

\- RX oversampling with configurable prescale

\- Three-sample majority voting

\- Start-bit glitch detection

\- Stop-bit error detection

\- Asynchronous active-low reset



\## Architecture



\### UART Transmitter

\- TX Finite State Machine

\- Serializer

\- Parity Generator

\- Output Multiplexer



\### UART Receiver

\- RX Finite State Machine

\- Edge/Bit Counter

\- Data Sampling

\- Deserializer

\- Start-Bit Checker

\- Parity Checker

\- Stop-Bit Checker



\## Verification



A self-checking Verilog testbench was developed to verify

simultaneous transmission and reception.



| Test | TX Data | RX Data | Parity | Result |

|------|---------|---------|--------|--------|

| 1 | A5 | 3C | Disabled | PASS |

| 2 | 55 | 96 | Even | PASS |

| 3 | C3 | 69 | Odd | PASS |



All three full-duplex test scenarios passed in ModelSim.



The testbench verifies transmitted data, stop bits,

optional parity, and received parallel data.



Current test coverage uses prescale = 8.

Additional error-injection and prescale tests are planned.



\## Tools



\- Verilog HDL

\- ModelSim

\- Git / GitHub



\## Simulation



1\. Compile all Verilog files inside rtl/.

2\. Compile tb/TB\_UART.v.

3\. Load the testbench module: vsim work.UART\_TB

4\. Run the simulation: run -all



\## Project Status



RTL implementation completed.

Initial full-duplex functional simulation passed.


# UART Loopback Communication System using Verilog HDL

A UART (Universal Asynchronous Receiver Transmitter) communication system designed and implemented in Verilog HDL using a modular RTL architecture. The project was simulated, verified, and deployed on the Basys3 FPGA board for real-time hardware validation.

The design implements UART transmission and reception using separate FSM-based TX and RX modules connected in loopback configuration. Data transmitted serially is received back correctly and verified through simulation as well as FPGA hardware testing.

## UART Configuration

| Parameter | Value |
|---|---|
| Clock Frequency | 100 MHz |
| Baud Rate | 9600 |
| Data Bits | 8 |
| Stop Bits | 1 |
| Parity | None |

---

The baud rate generator was designed for **9600 baud communication** using the 100 MHz Basys3 onboard clock.

---

# Project Overview

This project implements a complete UART communication system using Verilog HDL. The transmitter converts 8-bit parallel data into serial format, while the receiver reconstructs the serial stream back into parallel data.

The project includes:

| File | Description |
|---|---|
| `UART.v` | UART Top Module |
| `UARTtb.v` | Simulation Testbench |
| `top.v` | FPGA Hardware Top Module |
| `transmittor.v` | UART transmitter |
| `receiver.v` | UART receiver |
| `baud_rate_generator.v` | Baud generator |
| `displaymux.v` | Display module |
| `seg7_display.v` | 7-segment display |
| `segment.v` | Seven segment convertor |

The system was:
- Designed using Verilog HDL
- Simulated using Icarus Verilog and GTKWave
- Synthesized and implemented using Xilinx Vivado
- Verified on the Basys3 FPGA board
- Tested using PuTTY serial terminal communication

---


# Key Features

- UART Transmitter and Receiver implementation
- FSM-based serial communication
- 9600 baud rate operation
- Standard 8N1 UART frame format
- Modular RTL design
- Separate TX and RX baud tick generation
- Loopback communication testing
- Push-button triggered transmission
- LED and seven-segment display interfacing
- Functional simulation testbench
- FPGA hardware verification on Basys3

---

# Simulation Verification

The testbench transmits multiple 8-bit values through the UART transmitter and verifies that the receiver reconstructs the same data correctly and preocessed output data.

The UART_01.v module follows the data flow: ``` TX → [wire] → RX → processed_data → dataout ```
The UART_01.v module follows the data flow: ``` TX ──[wire]──► RX ──► process ──► TX again ──► dataout```

For simulation purpose update txfinval to 16 and rxfinval to 1 in baud generator (`baud_rate_generator.v`)

Simulation was performed using:
- Icarus Verilog
- GTKWave

The transmitted and received outputs matched successfully for all tested values.

---

# FPGA Hardware Verification

The design was successfully deployed on the Basys3 FPGA board using Xilinx Vivado.

UART communication was tested using the PuTTY serial terminal. Data transmitted from the FPGA was received correctly, while received UART data was displayed using onboard LEDs and seven-segment displays for real-time verification.

---

# Tools and Technologies Used

- Verilog HDL
- Xilinx Vivado
- Icarus Verilog
- GTKWave
- Basys3 FPGA Board
- PuTTY Serial Terminal

# Verilog-Parametric-FIFO
Parameterized Synchronous FIFO in Verilog
# Parameterized Synchronous FIFO

A fully parameterized, synchronous First-In-First-Out (FIFO) memory buffer written in Verilog HDL. This module is essential for data buffering and clock domain synchronization in digital hardware design.

## Features
- **Parameterized Design:** Both data width (DATA_WIDTH) and depth (DEPTH_ADDR) can be overridden during instantiation, making the IP core highly reusable across different FPGA/ASIC projects.
- **Simultaneous R/W:** The internal logic uses a concatenated case statement to safely handle simultaneous read and write operations occurring on the same clock edge without corrupting the count register.
- **Status Flags:** Combinational outputs for full and empty flags to prevent memory overflow and underflow from external controllers.

## Implementation Details
The FIFO uses a circular pointer architecture. An extra bit is utilized in the count register to distinguish between the truly full state and the empty state, which would otherwise have identical read/write pointer alignments.

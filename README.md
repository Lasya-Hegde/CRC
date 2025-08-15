# CRC
Cyclic Redundancy Check

Description:
This Verilog module implements a Cyclic Redundancy Check (CRC) error detection mechanism using a parameterized hardware design.

Functionality:
-> Accepts an input data word (data_in) of n bits (data + CRC bits) and a generator polynomial (G) of m bits.
-> Sequentially processes the input data through a finite state machine (FSM) to perform polynomial division in hardware.
-> At the end of computation, the remainder is checked — if non-zero, it indicates a CRC error.

Operation Flow:
-> Initialization (s0): Wait for the start signal and load the initial x and y registers based on the most significant bit of the input.

Iteration (s1–s6):
-> Compare the partial remainder (x_cur) with the generator polynomial (G).
-> If greater/equal, perform XOR (division step) and shift left (s4); otherwise, shift left without XOR (s5).
-> Append the next bit from y_cur and repeat until all bits are processed.

Completion (s3):
-> If the final remainder (R_cur) is zero, set error = 0 (no error).
-> Otherwise, set error = 1 (CRC check failed).
-> Assert done to indicate completion.

Outputs:
-> error: Indicates whether the CRC check passed or failed.
-> done: Signals the end of the CRC computation.
-> new: 2-bit status signal {done, error} for compact status reporting.

Key Features:
-> Fully parameterized:
-> n: Total number of bits (data + CRC bits).
-> m: Generator polynomial bit-width.
-> FSM-based sequential architecture (states s0 to s6).
-> Synthesizable for ASIC or FPGA targets.


The design is written in synthesizable Verilog, suitable for ASIC implementation, and have been synthesized using the saed90nm technology node in Cadence Genus.
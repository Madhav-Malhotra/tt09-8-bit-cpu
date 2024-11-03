/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements RAM Module for 8-bit CPU
 *
 * Notes:
 * 1. Currently, the NAND gate that uses the clock signal and control signal (R1) is not implemented.
 *    This part of the circuit is currently hard-coded as active high (1), and the corresponding switch is set to active low (0).
 * 2. The DIP switches used for programming are currently all set to 0. This needs to be implemented, or an alternative workaround should be found.
 */

module ram (
    input wire [3:0] address,   // 4-bit address input for selecting memory locations (A0 - A3 in schematic)
    input wire pc_in,           // Select line for the multiplexers (PROG in schematic)
    input wire OE_n,            // Output Enable (active low) for the bus transceiver (R1 in schematic)
    inout [7:0] RAM_BUS         // 8-bit RAM data bus (BUS_7 - BUS_0 in schematic)
);

    // Instantiating two DM74LS157 quad 2-to-1 multiplexers for controlling write enable signals
    wire [3:0] mux_out_we, mux_out_rl, mux_out_rh;

    // MUX for generating the Write Enable (WE) signal
    quad_2_1_mux mux_we (
        .strobe(1'b0),           // Strobe line is active low (disabled by default)
        .select(pc_in),          // Selects between inputs A and B based on the pc_in signal
        .A(4'b0),                // A input for mux_we is set to 0
        .B(4'b0001),             // B input for mux_we controls WE
        .Y(mux_out_we)           // Output of mux_we, with bit 3 controlling WE
    );

    // Write enable signal for RAM modules
    wire WE_n;
    assign WE_n = mux_out_we[3];   // Assigning the most significant bit of mux_out_we as the WE signal

    // Outputs from two RAM modules (lower and upper 4 bits)
    wire [3:0] ram_out_low, ram_out_high;

    // RAM module for lower 4 bits of the address space
    ram_74189 ram_low (
        .CS(1'b0),               // Chip Select (active low)
        .WE(WE_n),               // Write Enable signal from mux_we (active low)
        .A(address),             // Address lines for selecting memory location
        .D(mux_out_rl),          // Data input lines from mux_rl
        .O(ram_out_low)          // Output for the lower 4 bits of the address space
    );

    // RAM module for upper 4 bits of the address space
    ram_74189 ram_high (
        .CS(1'b0),               // Chip Select (active low)
        .WE(WE_n),               // Write Enable signal from mux_we (active low)
        .A(address),             // Address lines for selecting memory location
        .D(mux_out_rh),          // Data input lines from mux_rh
        .O(ram_out_high)         // Output for the upper 4 bits of the address space
    );

    // Instantiating multiplexers for handling connections from RAM_BUS to RAM inputs
    quad_2_1_mux mux_rl (
        .strobe(1'b0),                     // Strobe line (active low, disabled by default)
        .select(pc_in),                    // Selects between inputs A and B based on pc_in
        .A(4'b0),                          // A input for mux_rl (not used in this example)
        .B({RAM_BUS[2], RAM_BUS[3], RAM_BUS[1], RAM_BUS[0]}), // B input mapped to lower 4 bits of RAM_BUS as specified
        .Y(mux_out_rl)                     // Output of mux_rl, connected to D inputs of ram_low
    );

    quad_2_1_mux mux_rh (
        .strobe(1'b0),                     // Strobe line (active low, disabled by default)
        .select(pc_in),                    // Selects between inputs A and B based on pc_in
        .A(4'b0),                          // A input for mux_rh (not used in this example)
        .B({RAM_BUS[6], RAM_BUS[7], RAM_BUS[5], RAM_BUS[4]}), // B input mapped to upper 4 bits of RAM_BUS as specified
        .Y(mux_out_rh)                     // Output of mux_rh, connected to D inputs of ram_high
    );

    // Combining outputs from both RAM modules into an 8-bit bus
    wire [7:0] ram_out_combined;
    assign ram_out_combined = {ram_out_high, ram_out_low};

    // Instantiate a hex inverter to invert the output from the RAM modules
    wire [7:0] inverter_out;
    hex_inverter inverter (
        .A(ram_out_combined),   // Combined 8-bit output from RAM modules
        .Y(inverter_out)        // Inverted output
    );

    // Instantiate the bus transceiver to control data flow between RAM_BUS and the CPU bus
    bus_transceiver transceiver (
        .OE_n(OE_n),            // Output Enable for the transceiver, controlled by R0 in the schematic (active low)
        .DIR(1'b1),             // Direction control (1 = RAM -> Data Bus)
        .A(inverter_out),       // Inverted RAM output connected to the A side
        .B(RAM_BUS)             // RAM data bus connected to the B side
    );

endmodule

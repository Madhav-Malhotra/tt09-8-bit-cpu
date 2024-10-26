/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements ALU logic
 */


module top_level_alu(
   input wire [7:0] A,    // 8-bit input A
    input wire [7:0] B,    // 8-bit input B
    input wire CLK,        // Clock signal
    input wire CLR,        // Clear signal
    input wire SU,         // Control signal for subtract or add
    input wire FI,         // Flag input control
    input wire E0,         // Enable output signal
    output wire [7:0] BUS, // Output bus
    output wire CF,        // Carry flag output
    output wire ZF       // Zero flag output
    );

wire [7:0] b_xor;
 wire [3:0] S1, S2;     // Partial sum outputs for 4-bit adders
    wire C4;               // Carry output from first adder, input to the second adder
    wire [7:0] bus_in;    // Internal bus connection
wire [3:0] intermediate_nor;
wire [1:0] intermediate_and;
wire int_d;


    generate
        genvar i;
        for (i = 0; i < 7; i = i + 1) begin : 
            quad_xor xor (SU, B[i], b_xor[i]);
        end
    endgenerate

    // Instantiate first 4-bit adder
   adder adder1 (
        .A(A[3:0]),
        .B(b_xor[3:0]),
        .C0(SU),            // Use SU as a carry-in for addition or subtraction
        .S(S1),
        .C4(C4)             // Connect to C0 of the second adder
    );

    // Instantiate second 4-bit adder
    adder adder2 (
        .A(A[7:4]),
        .B(b_xor[7:4]),
        .C0(C4),            // Connect C4 from the first adder
        .S(S2),
        .C4(CF)             // Carry out from second adder
    );

    assign bus_in = {S2, S1};

bus_transceiver bus (
    .OE_n(E0),
    .DIR(1),
    .A(bus_in),
    .B(BUS)
);

wire [3:0] intermediate_nor;
wire [1:0] intermediate_and;


quad_nor nor_s1_0 (
    .a(S1[0]),
    .b(S1[1]),
    .y(intermediate_nor[0])
);

quad_nor nor_s1_1 (
    .a(S1[2]),
    .b(S1[3]),
    .y(intermediate_nor[1])
);

quad_nor nor_s2_0 (
    .a(S2[0]),
    .b(S2[1]),
    .y(intermediate_nor[2])
);

quad_nor nor_s2_1 (
    .a(S2[2]),
    .b(S2[3]),
    .y(intermediate_nor[3])
);

quad_and and_nor_0 (
    .a(intermediate_nor[0]),
    .b(intermediate_nor[1]),
    .y(intermediate_and[0])
);

quad_and and_nor_1 (
    .a(intermediate_nor[2]),
    .b(intermediate_nor[3]),
    .y(intermediate_and[1])
);

quad_and and_and (
    .a(intermediate_and[0]),
    .b(intermediate_and[1]),
    .y(int_d)
);


d_register_4b d_reg (
    .CLR(CLR),
    .CLK(CLK),

    .G1_n(FI), //E1
    .G2_n(FI), //E2

    .M(1'b0), //oe1
    .N(1'b0), //oe2

    .D({CF, int_d}), //D, cf connected to D0
    .Q({CF, ZF}) // Q
);




endmodule
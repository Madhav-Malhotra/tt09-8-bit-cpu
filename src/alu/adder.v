/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements N-bit look-ahead carry adder (for DM74LS283 4-bit, )
 */

module adder #(
    parameter N = 4  // Default width of the adder
)(
    input [N-1:0] A,  // N-bit input A
    input [N-1:0] B,  // N-bit input B
    input C0,         // Carry-in
    output [N-1:0] S, // N-bit sum output
    output CN         // Carry-out
);

    // Internal signals
    wire [N-1:0] gen, prop;
    wire [N:0] carry;

    // Generate and Propagate signals
    assign gen = A & B;
    assign prop = A ^ B;

    // Carry chain
    assign carry[0] = C0;
    generate
        genvar i;
        for (i = 1; i < N + 1; i = i + 1) begin : carry_chain
            assign carry[i] = gen[i-1] | (prop[i-1] & carry[i-1]);
        end
    endgenerate

    // Sum calculation
    assign S = prop ^ carry[N-1:0];
    assign CN = carry[N];

endmodule
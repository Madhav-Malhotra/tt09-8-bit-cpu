/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements register A/B (8-bit register)
 */

module regAB_top (
    input wire clk,             // clock input
    inout wire [7:0] bus,       // inout for storing or reading data
    input wire clr,             // resets what's stored in register
    input wire ai_n,            // enables d_register outputs
    input wire ao_n,            // enables bus transceiver connection
    output wire [7:0] A         // 8-bit data stored in register
);
    wire [7:0] A_internal;

    bus_transceiver bus_transceiver_A (
        .OE_n(ao_n),
        .DIR(1'b1),
        .A(A_internal[0:7]),
        .B(bus[0:7])
    );

    d_register d_register_A (
        .CLR(clr),
        .CLK(clk),
        .G1_n(ai_n),
        .G2_n(ai_n),
        .M(1'b0),
        .N(1'b0),
        .D(bus[4:7]),
        .Q(A_internal[3:0])
    );

    d_register d_register_B (
        .CLR(clr),
        .CLK(clk),
        .G1_n(ai_n),
        .G2_n(ai_n),
        .M(1'b0),
        .N(1'b0),
        .D(bus[0:3]),
        .Q(A_internal[7:4])
    );

    assign A = A_internal;

endmodule
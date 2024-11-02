/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements instruction register
 */

module regAB_top (
    input wire clk,             // clock input
    inout wire [7:0] bus,       // inout for storing or reading data
    input wire clr,             // resets what's stored in register
    input wire ii_n,            // enables d_register outputs
    input wire io_n,            // enables bus transceiver connection
    output wire [3:0] I         // 4-bit data stored in register
);
    wire [3:0] I_internal;

    bus_transceiver bus_transceiver_A (
        .OE_n(io_n),
        .DIR(1'b1),
        .A({ {4{1'b0}}, I_internal }),
        .B(bus[0:7])
    );

    d_register d_register_A (
        .CLR(clr),
        .CLK(clk),
        .G1_n(ii_n),
        .G2_n(ii_n),
        .M(1'b0),
        .N(1'b0),
        .D(bus[4:7]),
        .Q(I[0:3])
    );

    d_register d_register_B (
        .CLR(clr),
        .CLK(clk),
        .G1_n(ai_n),
        .G2_n(ai_n),
        .M(1'b0),
        .N(1'b0),
        .D(bus[0:3]),
        .Q(I_internal[3:0])
    );

endmodule
/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements program counter
 */

module pc_top (
    input wire clk,             // clock input
    inout wire [3:0] bus,       // inout for sending or receiving instr idx
    input wire clr_n,           // clears counter (active low)
    input wire ce,              // count enable (active high)
    input wire j_n,             // load enable (active low)
    input wire co_n             // output enable (opposite of clear output)
);
    wire [3:0] bus_internal;

    bus_transceiver bus_transceiver_A (
        .OE_n(co_n),
        .DIR(1'b0),
        .A({ {4{1'b0}}, bus[0:3] }),
        .B({ {4{1'b0}}, bus_internal[0:3] })
    );

    counter_4b counter_4b_A (
        .p_en(ce),  // both p_en and t_en must be digital high to start count
        .t_en(ce),
        .ld_n(j_n), // load enable
        .clk(clk),
        .clr_n(clr_n),
        .data_in(bus[0:3]),
        .data_out(bus_internal[0:3])
    );
    
endmodule
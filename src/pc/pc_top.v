/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements program counter
 */

module pc_top (
    input wire clk,             // clock input
    inout wire [3:0] bus,       // inout for sending or receiving instr idx
    input wire clr_n,           // 
    input wire ce,              //
    input wire j,               //
    input wire co_n             // output enable (opposite of clear output)
);
    wire [3:0] bus_internal;

    bus_transceiver bus_transceiver_A (
        .OE_n(co_n),
        .DIR(1'b0),
        .A({ {4{1'b0}}, bus[0:3] }),
        .B({ {4{1'b0}}, bus_internal[0:3] })
    );

    
    

endmodule
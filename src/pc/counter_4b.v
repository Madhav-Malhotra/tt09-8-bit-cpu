/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements 4-bit binary counter (for DM74LS161)
 */

`include "../common/JK_flipflop.v"

module counter_4b(
    input clk,      // Clock
    input enableP,  // something about parallel counting?
    input enableT,  // something about trickle counting?
    input load,     // 
    input clear,    //
    input [3:0] D,  // Data input (AKA A, B, C, and D)
    output [3:0] Q, // Data output (AKA Q0, Q1, Q2, and Q3)
    output carry    // Carry-out
);

    // Internal regs and wires
    wire [3:0] J, K, Qn;
    wire loadpt, nandclearload;
    
    JK_FF jk_ff0(.clk(clk), .J(J[0]), .K(K[0]), .Q(Q[0]), .Qn(Qn[0]));
    JK_FF jk_ff1(.clk(clk), .J(J[1]), .K(K[1]), .Q(Q[1]), .Qn(Qn[1]));
    JK_FF jk_ff2(.clk(clk), .J(J[2]), .K(K[2]), .Q(Q[2]), .Qn(Qn[2]));
    JK_FF jk_ff3(.clk(clk), .J(J[3]), .K(K[3]), .Q(Q[3]), .Qn(Qn[3])); 

    // Logic for J and K inputs
    assign nandclearload = ~(clear & load);
    assign loadpt = ~(nandclearload | ~enableP | ~enableT);

    assign J[0] = ~( (D[0] & clear & nandclearload) | (loadpt & Qn[0]) );
    assign K[0] = ~( (Q[0] & loadpt) | (nandclearload & J[0]) );

    assign J[1] = ~( (D[1] & clear & nandclearload) | (loadpt & Qn[1] & Q[0]) );
    assign K[1] = ~( (Q[1] & Q[0] & loadpt) | (nandclearload & J[1]) );

    assign J[2] = ~( (D[2] & clear & nandclearload) | (loadpt & Qn[2] & Q[1] & Q[0]) );
    assign K[2] = ~( (Q[2] & Q[1] & Q[0] & loadpt) | (nandclearload & J[2]) );

    assign J[3] = ~( (D[3] & clear & nandclearload) | (loadpt & Qn[3] & Q[2] & Q[1] & Q[0]) );
    assign K[3] = ~( (Q[3] & Q[2] & Q[1] & Q[0] & loadpt) | (nandclearload & J[3]) );

    // Carry-out
    assign carry = ~(Qn[0] | Qn[1] | Qn[2] | Qn[3] | ~enableT);

endmodule
/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements RAM
 */

module ram(
    input [3:0] address,    // 4-bit address input
    inout wire [7:0] data,  // 8-bit bidirectional data bus
    input wire we,          // Write enable signal (active high)
    input wire oe,          // Output enable signal (active low)
    input wire clk,         // Clock signal
);

    reg [7:0] memory [0:15]; // 16x8-bit memory array
    assign data = (!oe) ? memory[address] : 8'bz

    always @(posedge clk) begin
        if (we) begin
            memory[address] <= data;
        end
    end

endmodule
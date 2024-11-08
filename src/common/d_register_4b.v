/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements SN74LS173 4-bit D-register
 */

module d_register #(
    parameter WIDTH = 4 // Width of the register
) (
    input CLR,              // Asynchronous clear output to digital low
    input CLK,              // Clock input
    input G1_n,             // Gate enable 1 (active low)
    input G2_n,             // Gate enable 2 (active low)
    input M,                // Control for high-impedance output
    input N,                // Control for high-impedance output
    input [WIDTH-1:0] D,    // Data input
    output [WIDTH-1:0] Q    // Saved state output
);

  // Internal storage register
  reg [WIDTH-1:0] storage;

  // Clock-Driven Data Load Logic
  always @(posedge CLK or posedge CLR) begin
    if (CLR) begin
      storage <= {WIDTH{1'b0}};  // Asynchronously clear storage
    end else if (!G1_n && !G2_n) begin
      storage <= D;  // Load data into storage on the positive clock edge if enabled
    end
  end

  // Output Logic Control (Using Continuous Assignment)
  assign Q = (M || N) ? {WIDTH{1'bz}} : storage;

endmodule
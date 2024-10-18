/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements SN74LS173 4-bit D-register
 */

module d_register_4b (
    input CLR,              // Asynchronous clear output to digital low
    input CLK,              // Clock input
    input G1_n,             // Gate enable 1/2 (active low)
    input G2_n,             // both must be low for data load
    input M,                // Both M/N must be low to enable output
    input N,                // Else, we get high-impedance output
    input [3:0] D,          // Data input
    output reg [3:0] Q      // Saved state
);

  // Internal storage register
  reg [3:0] storage;

  // Asynchronous Clear Logic and High-Impedance Handling
  always @(*) begin
    if (CLR) begin
      Q = 4'b0000;  // Clear output immediately when CLR is asserted
    end else if (M || N) begin
      Q = 4'bzzzz;  // Set output to high-impedance if M or N is high
    end else begin
      Q = storage;  // Otherwise, output the stored value
    end
  end

  // Clock-Driven Data Load Logic
  always @(posedge CLK) begin
    if (!CLR && !G1_n && !G2_n) begin
      storage <= D;  // Load data into storage on positive clock edge if enabled
    end
  end

endmodule
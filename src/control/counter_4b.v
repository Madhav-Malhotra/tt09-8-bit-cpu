/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements DM74LS161 4-bit counter.
 */

module counter_4b (
  input p_en, // synchronous active high count enable
  input t_en, // synchronous active high count enable
  input ld_n, // synchronous active low load enable
  input clk, // clock
  input clr_n, // synchronous active low clear
  input [3:0] data_in, // data to be loaded (synchronously)
  output reg [3:0] data_out, // output data
  output ripple_carry_out // ripple carry output (1 when data_out reaches max value)
  
);

  // assign ripple carry output
  assign ripple_carry_out = (data_out == 4'b1111);

// Synchronous logic  
  always @(posedge(clk) or negedge(clr_n)) begin
    if (clr_n == 0) begin
      data_out <= 4'b0; // data getting cleared
    end else if (ld_n == 0) begin
      data_out <= data_in; // loading data output
    end else if ((p_en == 1) && (t_en == 1)) begin
      data_out <= data_out + 1; // incrementing data output
    end
  end

endmodule

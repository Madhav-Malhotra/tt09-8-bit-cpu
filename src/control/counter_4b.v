/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements DM74LS161 4-bit counter.
 */

module counter_4b (
  input p_en, t_en, ld_n, clk, clr_n,
  input [3:0] data_in,
  output reg [3:0] data_out,
  output ripple_carry_out
  
);

  assign ripple_carry_out = (data_out == 4'b1111);

  always @(posedge(clk) or negedge(clr_n)) begin
    if (clr_n == 0) begin
      data_out <= 4'b0;
    end else if (ld_n == 0) begin
      data_out <= data_in;
    end else if ((p_en == 1) && (t_en == 1)) begin
      data_out <= data_out + 1;
    end
  end

endmodule
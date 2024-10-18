/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements DM74LS157 4-bit 2-to-1 multiplexer
 */

module quad_2_1_mux (
    input wire strobe,          // Active low enable
    input wire select,          // connects out to B if 1, A if 0
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [3:0] Y
);
  
  assign Y = strobe ? 4'b0000 : (select ? B : A);

endmodule
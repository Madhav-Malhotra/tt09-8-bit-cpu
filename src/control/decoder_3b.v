/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements DM74LS138 3-bit decoder.
 */

module decoder_3b (
  input wire g1, // active high enable
  input g2a, // active low enable
  input g2b, // active low enable
  input a, b, c, // select pins
  output wire [7:0] y // active low output
);

  wire enable;
  assign enable = (g1 == 1'b1 &&( g2a == 1'b0 && g2b == 1'b0)); // active if all enables are active

  // assign y active low decoded output
  assign y = enable ? (
                ( {a, b, c} == 3'b000) ? 8'b11111110 :
                ( {a, b, c} == 3'b001) ? 8'b11111101 :
                ( {a, b, c} == 3'b010) ? 8'b11111011 :
                ( {a, b, c} == 3'b011) ? 8'b11110111 :
                ( {a, b, c} == 3'b100) ? 8'b11101111 :
                ( {a, b, c} == 3'b101) ? 8'b11011111 :
                ( {a, b, c} == 3'b110) ? 8'b10111111 :
                ( {a, b, c} == 3'b111) ? 8'b01111111 :
                8'b11111111 
              ) : 8'b11111111;

endmodule

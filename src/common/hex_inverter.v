/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements DM7404 (DM74LS04) Hex Inverter
 */

module hex_inverter (
    input [7:0] A,
    output [7:0] Y
);
  assign Y = ~A;
endmodule
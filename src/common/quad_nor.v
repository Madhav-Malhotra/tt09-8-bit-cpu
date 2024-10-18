/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements DM74LS02 Quad 2-Input NOR Gate
 */

module quad_nor (
    input [3:0] a,
    input [3:0] b,
    output [3:0] y
);

assign y = ~(a | b);

endmodule
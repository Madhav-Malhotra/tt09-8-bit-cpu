/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements DM74LS138 3-8 decoder
 */

module decoder_3_8(
    input wire select[2:0],
    input wire enableG1,
    input wire [1:0] enableG2,
    output reg [7:0] out
);

    always @(*) begin
        if (enableG2[0] | enableG2[1] | ~enableG1) begin
            out = 8'b11111111;
        end else begin
            
        end
    end

endmodule
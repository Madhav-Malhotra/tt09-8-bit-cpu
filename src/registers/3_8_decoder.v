/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements DM74LS138 3-8 decoder
 */

module decoder_3_8(
    input wire [2:0] select,
    input wire enableG1,
    input wire [1:0] enableG2,
    output reg [7:0] out
);

    always @(*) begin
        if (enableG2[0] | enableG2[1] | ~enableG1) begin
            out = 8'b11111111;
        end else begin
            case(select[2:0])
                3'b000: out = 8'b10000000;
                3'b001: out = 8'b01000000;
                3'b010: out = 8'b00100000;
                3'b011: out = 8'b00010000;
                3'b100: out = 8'b00001000;
                3'b101: out = 8'b00000100;
                3'b110: out = 8'b00000010;
                3'b111: out = 8'b00000001;
            endcase
        end
    end

endmodule
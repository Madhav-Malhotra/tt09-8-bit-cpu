/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements 74F189 16x4 RAM
 */

module ram_74189 (
    input wire CS,          // Active low chip select
    input wire WE,          // Active low write enable
    input wire [3:0] A,     // Address inputs
    input wire [3:0] D,     // Data inputs
    output reg [3:0] O     // Data outputs (3-STATE)
);

    //internal memory - 16 words, 4 bits each = 64 
    reg [3:0] memory [0:15];
 
    always @(*) begin
        // default value
        //set all mem to 0 
        
        if (!CS && WE) begin
            O = memory[A];
        end else begin
            if (!CS && !WE) begin
            memory[A] = D;
            end
            O = 4'bz;
        end
        
    end
    


endmodule
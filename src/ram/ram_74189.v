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
    output wire [3:0] O     // Data outputs (3-STATE)
);

    //internal memory - 16 words, 4 bits each = 64 
    reg [3:0] memory [0:15];
    // intermediate data output
    reg [3:0] data_out;
    
    
    always @(*) begin
        // Write
        if (!CS && !WE) begin
            memory[A] <= D;
        end
        //read
        else if (!CS && WE) begin
            data_out = memory[A];
        end
    end
    

    // Output control - complemented data with 3-STATE control
    assign O = (!CS && WE) ? ~data_out : 4'bz;

endmodule
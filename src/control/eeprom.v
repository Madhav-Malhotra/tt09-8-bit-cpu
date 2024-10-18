/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements AT28C16 EEPROM.
 */

module eeprom (
    input wire ce_n,      
    input wire oe_n,      
    input wire we_n,     
    input wire [10:0] addr, 
    inout wire [7:0] data   
);

    reg [7:0] mem_array [2047:0]; 
    reg [7:0] data_out;

    assign data = (ce_n == 1'b0 && oe_n == 1'b0 && we_n == 1'b1) ? data_out : 8'bz;

    always @(*) begin
      if (ce_n == 1'b0 && we_n == 1'b0 && oe_n == 1'b1) begin
            mem_array[addr] = data;
        end
    end

    always @(*) begin
      if (ce_n == 1'b0 && oe_n == 1'b0 && we_n == 1'b1) begin
            data_out = mem_array[addr];
        end
    end

endmodule
/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements AT28C16 EEPROM.
 */

module eeprom (
    input wire ce_n,   // Active low chip enable
    input wire oe_n,   // Active low output enable
    input wire we_n,   // Active low write enable  
    input wire [10:0] addr, // Address pins
    inout wire [7:0] data   // Data input/output
);

    reg [7:0] mem_array [2047:0]; // Memory cells (should probably look into making this smaller if design does not fit on tiny tapeout)
    reg [7:0] data_out; // Data output

    assign data = (ce_n == 1'b0 && oe_n == 1'b0 && we_n == 1'b1) ? data_out : 8'bz; // If chip enable and output enable are active, and write enable is inactive, the data pins get output data driven to them, otherwise do not drive data wires

    always @(*) begin
      if (ce_n == 1'b0 && we_n == 1'b0 && oe_n == 1'b1) begin
          mem_array[addr] = data; // if chip enable and write enable are active, and output enable is enactive, write the data on the data pins to specified memory addr
        end
    end

    always @(*) begin
      if (ce_n == 1'b0 && oe_n == 1'b0 && we_n == 1'b1) begin
          data_out = mem_array[addr]; // if chip enable and output enable are active, and write enable is not active, then update data_out register with new data
        end
    end

endmodule

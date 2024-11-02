`timescale 1ns / 1ps

module eeprom_tb;

    // Inputs
    reg ce_n;
    reg oe_n;
    reg we_n;
    reg [10:0] addr;
    reg [7:0] data_in;

    // Bidirectional data bus
    wire [7:0] data;

    // Data output for reading
    reg [7:0] data_out;

    // Instantiate the EEPROM module
    eeprom uut (
        .ce_n(ce_n),
        .oe_n(oe_n),
        .we_n(we_n),
        .addr(addr),
        .data(data)
    );

    // Tri-state buffer for bidirectional data bus control
    assign data = (we_n == 1'b0) ? data_in : 8'bz;

    initial begin
        // Initialize inputs
        ce_n = 1; oe_n = 1; we_n = 1; addr = 11'b0; data_in = 8'b0;

        // Test 1: Write data to address 0x000
        #10 ce_n = 0; we_n = 0; oe_n = 1; addr = 11'b00000000000; data_in = 8'hA5;
        #10 we_n = 1; // Release write enable to complete the write

        // Test 2: Read back data from address 0x000
        #10 ce_n = 0; oe_n = 0; addr = 11'b00000000000;
        #10 data_out = data;
        #10 assert(data_out == 8'hA5);

        // Test 3: Write data to address 0x001
        #10 ce_n = 0; we_n = 0; oe_n = 1; addr = 11'b00000000001; data_in = 8'h3C;
        #10 we_n = 1; // Release write enable to complete the write

        // Test 4: Read back data from address 0x001
        #10 ce_n = 0; oe_n = 0; addr = 11'b00000000001;
        #10 data_out = data;
        #10 assert(data_out == 8'h3C);

        // Test 5: Check high-impedance state when chip enable is inactive
        #10 ce_n = 1; oe_n = 0; addr = 11'b00000000000;
        #10 assert(data === 8'bz);

        // Test 6: Verify output disable with oe_n high
        #10 ce_n = 0; oe_n = 1; we_n = 1; addr = 11'b00000000000;
      #10 assert(data === 8'bz);

        $display("All tests passed successfully.");
        $finish;
    end

    initial begin
        $monitor("Time=%0t | ce_n=%b | oe_n=%b | we_n=%b | addr=%b | data_in=%b | data=%b", 
                 $time, ce_n, oe_n, we_n, addr, data_in, data);
    end

endmodule

`timescale 1ns / 1ps

module regAB_testbench();
    // Declare testbench signals
    reg clk;
    reg clr;
    reg ai_n;
    reg ao_n;
    wire [7:0] A;
    reg [7:0] bus_data;
    wire [7:0] bus;
    
    // Instantiate the Device Under Test (DUT)
    regAB_top dut (
        .clk(clk),
        .bus(bus),
        .clr(clr),
        .ai_n(ai_n),
        .ao_n(ao_n),
        .A(A)
    );

    // Clock generation
    initial begin
      	// Dump waves
        $dumpfile("dump.vcd");
        $dumpvars(1);
      
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
      	// Drive bus as tri-state in testbench
    	assign bus = ao_n ? 8'bz : bus_data;
      	
        // Initialize signals
        clr = 0;
        ai_n = 1;
        ao_n = 1;
        bus_data = 8'b00000000;

        // Test 1: Asynchronous Clear
        #10 clr = 1;
        #10 clr = 0;
        #10;

        // Test 2: Load data into register A with ai_n low (enabled)
        ai_n = 0;
        bus_data = 8'b10101010;
        #10;  // Allow data to settle on bus
        #10 clr = 0;  // Clear should already be inactive
        #10;

        // Trigger a clock edge to load data
        #5;
        ai_n = 1; // Disable loading after data capture
        #10;

        // Check if data is stored in A_internal via A

        // Test 3: Enable output to bus with ao_n low
        ao_n = 0;
        #10;

        // Verify that bus shows stored data
        ao_n = 1;  // Disable output to bus

        // Test 4: Set bus to high-impedance when M or N high
        ai_n = 1;
        ao_n = 1;
        bus_data = 8'b11110000;
        #10;

        // Test complete
        $finish;
    end

endmodule
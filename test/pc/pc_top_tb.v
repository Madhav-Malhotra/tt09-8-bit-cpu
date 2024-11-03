`timescale 1ns/1ps

module pc_top_tb;

    // Testbench Signals
    reg clk;
    reg clr_n;			// resets program counter to 0
  	reg ce;				// count enable (program counter increments)
  	reg j_n;			// load enable (active low)
  	reg co_n;			// output enable (active high) = clear output (active low)
    wire [3:0] bus;
  	reg [3:0] bus_driver; // Register to drive values onto bus conditionally
  
  	// Drive the bus only when load enable is active (j_n = 0)
    assign bus = (j_n == 0) ? bus_driver : 4'bz;

    // Instantiate the pc_top module
    pc_top dut (
        .clk(clk),
        .bus(bus),
        .clr_n(clr_n),
        .ce(ce),
        .j_n(j_n),
        .co_n(co_n)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
        // 1. Clear Counter Test
        clr_n = 0; ce = 1; j_n = 1; co_n = 1;
        #10;
        clr_n = 1; // Release clear

        // 2. Increment Counter Test
        ce = 1; j_n = 1;
        #50; // Observe multiple clock cycles for counting

        // 3. Load Value Test
        ce = 0; j_n = 0;
      	bus_driver = 4'b0101;
        #10; // Set desired bus value here
        j_n = 1; // Release load

        // 4. Output Enable Test
        co_n = 0; #10;				// output should be high impedance
        co_n = 1; #10;				// output should be normal

        // Finish simulation
        $stop;
    end

endmodule
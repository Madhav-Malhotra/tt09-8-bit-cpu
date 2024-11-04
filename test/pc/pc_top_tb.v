`timescale 1ns/1ps

module pc_top_tb;

    // Testbench Signals
    reg clk;
    reg clr_n;			// resets program counter to 0
  	reg ce;				// count enable (program counter increments)
  	reg j_n;			// load enable (active low)
  	reg co_n;			// output enable (active low)
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
        // Dump waves
    	$dumpfile("dump.vcd");
      	$dumpvars(0, pc_top_tb);
      
        // 1. Clear Counter Test
        clr_n = 0; ce = 1; j_n = 1; co_n = 0; 
        bus_driver = 4'b1010; 		// no effect, just don't float
        #10; 	   					// should see bus_internal = 0
        clr_n = 1; 					// Release clear
      	$display("Finished clear test");

        // 2. Increment Counter Test
        ce = 1; j_n = 1;
        #40; // Should see bus_internal = 1, 2, 3, 4, ...
      	$display("Finished counting");
      
      	// Reset for load value
      	clr_n = 0; ce = 0;
        #10;
      	clr_n = 1;
      	#10;

        // 3. Load Value Test
        j_n = 0;
      	bus_driver = 4'b1110;		// Set desired bus_internal
        #10; 						
        j_n = 1; 					// Release load
      	#10;
      	$display("Finished loading");
      
      	// Overflow test
      	ce = 1;
      	#20;						// should see carry overflow
      	ce = 0;
      	#10;

        // 4. Output Enable Test
        co_n = 1; #10;				// bus should be high impedance
        co_n = 0; #10;				// bus should be normal
      	$display("Finished output enable check");

        // Finish simulation
        $finish;
    end

endmodule
module mar (
 	input wire [3:0] d_in,    
    input wire [1:0] select,   
    input wire clk,            
    input wire clr,            
    input wire g,              // Strobe for the multiplexer (active low)
    input wire g1, g2,         // Enable signals for the register (active low)
    output wire [3:0] mar_out  
);

    wire [3:0] mux_out;  

    quad_2_1_mux mux (
        .s(select[0]),   // Single select bit
      	.g(g),           // Strobe (active low)
      	.a(d_in),        // First input to the MUX
        .b(4'b0000),     // Second input to the MUX (can add other inputs if necessary)
        .y(mux_out)      // MUX output
    );

    // Instantiate the 74LS173 register
    d_register_4b register (
    	.clk(clk),       // Clock signal
      	.clr(clr),       // Clear signal
      	.g1(g1),         // Enable signal 1 (active low)
      	.g2(g2),         // Enable signal 2 (active low)
        .d(mux_out),     // Data input from the MUX
        .q(mar_out)      // Register output connected to MAR_out
    );

endmodule
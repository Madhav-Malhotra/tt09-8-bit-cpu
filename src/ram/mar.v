module mar (
 	  input wire [3:0] d_in,    
    input wire [3:0] pc_in,    // 4-bit program counter input
    input wire select,         // Single bit select signal
    input wire clk,            
    input wire clr,            
    input wire g,              // Strobe for the multiplexer (active low)
    input wire g1, g2,         // Enable signals for the register (active low)
    output wire [3:0] mar_out  
);

    wire [3:0] mux_out;  

    quad_2_1_mux mux (
        .select(select),   // Single select bit
      	.strobe(g),           // Strobe (active low)
      	.A(d_in),        // First input to the MUX
        .B(pc_in),     // Second input to the MUX
        .Y(mux_out)      // MUX output
    );

    // Instantiate the 74LS173 register
    d_register_4b register (
    	  .CLK(clk),       // Clock signal
      	.CLR(clr),       // Clear signal
      	.G1_n(g1),       // Enable signal 1 (active low)
      	.G2_n(g2),       // Enable signal 2 (active low)
        .M(1'b0),        // Output enable control
        .N(1'b0),        // Output enable control
        .D(mux_out),     // Data input from the MUX
        .Q(mar_out)      // Register output connected to MAR_out
    );

endmodule
`timescale 1ns / 1ps

module counter_4b_tb;

    // Inputs
    reg p_en;
    reg t_en;
    reg ld_n;
    reg clk;
    reg clr_n;
    reg [3:0] data_in;

    // Outputs
    wire [3:0] data_out;
    wire ripple_carry_out;

    // Instantiate the counter module
    counter_4b uut (
        .p_en(p_en),
        .t_en(t_en),
        .ld_n(ld_n),
        .clk(clk),
        .clr_n(clr_n),
        .data_in(data_in),
        .data_out(data_out),
        .ripple_carry_out(ripple_carry_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        p_en = 0;
        t_en = 0;
        ld_n = 1;
        clr_n = 1;
        data_in = 4'b0000;

        // Test 1: Clear the counter
        #10 clr_n = 0; // Assert clear
        #10 clr_n = 1; // Release clear
        #10 assert(data_out == 4'b0000);

        // Test 2: Load a value
        #10 ld_n = 0; data_in = 4'b0101; // Load value 5
        #10 ld_n = 1; // Release load
        #10 assert(data_out == 4'b0101);

        // Test 3: Enable counting and count up
        #10 p_en = 1; t_en = 1; // Enable counting
        #40; // Let it count for 4 clock cycles
         assert(data_out == 4'b1001);

        // Test 4: Check ripple carry output
        
      #50 assert(ripple_carry_out == 0 && data_out == 4'b1110);


      #10 assert(data_out == 4'b1111 && ripple_carry_out == 1);

        // Test 5: Counter reset after max value
        #10 assert(data_out == 4'b0000 && ripple_carry_out == 0);


        $finish;
    end

    initial begin
        $monitor("Time=%0t | p_en=%b | t_en=%b | ld_n=%b | clr_n=%b | data_in=%b | data_out=%b | ripple_carry_out=%b", 
                 $time, p_en, t_en, ld_n, clr_n, data_in, data_out, ripple_carry_out);
    end

endmodule

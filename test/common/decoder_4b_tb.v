`timescale 1ns / 1ps

module decoder_3b_tb;

    // Inputs
    reg g1;
    reg g2a;
    reg g2b;
    reg a;
    reg b;
    reg c;

    // Output
    wire [7:0] y;

    // Instantiate the decoder module
    decoder_3b uut (
        .g1(g1),
        .g2a(g2a),
        .g2b(g2b),
        .a(a),
        .b(b),
        .c(c),
        .y(y)
    );

    initial begin
        // Initialize inputs
        g1 = 0; g2a = 1; g2b = 1; a = 0; b = 0; c = 0;

        // Test 1: Ensure output is disabled when not all enables are active
        #10 assert(y == 8'b11111111);

        // Test 2: Activate all enables and check outputs for each combination of a, b, c
        g1 = 1; g2a = 0; g2b = 0;

        // Iterate through all combinations of a, b, c
        for (integer i = 0; i < 8; i = i + 1) begin
            {a, b, c} = i[2:0];
            #10;
            case (i)
                3'b000: assert(y == 8'b11111110);
                3'b001: assert(y == 8'b11111101);
                3'b010: assert(y == 8'b11111011);
                3'b011: assert(y == 8'b11110111);
                3'b100: assert(y == 8'b11101111);
                3'b101: assert(y == 8'b11011111);
                3'b110: assert(y == 8'b10111111);
                3'b111: assert(y == 8'b01111111);
            endcase
        end

        // Test 3: Disable g1 and check if output is all high
        #10 g1 = 0;
        #10 assert(y == 8'b11111111);

        // Test 4: Disable g2a and check if output is all high
        #10 g1 = 1; g2a = 1; g2b = 0;
        #10 assert(y == 8'b11111111);

        // Test 5: Disable g2b and check if output is all high
        #10 g1 = 1; g2a = 0; g2b = 1;
        #10 assert(y == 8'b11111111);

        $display("All tests passed successfully.");
        $finish;
    end

    initial begin
        $monitor("Time=%0t | g1=%b | g2a=%b | g2b=%b | a=%b | b=%b | c=%b | y=%b", 
                 $time, g1, g2a, g2b, a, b, c, y);
    end

endmodule

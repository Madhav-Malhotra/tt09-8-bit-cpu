`timescale 1ns / 1ps



module ram_74189_tb;

    // Inputs
    reg CS;
    reg WE;
    reg [3:0] A;
    reg [3:0] D;

    // Outputs
    wire [3:0] O;

    // Instantiate the RAM module
    ram_74189 uut (
        .CS(CS),
        .WE(WE),
        .A(A),
        .D(D),
        .O(O)
    );

    initial begin
        // Initialize inputs
        CS = 1; WE = 1; A = 4'b0000; D = 4'b0000;

        // Test 1: Write to address 0
        #10 CS = 0; WE = 0; A = 4'b0000; D = 4'b1010;
        #10 WE = 1; // Release WE to simulate the end of the write cycle
        
        // Assert: Check that data has been written correctly
        #10 assert(O == ~4'b1010);

        // Test 2: Write to address 1
        #10 WE = 0; A = 4'b0001; D = 4'b1100;
        #10 WE = 1; // Release WE
        
        // Assert: Check that data has been written correctly
        #10 assert(O == ~4'b1100);

        // Test 3: High impedance state when CS is high
        #10 CS = 1; WE = 1; A = 4'b0000;
        #10 assert(O === 4'bz);

        $display("All tests passed successfully.");
        $finish;
    end

    initial begin
        $monitor("Time=%0t | CS=%b | WE=%b | A=%b | D=%b | O=%b", 
                 $time, CS, WE, A, D, O);
    end

endmodule

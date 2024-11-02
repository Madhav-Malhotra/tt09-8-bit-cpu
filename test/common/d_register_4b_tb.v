/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Test bench for SN74LS173 4-bit D-register
 */

module test_d_register_4b;

// Testbench parameters
reg CLR; // Reset signal
reg CLK; // Clock
reg G1_n; // Gate enable 1
reg G2_n; // Gate enable 2
reg M; // Control signal for impedance
reg N; // Control signal for impedance
reg [3:0] D; // Data input
wire [3:0] Q; // Data output
  
  d_register dut (
    .CLR(CLR),
    .CLK(CLK),
    .G1_n(G1_n),
    .G2_n(G2_n),
    .M(M),
    .N(N),
    .D(D),
    .Q(Q)
  );


// Generate clock signal

    always #5 CLK = ~CLK; // Toggle clock every 5 time units


// Testbench logic
initial begin
    // Monitor outputs for debugging
    $monitor("Time=%0t | CLR=%b CLK=%b G1_n=%b G2_n=%b M=%b N=%b D=%b | Q=%b", 
             $time, CLR, CLK, G1_n, G2_n, M, N, D, Q);

    // Case 1 - CLR high (CLR = 1), Q should be 0000
    CLR = 1; G1_n = 1; G2_n = 1; M = 0; N = 0; D = 4'b1010; CLK = 0;
    #10;
  $display("Case 1 - CLR is high: Q = %b (Expected: 0000)", Q);

    // Case 2 - CLK low, CLR low (CLR, CLK = 0), Q should hold Q0
    CLR = 0; G1_n = 1; G2_n = 1; M = 0; N = 0; D = 4'b0101;
    #10;
    $display("Case 2 - CLR low, CLK low, Q hold: Q = %b (Expected: Q0)", Q);

    // Case 3 - Data load (G1_n = 0, G2_n = 0, CLK rising edge)
    CLR = 0; G1_n = 0; G2_n = 0; M = 0; N = 0; D = 4'b1100;
    #10;
    $display("Case 3 - Load data: Q = %b (Expected: 1100)", Q);

    // Case 4 - High-impedance output (M = 1 or N = 1)
    CLR = 0; G1_n = 0; G2_n = 0; M = 1; N = 0; D = 4'b1111;
    #10;
    $display("Case 4a - High Impedance (M = 1): Q = %b (Expected: ZZZZ)", Q);

    CLR = 0; G1_n = 0; G2_n = 0; M = 0; N = 1; D = 4'b1111;
    #10;
    $display("Case 4b - High Impedance (N = 1): Q = %b (Expected: ZZZZ)", Q);

    // Case 5 - Load data across clock edges
    CLR = 0; G1_n = 0; G2_n = 0; M = 0; N = 0; D = 4'b1010;
    #10; // Wait for the rising clock edge to load data
    $display("Case 5 - Load on CLK edge: Q = %b (Expected: 1010)", Q);

    // Case 6 - Hold state when clock is low
    #10; // Hold and observe
    $display("Case 6 - Hold State on CLK Low: Q = %b (Expected: 1010)", Q);

    // End simulation
    $stop;
end

endmodule

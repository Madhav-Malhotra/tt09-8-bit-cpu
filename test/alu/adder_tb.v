`timescale 1ns/1ps
module adder_tb;
    parameter N = 4;  // 4-bit adder as per DM74LS283
    
    // Test signals
    reg [N-1:0] A, B;
    reg C0;
    wire [N-1:0] S;
    wire CN;
    
    // Add declarations for expected values
    reg [N-1:0] expected_sum;
    reg expected_carry;
    
    // Instantiate the adder
    adder #(
        .N(N)
    ) dut ( // Design Under Test
        .A(A),
        .B(B),
        .C0(C0),
        .S(S),
        .CN(CN)
    );
    
    // task to check results
    task check_result;
        input [N-1:0] expected_sum;
        input expected_carry;
        input [8*20:1] test_name;
        begin
            #5; // Wait for outputs to settle
            if (S !== expected_sum || CN !== expected_carry) begin
                $display("%s failed", test_name);
                $display("A = %b, B = %b, C0 = %b", A, B, C0);
                $display("Expected: Sum = %b, Carry = %b", expected_sum, expected_carry);
                $display("Got:      Sum = %b, Carry = %b", S, CN);
            end else begin
              $display("PASS Test case: %s, Sum = %b, Carry = %b", test_name, S, CN);
            end
        end
    endtask
    
    // Test stimulus
    initial begin
        // Initialize waveform dumping
        $dumpfile("adder_test.vcd");
        $dumpvars(0, adder_tb);
        
        // Initialize inputs
        A = 0;
        B = 0;
        C0 = 0;
        expected_sum = 0;
        expected_carry = 0;
        
        // Test Case 1: Basic addition without carry
        // A = 3, B = 1, C0 = 0, Out = 4, Carry = 0
        #10; 
        A = 4'b0011;
        B = 4'b0001;
        C0 = 0;
        check_result(4'b0100, 0, "3 + 1");
        
        // Test Case 2: Addition with carry-in
        #10;
        A = 4'b0011;  // 3
        B = 4'b0001;  // 1
        C0 = 1;       // +1
        check_result(4'b0101, 0, "3 + 1 + Cin");
        
        // Test Case 3: Addition with carry-out
        #10;
        A = 4'b1111;  // 15
        B = 4'b0001;  // 1
        C0 = 0;
        check_result(4'b0000, 1, "15 + 1 (overflow)");
        
        // Test Case 4: Maximum value addition
        #10;
        A = 4'b1111;  // 15
        B = 4'b1111;  // 15
        C0 = 0;
        check_result(4'b1110, 1, "15 + 15");
        
        // Test Case 5: Zero addition
        #10;
        A = 4'b0000;
        B = 4'b0000;
        C0 = 0;
        check_result(4'b0000, 0, "0 + 0");
        
        // Test Case 6: Carry propagation
        #10;
        A = 4'b1110;  // 14
        B = 4'b0001;  // 1
        C0 = 1;       // +1
        check_result(4'b0000, 1, "14 + 1 + Cin");
        
        // Test Case 7: Alternating bits
        #10;
        A = 4'b0101;
        B = 4'b1010;
        C0 = 0;
        check_result(4'b1111, 0, "5 + 10");
        
        // Test Case 8: Testing carry chain
        #10;
        A = 4'b0111;  // 7
        B = 4'b1000;  // 8
        C0 = 1;       // +1
        check_result(4'b0000, 1, "7 + 8 + Cin");
        
        // Test random values
        repeat(5) begin
            #10;
            A = $random & 4'hF; // Mask to 4 bits
            B = $random & 4'hF; // Mask to 4 bits
            C0 = $random & 1'b1; // Mask to 1 bit
            // Calculate expected results
            {expected_carry, expected_sum} = A + B + C0;
            check_result(expected_sum, expected_carry, "Random test");
        end
        
        // End simulation
        #10;
        $display("\nSimulation completed!");
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t A=%b B=%b C0=%b S=%b CN=%b",
                 $time, A, B, C0, S, CN);
    end
    
endmodule
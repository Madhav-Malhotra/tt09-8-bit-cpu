module tb_JK_FF;
    // Testbench signals
    reg clk;
    reg J;
    reg K;
    wire Q;
    wire Qn;

    // Instantiate the JK flip-flop
    JK_FF dut (
        .clk(clk),
        .J(J),
        .K(K),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate a clock pulse every 5 time units
    end

    // Testbench logic
    initial begin

        // Initialize signals to a known state
        J = 1;
        K = 1; 
        #10; // Wait for the initial clock cycle

        // Test Case 1: Set operation (active low: J=0, K=1)
        $display("\nTest Case 1: Set Operation (J=0, K=1)");
        J = 0; // Active low: asserting J
        K = 1; // Active low: deasserting K
        #10; // Wait for one clock cycle
        $display("Time=%0t | J=%b K=%b | Q=%b Qn=%b (Expected: Q=1)", $time, J, K, Q, Qn);

        // Test Case 2: Reset operation (active low: J=1, K=0)
        $display("\nTest Case 2: Reset Operation (J=1, K=0)");
        J = 1; // Active low: deasserting J
        K = 0; // Active low: asserting K
        #10; // Wait for one clock cycle
        $display("Time=%0t | J=%b K=%b | Q=%b Qn=%b (Expected: Q=0)", $time, J, K, Q, Qn);

        // Test Case 3: Toggle operation (active low: J=0, K=0)
        $display("\nTest Case 3: Toggle Operation (J=0, K=0)");
        J = 0; // Active low: asserting J
        K = 0; // Active low: asserting K
        #10; // Wait for one clock cycle
        $display("Time=%0t | J=%b K=%b | Q=%b Qn=%b (Expected: Toggle)", $time, J, K, Q, Qn);
        #10; // Observe toggle on another clock cycle
        $display("Time=%0t | J=%b K=%b | Q=%b Qn=%b (Toggled Again)", $time, J, K, Q, Qn);

        // Test Case 4: Hold state (active low: J=1, K=1)
        $display("\nTest Case 4: Hold State (J=1, K=1)");
        J = 1; // Active low: deasserting J
        K = 1; // Active low: deasserting K
        #10; // Wait for one clock cycle
        $display("Time=%0t | J=%b K=%b | Q=%b Qn=%b (Expected: Hold)", $time, J, K, Q, Qn);

        // End simulation
        #10;
        $display("\nTest completed");
        $finish;
    end

   
    initial begin
        #200;
        $display("Simulation timed out");
        $finish;
    end
endmodule
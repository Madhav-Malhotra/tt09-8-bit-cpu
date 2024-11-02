module test_dual_JK;
    // Testbench signals
    reg CLR;         // Asynchronous clear signal (active-low)
    reg CLK;         // Clock signal
    reg J;           // J input
    reg K;           // K input
    wire Q;          // Q output
    wire Qn;         // Complement of Q (Q bar)

    // Instantiate the JK flip-flop module (assuming it's named dual_jk_flip_flop)
    dual_JK uut (
        .clr_n(CLR),
        .clk(CLK),
        .J(J),
        .K(K),
        .Q(Q),
        .Q_n(Qn)
    );

    // Clock generation logic
    initial begin
        CLK = 0; // Start with clock low
        forever #5 CLK = ~CLK; // Toggle clock every 5 time units
    end

    // Testbench logic to cover the function table
    initial begin
        $monitor("Time=%0t | CLR=%b CLK=%b J=%b K=%b | Q=%b Qn=%b", $time, CLR, CLK, J, K, Q, Qn);

        // Initialize signals and verify the initial state
        CLR = 0; J = 0; K = 0; #1; // Ensure the initial state is known
        #9; // Wait to check initial state before any clock cycle
        $display("Initial state: Q = %b (Expected: 0 if CLR was asserted earlier)", Q);

        // Case 1: CLR low, Q should be reset to 0
        CLR = 0; #5; // Assert CLR to reset Q
        $display("Case 1 - CLR low: Q = %b (Expected: 0)", Q);
        CLR = 1; #5; // Release CLR to allow normal operation

        // Case 2: Hold state when J = 0 and K = 0
        J = 0; K = 0; #10; // Observe Q after a clock cycle
        $display("Case 2 - Hold state (J=0, K=0): Q = %b (Expected: Q0)", Q);

        // Case 3: Set state (J=1, K=0)
        J = 1; K = 0; #10; // Observe Q on the next clock cycle
        $display("Case 3 - Set state (J=1, K=0): Q = %b (Expected: 1)", Q);

        // Case 4: Reset state (J=0, K=1)
        J = 0; K = 1; #10; // Observe Q on the next clock cycle
        $display("Case 4 - Reset state (J=0, K=1): Q = %b (Expected: 0)", Q);

        // Case 5: Toggle state (J=1, K=1)
        J = 1; K = 1; #40; // Observe toggling behavior over multiple clock cycles
        $display("Case 5 - Toggle state (J=1, K=1): Q = %b", Q);

        // End simulation
        $stop;
    end
endmodule

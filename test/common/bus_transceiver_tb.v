module tb_bus_transceiver;
    // Declare signals for testing
    reg OE_n;            // Active-low Output Enable signal
    reg DIR;             // Direction control signal (0: B to A, 1: A to B)
    reg [7:0] drive_A;   // Register to drive A in the testbench
    reg [7:0] drive_B;   // Register to drive B in the testbench
    wire [7:0] A;        // 8-bit bus A (input/output)
    wire [7:0] B;        // 8-bit bus B (input/output)

    // Assign driving values conditionally to simulate bidirectional behavior
    assign A = (DIR == 0 && OE_n == 0) ? 8'bz : drive_A; // Let the module drive A if DIR=0, OE_n=0
    assign B = (DIR == 1 && OE_n == 0) ? 8'bz : drive_B; // Let the module drive B if DIR=1, OE_n=0

    // Instantiate the bus transceiver module
    bus_transceiver uut (
        .OE_n(OE_n),
        .DIR(DIR),
        .A(A),
        .B(B)
    );

    // Initializing testing process
    initial begin
        // Case 1: Isolation (OE_n = 1)
        OE_n = 1;       // Disable output (high)
        DIR = 0;        // Direction doesn't matter when OE_n is 1
        drive_A = 8'hZZ; // Set A to high-impedance
        drive_B = 8'h55; // Set B to a known value (01010101 in binary)
        #10; // Wait for 10 time units
        $display("Case 1 - Isolation: A = %h, B = %h (Expected: A = Z, B = 55)", A, B);

        // Case 2: B to A transfer (OE_n = 0, DIR = 0)
        OE_n = 0;       // Enable output (active-low)
        DIR = 0;        // Set direction to transfer data from B to A
        #10; // Wait for 10 time units
        $display("Case 2 - B to A Transfer: A = %h, B = %h (Expected: A = 55, B = 55)", A, B);

        // Case 3: A to B transfer (OE_n = 0, DIR = 1)
        drive_A = 8'hAA; // Set A to a new value (10101010 in binary)
        DIR = 1;         // Change direction to transfer data from A to B
        #10; // Wait for 10 time units
        $display("Case 3 - A to B Transfer: A = %h, B = %h (Expected: A = AA, B = AA)", A, B);


        $stop; // Stop the testbench simulation
    end
endmodule
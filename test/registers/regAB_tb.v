`timescale 1ns / 1ps

module regAB_testbench();
    // Declare testbench signals
    reg clk;
    reg clr;
    reg ai_n;
    reg ao_n;
    wire [7:0] A;
    reg [7:0] bus_drive; // added this line to drive the bus instead
    wire [7:0] bus;
    
    // Drive the bus conditionally
    assign bus = ao_n ? 8'bz : bus_drive; // continuous assignment is meant to simulate the tri-state behaviour of bus

    // Instantiate the Device Under Test (DUT)
    regAB_top dut (
        .clk(clk),
        .bus(bus),
        .clr(clr),
        .ai_n(ai_n),
        .ao_n(ao_n),
        .A(A)
    );

    // Clock generation
    initial begin
        // Dump waves for simulation visualization
        $dumpfile("dump.vcd");
      $dumpvars(0,dut);

        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
   // Test sequence adjustments for debugging
initial begin
    // Initialize signals
    clr = 0;
    ai_n = 1;
    ao_n = 1;
    bus_drive = 8'b00000000;

    // Display initial message
    $display("Starting test sequence...");

    // Test 1: Asynchronous Clear
    $display("Test 1: Asserting asynchronous clear...");
    #10 clr = 1;
    #10 if (A === 8'b0)
            $display("Test 1 Passed: Register cleared successfully. A = %h", A);
        else
            $display("Test 1 Failed: Register did not clear as expected. A = %h", A);
    clr = 0;
    #20; // Added delay to ensure proper state

    // Test 2: Load data into register A with ai_n low (enabled)
    $display("Test 2: Loading data into the register...");
    ai_n = 0;
    bus_drive = 8'b10101010;
    #10;  // Allow data to settle on bus
    #10 clr = 0;  // Ensure clear is inactive
    #10;
    
    // Trigger a clock edge to load data
    #5;
    ai_n = 1; // Disable loading after data capture
    #20;
    $display("After loading: A = %h, bus = %h", A, bus);

    // Check if data is stored in A
    if (A === 8'b10101010)
        $display("Test 2 Passed: Data loaded into the register correctly. A = %h", A);
    else
        $display("Test 2 Failed: Data not loaded into the register as expected. A = %h", A);

    // Test 3: Enable output to bus with ao_n low
    $display("Test 3: Enabling output to the bus...");
    ao_n = 0;
    #10;
    $display("During output: A = %h, bus = %h", A, bus);
    if (bus === 8'b10101010)
        $display("Test 3 Passed: Register data output to the bus successfully. A = %h, bus = %h", A, bus);
    else
        $display("Test 3 Failed: Register data not output to the bus as expected. A = %h, bus = %h", A, bus);

    // Disable output to the bus
    ao_n = 1;
    #10;

    // Test 4: Set bus to high-impedance
    $display("Test 4: Verifying high-impedance state...");
    if (bus === 8'bz)
        $display("Test 4 Passed: Bus is in high-impedance state. bus = %h", bus);
    else
        $display("Test 4 Failed: Bus is not in high-impedance state. bus = %h", bus);

    // End of test
    $display("Test sequence complete.");
    $finish;
end
endmodule
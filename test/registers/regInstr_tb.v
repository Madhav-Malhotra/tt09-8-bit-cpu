`timescale 1ns / 1ps

module regAB_top_tb;

    // Clock and Reset
    reg clk;
    reg clr;

    // Control Signals
    reg ii_n;
    reg ai_n;
    reg io_n;

    // Bidirectional Bus
    wire [7:0] bus;

    // Internal Data Buses for Driving the Bus
    reg [7:0] bus_in;
    reg bus_drive_en;

    // Output from the regAB_top Module
    wire [3:0] I;

    // Instantiate the regAB_top Module
    regAB_top uut (
        .clk(clk),
        .bus(bus),
        .clr(clr),
        .ii_n(ii_n),
        .io_n(io_n),
        .ai_n(ai_n),
        .I(I)
    );

    // Access Internal Signal (I_internal) for Verification
    wire [3:0] I_internal = uut.I_internal;

    // Tri-state Bus Logic
    assign bus = bus_drive_en ? bus_in : 8'bz;

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Waveform Generation
    initial begin
        $dumpfile("regAB_top_tb.vcd"); // Name of the dump file
        $dumpvars(0, regAB_top_tb);    // Dump all variables in this module
    end

    // Testbench Procedure
    initial begin
        // Initialize Signals
        clr = 1;
        ii_n = 1;
        ai_n = 1;
        io_n = 1;
        bus_in = 8'b0;
        bus_drive_en = 0;
        #20; // Wait for the system to stabilize

        // Test Case 1: Reset Operation
        $display("Test Case 1: Reset Operation");
        clr = 1;
        #10;
        clr = 0;
        #10;
        if (I !== 4'b0000 || I_internal !== 4'b0000) begin
            $display("Reset failed at time %0t", $time);
        end else begin
            $display("Reset successful at time %0t", $time);
        end

        // Test Case 2: Load Data into d_register_A
        $display("\nTest Case 2: Load Data into d_register_A");
        bus_in = 8'b1010_0000; // Data for bus[7:4] = 4'b1010
        bus_drive_en = 1;
        ii_n = 0; // Enable loading
        #10;
        @(posedge clk);
        ii_n = 1; // Disable loading
        bus_drive_en = 0;
        #10;
        if (I !== 4'b1010) begin
            $display("d_register_A load failed at time %0t, I = %b", $time, I);
        end else begin
            $display("d_register_A load successful at time %0t, I = %b", $time, I);
        end

        // Test Case 3: Load Data into d_register_B
        $display("\nTest Case 3: Load Data into d_register_B");
        io_n = 1;
      	bus_in = 8'b0000_0110; // Data for bus[3:0] = 4'b0110
        bus_drive_en = 1;
        ai_n = 0; // Enable loading
        #10;
        @(posedge clk);
        ai_n = 1; // Disable loading
      	bus_drive_en = 0;
        #10;
        if (I_internal !== 4'b0110) begin
            $display("d_register_B load failed at time %0t, I_internal = %b", $time, I_internal);
        end else begin
            $display("d_register_B load successful at time %0t, I_internal = %b", $time, I_internal);
        end

        // Test Case 4: Transfer Data via Bus Transceiver
      	bus_drive_en = 0;
        $display("\nTest Case 4: Transfer Data via Bus Transceiver");
        io_n = 0; // Enable bus transceiver
        #10;
        if (bus[3:0] !== I_internal) begin
            $display("Bus transceiver transfer failed at time %0t, bus[3:0] = %b, I_internal = %b", $time, bus[3:0], I_internal);
        end else begin
            $display("Bus transceiver transfer successful at time %0t, bus[3:0] = %b", $time, bus[3:0]);
        end
        io_n = 1; // Disable bus transceiver
        #10;

        // End of Testbench
        $display("\nTestbench completed successfully.");
        $finish;
    end

    // Monitor Signals
    initial begin
        $monitor("Time: %0t | clr=%b ii_n=%b ai_n=%b io_n=%b bus=%b I=%b I_internal=%b",
                 $time, clr, ii_n, ai_n, io_n, bus, I, I_internal);
    end

endmodule
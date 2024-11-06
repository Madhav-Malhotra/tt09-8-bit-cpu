`timescale 1ns/1ps

module ram_tb;

    // Testbench Signals
    reg [3:0] address;         // 4-bit address input
    reg pc_in;                 // Select line for multiplexers
    reg OE_n;                  // Output Enable (active low)
    reg EN;                    // Enable for WE signal to RAM
    reg clk;                   // Clock signal
    wire [7:0] RAM_BUS;        // 8-bit RAM data bus

    // Internal signals for driving the RAM_BUS
    reg [7:0] RAM_BUS_driver;
    reg RAM_BUS_drive_enable;
    reg [7:0] data;            // 8-bit register to store data read from RAM

    // Drive the RAM_BUS when RAM_BUS_drive_enable is high
    assign RAM_BUS = RAM_BUS_drive_enable ? RAM_BUS_driver : 8'bz;

    // Instantiate the RAM module
    ram uut (
        .address(address),
        .pc_in(pc_in),
        .OE_n(OE_n),
        .EN(EN),
        .clk(clk),
        .RAM_BUS(RAM_BUS)
    );

    // Clock Generation: 50MHz clock (20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Task to write data to a specific address
    task write_data(input [3:0] addr, input [7:0] data_in);
        begin
            pc_in = 1'b1;                 // Select write operation
            address = addr;               // Set address
            RAM_BUS_driver = data_in;     // Set data to write
            RAM_BUS_drive_enable = 1'b1;  // Enable driving the bus
            EN = 1'b1;                    // Enable write operation
            @(posedge clk);               // Wait for rising edge of clock
            EN = 1'b0;                    // Disable write operation
            RAM_BUS_drive_enable = 1'b0;  // Disable driving the bus
        end
    endtask

    // Task to read data from a specific address
    task read_data(input [3:0] addr, output [7:0] data_out);
        begin
            pc_in = 1'b0;                 // Select read operation
            address = addr;               // Set address
            OE_n = 1'b0;                  // Enable output
            @(posedge clk);               // Wait for rising edge of clock
            data_out = RAM_BUS;           // Capture data from bus
            OE_n = 1'b1;                  // Disable output
        end
    endtask

    // Testbench Procedure
    initial begin
        // Initialize signals
        address = 4'b0000;
        pc_in = 1'b0;
        OE_n = 1'b1;  // Disable output
        EN = 1'b0;    // Disable write
        RAM_BUS_driver = 8'b00000000;
        RAM_BUS_drive_enable = 1'b0;

        // Wait for global reset
        #20;

        // Test Case 1: Write and Read at Address 0x0
        write_data(4'b0000, 8'b10101010);
        read_data(4'b0000, data);
        assert(data === 8'b10101010) else $fatal(1, "Test Case 1 Failed: Expected 8'b10101010, Got %b", data);

        // Test Case 2: Write and Read at Address 0xF (Boundary Address)
        write_data(4'b1111, 8'b01010101);
        read_data(4'b1111, data);
        assert(data === 8'b01010101) else $fatal(1, "Test Case 2 Failed: Expected 8'b01010101, Got %b", data);

        // Test Case 3: Write and Read All Zeros
        write_data(4'b0010, 8'b00000000);
        read_data(4'b0010, data);
        assert(data === 8'b00000000) else $fatal(1, "Test Case 3 Failed: Expected 8'b00000000, Got %b", data);

        // Test Case 4: Write and Read All Ones
        write_data(4'b0011, 8'b11111111);
        read_data(4'b0011, data);
        assert(data === 8'b11111111) else $fatal(1, "Test Case 4 Failed: Expected 8'b11111111, Got %b", data);

        // Test Case 5: Output Enable Control
        write_data(4'b0100, 8'b11001100);
        pc_in = 1'b0;                 // Select read operation
        address = 4'b0100;            // Set address
        OE_n = 1'b1;                  // Disable output
        @(posedge clk);               // Wait for rising edge of clock
        assert(RAM_BUS === 8'bz) else $fatal(1, "Test Case 5 Failed: Expected high impedance, Got %b", RAM_BUS);
        OE_n = 1'b0;                  // Enable output
        @(posedge clk);               // Wait for rising edge of clock
        assert(RAM_BUS === 8'b11001100) else $fatal(1, "Test Case 5 Failed: Expected 8'b11001100, Got %b", RAM_BUS);

        // Additional test cases can be added here

        // End of simulation
        $finish;
    end

    // Signal Monitoring
    initial begin
        $monitor("Time: %0t | clk: %b | pc_in: %b | OE_n: %b | EN: %b | address: %b | RAM_BUS: %b | RAM_BUS_driver: %b | RAM_BUS_drive_enable: %b | data: %b",
                 $time, clk, pc_in, OE_n, EN, address, RAM_BUS, RAM_BUS_driver, RAM_BUS_drive_enable, data);
    end

    // Dumping signals for waveform analysis
    initial begin
        $dumpfile("simulation.vcd"); // Specify the name of the VCD file
        $dumpvars(0, ram_tb);        // Dump all signals in the ram_tb module and its submodules
    end

endmodule

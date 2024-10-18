`default_nettype none

module tt_um_a_register (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

reg [7:0] latch_data;

always @(posedge clk or negedge rst_n) begin

    if (!rst_n)
        latch_data <= 8'b0;
    else
        latch_data <= ui_in;   // Latch the input bus data (ui_in)
    end

    // Output the latched data to LEDs or external outputs (DA_0 to DA_7)
    assign uo_out  = latch_data;  // Output the latched data
    assign uio_out = 8'b0;        // IO output not used, so set to 0
    assign uio_oe  = 8'b0;        // IO enable not used, so set to 0

    // List unused inputs to prevent warnings
    wire _unused = &{ena, uio_in, 1'b0};

endmodule
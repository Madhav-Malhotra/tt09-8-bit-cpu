// Code your design here
module tt_um_instruction_register (
    input  wire [7:0] ui_in,    // 8-bit input bus (BUS_0 to BUS_7)
    output wire [7:0] uo_out,   // Output bus (to LEDs or outputs IR_4 to IR_7)
    input  wire [7:0] uio_in,   // IO input (not used here, so we set it to 0)
    output wire [7:0] uio_out,  // IO output (not used here, so we set it to 0)
    output wire [7:0] uio_oe,   // IO enable (not used here, so we set it to 0)
    input  wire       ena,      // Always 1 when the design is powered (ignore it)
    input  wire       clk,      // Clock signal
    input  wire       rst_n     // Active-low reset (low = reset)
);

    // Internal register to store the latched data
    reg [7:0] latch_data;

    // Always block for latching data or clearing on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)               // If reset is low (active)
            latch_data <= 8'b0;    // Clear the register (set it to 0)
        else                      // Otherwise, on clock pulse
            latch_data <= ui_in;   // Load the input data into the register
    end

    // Assign the stored data to the output pins (uo_out)
    assign uo_out  = latch_data;  // Output the latched data to LEDs or outputs
    assign uio_out = 8'b0;        // IO outputs not used, so set them to 0
    assign uio_oe  = 8'b0;        // IO enable not used, so set it to 0

    // Prevent warnings by listing unused inputs
    wire _unused = &{ena, uio_in, 1'b0};

endmodule
`include "../../src/common/quad_and.v"

module quad_and_tb;
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] y;

    quad_and quad_and_inst (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        // Functional table Test cases 
        a = 4'b0000; b = 4'b0000; #5; $display("%b %b | %b", a, b, y);
        a = 4'b0000; b = 4'b0001; #5; $display("%b %b | %b", a, b, y);
        a = 4'b0001; b = 4'b0000; #5; $display("%b %b | %b", a, b, y);
        a = 4'b0001; b = 4'b0001; #5; $display("%b %b | %b", a, b, y);
    end
endmodule

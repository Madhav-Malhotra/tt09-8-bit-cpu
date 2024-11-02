`include "../../src/common/quad_nor.v"

module quad_nor_tb;
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] y;

    quad_nor quad_nor_inst (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        // Functional table test cases
        a = 4'b0000; b = 4'b0000; #5; $display("%b %b | %b", a, b, y);
        a = 4'b1010; b = 4'b1001; #5; $display("%b %b | %b", a, b, y);
        a = 4'b0101; b = 4'b0000; #5; $display("%b %b | %b", a, b, y);
        a = 4'b0101; b = 4'b0001; #5; $display("%b %b | %b", a, b, y);
    end
endmodule

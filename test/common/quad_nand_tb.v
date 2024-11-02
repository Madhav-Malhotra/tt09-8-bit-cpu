`include "../../src/common/quad_nand.v"

module quad_nand_tb;
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] y;

    quad_nand quad_nand_inst (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        // Functional table test cases 
        a = 4'b0000; b = 4'b0000; #5; $display("%b %b | %b", a, b, y);
        a = 4'b0000; b = 4'b0001; #5; $display("%b %b | %b", a, b, y);
        a = 4'b1111; b = 4'b0000; #5; $display("%b %b | %b", a, b, y);
        a = 4'b1111; b = 4'b1111; #5; $display("%b %b | %b", a, b, y);
    end
endmodule

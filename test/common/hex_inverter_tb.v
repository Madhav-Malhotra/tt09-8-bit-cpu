module test;
  reg [7:0] a_test;
  wire [7:0] y_test;
  
  hex_inverter invert(.A(a_test), .Y(y_test));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, test);
    
    $display("A is high"); // y should be fe (8'b11111110)
    a_test = 8'b00000001;
    display;

    $display("A is low"); // y should be ff (8'b11111111)
    a_test = 8'b00000000;
    display;

    $display("A is mixed"); // y should be aa (8'b10101010)
    a_test = 8'b01010101;
    display;
  end
  
  task display;
    #1 $display("A:%0h, Y:%0h", 
                a_test, y_test);
  endtask
endmodule
    
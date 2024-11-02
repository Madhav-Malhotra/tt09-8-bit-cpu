module test;
  reg [3:0] a_test;
  reg [3:0] b_test;
  wire [3:0] y_test;
  
  quad_or or1(.a(a_test), .b(b_test), .y(y_test));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, test);
    
    $display("a and b are low"); // y should be 0 (4'b0000)
    a_test = 4'b0000;
    b_test = 4'b0000;
    display();
    #5;

    $display("a and b are high"); // y should be F (4'b1111)
    a_test = 4'b1111;
    b_test = 4'b1111;
    display();
    #5;
    
    $display("a last bit is high and b last bit is low"); // y should be 1 (4'b0001)
    a_test = 4'b0001;
    b_test = 4'b0000;
    display();
    #5;

    $display("a last bit is low and b last bit is high"); // y should be 1 (4'b0001)
    a_test = 4'b0000;
    b_test = 4'b0001;
    display();
    #5;

    $display("a and b last bit is high"); // y should be 1 (4'b0001)
    a_test = 4'b0001;
    b_test = 4'b0001;
    display();
    #5;

    $display("a is high and b is low"); // y should be F (4'b1111)
    a_test = 4'b1111;
    b_test = 4'b0000;
    display();
    #5;

    $display("a is low and b random bits are high"); // y should be 5 (4'b0101)
    a_test = 4'b0000;
    b_test = 4'b0101;
    display();
    #5;

    $display("a and b random bits are high"); // y should be E (4'b1110)
    a_test = 4'b1100;
    b_test = 4'b1010;
    display();
    #5;


  end
  
  task display;
    #1 $display("a:%0h, b:%0h, y:%0h", 
               a_test, b_test, y_test);
  endtask
endmodule
module tb_top;

  parameter size = 5;

  logic clk;
  logic reset;
  logic valid_i;
  logic signed [size-1:0] a, b, c, d;
  logic signed [size-1:0] q;
  logic valid_o;

  top #(.size(size)) dut (
    .clk(clk),
    .reset(reset),
    .valid_i(valid_i),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .q(q),
    .valid_o(valid_o)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end  

  logic signed [2*size-1:0] expected_result;

  initial begin
    clk = 0;
    reset = 1;
    valid_i = 0;
    a = 0; b = 0; c = 0; d = 0;
    #15 reset = 0;

    run_test(10, 5, 2, 1);     // (10 - 5) * (1 + 6) - 4) / 2 = (5 * 7 - 4)/2 = 31/2 = 15
    #50
    run_test(-5, -10, 1, -1);  //(5 * 4 + 4)/2 = 24/2 = 12
    #50
    run_test(8, 3, -1, 2);     //(5 * (-2) - 8)/2 = (-10 - 8)/2 = -9
    #50
    run_test(0, 0, 0, 0);      //0
    #50
    run_test(7, 7, 5, 3);      //((0)*(1 + 15) - 12)/2 = -6

    #100 $finish;
  end

  task run_test(
    input logic signed [size-1:0] aa,
    input logic signed [size-1:0] bb,
    input logic signed [size-1:0] cc,
    input logic signed [size-1:0] dd
  );
    begin
      expected_result = ((aa - bb) * (1 + 3 * cc) - 4 * dd) >>> 1;

      @(posedge clk);
      a <= aa;
      b <= bb;
      c <= cc;
      d <= dd;
      valid_i <= 1;

      @(posedge clk);
      valid_i <= 0;
    end
  endtask

endmodule

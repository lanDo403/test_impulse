module top
#(parameter size = 5)
(
  input  logic                     clk,
  input  logic                     reset,
  input  logic                     valid_i,
  input  logic signed [size-1:0]   a,
  input  logic signed [size-1:0]   b,
  input  logic signed [size-1:0]   c,
  input  logic signed [size-1:0]   d,

  output logic                     valid_o,
  output logic signed [size-1:0]   q
);

  //Буферизация входов по сигналу валидности
  logic signed [size-1:0] a_valid, b_valid, c_valid, d_valid;

  //Промежуточные результаты
  logic signed [2*size-1:0] stage1_result;
  logic signed [2*size-1:0] stage2_result;
  logic signed [2*size-1:0] q_reg;

  //Валидность по стадиям
  logic valid_in, valid_stage1, valid_stage2;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      valid_in     <= 0;
      valid_stage1 <= 0;
      valid_stage2 <= 0;
      valid_o      <= 0;
    end else begin
      valid_in     <= valid_i;
      valid_stage1 <= valid_in;
      valid_stage2 <= valid_stage1;
      valid_o      <= valid_stage2;
    end
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      a_valid <= 0;
      b_valid <= 0;
      c_valid <= 0;
      d_valid <= 0;
    end else if (valid_in) begin
      a_valid <= a;
      b_valid <= b;
      c_valid <= c;
      d_valid <= d;
    end
  end

  //Стадия 1: (a - b) * (1 + 3c)
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      stage1_result <= 0;
    else if (valid_stage1)
      stage1_result <= (a_valid - b_valid) * (1 + 3 * c_valid);
  end

  //Стадия 2: stage1 - 4d
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      stage2_result <= 0;
    else if (valid_stage2)
      stage2_result <= stage1_result - (4 * d_valid);
  end

  //Стадия 3: Делим результат на 2
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      q_reg <= 0;
    else if (valid_o)
      q_reg <= stage2_result >>> 1;
  end

  assign q = q_reg[size-1:0];

endmodule

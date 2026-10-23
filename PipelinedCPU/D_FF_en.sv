`timescale 1ns/10ps

module D_FF_en (q, d, en, reset, clk);
  output logic q;
  input  logic d, en, reset, clk;

  logic not_en;
  logic d_and_en;
  logic q_and_not_en;
  logic d_int;

  not  #(0.05) g0(not_en, en);

  and  #(0.05) g1(d_and_en, d, en);

  and  #(0.05) g2(q_and_not_en, q, not_en);

  or   #(0.05) g3(d_int, d_and_en, q_and_not_en);

  D_FF ff0(q, d_int, reset, clk);
endmodule

module D_FF_en_testbench();
  logic d, en, reset, clk;
  logic q;

  D_FF_en dut (.q(q), .d(d), .en(en), .reset(reset), .clk(clk));

  initial begin
    clk = 0;
    forever #500 clk = ~clk;   
  end

  initial begin
  
    reset = 1; en = 0; d = 0;
    @(posedge clk);
    @(posedge clk);
    reset = 0;

    d = 1; en = 0;
    @(posedge clk);

    en = 1;
    @(posedge clk);


    en = 0; d = 0;
    @(posedge clk);

    reset = 1;
    @(posedge clk);
    reset = 0;

    $stop;
  end
endmodule

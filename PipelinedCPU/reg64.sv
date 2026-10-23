`timescale 1ns/10ps

module reg64 (q, d, en, reset, clk);
  output [63:0] q;
  input  [63:0] d;
  input en, reset, clk;

  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : regbit
      D_FF_en ff (q[i], d[i], en, reset, clk);
    end
  endgenerate

endmodule


module reg64_testbench();
  logic [63:0] d;
  logic [63:0] q;
  logic en, reset, clk;


  reg64 dut (.q(q), .d(d), .en(en), .reset(reset), .clk(clk));

  initial begin
    clk = 0;
    forever #500 clk = ~clk;
  end

  initial begin

    reset = 1; en = 0; d = 64'h0;
    @(posedge clk);
    @(posedge clk);
    reset = 0;

    d = 64'hFFFFFFFFFFFFFFFF; en = 0;
    @(posedge clk);
	 
    en = 1;
    @(posedge clk);


    en = 0; d = 64'h123456789ABCDEF0;
    @(posedge clk);

    en = 1; d = 64'hDEADBEEFCAFEBABE;
    @(posedge clk);


    reset = 1;
    @(posedge clk);
    reset = 0;

    $stop;
  end
endmodule

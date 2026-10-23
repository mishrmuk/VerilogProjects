`timescale 1ns/10ps

module decoder5to32 (out, in, en);
  output [31:0] out;
  input  [4:0]  in;
  input         en;

  logic [4:0] n;

 
  not #(0.05) g0(n[0], in[0]);
  not #(0.05) g1(n[1], in[1]);
  not #(0.05) g2(n[2], in[2]);
  not #(0.05) g3(n[3], in[3]);
  not #(0.05) g4(n[4], in[4]);

 
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : dec
      logic b0, b1, b2, b3, b4;

      if (i[0]) begin
        buf #(0.05) s0(b0, in[0]);
      end else begin
        buf #(0.05) s0(b0, n[0]);
      end

      if (i[1]) begin
        buf #(0.05) s1(b1, in[1]);
      end else begin
        buf #(0.05) s1(b1, n[1]);
      end

      if (i[2]) begin
        buf #(0.05) s2(b2, in[2]);
      end else begin
        buf #(0.05) s2(b2, n[2]);
      end

      if (i[3]) begin
        buf #(0.05) s3(b3, in[3]);
      end else begin
        buf #(0.05) s3(b3, n[3]);
      end

      if (i[4]) begin
        buf #(0.05) s4(b4, in[4]);
      end else begin
        buf #(0.05) s4(b4, n[4]);
      end

      and #(0.05) g_and(out[i], en, b4, b3, b2, b1, b0);
    end
  endgenerate

endmodule


module decoder5to32_testbench();
  logic [4:0] in;
  logic en;
  logic [31:0] out;

  decoder5to32 dut (.out(out), .in(in), .en(en));

  initial begin
    en = 1;

    for (int i = 0; i < 32; i++) begin
      in = i[4:0];
      #500; 
    end

    en = 0;
    #500;

    $stop;
  end
endmodule

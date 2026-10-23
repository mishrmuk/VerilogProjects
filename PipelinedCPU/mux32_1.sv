`timescale 1ns/10ps

module mux32_1 (out, in, sel);
  output logic out;
  input  logic [31:0] in;
  input  logic [4:0]  sel;

  logic [15:0] w16;
  logic [7:0]  w8;
  logic [3:0]  w4;
  logic [1:0]  w2;

  genvar i;

  generate
    for (i = 0; i < 16; i = i + 1) begin : L0
      mux2_1 m (w16[i], in[2*i], in[2*i+1], sel[0]);
    end
  endgenerate

  generate
    for (i = 0; i < 8; i = i + 1) begin : L1
      mux2_1 m (w8[i], w16[2*i], w16[2*i+1], sel[1]);
    end
  endgenerate

  generate
    for (i = 0; i < 4; i = i + 1) begin : L2
      mux2_1 m (w4[i], w8[2*i], w8[2*i+1], sel[2]);
    end
  endgenerate

  generate
    for (i = 0; i < 2; i = i + 1) begin : L3
      mux2_1 m (w2[i], w4[2*i], w4[2*i+1], sel[3]);
    end
  endgenerate

  mux2_1 m_final (out, w2[0], w2[1], sel[4]);

endmodule


module mux32_1_testbench();
  logic [31:0] in;
  logic [4:0]  sel;
  logic out;

  mux32_1 dut (.out(out), .in(in), .sel(sel));

  initial begin
    for (int i = 0; i < 32; i++) begin
      sel = i;
      in  = 32'h00000001 << i;
      #500;
    end

    $stop;
  end
endmodule


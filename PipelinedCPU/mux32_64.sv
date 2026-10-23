`timescale 1ns/10ps

module mux32_64 (out, in, sel);
  output [63:0] out;
  input  [63:0] in [31:0];  
  input  [4:0]  sel;

  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : muxbit
      mux32_1 m (out[i], 
                 { in[31][i], in[30][i], in[29][i], in[28][i],
                   in[27][i], in[26][i], in[25][i], in[24][i],
                   in[23][i], in[22][i], in[21][i], in[20][i],
                   in[19][i], in[18][i], in[17][i], in[16][i],
                   in[15][i], in[14][i], in[13][i], in[12][i],
                   in[11][i], in[10][i], in[9][i],  in[8][i],
                   in[7][i],  in[6][i],  in[5][i],  in[4][i],
                   in[3][i],  in[2][i],  in[1][i],  in[0][i] },
                 sel);
    end
  endgenerate

endmodule


module mux32_64_testbench();
  logic [63:0] in [31:0];
  logic [63:0] out;
  logic [4:0]  sel;

  mux32_64 dut (.out(out), .in(in), .sel(sel));

  initial begin
    for (int i = 0; i < 32; i++)
      in[i] = 64'h1000_0000_0000_0000 >> i;

    for (int i = 0; i < 32; i++) begin
      sel = i;
      #500;
    end

    $stop;
  end
endmodule

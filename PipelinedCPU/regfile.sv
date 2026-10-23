`timescale 1ns/10ps

module regfile (
  output logic [63:0] ReadData1,
  output logic [63:0] ReadData2,
  input  logic [63:0] WriteData,
  input  logic [4:0]  ReadRegister1,
  input  logic [4:0]  ReadRegister2,
  input  logic [4:0]  WriteRegister,
  input  logic        RegWrite,
  input  logic        clk
);

  logic [31:0] we;
  logic [63:0] regs [31:0];

  decoder5to32 dec(we, WriteRegister, RegWrite);

  genvar i;
  generate
    for (i = 0; i < 31; i = i + 1) begin : regloop
      reg64 r (regs[i], WriteData, we[i], 1'b0, clk);
    end
  endgenerate

  assign regs[31] = 64'h0;

  mux32_64 muxA(ReadData1, regs, ReadRegister1);
  mux32_64 muxB(ReadData2, regs, ReadRegister2);

endmodule
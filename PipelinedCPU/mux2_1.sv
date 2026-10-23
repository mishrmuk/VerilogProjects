`timescale 1ns/10ps

module mux2_1 (out, a, b, sel);
  output logic out;
  input  logic a, b, sel;

  logic nsel, w0, w1;

  not #(0.05) g0(nsel, sel);
  and #(0.05) g1(w0, a, nsel);
  and #(0.05) g2(w1, b, sel);
  or  #(0.05) g3(out, w0, w1);

endmodule
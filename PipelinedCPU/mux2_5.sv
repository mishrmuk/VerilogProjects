`timescale 1ns/10ps

// If sel = 0, out = in0.
// If sel = 1, out = in1.
module mux2_5 (
    output logic [4:0] out,
    input  logic [4:0] in0,
    input  logic [4:0] in1,
    input  logic       sel
);

    mux2_1 m0 (out[0], in0[0], in1[0], sel);
    mux2_1 m1 (out[1], in0[1], in1[1], sel);
    mux2_1 m2 (out[2], in0[2], in1[2], sel);
    mux2_1 m3 (out[3], in0[3], in1[3], sel);
    mux2_1 m4 (out[4], in0[4], in1[4], sel);

endmodule
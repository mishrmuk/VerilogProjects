`timescale 1ns/10ps


// If sel = 0 -> out = in0
// If sel = 1 -> out = in1
module mux2_64 (
    output logic [63:0] out,
    input  logic [63:0] in0,
    input  logic [63:0] in1,
    input  logic        sel
);

    genvar i;

    generate
        for (i = 0; i < 64; i++) begin : mux_loop
            mux2_1 m (
                .out(out[i]),
                .a(in0[i]),
                .b(in1[i]),
                .sel(sel)
            );
        end
    endgenerate

endmodule
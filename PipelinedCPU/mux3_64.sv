`timescale 1ns/10ps

//chooses one of three 64 bit outputs
module mux3_64 (
    output logic [63:0] out,
    input  logic [63:0] in0,
    input  logic [63:0] in1,
    input  logic [63:0] in2,
    input  logic [1:0]  sel
);

    logic [63:0] mux01_out;

    mux2_64 m0 (
        .out(mux01_out),
        .in0(in0),
        .in1(in1),
        .sel(sel[0])
    );

    mux2_64 m1 (
        .out(out),
        .in0(mux01_out),
        .in1(in2),
        .sel(sel[1])
    );

endmodule
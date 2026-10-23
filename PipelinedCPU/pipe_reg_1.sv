`timescale 1ns/10ps

module pipe_reg_1 (
    input  logic clk,
    input  logic reset,
    input  logic en,
    input  logic flush,
    input  logic d,
    output logic q
);

    logic d_clear;

// 1-bit pipeline register
// Stores one control/data bit between pipeline stages.
// en:
//   1 = update q on clock edge
//   0 = hold old q
// flush:
//   1 = force stored value to 0
//   0 = store normal input d
    mux2_1 flush_mux (
    .out(d_clear),
    .a(d),
    .b(1'b0),
    .sel(flush)
	 );

    D_FF_en dff (
        .q(q),
        .d(d_clear),
        .reset(reset),
        .en(en),
        .clk(clk)
    );

endmodule
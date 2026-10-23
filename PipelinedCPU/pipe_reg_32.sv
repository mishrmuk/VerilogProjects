`timescale 1ns/10ps

// 32-bit pipeline register with enable and flush
// Stores a 32-bit value between pipeline stages
// en = 1: update on clock edge
// en = 0: hold old value/stall
// flush = 1: store 0 instead of d
// flush = 0: store normal d value

module pipe_reg_32 (
    input  logic        clk,
    input  logic        reset,
    input  logic        en,
    input  logic        flush,
    input  logic [31:0] d,
    output logic [31:0] q
);

    genvar i;
    generate
        for (i = 0; i < 32; i++) begin : regs
            pipe_reg_1 bit_reg (
                .clk(clk),
                .reset(reset),
                .en(en),
                .flush(flush),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule
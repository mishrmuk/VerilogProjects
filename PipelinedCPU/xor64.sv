`timescale 1ns/10ps

module xor64(out, a, b);

    output [63:0] out;
    input  [63:0] a, b;

    //bitwise xor
	 genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : xor_loop
            xor #(0.05) g1(out[i], a[i], b[i]);
        end
    endgenerate

endmodule

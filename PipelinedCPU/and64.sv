`timescale 1ns/10ps

module and64(out, a, b);

    output [63:0] out;
    input  [63:0] a, b;

	 
	 //bitwise and 
	 genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : and_loop
            and #(0.05) g1(out[i], a[i], b[i]);
        end
    endgenerate

endmodule

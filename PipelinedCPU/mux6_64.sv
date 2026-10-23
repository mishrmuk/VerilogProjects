`timescale 1ns/10ps

module mux6_64(out, in0, in1, in2, in3, in4, in5, sel);

    output logic [63:0] out;
    input  logic [63:0] in0, in1, in2, in3, in4, in5;
    input  logic [2:0] sel;

    logic n0, n1, n2; //inverted select

    logic [63:0] o0, o1, o2, o3, o4, o5;
    logic [63:0] t0, t1;

    not #(0.05) (n0, sel[0]);
    not #(0.05) (n1, sel[1]);
    not #(0.05) (n2, sel[2]);

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : sel_loop

            and #(0.05) (o0[i], in0[i], n2, n1, n0); //when sel = 000, input 0 in o0[i]

            and #(0.05) (o1[i], in1[i], n2, sel[1], n0); //when sel = 010, input 1 in o1[i]

            and #(0.05) (o2[i], in2[i], n2, sel[1], sel[0]); //when sel = 011, input 2 in o2[i]

            and #(0.05) (o3[i], in3[i], sel[2], n1, n0); //when sel = 100, input 3 in o3[i]

            and #(0.05) (o4[i], in4[i], sel[2], n1, sel[0]); //when sel = 101, input 3 in o4[i]

            and #(0.05) (o5[i], in5[i], sel[2], sel[1], n0); //when sel = 110, input 3 in o5[i]

				or #(0.05) (t0_0, o0[i], o1[i]); //selects either input 0 or 1 whether active to t0_0
				
				or #(0.05) (t0_1, o2[i], o3[i]); //selects either input 2 or 3 whether active to t0_1

				or #(0.05) (t0[i], t0_0, t0_1); //t0[i] = (o0 OR o1) OR (o2 OR o3)

				or #(0.05) (t1[i], o4[i], o5[i]); //t1[i] = o4[i] OR o5[i]

				or #(0.05) (out[i], t0[i], t1[i]); // out[i] = t0[i] OR t1[i] - picks the active input
        end
    endgenerate

endmodule


`timescale 1ns/10ps

module mux6_64_testbench();

    logic [63:0] in0, in1, in2, in3, in4, in5;
    logic [2:0] sel;
    logic [63:0] out;

    mux6_64 dut(out, in0, in1, in2, in3, in4, in5, sel);

    initial begin
        in0 = 64'h0000000000000000;
        in1 = 64'h1111111111111111;
        in2 = 64'h2222222222222222;
        in3 = 64'h3333333333333333;
        in4 = 64'h4444444444444444;
        in5 = 64'h5555555555555555;

        for (int i = 0; i < 6; i++) begin
            sel = i;
            #500;
        end

        $stop;
    end

endmodule

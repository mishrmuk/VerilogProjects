`timescale 1ns/10ps

module nor64(out, in);

    output logic out;
    input  logic [63:0] in;

    logic [15:0] l1;
    logic [3:0]  l2;
    logic l3;
    logic tmp;

    genvar i;

  
    generate
        for (i = 0; i < 16; i = i + 1) begin : L1
            or #(0.05) (l1[i],
                in[4*i],
                in[4*i+1],
                in[4*i+2],
                in[4*i+3]);
        end
    endgenerate


    generate
        for (i = 0; i < 4; i = i + 1) begin : L2
            or #(0.05) (l2[i],
                l1[4*i],
                l1[4*i+1],
                l1[4*i+2],
                l1[4*i+3]);
        end
    endgenerate

    or #(0.05) (l3, l2[0], l2[1], l2[2], l2[3]);

 
    not #(0.05) (out, l3);

endmodule

`timescale 1ns/10ps

module nor64_testbench();

    logic [63:0] in;
    logic out;

    nor64 dut(out, in);

    initial begin


        in = 64'h0000000000000000;
        #500;


        in = 64'h0000000000000001;
        #500;

        in = 64'h8000000000000000;
        #500;


        in = 64'h123456789ABCDEF0;
        #500;

        in = 64'hFFFFFFFFFFFFFFFF;
        #500;


        in = 64'hAAAAAAAAAAAAAAAA;
        #500;

        in = 64'h5555555555555555;
        #500;

        $stop;
    end

endmodule
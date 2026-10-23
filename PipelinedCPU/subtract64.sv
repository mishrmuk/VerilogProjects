`timescale 1ns/10ps

module subtract64(diff, cout, a, b);

    output logic [63:0] diff;
    output logic cout;
    input  logic [63:0] a, b;

    //inverted b
	 logic [63:0] b_inverted;

    //loop to invert b bitwise
	 genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : invert_loop
            not #(0.05) g1(b_inverted[i], b[i]);
        end
    endgenerate

    // A + ~B + 1
	 adder64 add_sub(diff, cout, a, b_inverted, 1'b1);

endmodule


`timescale 1ns/10ps

module subtract64_testbench();

    logic [63:0] a, b;
    logic [63:0] diff;
    logic cout;

    subtract64 dut(diff, cout, a, b);

    initial begin

        a = 64'd5; b = 64'd3;
        #5000;
        
        a = 64'd3; b = 64'd5;
        #5000;
        
        a = -64'd1; b = 64'd1;
        #5000;
        
        for (int i = 0; i < 10; i++) begin
            a = $random();
            b = $random();
            #5000;
            
        end

        $stop;
    end

endmodule

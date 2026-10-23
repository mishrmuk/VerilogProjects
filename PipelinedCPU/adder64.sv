`timescale 1ns/10ps

module adder64(sum, cout, a, b, cin);

    output logic [63:0] sum;
    output logic cout;
    input  logic [63:0] a, b;
    input  logic cin;

    logic [63:0] c;   //cary chain

    full_adder fa0(sum[0], c[0], a[0], b[0], cin); //LSB adder with external cin

    //63 bit ripple carry chain
	 genvar i;
    generate
        for (i = 1; i < 64; i = i + 1) begin : adders
            full_adder fa(sum[i], c[i], a[i], b[i], c[i-1]);
        end
    endgenerate

	 
    assign cout = c[63]; //last carry out

endmodule


`timescale 1ns/10ps

module adder64_testbench();

    logic [63:0] a, b;
    logic cin;
    logic [63:0] sum;
    logic cout;

    adder64 dut(sum, cout, a, b, cin);

    initial begin

        a = 64'd1; b = 64'd1; cin = 0;
        #500;


        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'h0000000000000001;
        cin = 0;
        #500;

        for (int i = 0; i < 10; i++) begin
            a = $random();
            b = $random();
            cin = $random();
            #500;
  
        end

        $stop;
    end

endmodule

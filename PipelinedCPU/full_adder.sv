`timescale 1ns/10ps

module full_adder(sum, cout, a, b, cin);

    output logic sum, cout;
    input  logic a, b, cin;

    logic axb, a_and_b, axb_and_cin;
	 
	 // Sum = a XOR b XOR cin
    xor  #(0.05) g1(axb, a, b);
    xor  #(0.05) g2(sum, axb, cin);
		
    // cout = (a & b) | (cin & (a ^ b))
	 and  #(0.05) g3(a_and_b, a, b);
    and  #(0.05) g4(axb_and_cin, axb, cin);
    or   #(0.05) g5(cout, a_and_b, axb_and_cin);

endmodule

`timescale 1ns/10ps

module full_adder_testbench();

    logic a, b, cin;
    logic sum, cout;

    full_adder dut(sum, cout, a, b, cin);

    initial begin

        for (int i = 0; i < 8; i++) begin
	
            {a, b, cin} = i;

            #200;
        
        end

        $stop;
    end

endmodule
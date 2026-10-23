// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 200000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
	
		//B Test
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		
		//Addition Tests
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		
		//Basic Addition
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		A = 64'h000000000000000A; B = 64'h0000000000000005;
		#(delay);
		assert(result == 64'h000000000000000F && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
			
		
		// zero case-
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);

		// carry out case (unsigned overflow)
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);

		// positive overflow (signed)
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h8000000000000000 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);

		// negative overflow (signed)
		A = 64'h8000000000000000; B = 64'h8000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 1 && overflow == 1 && negative == 0 && zero == 1);
		
		// mixed sign (no overflow)
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		
		
		//sUBTRACTION tESTS
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		
		// Basic subtraction
		A = 1; B = 1;
		#(delay);
		assert(result == 0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);

		A = 10; B = 5;
		#(delay);
		assert(result == 5 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 0);

		// zero case
		A = 0; B = 0;
		#(delay);
		assert(result == 0 && carry_out == 1 && zero == 1 && negative == 0 && overflow == 0);

		// unsigned wraparound (borrow happens)
		A = 0; B = 1;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && carry_out == 0 && negative == 1 && zero == 0 && overflow == 0);

		// negative result (no borrow)
		A = 5; B = 15;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFF6 && carry_out == 0 && negative == 1 && zero == 0 && overflow == 0);

		// overflow risk case
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'h8000000000000000 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);

		// negative overflow
		A = 64'h8000000000000000; B = 1;
		#(delay);
		assert(result == 64'h7FFFFFFFFFFFFFFF && carry_out == 1 && overflow == 1 && negative == 0 && zero == 0);
		
		
		
		// AND TESTS
		$display("%t testing AND", $time);
		cntrl = ALU_AND;

		// Basic AND 
		A = 64'h000000000000000F;
		B = 64'h00000000000000F0;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);

		// Overlapping bits
		A = 64'hFFFF0000FFFF0000;
		B = 64'h00FFFF00FF00FF00;
		#(delay);
		assert(result == 64'h00FF0000FF000000 && negative == result[63] && zero == 0);

		// All ones AND all ones
		A = 64'hFFFFFFFFFFFFFFFF;
		B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);

		// All zeros AND anything
		A = 64'h0000000000000000;
		B = 64'h123456789ABCDEF0;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);

		// Alternating bit pattern
		A = 64'hAAAAAAAAAAAAAAAA;
		B = 64'h5555555555555555;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);

		// Random
		A = 64'hF0F0F0F0F0F0F0F0;
		B = 64'h0FF00FF00FF00FF0;
		#(delay);
		assert(result == 64'h00F000F000F000F0 && negative == 0 && zero == 0);
		
		

		// OR TESTS
		$display("%t testing OR", $time);
		cntrl = ALU_OR;

		// Basic OR
		A = 64'h000000000000000F;
		B = 64'h00000000000000F0;
		#(delay);
		assert(result == 64'h00000000000000FF && negative == 0 && zero == 0);

		// Disjoint bit patterns
		A = 64'hF0F0F0F0F0F0F0F0;
		B = 64'h0F0F0F0F0F0F0F0F;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);

		// OR with zero
		A = 64'h0000000000000000;
		B = 64'h123456789ABCDEF0;
		#(delay);
		assert(result == 64'h123456789ABCDEF0 && negative == result[63] && zero == 0);

		// OR with all ones
		A = 64'hFFFFFFFFFFFFFFFF;
		B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);

		// Both zero
		A = 64'h0000000000000000;
		B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);

		// Mixed random pattern
		A = 64'h00FF00FF00FF00FF;
		B = 64'hFF00FF00FF00FF00;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);
		
		
		
		
		// XOR TESTS
		// -----------------------------
		$display("%t testing XOR", $time);
		cntrl = ALU_XOR;

		// Basic XOR 
		A = 64'h00000000000000FF;
		B = 64'h000000000000FF00;
		#(delay);
		assert(result == 64'h000000000000FFFF && negative == 0 && zero == 0);

		// Same pattern XOR 
		A = 64'hFFFFFFFFFFFFFFFF;
		B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);

		// XOR with zero
		A = 64'h123456789ABCDEF0;
		B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h123456789ABCDEF0 && negative == result[63] && zero == 0);

		// Alternating bit patterns
		A = 64'hAAAAAAAAAAAAAAAA;
		B = 64'h5555555555555555;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);

		// Partial overlap
		A = 64'hF0F0F0F0F0F0F0F0;
		B = 64'h0FF00FF00FF00FF0;
		#(delay);
		assert(result == 64'hFF00FF00FF00FF00 && negative == 1 && zero == 0);

		// Small values
		A = 64'h000000000000000F;
		B = 64'h0000000000000005;
		#(delay);
		assert(result == 64'h000000000000000A && negative == 0 && zero == 0);
			
	end
endmodule

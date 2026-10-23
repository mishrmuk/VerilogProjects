`timescale 1ns/10ps

module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);

    input  [63:0] A, B;
    input  [2:0]  cntrl;

    output [63:0] result;
    output negative, zero, overflow, carry_out;
	 
	 //stores output of all operations    
	 logic [63:0] add_out, sub_out, and_out, or_out, xor_out;
    logic add_cout, sub_cout;

    adder64    add_u(add_out, add_cout, A, B, 1'b0); //A+B
    subtract64 sub_u(sub_out, sub_cout, A, B);//A-B

    and64 and_u(and_out, A, B);//A&B
    or64  or_u(or_out, A, B);//A|B
    xor64 xor_u(xor_out, A, B);//A xor B

 
    logic sel1, sel2;
	 logic  [2:0]  n_cntrl; //inverse of cntrl
	 
	 not #(0.05) n2(n_cntrl[2],cntrl[2]);
	 not #(0.05) n1(n_cntrl[1],cntrl[1]); 
	 not #(0.05) n0(n_cntrl[0],cntrl[0]); 

    and #(0.05) g1(sel1, n_cntrl[2], cntrl[1], n_cntrl[0]); //sel1 signal for addition

    and #(0.05) g2(sel2, n_cntrl[2], cntrl[1], cntrl[0]); //sel2 signal for negative

    
    //cntrl chooses which operation happens
	 mux6_64 mux_u(result,
                  B,
                  add_out,
                  sub_out,
                  and_out,
                  or_out,
                  xor_out,
                  cntrl);
						
	
	
	//1 if all bits are zero
	nor64 z0(zero, result);
	
   //negative flag becomes twos complement of result
	buf #(0.05) nflag(negative, result[63]);

	logic is_add, is_sub;

	and #(0.05) c1(is_add, n_cntrl[2], cntrl[1], n_cntrl[0]); //is_add for 010
	and #(0.05) c2(is_sub, n_cntrl[2], cntrl[1], cntrl[0]); //is_sub for 011
	logic c_add, c_sub;

	and #(0.05) c3(c_add, is_add, add_cout); //passes adders carryout if current operation is add
	and #(0.05) c4(c_sub, is_sub, sub_cout); //passes subtractors carryout if current operation is sub

	or  #(0.05) o5(carry_out, c_add, c_sub); //if either carry out is on then carry is passed through
	
	
	
	logic add_same_sign;
	logic add_diff_result;

	logic sub_diff_sign_ab;
	logic sub_diff_result;

	logic add_sign_a, add_sign_b, add_sign_r;
	logic sub_sign_a, sub_sign_b, sub_sign_r;

	

	xnor #(0.05) a1(add_same_sign, A[63], B[63]);  //T when a and b same sign    
	xor  #(0.05) a2(add_diff_result, A[63], add_out[63]); //T when result signs differs from A

	and  #(0.05) o1(ov_add, add_same_sign, add_diff_result); // same input sings + different result sign = overflow

	

	xor  #(0.05) s1(sub_diff_sign_ab, A[63], B[63]); //T when A and B have different signs  
	xor  #(0.05) s2(sub_diff_result, A[63], sub_out[63]); //True when result sign differs from A

	and  #(0.05) o2(ov_sub, sub_diff_sign_ab, sub_diff_result); //sign mismatch + wrong result sign = overflow


	and #(0.05) o3_add(ov_add_final, ov_add, sel1); //add overflow only when add active
	and #(0.05) o3_sub(ov_sub_final, ov_sub, sel2); //sub overflow only whne sub active

	or  #(0.05) o4(overflow, ov_add_final, ov_sub_final); //final overflow flagged on both cases

endmodule
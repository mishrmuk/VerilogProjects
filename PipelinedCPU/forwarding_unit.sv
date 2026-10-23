`timescale 1ns/10ps

//detects data hazards and whether ALU inputs should be forwarded
module forwarding_unit (
    input  logic [4:0] id_ex_rn, //source registers currently in id/ex stage
    input  logic [4:0] id_ex_rm,

    input  logic [4:0] ex_mem_rd, //info about instruction one stage ahead in EX/MEM
    input  logic       ex_mem_RegWrite,

    input  logic [4:0] mem_wb_rd, //infor about instructions two ahead in mem/wb
    input  logic       mem_wb_RegWrite,

    output logic [1:0] ForwardA, //control signals for forwarding muxes
    output logic [1:0] ForwardB
);

//00 = no forwarding
//01 = forward from MEM/WB
//10 = forward from EX/MEM



    // equality checks - become 1 if register numbers match
	 //instruction is writing the exact register current instruction source
    logic ex_eq_rn; //ex_mem_rd == id_ex_rn
	 logic ex_eq_rm; //ex_mem_rd == id_ex_rm
    logic mem_eq_rn; //mem_wb_rd == id_ex_rn
    logic mem_eq_rm; //mem_wb_rd == id_ex_rm

    // rd != 31 checks, never forward from X31
    logic ex_rd_not31; //ex_mem_rd != 31
    logic mem_rd_not31; //mem_wb_rd != 31

    
    logic ex_hazard_A; //1 if ALU input A must forward from EX/MEM
    logic ex_hazard_B; //1 if ALU input B must forward from EX/MEM
    logic mem_hazard_A_raw; //1 if ALU input A may need forwarding from MEM/WB
    logic mem_hazard_B_raw; //1 if ALU input B may need forwarding from MEM/WB

    logic not_ex_hazard_A; //stores NOT ex_hazard a
    logic not_ex_hazard_B; //stores NOT ex_hazard b

    
    // ex_mem_rd == id_ex_rn
    // ex_eq_rn = 1 if same
    eq5_gate ex_rn_compare (
    .eq(ex_eq_rn),
    .a(ex_mem_rd),
    .b(id_ex_rn)
	 );
	 
   
    // ex_mem_rd == id_ex_rm
    // ex_eq_rm = 1 if same
    eq5_gate ex_rm_compare (
    .eq(ex_eq_rm),
    .a(ex_mem_rd),
    .b(id_ex_rm)
	 );
	 
	 
    
    // mem_wb_rd == id_ex_rn
    // mem_eq_rn = 1 if same
    eq5_gate mem_rn_compare (
    .eq(mem_eq_rn),
    .a(mem_wb_rd),
    .b(id_ex_rn)
	 );

   
    // mem_wb_rd == id_ex_rm
    // mem_eq_rm  = 1 if same
    eq5_gate mem_rm_compare (
    .eq(mem_eq_rm),
    .a(mem_wb_rd),
    .b(id_ex_rm)
	 );

 
    // rd != 31
    // Since 31 = 11111, rd != 31 if at least one bit is 0.
  
    // ex_rd_not31 = 1 when ex_mem_rd is not 11111
	 not31_gate ex_rd_not31_check (
    .not31(ex_rd_not31),
    .rd(ex_mem_rd)
	 );

    // mem_rd_not31 = 1 when mem_wb_rd is not 11111
	 not31_gate mem_rd_not31_check (
    .not31(mem_rd_not31),
    .rd(mem_wb_rd)
	 );

	 
    //Does the current instruction need a valuethat the instruction ahead is about to write
    
	 // if all true, forward ALU input A from EX/MEM to ALU input mux
    and #(0.05) ex_haz_A_and (
        ex_hazard_A, //output
        ex_mem_RegWrite, //is instruction ahead writing?
        ex_rd_not31, //is destination reg not X31?
        ex_eq_rn //intruction ahead destination match current source reg A?
    );
	 
	 // if all true, forward ALU input A from EX/MEM to ALU input mux
    and #(0.05) ex_haz_B_and (
        ex_hazard_B, //output
        ex_mem_RegWrite, //is instruction ahead writing?
        ex_rd_not31, //is destination reg not X31?
        ex_eq_rm //is instruction ahead destination equal to current source reg B
    );

    //checks whether instruction in mem/wb has value current execution needs
	 //The MEM/WB instruction writes a real register and that register is needed as ALU input A or B
    
	 //if all true, might need to forward to ALU input A
	 and #(0.05) mem_haz_A_raw_and (
        mem_hazard_A_raw, //output
        mem_wb_RegWrite, //regwrite value from mem/wb
        mem_rd_not31, //destination reg in from mem/wb not X31
        mem_eq_rn //destination reg matches current Rn
    );
	 
	 
    and #(0.05) mem_haz_B_raw_and (
        mem_hazard_B_raw, //output
        mem_wb_RegWrite, //regwrite value from mem/wb
        mem_rd_not31, ////destination reg in from mem/wb not X31
        mem_eq_rm ////destination reg matches current Rm
    );

    // MEM hazard only if EX hazard is not already true
    not #(0.05) not_ex_A (not_ex_hazard_A, ex_hazard_A);
    not #(0.05) not_ex_B (not_ex_hazard_B, ex_hazard_B);

    
	 //Use MEM/WB forwarding for ALU input A only if EX/MEM forwarding is not already needed
	 and #(0.05) mem_haz_A_final (
        ForwardA[0],
        mem_hazard_A_raw,
        not_ex_hazard_A
    );
	 
	 //Use MEM/WB forwarding for ALU input B only if EX/MEM forwarding is not already needed
    and #(0.05) mem_haz_B_final (
        ForwardB[0],
        mem_hazard_B_raw,
        not_ex_hazard_B
    );

    // Forward[1] = EX/MEM hazard
    assign ForwardA[1] = ex_hazard_A;
	 assign ForwardB[1] = ex_hazard_B;

endmodule
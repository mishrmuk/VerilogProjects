`timescale 1ns/10ps

//stores the values produced in EX so MEM can use them next cycle.
module ex_mem_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        en, // enable: 1 = update, 0 = stall/hold old values
    input  logic        flush, // flush: 1 = store zeros instead of real inputs

    input  logic [63:0] branch_target_in,  // branch target address calculated in EX
    input  logic [63:0] alu_result_in, // ALU result from EX stage
    input  logic [63:0] write_data_in, // data value to write to memory for STUR
    input  logic [63:0] pc_plus4_in, // PC+4, needed for BL writeback
   
    input  logic        zero_in, // zero flag from ALU
    input  logic        branch_taken_in, // whether branch was taken
 
    input  logic [4:0]  rd_in, // destination register number
 
    input  logic        MemRead_in, // 1 for LDUR
    input  logic        MemWrite_in, // 1 for STUR

   
    input  logic        RegWrite_in, //1 if inst writes to regfile
    input  logic        MemToReg_in,//1 if writeback frommemory
    input  logic        BL_in, //1 if instr is BL

    output logic [63:0] branch_target_out, //saved branch target to mem
    output logic [63:0] alu_result_out, //saved alu result to mem
    output logic [63:0] write_data_out, //saved store data to mem
    output logic [63:0] pc_plus4_out, //saved pc+4 to mem

    output logic        zero_out, //saved zero flag
    output logic        branch_taken_out, //saved branch taken

    output logic [4:0]  rd_out, //saved destination reg number

    output logic        MemRead_out, //mem read control
    output logic        MemWrite_out, //mem write control

    output logic        RegWrite_out, //saved reg write control
    output logic        MemToReg_out, //saved mem to reg control
    output logic        BL_out //saved BL control
);


//stores branch target address
    pipe_reg_64 r_branch_target (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(branch_target_in), .q(branch_target_out)
    );

//stores alu result (mem address or arithmetic result)
    pipe_reg_64 r_alu_result (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(alu_result_in), .q(alu_result_out)
    );

//store value to write for STUR
    pipe_reg_64 r_write_data (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(write_data_in), .q(write_data_out)
    );

//store pc+4
    pipe_reg_64 r_pc_plus4 (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(pc_plus4_in), .q(pc_plus4_out)
    );

 // store zero flags
    pipe_reg_1 r_zero (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(zero_in), .q(zero_out)
    );

//store branch taken
    pipe_reg_1 r_branch_taken (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(branch_taken_in), .q(branch_taken_out)
    );

//store rd address
    pipe_reg_5 r_rd (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(rd_in), .q(rd_out)
    );

//sotre memread
    pipe_reg_1 r_memread (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(MemRead_in), .q(MemRead_out)
    );

//store memwrite
    pipe_reg_1 r_memwrite (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(MemWrite_in), .q(MemWrite_out)
    );

//store regwrite
    pipe_reg_1 r_regwrite (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(RegWrite_in), .q(RegWrite_out)
    );
	 
//store memtoreg
    pipe_reg_1 r_memtoreg (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(MemToReg_in), .q(MemToReg_out)
    );

//store BL
    pipe_reg_1 r_bl (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(BL_in), .q(BL_out)
    );

endmodule
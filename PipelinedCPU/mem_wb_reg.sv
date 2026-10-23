`timescale 1ns/10ps

//between mem and writeback stage

module mem_wb_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        en, // enable: 1 = update, 0 = stall
    input  logic        flush, // flush: 1 = store zeros

    input  logic [63:0] read_data_in, //data loaded with LDUR
    input  logic [63:0] alu_result_in, //ALU result
    input  logic [63:0] pc_plus4_in, //PC+4 for BL writeback

    input  logic [4:0]  rd_in, // destination register

    input  logic        RegWrite_in, //enables reg file for WB
    input  logic        MemToReg_in, //mem data vs ALU (STUR)
    input  logic        BL_in, //BL instruction

    output logic [63:0] read_data_out, //saved mem read data into WB
    output logic [63:0] alu_result_out, //saved ALU result sent to WB
    output logic [63:0] pc_plus4_out, //saved PC+4 sent to WB


    output logic [4:0]  rd_out, //destination reg output

    output logic        RegWrite_out, //saved regwrite enable
    output logic        MemToReg_out, //saved WB source select
    output logic        BL_out //BL control
);

    //registers that save signals, when flush is 1 they revert to 0
	 
	 pipe_reg_64 r_read_data (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(read_data_in),
        .q(read_data_out)
    );

    pipe_reg_64 r_alu_result (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(alu_result_in),
        .q(alu_result_out)
    );

    pipe_reg_64 r_pc_plus4 (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(pc_plus4_in),
        .q(pc_plus4_out)
    );

    pipe_reg_5 r_rd (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(rd_in),
        .q(rd_out)
    );

    pipe_reg_1 r_regwrite (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(RegWrite_in),
        .q(RegWrite_out)
    );

    pipe_reg_1 r_memtoreg (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(MemToReg_in),
        .q(MemToReg_out)
    );

    pipe_reg_1 r_bl (
        .clk(clk), .reset(reset), .en(en), .flush(flush),
        .d(BL_in),
        .q(BL_out)
    );

endmodule
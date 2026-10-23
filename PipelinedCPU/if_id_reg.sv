`timescale 1ns/10ps

// IF/ID pipeline register
// This register sits between:
//   IF = Instruction Fetch
//   ID = Instruction Decode
//
// It saves the fetched instruction and PC values
// so the decode stage can use them in the next cycle

module if_id_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        en,     //1 = update, 0 = stall/hold old values
    input  logic        flush,  // 1 = clear outputs to 0/NOP


    input  logic [63:0] pc_in, //PC of fetched instr
    input  logic [63:0] pc_plus4_in, //PC+4 of fetched instr
    input  logic [31:0] instr_in, //instr from imem

    output logic [63:0] pc_out, //saved PC sent to ID Stage
    output logic [63:0] pc_plus4_out, //saved PC+4 sent to ID stage
    output logic [31:0] instr_out //saved instr sent to ID stage
);

    //save PC between IF and ID
	 pipe_reg_64 pc_reg (
        .clk(clk),
        .reset(reset),
        .en(en),
        .flush(flush),
        .d(pc_in),
        .q(pc_out)
    );

	 // Save PC+4 between IF and ID
    // useful for BL
    pipe_reg_64 pc_plus4_reg (
        .clk(clk),
        .reset(reset),
        .en(en),
        .flush(flush),
        .d(pc_plus4_in),
        .q(pc_plus4_out)
    );
	 
	 // Save 32 bit instr between IF/ID
    pipe_reg_32 instr_reg (
        .clk(clk),
        .reset(reset),
        .en(en),
        .flush(flush),
        .d(instr_in),
        .q(instr_out)
    );

endmodule
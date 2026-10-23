`timescale 1ns/10ps

// ID/EX pipeline register
// Sits between:
//   ID = instruction decode / register read
//   EX = execute / ALU / branch calculation
//
//saves:
//   data values: PC, PC+4, register values, immediate
//   register IDs: Rn, Rm, Rd
//   control signals for later stages

module id_ex_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        en,
    input  logic        flush,

    // pc/instructions
    input  logic [63:0] pc_in, //pc of instr in decode
    input  logic [63:0] pc_plus4_in, //pc+4 instr in decode
    input  logic [63:0] read_data1_in, //value read from reg1 (rn)
    input  logic [63:0] read_data2_in, //value read from reg2(Rm or Rd)
    input  logic [63:0] imm_in, //imm_gen output inputted here

    // registers
    input  logic [4:0]  rn_in, //first source reg
    input  logic [4:0]  rm_in,//second source reg
    input  logic [4:0]  rd_in, //destination reg

    // ALU controls
    input  logic        ALUSrc_in, //0 = reg, 1 = immediate
    input  logic [2:0]  ALUCtrl_in, //alu operation

    // control unit inputs
    input  logic        MemRead_in, //control for LDUR
    input  logic        MemWrite_in, //control for STUR
    input  logic        Branch_in, //conditional Branch
    input  logic        UncondBranch_in, //unconditional branch
    input  logic        CBZBranch_in, //cbz branch
    input  logic        BR_in, //BR branch
    input  logic        RegWrite_in, //write to reg file
    input  logic        MemToReg_in, //write to dmem (0 ALU result, 1, read data)
    input  logic        BL_in, //control for BL, write PC+4 to X30
	 input  logic SetFlags_in, //control for flag update for ADDS and SUBS

    // pc outputs
    output logic [63:0] pc_out, //pc into EX
    output logic [63:0] pc_plus4_out, //pc+4 into EX
    output logic [63:0] read_data1_out, //reg1 value into EX
    output logic [63:0] read_data2_out, //reg2 value into EX
    output logic [63:0] imm_out, //immediate into EX

    // register outputs
    output logic [4:0]  rn_out,
    output logic [4:0]  rm_out,
    output logic [4:0]  rd_out,

    // ALU control outputs
    output logic        ALUSrc_out,
    output logic [2:0]  ALUCtrl_out,

    // control unit outputs
    output logic        MemRead_out,
    output logic        MemWrite_out,
    output logic        Branch_out,
    output logic        UncondBranch_out,
    output logic        CBZBranch_out,
    output logic        BR_out,
    output logic        RegWrite_out,
    output logic        MemToReg_out,
    output logic        BL_out,
	 output logic SetFlags_out
);

    //stores pc
    pipe_reg_64 r_pc       (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(pc_in),         .q(pc_out));
    //stores pc+4
	 pipe_reg_64 r_pc4      (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(pc_plus4_in),  .q(pc_plus4_out));
    //stores reg1 value
	 pipe_reg_64 r_rd1      (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(read_data1_in),.q(read_data1_out));
    //stores reg2 value
	 pipe_reg_64 r_rd2      (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(read_data2_in),.q(read_data2_out));
    //stores immediate value
	 pipe_reg_64 r_imm      (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(imm_in),       .q(imm_out));

    //store sregister ID values
    pipe_reg_5 r_rn        (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(rn_in), .q(rn_out));
    pipe_reg_5 r_rm        (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(rm_in), .q(rm_out));
    pipe_reg_5 r_rd        (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(rd_in), .q(rd_out));

    // stores ALUSrc value (reg or immediate) 
    pipe_reg_1 r_alusrc    (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(ALUSrc_in), .q(ALUSrc_out));

    //stores each bit of ALU ctrl separately
	 pipe_reg_1 r_aluctrl0  (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(ALUCtrl_in[0]), .q(ALUCtrl_out[0]));
    pipe_reg_1 r_aluctrl1  (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(ALUCtrl_in[1]), .q(ALUCtrl_out[1]));
    pipe_reg_1 r_aluctrl2  (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(ALUCtrl_in[2]), .q(ALUCtrl_out[2]));

    //stores control signals
    pipe_reg_1 r_memread   (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(MemRead_in),      .q(MemRead_out));
    pipe_reg_1 r_memwrite  (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(MemWrite_in),     .q(MemWrite_out));
    pipe_reg_1 r_branch    (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(Branch_in),       .q(Branch_out));
    pipe_reg_1 r_uncond    (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(UncondBranch_in), .q(UncondBranch_out));
    pipe_reg_1 r_cbz       (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(CBZBranch_in),    .q(CBZBranch_out));
    pipe_reg_1 r_br        (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(BR_in),           .q(BR_out));

    pipe_reg_1 r_regwrite  (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(RegWrite_in), .q(RegWrite_out));
    pipe_reg_1 r_memtoreg  (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(MemToReg_in), .q(MemToReg_out));
    pipe_reg_1 r_bl        (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(BL_in),       .q(BL_out));
	 
	 pipe_reg_1 r_setflags (.clk(clk), .reset(reset), .en(en), .flush(flush), .d(SetFlags_in), .q(SetFlags_out));

endmodule
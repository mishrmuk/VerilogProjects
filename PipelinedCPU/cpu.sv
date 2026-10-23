`timescale 1ns/10ps

module cpu (
    input  logic        clk,
    input  logic        reset,

    output logic [63:0] pc, //counter goes to imem
    input  logic [31:0] instr, //instr recieved from imem based on pc

    output logic [63:0] dataadr, //memory address from LDUR/STUR
    output logic [63:0] writedata, //value outputed to store STUR
    output logic        memwrite, //turns on when to store to dmem
    output logic        memread, //turns on to load data from dmem
    output logic [3:0]  xfer_size, //8 bytes
    input  logic [63:0] read_data //value returned by LDUR from dmem
);

    logic [63:0] pc_next; //next pc value loaded in pc register
	 
	 logic [4:0] Rn, Rm, Rd; //5 bit register numbers
	 logic [4:0] ReadReg2; //selected second read register
	 logic [63:0] ReadData1; //value from register1
	 logic [63:0] ReadData2; //value from register2
	 logic [63:0] WriteData; //va;ue written back to register file
	 
	 logic RegWrite;//1 when write to reg file
	 logic Reg2Loc; //chooses whether second register is from Rm or Rd
	 
	 logic [63:0] ALUInputB; //second ALU Input
	 logic [63:0] ALUResult; //ALU output
	 
	 logic [2:0] ALUCtrl; //chooses ALU operation
	 logic       ALUSrc; //chooses register vs immediate for ALU input B
	 
	 logic negative; //raw flags from ALU
	 logic zero;
	 logic overflow;
	 logic carry_out;
	 
	 logic [63:0] ImmExt; //64 bit immediate ouput from imm_gen
	 logic [2:0]  ImmSel; //chooses which format of immediate
	 
	 logic MemToReg; //chooses writeback source, either ALUResult or read-data from mem
	 
	 logic [63:0] flags_in; //flag regi input and output
	 logic [63:0] flags_out;
	 
	 logic flag_negative; //stored/saved versions of ALU Flags 
	 logic flag_zero;
	 logic flag_overflow;
	 logic flag_carry_out;
	 logic SetFlags; //controls whether flag register actually updates (ADDS, SUBS)
	 
	 logic BL; //branch with link instruction
	 logic [4:0] WriteReg; //chosen destination reg
	 logic [63:0] WBData; //writebakc data before BL mux
	 
	 logic [63:0] pc_plus4; //next instr
	 logic [63:0] pc_branch; //branch target
	 logic [63:0] pc_branch_or_plus4; //chosen next or branch PC
	 
	 logic BranchTaken; //final branch decision
	 logic UncondBranch; //B/BL
	 logic BranchLT; //B.LT
	 logic CBZBranch; //CBZ
	 logic BR; //Branch to reg
	 
	 
	 //IF/ID Wires
	 //belong to instruction currently in decode
	 logic [63:0] if_id_pc; //stores pc from if to id
	 logic [63:0] if_id_pc_plus4; //pc+4 from if to id
	 logic [31:0] if_id_instr; //instr from if to id
	 
	 //ID/EX wires
	 //belong to instruction in EX stage
	 logic [63:0] id_ex_pc; //pc from id to ex
	 logic [63:0] id_ex_pc_plus4; //pc+4 from id to ex
	 logic [63:0] id_ex_read_data1; //value read from reg1
	 logic [63:0] id_ex_read_data2; //value read from reg2
	 logic [63:0] id_ex_imm; //immediate value
	 
	 logic [4:0] id_ex_rn; //saved source register 1 numbers
	 logic [4:0] id_ex_rm; //saved source register 2 number
	 logic [4:0] id_ex_rd; //saved destination register number
	 
	 logic       id_ex_ALUSrc; //saved control for ALU input B
	 logic [2:0] id_ex_ALUCtrl; //saved ALU operation control
	 
	 logic       id_ex_MemRead; //saved memory-read control for LDUR
	 logic       id_ex_MemWrite;//saved memory-write control for STUR
	 logic       id_ex_Branch;//saved conditional branch control like BLT
	 logic       id_ex_UncondBranch; //saved unconditional branch control
	 logic       id_ex_CBZBranch; //saved CBZ control
	 logic       id_ex_BR; //saved BR control
	 
	 logic       id_ex_RegWrite; //saved regwrite control
	 logic       id_ex_MemToReg; //saved writeback source control
	 logic       id_ex_BL; //saved BL control
	 
	 
	 
	 // EX/MEM pipeline wires
	 logic [63:0] ex_mem_branch_target; //Branch target address saved from EX
	 logic [63:0] ex_mem_alu_result; //Saved ALU result
	 logic [63:0] ex_mem_write_data; //Saved value to write to memory for STUR
	 logic [63:0] ex_mem_pc_plus4; //saved PC+4 for BL
	 
	 logic        ex_mem_zero; //saved alu zero flag
	 logic        ex_mem_branch_taken; //saved branch decision
	 
	 logic [4:0]  ex_mem_rd; //saved destination reg number
	 
	 logic        ex_mem_MemRead; //saved mem read signal for LDUR
	 logic        ex_mem_MemWrite; //saved mem write signal for STUR
	 
	 logic        ex_mem_RegWrite; //saved reg write signal
	 logic        ex_mem_MemToReg; //saved writeback source signal
	 logic        ex_mem_BL; //saved BL signal
	 
	 logic ctrl_memwrite; //raw memwrite output from control unit before pipeline
	 logic ctrl_memread; //raw memread output from control unit before pipeline
	 
	 logic id_ex_SetFlags; //saved setflags after ID/EX reg
	 
	 
	 // MEM/WB pipeline wires
	 logic [63:0] mem_wb_read_data; //saved data read from mem for LDUR 
	 logic [63:0] mem_wb_alu_result; //saved alu result for WB
	 logic [63:0] mem_wb_pc_plus4; //saved PC+4 for BL
	 
	 logic [4:0]  mem_wb_rd; //saved destination reg for WB
	 
	 logic        mem_wb_RegWrite; //final reg write enable
	 logic        mem_wb_MemToReg; //final WB source select
	 logic        mem_wb_BL; //final BL signal
	 
	 
	 
	 //Forwarding wires
	 logic [63:0] ALUInputA; //actual value going into ALU A
	 logic [63:0] ForwardedB; //forwarded reg value before ALUSrc mux
	 logic [1:0] ForwardA; //controls ALU input A forwarding
	 logic [1:0] ForwardB; //controls ALU input B forwarding
	 //00 = normal ID/EX value
	 //01 = MEM/WB forwarded value
	 //10 = EX/MEM forwarded value
	 
	 
	 //Decode stage bypass
	 logic [63:0] ID_ReadData1; //reg source 1 after WB to ID bypass
	 logic [63:0] ID_ReadData2; //reg source 2 after WB to ID bypass
	 
	 logic RedirectTaken; //becoemes 1 when any branch changes PC
	 
	 
	 
    reg64 PC ( //PC register, every clock cycle goes to next instr, reset means pc -> 0
        .q(pc),
        .d(pc_next),
        .en(1'b1),
        .reset(reset),
        .clk(clk)
    );
	 
	 
	 logic pc_plus4_cout; //unused carry-outs
	 logic pc_branch_cout;
	 
	 
	 adder64 pc_plus4_adder ( //PC + 4
		 .sum(pc_plus4),
		 .cout(pc_plus4_cout),
		 .a(pc),
		 .b(64'd4),
		 .cin(1'b0)
		 );
	
	
		//calclates pc_branch for current instruction being executed
	 adder64 pc_branch_adder (//pc_branch = current PC + branch offset
		 .sum(pc_branch),
		 .cout(pc_branch_cout),
		 .a(id_ex_pc), //pc of intruction in ID/EX
		 .b(id_ex_imm), //immediate of instruction in ID/EX
		 .cin(1'b0)
		 );
		 
	//IF/ID Register
	if_id_reg if_id (
    .clk(clk),
    .reset(reset),
    .en(1'b1), //always enabled, always fetches new instruction
    .flush(RedirectTaken), //if branch changes PC<, flush the reg and create a NOP

    .pc_in(pc), //stores most recent pc
    .pc_plus4_in(pc_plus4), //stores most recent pc Plus 4
    .instr_in(instr), //stores most recent instruction

    .pc_out(if_id_pc), //output saved values nto decode stage
    .pc_plus4_out(if_id_pc_plus4),
    .instr_out(if_id_instr)
	 );
	 
	 
	 //writeing and reding happen between ex and mem stage
    assign dataadr = ex_mem_alu_result; //memory address from ALU for LDUR/STUR in mem stage
    assign writedata = ex_mem_write_data; //value stored to memory comes from second register read in memwrite stage
    assign xfer_size = 4'd8; //sets the xfer_size
	 
	 assign memwrite = ex_mem_MemWrite; //memwrite tells what memory to write in MEM stage
	 assign memread  = ex_mem_MemRead; //memread tells what mem to read in MEM stage
	 
	 
	 //deocde works on intrcution currently in ID stage
	 assign Rn = if_id_instr[9:5]; 
	 assign Rm = if_id_instr[20:16];
	 assign Rd = if_id_instr[4:0];
	 
	 
	 
	 mux2_5 reg2loc_mux ( //chooses the second register file read address
    .out(ReadReg2),//Reg2Loc = 0 -> ReadReg2 = Rm
    .in0(Rm), //Reg2Loc = 1 -> ReadReg2 = Rd
    .in1(Rd),
    .sel(Reg2Loc)
	 ); //ADDS/SUBS use Rm and STUR/CBZ/BR use Rd
		 
		 
	 
	 //writeback happens in WB stage
	 mux2_5 bl_reg_mux (
    .out(WriteReg), //final destination reg
    .in0(mem_wb_rd), //destination reg from MEM/WB
    .in1(5'd30), //alternative is X30
    .sel(mem_wb_BL)//select signal BL from MEM/WB
	 );
	 
	 
	 regfile RF ( //register file
    .ReadData1(ReadData1), //reads Reg[Rn]
    .ReadData2(ReadData2), //reads Reg[ReadReg2]
    .WriteData(WriteData), //writes Reg[WriteReg] = WriteData when RegWrite = 1
    .ReadRegister1(Rn),
    .ReadRegister2(ReadReg2),
    .WriteRegister(WriteReg),
    .RegWrite(mem_wb_RegWrite), //register write happens in WB stage, from MEM/WB
    .clk(clk)
	 );
	
	 
	 logic wr_not31; //1 if writereg not x31
	 logic wr_eq_rn;//1 if reg being written in WB = Rn
	 logic wr_eq_readreg2; //1 if reg being written in WB = ReadReg2
	 logic bypass_read1; //decide whether to bypass for source 1
	 logic bypass_read2; //decide whether to bypass for source 2
	 
	 // WriteReg != 31
	 not31_gate wr_not31_check (
    .not31(wr_not31),
    .rd(WriteReg)
	 );
	 
	 // WriteReg == Rn
	 //Checks if WB is writing the same register that Decode is reading as source 1
	 eq5_gate eq_write_rn (
    .eq(wr_eq_rn),
    .a(WriteReg),
    .b(Rn)
	 );
	 
	 
	 // WriteReg == ReadReg2
	 //Checks if WB is writing the same register that Decode is reading as source 2
	 eq5_gate eq_write_readreg2 (
    .eq(wr_eq_readreg2),
    .a(WriteReg),
    .b(ReadReg2)
	 );
	 
	 
	 // bypass_read1 = 1 if:
	 //WB is writing a reg
	 //reg is not X31
	 //reg = Rn
	 and #(0.05) bypass1_gate (
    bypass_read1,
    mem_wb_RegWrite,
    wr_not31,
    wr_eq_rn
	 );
	 
	 
	 // bypass_read2 = 1 if:
	 //WB is writing a reg
	 //reg is not X31
	 //reg = ReadReg2
	 and #(0.05) bypass2_gate (
    bypass_read2,
    mem_wb_RegWrite,
    wr_not31,
    wr_eq_readreg2
	 );
	 
	 
	 //If WB is writing the same register ID is reading, use the new WB value immediately
	 //bypass_read1 = 0 → use normal register file output ReadData1
	 //bypass_read1 = 1 → use WriteData from WB directly
	 mux2_64 wb_id_bypass_mux1 (
    .out(ID_ReadData1),
    .in0(ReadData1),
    .in1(WriteData),
    .sel(bypass_read1)
	 );
	 
	 
	 //bypass_read2 = 0 → ID_ReadData2 = ReadData2
	 //bypass_read2 = 1 → ID_ReadData2 = WriteData
	 mux2_64 wb_id_bypass_mux2 (
    .out(ID_ReadData2),
    .in0(ReadData2),
    .in1(WriteData),
    .sel(bypass_read2)
	 );
	 
	 
	 //chooses normal writeback value, use MEM/WB because happens in WB stage
	 mux2_64 memtoreg_mux (
    .out(WBData), //output before BL
    .in0(mem_wb_alu_result), //alu result for add sub, etc
    .in1(mem_wb_read_data), //use memory data for LDUR
    .sel(mem_wb_MemToReg) //0 ALU result, 1 mem data
	 );
	 
	 //chooses final data written to reg file
	 mux2_64 bl_wb_mux (
    .out(WriteData), //final value written into register
    .in0(WBData), //normal writeback data
    .in1(mem_wb_pc_plus4), //for BL, write PC+4 (from WB stage)
    .sel(mem_wb_BL) //if current WB instr is BL, choose PC+4
	 );
	 
	 //chooses forwarded value for ALU B before immediate
	 mux3_64 forwardB_mux (
    .out(ForwardedB), //forwarded reg value for B
    .in0(id_ex_read_data2), //normal source B from ID/EX
    .in1(WriteData), //forward from Mem/WB stage
    .in2(ex_mem_alu_result), //forward from EX/MEM stage
    .sel(ForwardB) //choose ouput based on forwarding unit
	 );
	 
	 
	 mux2_64 alusrc_mux ( //chooses ALU's second input
    .out(ALUInputB), 
    .in0(ForwardedB), //reg value for R type instructions
    .in1(id_ex_imm), //use immediate for I type, from EX stage
    .sel(id_ex_ALUSrc) //choose which one, instruction with ALU in EX
	 ); //ADDS/SUBS use register, ADDI/LDUR/STUR use immediate
	 
	 
	 
	 
	 mux3_64 forwardA_mux (
    .out(ALUInputA), //final value sent to ALU input A
    .in0(id_ex_read_data1), //reg value from instruction current in EX
    .in1(WriteData), //forwarded value from MEM/WB
    .in2(ex_mem_alu_result), //forwarded value from EX/MEM
    .sel(ForwardA) //selects to forward or not from forwarding unit
	 );
	 
	 
	 
	 alu ALU ( //main arithmetic and logic unit
    .A(ALUInputA), //Reg[Rn]
    .B(ALUInputB), //ALUInputB register or immediate
    .cntrl(id_ex_ALUCtrl), ////control signal choosing ALU operation, alu works on instruction in EX
    .result(ALUResult), //output
    .negative(negative), //flags
    .zero(zero),
    .overflow(overflow),
    .carry_out(carry_out)
	 );
	 
	 
	 imm_gen IMMG ( //64 bit immediate
    .instr(if_id_instr), //instr from imem, use instruction currently in decode
    .ImmSel(ImmSel), //controlled by control
    .imm_out(ImmExt) //output of immediate, gets stores later into is_ex_imm
	 ); //ADDI -> instr[21:10]
	 //LDUR/STUR -> instr[20:12]
	 //B/BL ->instr[25:0] shifted left 2
	 //CBZ/B.LT -> instr[23:5] shifted left 2
	 
	 
	 control CTRL(  //control outputs, raw signals before pipelines except instr
    .instr(if_id_instr), //use intruction currently in decode
    .Reg2Loc(Reg2Loc),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemToReg(MemToReg),
    .MemWrite(ctrl_memwrite), //ctrl for clarity because of earlier assign
    .MemRead(ctrl_memread),
    .ALUCtrl(ALUCtrl),
    .ImmSel(ImmSel),
	 .SetFlags(SetFlags),
	 .UncondBranch(UncondBranch),
	 .BranchLT(BranchLT),
	 .CBZBranch(CBZBranch),
	 .BR(BR),
	 .BL(BL)
	 );
	 
	 

	 id_ex_reg id_ex(
    .clk(clk),
    .reset(reset),
    .en(1'b1),
    .flush(1'b0),

    .pc_in(if_id_pc), //pc from decode
    .pc_plus4_in(if_id_pc_plus4), //PC+4 from decode
    .read_data1_in(ID_ReadData1),//fire reg value read from regfile, after potential bypass
    .read_data2_in(ID_ReadData2),
    .imm_in(ImmExt), //raw signal

    .rn_in(Rn), //reg1 source
    .rm_in(ReadReg2), //Could be Rm or Rd depending on Reg2Loc
    .rd_in(Rd), //destination

    .ALUSrc_in(ALUSrc), //raw controls
    .ALUCtrl_in(ALUCtrl),

    .MemRead_in(ctrl_memread),
    .MemWrite_in(ctrl_memwrite),
    .Branch_in(BranchLT),
    .UncondBranch_in(UncondBranch),
    .CBZBranch_in(CBZBranch),
    .BR_in(BR),

    .RegWrite_in(RegWrite),
    .MemToReg_in(MemToReg),
    .BL_in(BL),
	 .SetFlags_in(SetFlags),

    .pc_out(id_ex_pc), //saved pc to next stage
    .pc_plus4_out(id_ex_pc_plus4), //saved PC+4 to next stage
    .read_data1_out(id_ex_read_data1), //saved read data to next stage
    .read_data2_out(id_ex_read_data2),
    .imm_out(id_ex_imm), //saved immediate

    .rn_out(id_ex_rn), //saved signals to next stage
    .rm_out(id_ex_rm),
    .rd_out(id_ex_rd),

    .ALUSrc_out(id_ex_ALUSrc),
    .ALUCtrl_out(id_ex_ALUCtrl),

    .MemRead_out(id_ex_MemRead),
    .MemWrite_out(id_ex_MemWrite),
    .Branch_out(id_ex_Branch),
    .UncondBranch_out(id_ex_UncondBranch),
    .CBZBranch_out(id_ex_CBZBranch),
    .BR_out(id_ex_BR),

    .RegWrite_out(id_ex_RegWrite),
    .MemToReg_out(id_ex_MemToReg),
    .BL_out(id_ex_BL),
	 .SetFlags_out(id_ex_SetFlags)
	 );
	 
	 
	 //64 bit value containing the 4 flags
	 assign flags_in = {60'd0, negative, zero, overflow, carry_out};
	 
	 reg64 FLAGS ( //store flags only when SetFlags = 1
    .q(flags_out), //happens for ADDS and SUBS
    .d(flags_in),
    .en(id_ex_SetFlags), //ALU runs in EX, use that as input
    .reset(reset),
    .clk(clk)
	 );
	 
	 assign flag_negative  = flags_out[3]; //extracts saved flags from flags register
	 assign flag_zero      = flags_out[2];
	 assign flag_overflow  = flags_out[1];
	 assign flag_carry_out = flags_out[0];
	 
	 
	 
	 logic lt_condition; //1 when saved flags are less than/negative xor overflow
	 logic take_lt; //1 when B.Lt and less than true
	 logic take_cbz; //1  when CBZ and register value is zero
	 
	 // lt_condition = flag_negative XOR flag_overflow
	 xor #(0.05) lt_xor (
    lt_condition,
    flag_negative,
    flag_overflow
	 );
	 
	 
	 // take_lt = BranchLT AND lt_condition
	 and #(0.05) lt_and (
    take_lt,
    id_ex_Branch, //in execute stage
    lt_condition
	 );
	 
	 //take_cbz = CBZBranch AND cbz_zero
	 //current instr is CBZ and selected reg is zero
	 and #(0.05) cbz_and (
    take_cbz,
    id_ex_CBZBranch, //in execute stage
    zero
	 );
	 
	 // all possible ways to branch
	 or #(0.05) branch_or (
    BranchTaken,
    id_ex_UncondBranch, //in execute stage
    take_lt,
    take_cbz
	 );
	
	
	//already used id_ex values to calculate the stuff
	 mux2_64 branch_pc_mux ( //chooses normal next PC or branch target
    .out(pc_branch_or_plus4), 
    .in0(pc_plus4),// BranchTaken = 0 -> pc_branch_or_plus4 = pc_plus4
    .in1(pc_branch), //BranchTaken = 1 -> pc_branch_or_plus4 = pc_branch
    .sel(BranchTaken)
	 );
	 
	 mux2_64 br_pc_mux ( //handles BR X30
    .out(pc_next),
    .in0(pc_branch_or_plus4), //BR = 0 -> pc_next = pc_branch_or_plus4
    .in1(ForwardedB), //BR = 1 -> pc_next = ForwardedB because accessing X30
    .sel(id_ex_BR) //branch decision in execute stage
	 );
	 
	 //for the flush IF/ID, if any branch taken
	 or #(0.05) redirect_or (
    RedirectTaken,
    BranchTaken,
    id_ex_BR //branch decision in execute stage
	 );
	 
	ex_mem_reg ex_mem (
    .clk(clk),
    .reset(reset),
    .en(1'b1),
    .flush(1'b0),

    .branch_target_in(pc_branch), //pc branch already uses previous values
    .alu_result_in(ALUResult), //generated in last stage
    .write_data_in(ForwardedB), //forwarded value
    .pc_plus4_in(id_ex_pc_plus4), //pc+4 from previous stage

    .zero_in(zero), //regular signals, no rpevious value because generated in EX
    .branch_taken_in(BranchTaken),

    .rd_in(id_ex_rd), //previous stage signals

    .MemRead_in(id_ex_MemRead),
    .MemWrite_in(id_ex_MemWrite),

    .RegWrite_in(id_ex_RegWrite),
    .MemToReg_in(id_ex_MemToReg),
    .BL_in(id_ex_BL),

    .branch_target_out(ex_mem_branch_target), //outputs into MEM
    .alu_result_out(ex_mem_alu_result),
    .write_data_out(ex_mem_write_data),
    .pc_plus4_out(ex_mem_pc_plus4),

    .zero_out(ex_mem_zero),
    .branch_taken_out(ex_mem_branch_taken),

    .rd_out(ex_mem_rd),

    .MemRead_out(ex_mem_MemRead),
    .MemWrite_out(ex_mem_MemWrite),

    .RegWrite_out(ex_mem_RegWrite),
    .MemToReg_out(ex_mem_MemToReg),
    .BL_out(ex_mem_BL)
	 );
	 
	 
	 mem_wb_reg mem_wb (
    .clk(clk),
    .reset(reset),
    .en(1'b1),
    .flush(1'b0),

    .read_data_in(read_data), //data coming back from datamem
    .alu_result_in(ex_mem_alu_result), //previous stage signal
    .pc_plus4_in(ex_mem_pc_plus4),

    .rd_in(ex_mem_rd),

    .RegWrite_in(ex_mem_RegWrite),
    .MemToReg_in(ex_mem_MemToReg),
    .BL_in(ex_mem_BL),

    .read_data_out(mem_wb_read_data), //future signals
    .alu_result_out(mem_wb_alu_result),
    .pc_plus4_out(mem_wb_pc_plus4),

    .rd_out(mem_wb_rd),

    .RegWrite_out(mem_wb_RegWrite),
    .MemToReg_out(mem_wb_MemToReg),
    .BL_out(mem_wb_BL)
	 );
	 
	 
	 forwarding_unit FU (
    .id_ex_rn(id_ex_rn),//registers in EX stage
    .id_ex_rm(id_ex_rm),

    .ex_mem_rd(ex_mem_rd), //registers in MEM Stage
    .ex_mem_RegWrite(ex_mem_RegWrite),

    .mem_wb_rd(mem_wb_rd), //registers in WB stage
    .mem_wb_RegWrite(mem_wb_RegWrite),

    .ForwardA(ForwardA), //singlas that indicate whether to forward or not and what
    .ForwardB(ForwardB)
	 );


	 


endmodule
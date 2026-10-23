`timescale 1ns/10ps

module imm_gen (
    input  logic [31:0] instr, //full 32 bit instruction
    input  logic [2:0]  ImmSel, //control singal choosing immediate format
    output logic [63:0] imm_out //final 64 bit sent to ALU or branch
);

    logic [63:0] imm_addi; //ADDI immediate
    logic [63:0] imm_d; //LDUR/STUR
    logic [63:0] imm_b; //B/BL
    logic [63:0] imm_cond; //CBZ/B.LT immediate

    logic [63:0] mux0_out; //intermediate muxes
    logic [63:0] mux1_out;

    // ADDI: zero-extend instr[21:10]
    assign imm_addi = {52'b0, instr[21:10]};

    // LDUR/STUR: sign-extend instr[20:12]
    assign imm_d = {{55{instr[20]}}, instr[20:12]};

    // B/BL: sign-extend instr[25:0] then shift left 2
    assign imm_b = {{36{instr[25]}}, instr[25:0], 2'b00};

    // CBZ/B.LT: sign-extend instr[23:5] then shift left 2
    assign imm_cond = {{43{instr[23]}}, instr[23:5], 2'b00};

    // ImmSel:
    // 000 = ADDI
    // 001 = LDUR/STUR
    // 010 = B/BL
    // 011 = CBZ/B.LT

    //chooses between imm_addi and imm_d, 000 vs 001
	 mux2_64 imm_mux0 (
        .out(mux0_out),
        .in0(imm_addi),
        .in1(imm_d),
        .sel(ImmSel[0])
    );
	 
	 //chooses between imm_b and imm_cond 010 vs 011
    mux2_64 imm_mux1 (
        .out(mux1_out),
        .in0(imm_b),
        .in1(imm_cond),
        .sel(ImmSel[0])
    );

	 //chooses between previous two muxes
    mux2_64 imm_mux2 (
        .out(imm_out),
        .in0(mux0_out),
        .in1(mux1_out),
        .sel(ImmSel[1])
    );

endmodule
`timescale 1ns/10ps

module control (
    input  logic [31:0] instr,

    output logic Reg2Loc, //choise whether second read is 20:16 or 4:0 STUR< CBZ< BR used 4:0
    output logic RegWrite, //enables write into register file unlike STUR, B, CBZ, BLT, BR
    output logic ALUSrc, //chooses ALU second input, readdata2 or immext
    output logic MemToReg, //chooses whether aluresult or read_data (LDUR) gets written to regfile
    output logic MemWrite, //enables writing to dmem STUR
    output logic MemRead, //enables reading from dmem LDUR
    output logic [2:0] ALUCtrl, //selects ALU operation
    output logic [2:0] ImmSel, //tells which instruction format to use
    output logic SetFlags, //setsflags forr ADDS or SUBS
    output logic UncondBranch, //indicates unconditional branch
    output logic BranchLT, //BLT instruction
    output logic CBZBranch, //indicates a CBZ instruction
    output logic BR, //BR instruction
    output logic BL //Branch with link instruction
);

    //do not write registers
	 //do not read/write memory
	 //do not branch
	//use ALU add by default
	//use ADDI immediate format by default
	 always_comb begin
        Reg2Loc      = 1'b0;
        RegWrite     = 1'b0;
        ALUSrc       = 1'b0;
        MemToReg     = 1'b0;
        MemWrite     = 1'b0;
        MemRead      = 1'b0;
        ALUCtrl      = 3'b010;
        ImmSel       = 3'b000;
        SetFlags     = 1'b0;
        UncondBranch = 1'b0;
        BranchLT     = 1'b0;
        CBZBranch    = 1'b0;
        BR           = 1'b0;
        BL           = 1'b0;

        casez (instr[31:21])

            11'b1001000100?: begin // ADDI
                RegWrite = 1'b1;//writes result to Rd
                ALUSrc   = 1'b1;//input B should be from immediate
                ALUCtrl  = 3'b010;//ALU adds
                ImmSel   = 3'b000; //zero extend for immediate
            end

            11'b10101011000: begin // ADDS
                RegWrite = 1'b1; //write result into Rd
                ALUSrc   = 1'b0; //Rm is ALU input B
                ALUCtrl  = 3'b010; //ALU adds
                SetFlags = 1'b1; //save ALU flags
            end

            11'b11101011000: begin // SUBS
                RegWrite = 1'b1; //write result in Rd
                ALUSrc   = 1'b0; //use Rm not immediate
                ALUCtrl  = 3'b011;//ALU subtracts
                SetFlags = 1'b1; //save ALU flags
            end

            11'b11111000010: begin // LDUR
                RegWrite = 1'b1; //loaded value into Rd
                ALUSrc   = 1'b1; //ALU uses immediate 
                MemToReg = 1'b1; //reg writeback should come from memory read_data
                MemRead  = 1'b1; //read memory data
                ALUCtrl  = 3'b010; //adds base register pus offset
                ImmSel   = 3'b001; //d type immediate
            end

            11'b11111000000: begin // STUR
                Reg2Loc  = 1'b1; //second register read from Rd, stur stores value in Rd
                ALUSrc   = 1'b1; //immediate offset for address calculation
                MemWrite = 1'b1; //turn on data memory write
                ALUCtrl  = 3'b010; //ALU adds offset
                ImmSel   = 3'b001; //d type immediate
            end

        endcase

        //if statements are used for instructions whose opcode is in different bit positions or needs extra checks.
		  
		  if (instr[31:26] == 6'b000101) begin // B
            UncondBranch = 1'b1; //take branch
            ImmSel       = 3'b010; //use b type immediate
            RegWrite     = 1'b0; //don't write to reg
        end

        if (instr[31:24] == 8'b01010100 && instr[4:0] == 5'b01011) begin // B.LT
            BranchLT = 1'b1; //this is BLT
            ImmSel   = 3'b011; //conditional branch immediate 
            RegWrite = 1'b0; //no regwrite
        end

        if (instr[31:24] == 8'b10110100) begin // CBZ
            Reg2Loc   = 1'b1; //read register 2 from Rd
            CBZBranch = 1'b1; //this is CBZ
            ImmSel    = 3'b011; //conditional branch immediate
            RegWrite  = 1'b0; //no regwrite
				ALUSrc    = 1'b0; //no immediate
				ALUCtrl   = 3'b000; //trasnfer input B

        end

        if (instr[31:21] == 11'b11010110000) begin // BR
            Reg2Loc  = 1'b1; //read register 2 from Rd
            BR       = 1'b1; //use register value as next PC
            RegWrite = 1'b0; //does not write
        end

        if (instr[31:26] == 6'b100101) begin // BL
            UncondBranch = 1'b1; //always branches
            BL           = 1'b1; //BL
            RegWrite     = 1'b1; //writes addr in X30
            ImmSel       = 3'b010; //b type immediate
            Reg2Loc      = 1'b0; //no reg2loc
        end
    end

endmodule
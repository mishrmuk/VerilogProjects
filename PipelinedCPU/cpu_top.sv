`timescale 1ns/10ps

module cpu_top (
    input logic clk,
    input logic reset
);

    logic [63:0] pc; //address sent to imem from cpu
    logic [31:0] instr; // intruction returned from imem

    logic [63:0] dataadr; //memory address for LDUR/STUR
    logic [63:0] writedata; //data outputted/stored during STUR from cpu
    logic [63:0] read_data; //data loaded during LDUR into cpu
    logic        memwrite; //1 when storing
    logic        memread; //1 when loading
    logic [3:0]  xfer_size; //bytes to transfer (64 bit word, 8 bytes)

    cpu dut (
        .clk(clk),
        .reset(reset), //top level clk and reset

        .pc(pc), //cpu sends out pc to imem
        .instr(instr), //instr sent from imem after pc sent out

        .dataadr(dataadr), //cpu outputs addr for LDUR/STUR
        .writedata(writedata), //data outputted dring STUR
        .memwrite(memwrite), //outputs 1 when storing
        .memread(memread), //outputs 1 when loading
        .xfer_size(xfer_size), //bytes
        .read_data(read_data) //data memory returns read_data
    );

    instructmem imem (
        .address(pc), //cpu inputs pc
        .instruction(instr), //imem spits out instr at that location
        .clk(clk)
    );

    datamem dmem (
        .address(dataadr), //ALu result from CPU inputted
        .write_enable(memwrite), //if memwrite from cpu = 1, data memory writes, for STUR
        .read_enable(memread), //if memread = 1, data memory reads for LDUR
        .write_data(writedata), //value being store during STUR/memwrite
        .clk(clk),
        .xfer_size(xfer_size),
        .read_data(read_data) //output logic read from datamem when memread = 1 
    );

endmodule


module cpu_top_tb;

    logic clk;
    logic reset;


    cpu_top dut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        forever #500 clk = ~clk;
    end


    initial begin
        reset = 1;
        #1200;
        reset = 0;


        #2000000;

        $stop;
    end

endmodule


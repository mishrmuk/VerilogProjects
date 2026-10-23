`timescale 1ns/10ps

//not31 = 1  → rd is not 31
//not31 = 0  → rd is 31
module not31_gate (
    output logic not31,
    input  logic [4:0] rd
);

    logic n0, n1, n2, n3, n4;

    not #(0.05) g0 (n0, rd[0]);
    not #(0.05) g1 (n1, rd[1]);
    not #(0.05) g2 (n2, rd[2]);
    not #(0.05) g3 (n3, rd[3]);
    not #(0.05) g4 (n4, rd[4]);

    or #(0.05) g5 (not31, n0, n1, n2, n3, n4);

endmodule
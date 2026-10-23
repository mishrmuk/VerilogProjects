`timescale 1ns/10ps

// If a == b, eq = 1, otherwise, eq = 0

module eq5_gate (
    output logic eq,
    input  logic [4:0] a,
    input  logic [4:0] b
);

    logic x0, x1, x2, x3, x4;

    xor #(0.05) g0 (x0, a[0], b[0]); //0 if bits are equal, 1 if different
    xor #(0.05) g1 (x1, a[1], b[1]);
    xor #(0.05) g2 (x2, a[2], b[2]);
    xor #(0.05) g3 (x3, a[3], b[3]);
    xor #(0.05) g4 (x4, a[4], b[4]);

    nor #(0.05) g5 (eq, x0, x1, x2, x3, x4); //1 only if all inputs are 0(bits are all equal)

endmodule
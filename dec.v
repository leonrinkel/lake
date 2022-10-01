module dec
(
    /* inputs */
    input [31:0] i_inst,

    /* outputs */
    output [6:0] o_opcode,
    output [2:0] o_funct3,
    output [6:0] o_funct7,
    output [4:0] o_rd,
    output [4:0] o_rs1,
    output [4:0] o_rs2
);

    assign o_opcode = i_inst[ 6: 0];
    assign o_funct3 = i_inst[14:12];
    assign o_funct7 = i_inst[31:25];
    assign o_rd     = i_inst[11: 7];
    assign o_rs1    = i_inst[19:15];
    assign o_rs2    = i_inst[24:20];

endmodule

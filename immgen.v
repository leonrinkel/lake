module immgen
(
    /* inputs */
    input [31:0] i_inst,
    input [ 6:0] i_opcode,

    /* outputs */
    output reg [31:0] o_imm
);

    always @(i_opcode)
    begin
        case (i_opcode)

            /* I-type */
            7'b0000011, /* LB, LH, LW, LBU, LHU */
            7'b0010011, /* ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI */
            7'b1100111: /* JALR */
            begin
                o_imm = {
                    {20{i_inst[31]}},
                    i_inst[31:20]
                };
            end

            /* S-type */
            7'b0100011: /* SB, SH, SW */
            begin
                o_imm = {
                    {20{i_inst[31]}},
                    i_inst[31:25],
                    i_inst[11:7]
                };
            end

            /* U-type */
            7'b0110111, /* LUI */
            7'b0010111: /* AUIPC */
            begin
                o_imm = {
                    i_inst[31:12],
                    12'b0
                };
            end

            /* J-type */
            7'b1101111: /* JAL */
            begin
                o_imm = {
                    {11{i_inst[31]}},
                    i_inst[31],
                    i_inst[19:12],
                    i_inst[20],
                    i_inst[30:21],
                    1'b0
                };
            end

            /* B-type */
            7'b1100011: /* BEQ, BNE, BLT, BGE, BLTU, BGEU */
            begin
                o_imm = {
                    {19{i_inst[31]}},
                    i_inst[31],
                    i_inst[7],
                    i_inst[30:25],
                    i_inst[11:8],
                    1'b0
                };
            end

            default: o_imm = 32'bx;

        endcase
    end

endmodule

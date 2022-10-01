module ctrl
(
    /* inputs */
    input [6:0] i_opcode,
    input [2:0] i_funct3,
    input [6:0] i_funct7,
    input       i_alu_zf,

    /* outputs */
    output reg       o_alu_op_a_sel,
    output reg       o_alu_op_b_sel,
    output reg [3:0] o_alu_op,
    output reg       o_reg_w_en,
    output reg [1:0] o_reg_wb_sel,
    output reg [2:0] o_mem_fmt,
    output reg       o_mem_w_en,
    output reg [1:0] o_pc_sel
);

    always_comb
    begin
        case (i_opcode)

            /* ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI */
            7'b0010011:
            begin
                o_alu_op_a_sel = 1'b0; /* rs1 */
                o_alu_op_b_sel = 1'b1; /* imm */
                o_reg_w_en     = 1'b1;
                o_reg_wb_sel   = 2'd0; /* alu res */
                o_mem_fmt      = 3'bx;
                o_mem_w_en     = 1'b0;
                o_pc_sel       = 2'd0; /* pc+4 */

                case (i_funct3)
                    3'b000: o_alu_op = 4'b0000; /* ADD */
                    3'b010: o_alu_op = 4'b0011; /* SLT */
                    3'b011: o_alu_op = 4'b0100; /* SLTU */
                    3'b100: o_alu_op = 4'b0101; /* XOR */
                    3'b110: o_alu_op = 4'b1000; /* OR */
                    3'b111: o_alu_op = 4'b1001; /* AND */
                    3'b001: o_alu_op = 4'b0010; /* SLL */
                    3'b101:
                    begin
                        case (i_funct7)
                            7'b0000000: o_alu_op = 4'b0110; /* SRL */
                            7'b0100000: o_alu_op = 4'b0111; /* SRA */
                            default   : o_alu_op = 4'bx;
                        endcase
                    end
                    default: o_alu_op = 4'bx;
                endcase
            end

            /* ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND */
            7'b0110011:
            begin
                o_alu_op_a_sel = 1'b0; /* rs1 */
                o_alu_op_b_sel = 1'b0; /* rs2 */
                o_reg_w_en     = 1'b1;
                o_reg_wb_sel   = 2'd0; /* alu res */
                o_mem_fmt      = 3'bx;
                o_mem_w_en     = 1'b0;
                o_pc_sel       = 2'd0; /* pc+4 */

                case (i_funct3)
                    3'b000:
                    begin
                        case (i_funct7)
                            7'b0000000: o_alu_op = 4'b0000; /* ADD */
                            7'b0100000: o_alu_op = 4'b0001; /* SUB */
                            default   : o_alu_op = 4'bx;
                        endcase
                    end
                    3'b010: o_alu_op = 4'b0011; /* SLT */
                    3'b011: o_alu_op = 4'b0100; /* SLTU */
                    3'b100: o_alu_op = 4'b0101; /* XOR */
                    3'b110: o_alu_op = 4'b1000; /* OR */
                    3'b111: o_alu_op = 4'b1001; /* AND */
                    3'b001: o_alu_op = 4'b0010; /* SLL */
                    3'b101:
                    begin
                        case (i_funct7)
                            7'b0000000: o_alu_op = 4'b0110; /* SRL */
                            7'b0100000: o_alu_op = 4'b0111; /* SRA */
                            default   : o_alu_op = 4'bx;
                        endcase
                    end
                    default: o_alu_op = 4'bx;
                endcase
            end

            /* SB, SH, SW */
            7'b0100011:
            begin
                o_alu_op_a_sel = 1'b0; /* rs1 */
                o_alu_op_b_sel = 1'b1; /* imm */
                o_alu_op       = 4'b0000; /* ADD */
                o_reg_w_en     = 1'b0;
                o_reg_wb_sel   = 2'bx;
                o_mem_fmt      = i_funct3;
                o_mem_w_en     = 1'b1;
                o_pc_sel       = 2'd0; /* pc+4 */
            end

            /* LB, LH, LW, LBU, LHU */
            7'b0000011:
            begin
                o_alu_op_a_sel = 1'b0; /* rs1 */
                o_alu_op_b_sel = 1'b1; /* imm */
                o_alu_op       = 4'b0000; /* ADD */
                o_reg_w_en     = 1'b1;
                o_reg_wb_sel   = 2'd1; /* mem */
                o_mem_fmt      = i_funct3;
                o_mem_w_en     = 1'b0;
                o_pc_sel       = 2'd0; /* pc+4 */
            end

            /* JAL */
            7'b1101111:
            begin
                o_alu_op_a_sel = 1'b1; /* pc */
                o_alu_op_b_sel = 1'b1; /* imm */
                o_alu_op       = 4'b0000; /* ADD */
                o_reg_w_en     = 1'b1;
                o_reg_wb_sel   = 2'd2; /* pc+4 */
                o_mem_fmt      = 3'bx;
                o_mem_w_en     = 1'b0;
                o_pc_sel       = 2'd1; /* alu res */
            end

            /* JALR */
            7'b1100111:
            begin
                o_alu_op_a_sel = 1'b0; /* rs1 */
                o_alu_op_b_sel = 1'b1; /* imm */
                o_alu_op       = 4'b0000; /* ADD */
                o_reg_w_en     = 1'b1;
                o_reg_wb_sel   = 2'd2; /* pc+4 */
                o_mem_fmt      = 3'bx;
                o_mem_w_en     = 1'b0;
                o_pc_sel       = 2'd1; /* alu res */
            end

            /* BEQ, BNE, BLT, BGE, BLTU, BGEU */
            7'b1100011:
            begin
                o_alu_op_a_sel = 1'b0; /* rs1 */
                o_alu_op_b_sel = 1'b0; /* rs2 */
                o_reg_w_en     = 1'b0;
                o_reg_wb_sel   = 2'bx;
                o_mem_fmt      = 3'bx;
                o_mem_w_en     = 1'b0;

                case (i_funct3)

                    /* BEQ */
                    3'b000:
                    begin
                        o_alu_op = 4'b0001; /* SUB */
                        o_pc_sel =
                            (i_alu_zf) ? 2'd2 /* pc+imm */
                                       : 2'd0 /* pc+4 */;
                    end

                    /* BNE */
                    3'b001:
                    begin
                        o_alu_op = 4'b0001; /* SUB */
                        o_pc_sel =
                            (i_alu_zf) ? 2'd0 /* pc+4 */
                                       : 2'd2 /* pc+imm */;
                    end

                    /* BLT */
                    3'b100:
                    begin
                        o_alu_op = 4'b0011; /* SLT */
                        o_pc_sel =
                            (i_alu_zf) ? 2'd0 /* pc+4 */
                                       : 2'd2 /* pc+imm */;
                    end

                    /* BGE */
                    3'b101:
                    begin
                        o_alu_op = 4'b0011; /* SLT */
                        o_pc_sel =
                            (i_alu_zf) ? 2'd2 /* pc+imm */
                                       : 2'd0 /* pc+4 */;
                    end

                    /* BLTU */
                    3'b110:
                    begin
                        o_alu_op = 4'b0100; /* SLTU */
                        o_pc_sel =
                            (i_alu_zf) ? 2'd0 /* pc+4 */
                                       : 2'd2 /* pc+imm */;
                    end

                    /* BGEU */
                    3'b111:
                    begin
                        o_alu_op = 4'b0100; /* SLTU */
                        o_pc_sel =
                            (i_alu_zf) ? 2'd2 /* pc+imm */
                                       : 2'd0 /* pc+4 */;
                    end

                    default:
                    begin
                        o_alu_op = 4'bx;
                        o_pc_sel = 2'bx;
                    end

                endcase
            end

            /* LUI */
            7'b0110111:
            begin
                o_alu_op_a_sel = 1'bx;
                o_alu_op_b_sel = 1'bx;
                o_alu_op       = 4'bx;
                o_reg_w_en     = 1'b1;
                o_reg_wb_sel   = 2'd3; /* imm */
                o_mem_fmt      = 3'bx;
                o_mem_w_en     = 1'b0;
                o_pc_sel       = 2'd0; /* pc+4 */
            end

            /* AUIPC */
            7'b0010111:
            begin
                o_alu_op_a_sel = 1'd1; /* pc */
                o_alu_op_b_sel = 1'd1; /* imm */
                o_alu_op       = 4'b0000; /* ADD */
                o_reg_w_en     = 1'b1;
                o_reg_wb_sel   = 2'd0; /* alu res */
                o_mem_fmt      = 3'bx;
                o_mem_w_en     = 1'd0;
                o_pc_sel       = 2'd0; /* pc+4 */
            end

            default:
            begin
                o_alu_op_a_sel = 1'bx;
                o_alu_op_b_sel = 1'bx;
                o_alu_op       = 4'bx;
                o_reg_w_en     = 1'bx;
                o_reg_wb_sel   = 2'bx;
                o_mem_fmt      = 3'bx;
                o_mem_w_en     = 1'bx;
                o_pc_sel       = 2'bx;
            end

        endcase
    end

endmodule

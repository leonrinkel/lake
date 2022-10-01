module lake
(
    /* inputs */
    input i_clk,
    input i_rst,

    /* outputs */
    output o_halt
);

    initial
    begin
        $dumpfile("lake.vcd");
        $dumpvars();
    end

    wire [31:0] cur_pc;
    wire [31:0] next_pc;
    wire [31:0] pc_plus_4;
    wire [31:0] imm;
    wire [31:0] pc_plus_imm;
    wire [ 1:0] pc_sel;
    wire [31:0] alu_res;
    wire [31:0] inst;
    wire [ 6:0] opcode;
    wire [ 2:0] funct3;
    wire [ 6:0] funct7;
    wire [ 4:0] rd;
    wire [ 4:0] rs1;
    wire [ 4:0] rs2;
    wire [31:0] rd_val;
    wire        reg_w_en;
    wire [31:0] rs1_val;
    wire [31:0] rs2_val;
    wire        alu_zf;
    wire        alu_op_a_sel;
    wire        alu_op_b_sel;
    wire [ 3:0] alu_op;
    wire [ 1:0] reg_wb_sel;
    wire [ 2:0] mem_fmt;
    wire        mem_w_en;
    wire [31:0] alu_op_a_val;
    wire [31:0] alu_op_b_val;
    wire [31:0] mem_r_data;

    pc pc
    (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_next_pc(next_pc),
        .o_pc(cur_pc)
    );

    adder pc_plus_4_adder
    (
        .i_op_a(cur_pc),
        .i_op_b(32'd4),
        .o_res(pc_plus_4)
    );

    adder pc_plus_imm_adder
    (
        .i_op_a(cur_pc),
        .i_op_b(imm),
        .o_res(pc_plus_imm)
    );

    mux4 pc_mux
    (
        .i_sel(pc_sel),
        .i_0(pc_plus_4),
        .i_1(alu_res),
        .i_2(pc_plus_imm),
        .i_3(32'bx),
        .o_res(next_pc)
    );

    imem imem
    (
        .i_clk(i_clk),
        .i_pc(cur_pc),
        .o_inst(inst)
    );

    dec dec
    (
        .i_inst(inst),
        .o_opcode(opcode),
        .o_funct3(funct3),
        .o_funct7(funct7),
        .o_rd(rd),
        .o_rs1(rs1),
        .o_rs2(rs2)
    );

    immgen immgen
    (
        .i_inst(inst),
        .i_opcode(opcode),
        .o_imm(imm)
    );

    regfile regfile
    (
        .i_clk(i_clk),
        .i_rs1(rs1),
        .i_rs2(rs2),
        .i_rd(rd),
        .i_rd_val(rd_val),
        .i_w_en(reg_w_en),
        .o_rs1_val(rs1_val),
        .o_rs2_val(rs2_val)
    );

    ctrl ctrl
    (
        .i_opcode(opcode),
        .i_funct3(funct3),
        .i_funct7(funct7),
        .i_alu_zf(alu_zf),
        .o_alu_op_a_sel(alu_op_a_sel),
        .o_alu_op_b_sel(alu_op_b_sel),
        .o_alu_op(alu_op),
        .o_reg_w_en(reg_w_en),
        .o_reg_wb_sel(reg_wb_sel),
        .o_mem_fmt(mem_fmt),
        .o_mem_w_en(mem_w_en),
        .o_pc_sel(pc_sel)
    );

    mux2 alu_op_a_mux
    (
        .i_sel(alu_op_a_sel),
        .i_0(rs1_val),
        .i_1(cur_pc),
        .o_res(alu_op_a_val)
    );

    mux2 alu_op_b_mux
    (
        .i_sel(alu_op_b_sel),
        .i_0(rs2_val),
        .i_1(imm),
        .o_res(alu_op_b_val)
    );

    alu alu
    (
        .i_op_a(alu_op_a_val),
        .i_op_b(alu_op_b_val),
        .i_op(alu_op),
        .o_res(alu_res),
        .o_zf(alu_zf)
    );

    dmem dmem
    (
        .i_clk(i_clk),
        .i_addr(alu_res),
        .i_w_data(rs2_val),
        .i_fmt(mem_fmt),
        .i_w_en(mem_w_en),
        .o_r_data(mem_r_data)
    );

    mux4 reg_wb_mux
    (
        .i_sel(reg_wb_sel),
        .i_0(alu_res),
        .i_1(mem_r_data),
        .i_2(pc_plus_4),
        .i_3(32'bx),
        .o_res(rd_val)
    );

    /* magic halt inst */
    assign o_halt = (inst == 32'h12300013);

endmodule

module regfile
(
    /* inputs */
    input        i_clk,
    input [ 4:0] i_rs1,
    input [ 4:0] i_rs2,
    input [ 4:0] i_rd,
    input [31:0] i_rd_val,
    input        i_w_en,

    /* outputs */
    output [31:0] o_rs1_val,
    output [31:0] o_rs2_val
);

    reg [31:0] regs [31:0];

    initial regs[0] = 32'd0;

    assign o_rs1_val = regs[i_rs1];
    assign o_rs2_val = regs[i_rs2];

    always_ff @(posedge i_clk)
    begin
        if (i_w_en && i_rd != 5'd0)
            regs[i_rd] <= i_rd_val;
    end

endmodule

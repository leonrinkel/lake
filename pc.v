module pc
(
    /* inputs */
    input        i_clk,
    input        i_rst,
    input [31:0] i_next_pc,

    /* outputs */
    output [31:0] o_pc
);

    parameter [31:0] INITIAL_PC = -32'd4;

    reg [31:0] pc;
    initial pc = INITIAL_PC;

    always @(posedge i_clk)
    begin
        if (i_rst) pc <= INITIAL_PC;
        else pc <= i_next_pc;
    end

    assign o_pc = pc;

endmodule

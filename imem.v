module imem
#(
    parameter SIZE = 256
) (
    /* inputs */
    input        i_clk,
    input [31:0] i_pc,

    /* outputs */
    output [31:0] o_inst
);

    reg [7:0] mem [SIZE-1:0];

    initial
    begin
        $readmemh("../prog.v", mem);
    end

    assign o_inst = {
        mem[(i_pc >> 2) * 4 + 3],
        mem[(i_pc >> 2) * 4 + 2],
        mem[(i_pc >> 2) * 4 + 1],
        mem[(i_pc >> 2) * 4 + 0]
    };

endmodule

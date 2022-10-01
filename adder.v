module adder
#(
    parameter WIDTH = 32
)
(
    /* inputs */
    input [WIDTH-1:0] i_op_a,
    input [WIDTH-1:0] i_op_b,

    /* outputs */
    output [WIDTH-1:0] o_res
);

    assign o_res = i_op_a + i_op_b;

endmodule

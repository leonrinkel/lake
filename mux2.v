module mux2
#(
    parameter WIDTH = 32
)
(
    /* inputs */
    input             i_sel,
    input [WIDTH-1:0] i_0,
    input [WIDTH-1:0] i_1,

    /* outputs */
    output [WIDTH-1:0] o_res
);

    assign o_res =
        (i_sel == 1'd0) ? i_0 :
            (i_sel == 1'd1) ? i_1 :
                {WIDTH{1'bz}};

endmodule

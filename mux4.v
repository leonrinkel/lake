module mux4
#(
    parameter WIDTH = 32
)
(
    /* inputs */
    input [      1:0] i_sel,
    input [WIDTH-1:0] i_0,
    input [WIDTH-1:0] i_1,
    input [WIDTH-1:0] i_2,
    input [WIDTH-1:0] i_3,

    /* outputs */
    output [WIDTH-1:0] o_res
);

    assign o_res =
        (i_sel == 2'd0) ? i_0 :
            (i_sel == 2'd1) ? i_1 :
                (i_sel == 2'd2) ? i_2 :
                    (i_sel == 2'd3) ? i_3 :
                        {WIDTH{1'bz}};

endmodule

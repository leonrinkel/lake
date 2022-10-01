module alu
(
    /* inputs */
    input signed [31:0] i_op_a,
    input signed [31:0] i_op_b,
    input        [ 3:0] i_op,

    /* outputs */
    output reg [31:0] o_res,
    output            o_zf
);

    assign o_zf = (o_res == 32'd0);

    always_comb
    begin
        case (i_op)
            4'b0000: o_res = i_op_a + i_op_b;
            4'b0001: o_res = i_op_a - i_op_b;
            4'b0010: o_res = i_op_a << i_op_b[4:0];
            4'b0011: o_res = (i_op_a < i_op_b) ? 32'b1 : 32'b0;
            4'b0100:
                o_res = ($unsigned(i_op_a) < $unsigned(i_op_b))
                    ? 32'b1 : 32'b0;
            4'b0101: o_res = i_op_a ^ i_op_b;
            4'b0110: o_res = i_op_a >> i_op_b[4:0];
            4'b0111: o_res = i_op_a >>> i_op_b[4:0];
            4'b1000: o_res = i_op_a | i_op_b;
            4'b1001: o_res = i_op_a & i_op_b;
            default: o_res = 32'd0;
        endcase
    end

endmodule

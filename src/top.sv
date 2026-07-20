`timescale 1ns/1ps

module top #(
    parameter int N = 2,
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH  = 32
)(
    input  logic clk,
    input  logic rst,
    input  logic clear,

    input  logic signed [DATA_WIDTH-1:0] a_in [N],
    input  logic signed [DATA_WIDTH-1:0] b_in [N],

    output logic signed [ACC_WIDTH-1:0] c_out [N][N]
);

    systolic_array #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) u_array (
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .a_in(a_in),
        .b_in(b_in),
        .c_out(c_out)
    );

endmodule

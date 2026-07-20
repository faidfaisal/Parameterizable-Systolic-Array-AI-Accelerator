`timescale 1ns/1ps

module systolic_array #(
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

    logic signed [DATA_WIDTH-1:0] a_wire [N][N];
    logic signed [DATA_WIDTH-1:0] b_wire [N][N];

    genvar i, j;
    generate
        for (i = 0; i < N; i++) begin : ROWS
            for (j = 0; j < N; j++) begin : COLS
                logic signed [DATA_WIDTH-1:0] pe_a_in;
                logic signed [DATA_WIDTH-1:0] pe_b_in;
                
                if (j == 0) begin
                    assign pe_a_in = a_in[i];
                end else begin
                    assign pe_a_in = a_wire[i][j-1];
                end
                
                if (i == 0) begin
                    assign pe_b_in = b_in[j];
                end else begin
                    assign pe_b_in = b_wire[i-1][j];
                end

                pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)
                ) u_pe (
                    .clk(clk),
                    .rst(rst),
                    .clear(clear),
                    .a_in(pe_a_in),
                    .b_in(pe_b_in),
                    .a_out(a_wire[i][j]),
                    .b_out(b_wire[i][j]),
                    .acc_out(c_out[i][j])
                );
            end
        end
    endgenerate

endmodule

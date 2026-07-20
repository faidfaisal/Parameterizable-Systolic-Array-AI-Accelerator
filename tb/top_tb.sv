`timescale 1ns/1ps

module top_tb;

    localparam int N = 2;
    localparam int DATA_WIDTH = 8;
    localparam int ACC_WIDTH  = 32;

    logic clk;
    logic rst;
    logic clear;
    logic signed [DATA_WIDTH-1:0] a_in [N];
    logic signed [DATA_WIDTH-1:0] b_in [N];
    logic signed [ACC_WIDTH-1:0]  c_out [N][N];

    top #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .a_in(a_in),
        .b_in(b_in),
        .c_out(c_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        clear = 0;
        a_in[0] = 0;
        a_in[1] = 0;
        b_in[0] = 0;
        b_in[1] = 0;

        #10 rst = 0;
        #10 clear = 1;
        #10 clear = 0;

        a_in[0] = 1; a_in[1] = 0; b_in[0] = 5; b_in[1] = 0; #10;
        a_in[0] = 2; a_in[1] = 3; b_in[0] = 7; b_in[1] = 6; #10;
        a_in[0] = 0; a_in[1] = 4; b_in[0] = 0; b_in[1] = 8; #10;
        a_in[0] = 0; a_in[1] = 0; b_in[0] = 0; b_in[1] = 0; #20;

        $display("TOP OUTPUT C = [[%0d, %0d], [%0d, %0d]]", c_out[0][0], c_out[0][1], c_out[1][0], c_out[1][1]);
        $finish;
    end

endmodule

`timescale 1ns/1ps

module pe_tb;

    localparam int DATA_WIDTH = 8;
    localparam int ACC_WIDTH  = 32;

    logic clk;
    logic rst;
    logic clear;
    logic signed [DATA_WIDTH-1:0] a_in, b_in;
    logic signed [DATA_WIDTH-1:0] a_out, b_out;
    logic signed [ACC_WIDTH-1:0] acc_out;

    pe #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .a_in(a_in),
        .b_in(b_in),
        .a_out(a_out),
        .b_out(b_out),
        .acc_out(acc_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        clear = 0;
        a_in = 0;
        b_in = 0;

        #10;
        rst = 0;

        a_in = 2;
        b_in = 7;
        #10;

        a_in = 3;
        b_in = 4;
        #10;

        if (acc_out !== 26) begin
            $display("PE TEST FAILED: expected 26, got %0d", acc_out);
            $finish;
        end

        clear = 1;
        #10;
        clear = 0;

        if (acc_out !== 0) begin
            $display("PE CLEAR FAILED: expected 0, got %0d", acc_out);
            $finish;
        end

        $display("PE TEST PASSED");
        $finish;
    end

endmodule

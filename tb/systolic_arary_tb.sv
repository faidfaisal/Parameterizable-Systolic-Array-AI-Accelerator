`timescale 1ns/1ps

module systolic_array_tb;

    localparam int N = 2;
    localparam int DATA_WIDTH = 8;
    localparam int ACC_WIDTH  = 32;

    logic clk;
    logic rst;
    logic clear;

    logic signed [DATA_WIDTH-1:0] a_in [N];
    logic signed [DATA_WIDTH-1:0] b_in [N];
    logic signed [ACC_WIDTH-1:0]  c_out [N][N];

    systolic_array #(
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

    task feed(input int a0, input int a1, input int b0, input int b1);
        begin
            a_in[0] = a0;
            a_in[1] = a1;
            b_in[0] = b0;
            b_in[1] = b1;
            #10;
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        clear = 0;
        a_in[0] = 0;
        a_in[1] = 0;
        b_in[0] = 0;
        b_in[1] = 0;

        #10;
        rst = 0;

        clear = 1;
        #10;
        clear = 0;

        // Matrix A = [ [1, 2], [3, 4] ]
        // Matrix B = [ [5, 6], [7, 8] ]
        // Expected C = [ [19, 22], [43, 50] ]
        //
        // Inputs are skewed so values arrive at the correct PE at the correct time.

        feed(1, 0, 5, 0);
        feed(2, 3, 7, 6);
        feed(0, 4, 0, 8);
        feed(0, 0, 0, 0);
        feed(0, 0, 0, 0);

        if (c_out[0][0] !== 19 ||
            c_out[0][1] !== 22 ||
            c_out[1][0] !== 43 ||
            c_out[1][1] !== 50) begin
            $display("SYSTOLIC ARRAY TEST FAILED");
            $display("C00=%0d C01=%0d", c_out[0][0], c_out[0][1]);
            $display("C10=%0d C11=%0d", c_out[1][0], c_out[1][1]);
            $finish;
        end

        $display("SYSTOLIC ARRAY TEST PASSED");
        $display("C = [[%0d, %0d], [%0d, %0d]]", c_out[0][0], c_out[0][1], c_out[1][0], c_out[1][1]);
        $finish;
    end

endmodule

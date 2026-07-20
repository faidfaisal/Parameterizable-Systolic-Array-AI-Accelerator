`timescale 1ns/1ps

module controller #(
    parameter int N = 2
)(
    input  logic clk,
    input  logic rst,
    input  logic start,

    output logic clear,
    output logic running,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE,
        CLEAR_ACC,
        COMPUTE,
        DONE_STATE
    } state_t;

    state_t state, next_state;
    int cycle_count;

    localparam int COMPUTE_CYCLES = (3 * N) - 2;

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            cycle_count <= 0;
        end else begin
            state <= next_state;

            if (state == COMPUTE)
                cycle_count <= cycle_count + 1;
            else
                cycle_count <= 0;
        end
    end

    always_comb begin
        next_state = state;
        clear = 1'b0;
        running = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (start)
                    next_state = CLEAR_ACC;
            end

            CLEAR_ACC: begin
                clear = 1'b1;
                next_state = COMPUTE;
            end

            COMPUTE: begin
                running = 1'b1;
                if (cycle_count == COMPUTE_CYCLES - 1)
                    next_state = DONE_STATE;
            end

            DONE_STATE: begin
                done = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

endmodule

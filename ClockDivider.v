module ClockDivider #(
    parameter                 COUNT_WIDTH = 24,
    parameter [COUNT_WIDTH:0] MAX_COUNT   = 6_000_000
) (
    input i_clk,

    output reg o_clk
);
    reg [COUNT_WIDTH:0] w_count;

    always @(posedge i_clk) begin
        if (w_count == MAX_COUNT) begin
            w_count <= 0;
            o_clk   <= ~o_clk;
        end else begin
            w_count <= w_count + 1;
        end
    end
endmodule

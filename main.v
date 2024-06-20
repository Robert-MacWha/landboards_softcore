module main (
    input i_clk,

    input [1:0] i_btn,
    output reg [3:0] o_led
);
    // Inputs
    wire rst = ~i_btn[0];
    wire btn = ~i_btn[1];

    // Internal Wires
    reg [7:0] w_peripDataToCPU;
    wire [7:0] w_peripAddr;
    wire [7:0] w_peripDataFromCPU;
    wire w_peripWrSig;
    wire w_peripRdSig;

    // Peripherals:
    always @(posedge i_clk or posedge rst) begin
        if (rst == 1) begin
            w_peripDataToCPU <= 0;
        end else begin
            if (w_peripRdSig == 1) begin
                case (w_peripAddr)
                    0: w_peripDataToCPU <= btn;
                endcase
            end else if (w_peripWrSig == 1) begin
                case (w_peripAddr)
                    1: o_led[0] <= w_peripDataFromCPU[0];
                    2: o_led[1] <= w_peripDataFromCPU[0];
                    3: o_led[2] <= w_peripDataFromCPU[0];
                    4: o_led[3] <= w_peripDataFromCPU[0];
                endcase
            end
        end
    end

    Processor #(
        .INIT_FILE("./instructions/test.mem")
    ) processor (
        .i_clk(i_clk),
        .i_rst(rst),
        .i_peripDataToCPU(w_peripDataToCPU),
        .o_peripAddr(w_peripAddr),
        .o_peripDataFromCPU(w_peripDataFromCPU),
        .o_peripWrSig(w_peripWrSig),
        .o_peripRdSig(w_peripRdSig)
    );
endmodule

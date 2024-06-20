`timescale 1 ns / 10 ps
`define DUMPSTR(x) `"Processor_tb.vcd`"

module Processor_tb ();
    reg w_clk = 0;
    reg w_rst = 0;

    reg [7:0] w_peripDataToCPU;
    wire [7:0] w_peripAddr;
    wire [7:0] w_peripDataFromCPU;
    wire w_peripWrSig;
    wire w_peripRdSig;

    localparam DURATION = 10_000;
    localparam CLK_FREQUENCY = 41.67;

    // generate 12 mHz clock signal (1 / (2 * 41.67) * 1ns) = 11,999,040.08 mHz
    always begin
        #(CLK_FREQUENCY) w_clk <= ~w_clk;
    end

    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, Processor_tb);

        // Reset the processor
        w_rst <= 1;
        #(CLK_FREQUENCY * 4) w_rst <= 0;

        w_peripDataToCPU <= 0;

        #(CLK_FREQUENCY * 4)
        // Pass the value 1 to the processor
        w_peripDataToCPU <= 1;

        #(CLK_FREQUENCY * 4) w_peripDataToCPU <= 0;

        // Tests complete
        #(DURATION) $display("Finished!");
        $finish;
    end

    Processor #(
        .INIT_FILE("instructions/test.mem")
    ) processor (
        .i_clk(w_clk),
        .i_rst(w_rst),
        .i_peripDataToCPU(w_peripDataToCPU),
        .o_peripAddr(w_peripAddr),
        .o_peripDataFromCPU(w_peripDataFromCPU),
        .o_peripWrSig(w_peripWrSig),
        .o_peripRdSig(w_peripRdSig)
    );

endmodule

`timescale 1 ns / 10 ps
`define DUMPSTR(x) `"ProgramCounter_tb.vcd`"

module ProgramCounter_tb ();
    reg w_clk = 0;
    reg w_rst = 0;
    reg w_loadPC = 0;
    reg w_incPC = 0;
    reg [12:0] w_PCVal = 0;
    wire [12:0] w_PC;

    localparam DURATION = 10_000;
    localparam CLK_FREQUENCY = 41.67;

    // generate 12 mHz clock signal (1 / (2 * 41.67) * 1ns) = 11,999,040.08 mHz
    always begin
        #(CLK_FREQUENCY) w_clk <= ~w_clk;
    end

    // run simulation
    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, ProgramCounter_tb);

        w_rst <= 1;
        #(CLK_FREQUENCY) w_rst <= 0;

        // Test 1 - set inc_PC to 1 and make sure the program counter increases
        w_incPC <= 1;
        #(8 * CLK_FREQUENCY)

        if (w_PC != 4) begin
            $display("Test 1 failed: w_PC != 4, w_PC = %d", w_PC);
            $fatal;
        end else begin
            $display("Test 1 passed: w_PC = %d", w_PC);
        end

        // Test 2 - set w_loadPC to 1 and assign a value with w_PCVal
        w_loadPC <= 1;
        w_PCVal  <= 261;
        #(4 * CLK_FREQUENCY)

        if (w_PC !== 261) begin
            $display("Test 2 failed: w_PC != 261, w_PC = %d", w_PC);
            $fatal;
        end else begin
            $display("Test 2 passed: w_PC = %d", w_PC);
        end

        // Tests complete
        #(DURATION) $display("Finished!");
        $finish;
    end

    ProgramCounter pc (
        .i_clk(w_clk),
        .i_rst(w_rst),
        .i_loadPC(w_loadPC),
        .i_incPC(w_incPC),
        .i_PCVal(w_PCVal),
        .o_PC(w_PC)
    );

endmodule

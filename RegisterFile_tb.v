`timescale 1 ns / 10 ps
`define DUMPSTR(x) `"RegisterFile_tb.vcd`"

module RegisterFile_tb ();
    localparam SELECT_WIDTH = 4;
    localparam REG_WIDTH = 8;

    reg w_clk = 0;
    reg w_ldSig = 0;
    reg [SELECT_WIDTH-1:0] w_regSel;
    reg [REG_WIDTH-1:0] w_regInData;
    wire [REG_WIDTH-1:0] w_regOutData;

    localparam DURATION = 10_000;
    localparam CLK_FREQUENCY = 41.67;

    // generate 12 mHz clock signal (1 / (2 * 41.67) * 1ns) = 11,999,040.08 mHz
    always begin
        #(CLK_FREQUENCY) w_clk <= ~w_clk;
    end

    // run simulation
    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, RegisterFile_tb);

        // Assign 10 to reg 0
        w_ldSig <= 1;
        w_regSel <= 0;
        w_regInData <= 10;
        #(2 * CLK_FREQUENCY)

        // Assign 20 to reg 3
        w_regSel <= 3;
        w_regInData <= 20;

        #(2 * CLK_FREQUENCY)

        // Test 1 - Load both values from the register
        w_ldSig <= 0;
        w_regSel <= 0;
        #(2 * CLK_FREQUENCY)

        if (w_regOutData != 10) begin
            $display("Test 1 failed: w_regOutData != 10, w_regOutData = %d", w_regOutData);
            $fatal;
        end else begin
            $display("Test 1 passed: w_regOutData = %d", w_regOutData);
        end

        w_regSel <= 3;
        #(2 * CLK_FREQUENCY)

        if (w_regOutData != 20) begin
            $display("Test 2 failed: w_regOutData != 20, w_regOutData = %d", w_regOutData);
            $fatal;
        end else begin
            $display("Test 2 passed: w_regOutData = %d", w_regOutData);
        end

        // Tests complete
        #(DURATION) $display("Finished!");
        $finish;
    end

    RegisterFile regFile (
        .i_clk(w_clk),
        .i_ldSig(w_ldSig),
        .i_regSel(w_regSel),
        .i_regData(w_regInData),
        .o_regData(w_regOutData)
    );

endmodule

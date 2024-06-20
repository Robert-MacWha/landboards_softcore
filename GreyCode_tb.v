`timescale 1 ns / 10 ps
`define DUMPSTR(x) `"GreyCode_tb.vcd`"

module GreyCode_tb;

    localparam DURATION = 10_000;

    //Ports
    reg i_clk;
    reg i_rst;
    wire [1:0] o_greyCode;

    GreyCode GreyCode_inst (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_greyCode(o_greyCode)
    );

    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, GreyCode_tb);

        // Reset
        i_clk <= 0;
        i_rst <= 1;
        #1 i_clk <= 1;
        #1 i_clk <= 0;
        i_rst <= 0;

        // Test 0 - assert grey code == 00
        if (o_greyCode != 'b00) begin
            $display("Test 1 failed: o_greyCode != 00, o_greyCode = %d", o_greyCode);
        end else begin
            $display("Test 1 passed: o_greyCode = %d", o_greyCode);
        end

        // Test 2 - Tick clock and assert greyCode == 01
        #1 i_clk <= 1;
        #1 i_clk <= 0;
        if (o_greyCode != 'b01) begin
            $display("Test 2 failed: o_greyCode != 01, o_greyCode = %d", o_greyCode);
        end else begin
            $display("Test 2 passed: o_greyCode = %d", o_greyCode);
        end

        // Test 3 - Tick clock and assert greyCode == 11
        #1 i_clk <= 1;
        #1 i_clk <= 0;
        if (o_greyCode != 'b11) begin
            $display("Test 3 failed: o_greyCode != 11, o_greyCode = %d", o_greyCode);
        end else begin
            $display("Test 3 passed: o_greyCode = %d", o_greyCode);
        end

        // Test 4 - Tick clock and assert greyCode == 10
        #1 i_clk <= 1;
        #1 i_clk <= 0;
        if (o_greyCode != 'b10) begin
            $display("Test 4 failed: o_greyCode != 10, o_greyCode = %d", o_greyCode);
        end else begin
            $display("Test 4 passed: o_greyCode = %d", o_greyCode);
        end

        // Test 5 - Tick clock and assert greyCode == 00
        #1 i_clk <= 1;
        #1 i_clk <= 0;
        if (o_greyCode != 'b00) begin
            $display("Test 5 failed: o_greyCode != 00, o_greyCode = %d", o_greyCode);
        end else begin
            $display("Test 5 passed: o_greyCode = %d", o_greyCode);
        end

        // Tests complete
        $display("Finished!");
        $finish;
    end


endmodule

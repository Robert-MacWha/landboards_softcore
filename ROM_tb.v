`timescale 1 ns / 10 ps
`define DUMPSTR(x) `"ROM_tb.vcd`"

module ROM_tb ();
    localparam SELECT_WIDTH = 4;
    localparam REG_WIDTH = 8;

    reg w_clk = 0;
    reg [9:0] w_addr = 0;
    wire [15:0] w_data;

    localparam DURATION = 10_000;
    localparam CLK_FREQUENCY = 41.67;

    // generate 12 mHz clock signal (1 / (2 * 41.67) * 1ns) = 11,999,040.08 mHz
    always begin
        #(CLK_FREQUENCY) w_clk <= ~w_clk;
    end

    // run simulation
    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, ROM_tb);

        // Test 1 - load w_addr 0
        w_addr <= 0;
        #(CLK_FREQUENCY * 2)
        if (w_data != 16'b0111000100000000) begin
            $display("Test 1 failed: w_data != 'b0111000100000000, w_data = %d", w_data);
            $fatal;
        end else begin
            $display("Test 1 passed: w_data = %d", w_data);
        end

        // Test 2 - load w_addr 1
        w_addr <= 1;
        #(CLK_FREQUENCY * 2)
        if (w_data != 16'b0111000100000011) begin
            $display("Test 2 failed: w_data != 'b0111000100000011, w_data = %d", w_data);
            $fatal;
        end else begin
            $display("Test 2 passed: w_data = %d", w_data);
        end


        // Tests complete
        #(DURATION) $display("Finished!");
        $finish;
    end

    ROM #(
        .INIT_FILE("ROM_tb.mem")
    ) rom (
        .i_clk (w_clk),
        .i_addr(w_addr),
        .o_data(w_data)
    );

endmodule

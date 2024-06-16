module main (
    input i_clk,
    input i_rst,
    input i_key0,

    output o_d1
);
    wire w_rst = ~i_rst;
    wire w_key0 = ~i_key0;

    reg w_loadPC = 0;
    reg w_incPC = 0;
    reg [12:0] w_PCVal = 0;
    wire [12:0] w_PC = 0;

    ProgramCounter programCounter (
        .i_clk(i_clk),
        .i_loadPC(w_loadPC),
        .i_incPC(w_incPC),
        .i_PCVal(w_PCVal),

        .o_PC(w_PC)
    );

endmodule

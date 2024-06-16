//? 12-bit Program Counter that supports increments and direct assignment.
module ProgramCounter (
    input             i_clk,     //? Clock (50 mHz)
    input             i_rst,
    input             i_loadPC,  //? Load PC control
    input             i_incPC,   //? Increment PC control
    input      [12:0] i_PCVal,   //? PC Load Value
    output reg [12:0] o_PC
);
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst == 1) begin
            o_PC <= 0;
        end else begin
            if (i_loadPC == 1) begin
                o_PC <= i_PCVal;
            end else if (i_incPC == 1) begin
                o_PC <= o_PC + 1;
            end
        end
    end
endmodule


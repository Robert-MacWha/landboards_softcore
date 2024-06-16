//? Register file module designed to read/write data to specified addresses.
//? By default, the data at the selected address will be written to data out. If 
//? the load signal is high, the data from data in will be written to the selected 
//? address.
module RegisterFile #(
    parameter SELECT_WIDTH = 4, //? Size of the register select signal
    parameter REG_WIDTH = 8     //? Size of a single register
) (
    input  wire                    i_clk,
    input  wire                    i_ldSig,    //? Load signal
    input  wire [SELECT_WIDTH-1:0] i_regSel,   //? Register select address
    input  wire [   REG_WIDTH-1:0] i_regData,  //? Register data in
    output reg  [   REG_WIDTH-1:0] o_regData   //? Register data out
);
    reg [REG_WIDTH-1:0] reg0 = 0;
    reg [REG_WIDTH-1:0] reg1 = 0;
    reg [REG_WIDTH-1:0] reg2 = 0;
    reg [REG_WIDTH-1:0] reg3 = 0;

    //? Register manipulation
    always @(posedge i_clk) begin
        if (i_ldSig == 1) begin
            case (i_regSel)
                'b0000: reg0 <= i_regData;
                'b0001: reg1 <= i_regData;
                'b0010: reg2 <= i_regData;
                'b0011: reg3 <= i_regData;
            endcase
        end else begin
            case (i_regSel)
                'b0000:  o_regData <= reg0;
                'b0001:  o_regData <= reg1;
                'b0010:  o_regData <= reg2;
                'b0011:  o_regData <= reg3;
                'b1000:  o_regData <= 'h00;
                'b1001:  o_regData <= 'h01;
                'b1010:  o_regData <= 'hFF;
                default: o_regData <= 'h00;
            endcase
        end
    end
endmodule

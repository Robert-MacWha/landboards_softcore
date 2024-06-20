module GreyCode (
    input i_clk,
    input i_rst,
    output reg [1:0] o_greyCode
);
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst == 1) begin
            o_greyCode = 0;
        end else begin
            case (o_greyCode)
                'b00: o_greyCode <= 'b01;
                'b01: o_greyCode <= 'b11;
                'b11: o_greyCode <= 'b10;
                'b10: o_greyCode <= 'b00;
                default: o_greyCode <= 'b00;
            endcase
        end
    end
endmodule

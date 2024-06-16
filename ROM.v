module ROM #(
    parameter INIT_FILE  = "",
    parameter ADDR_WIDTH = 10,
    parameter DATA_WIDTH = 16
) (
    input i_clk,
    input [ADDR_WIDTH-1:0] i_addr,
    output reg [DATA_WIDTH-1:0] o_data
);
    reg [DATA_WIDTH-1:0] rom[0:(1 << ADDR_WIDTH)-1];

    always @(posedge i_clk) begin
        // read to memory
        o_data <= rom[i_addr];
    end

    // Initialize memory
    initial begin
        if (INIT_FILE) begin
            $readmemh(INIT_FILE, rom);
        end
    end
endmodule

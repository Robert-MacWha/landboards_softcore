module ROM #(
    parameter INIT_FILE = ""
) (
    input             i_clk,
    input      [ 9:0] i_addr,
    output reg [15:0] o_data
);
    reg [15:0] rom[0:(1 << 10)-1];

    always @(posedge i_clk) begin
        // read from memory
        o_data <= rom[i_addr];
    end

    // Initialize memory
    initial begin
        if (INIT_FILE != "") begin
            $readmemb(INIT_FILE, rom);
        end
    end
endmodule

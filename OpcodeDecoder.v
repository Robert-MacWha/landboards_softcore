module OpcodeDecoder (
    input [15:0] i_instruction,

    output wire OP_LRI,
    output wire OP_IOR,
    output wire OP_IOW,
    output wire OP_ARI,
    output wire OP_BEZ,
    output wire OP_BNZ,
    output wire OP_JMP
);
    wire [3:0] opcode = i_instruction[15:12];

    assign OP_LRI = (opcode == 4'b0010) ? 1 : 0;
    assign OP_IOR = (opcode == 4'b0110) ? 1 : 0;
    assign OP_IOW = (opcode == 4'b0111) ? 1 : 0;
    assign OP_ARI = (opcode == 4'b1000) ? 1 : 0;
    assign OP_BEZ = (opcode == 4'b1100) ? 1 : 0;
    assign OP_BNZ = (opcode == 4'b1101) ? 1 : 0;
    assign OP_JMP = (opcode == 4'b1110) ? 1 : 0;
endmodule

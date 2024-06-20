module Processor #(
    parameter INIT_FILE = ""
) (
    input i_clk,
    input i_rst,

    // Peripheral ports
    input [7:0] i_peripDataToCPU,

    output [7:0] o_peripAddr,
    output [7:0] o_peripDataFromCPU,
    output o_peripWrSig,
    output o_peripRdSig
);
    //* Architecture
    // Program counter
    wire w_PCLoadSig;
    wire w_PCIncSig;
    wire [11:0] w_PCLoadVal;  // ? Value to load into the program counter
    wire [11:0] w_PC;  //? Value of the program counter

    // Register File
    wire w_regLdSig;
    wire [3:0] w_regSel;
    wire [7:0] w_regIn;  // ? Data written to register 
    wire [7:0] w_regOut;  // ? Data loaded from register

    // ROM
    wire [15:0] romData;

    // Opcode Decoder
    wire OP_LRI;
    wire OP_IOR;
    wire OP_IOW;
    wire OP_ARI;
    wire OP_BEZ;
    wire OP_BNZ;
    wire OP_JMP;

    // State Machine
    wire [1:0] w_greyCode;

    // ALU
    wire [7:0] w_aluOut;

    //* Function
    // Program counter manipulation
    assign w_PCLoadSig = (w_greyCode == 'b10 && OP_JMP == 1) ? 1 : 0;  // Load PC on jmp opcode
    assign w_PCIncSig = (w_greyCode == 'b10) ? 1 : 0;
    assign w_PCLoadVal = romData[11:0];

    // Register file controls
    assign w_regLdSig = (w_greyCode == 'b10 && (OP_LRI == 1 || OP_IOR == 1)) ? 1 : 0; // Load register on LRI or IOR opcodes
    assign w_regSel = romData[11:8];  // Assign register load addr based on instruction

    // Assign the register input data based on the opcode 
    // 
    // - IOR - load from perip
    // - LRI - load from rom data
    // - ARI - load from ALU output
    assign w_regIn = (OP_IOR == 1) ? i_peripDataToCPU : (OP_LRI == 1) ? romData[7:0] : (OP_ARI == 1) ? w_aluOut : 0;

    // Peripheral controls
    assign o_peripWrSig = (w_greyCode == 'b10 && OP_IOW == 1) ? 1 : 0; // Write to peripherals for one clock cycle
    assign o_peripRdSig = (w_greyCode[1] == 1 && OP_IOR == 1) ? 1 : 0; // Read from peripherals for two clock cycles
    assign o_peripAddr = romData[7:0];  // Always assign peripheral address to rom [7:0]
    assign o_peripDataFromCPU = w_regOut; // Always assign the data read from the CPU to the register data

    //* Modules
    ProgramCounter progCtr (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_loadPC(w_PCLoadSig),
        .i_incPC(w_PCIncSig),
        .i_PCVal(w_PCLoadVal),
        .o_PC(w_PC)
    );

    RegisterFile regFile (
        .i_clk(i_clk),
        .i_ldSig(w_regLdSig),
        .i_regSel(w_regSel),
        .i_regData(w_regIn),
        .o_regData(w_regOut)
    );

    OpcodeDecoder opDecoder (
        .i_instruction(romData),
        .OP_LRI(OP_LRI),
        .OP_IOR(OP_IOR),
        .OP_IOW(OP_IOW),
        .OP_ARI(OP_ARI),
        .OP_BEZ(OP_BEZ),
        .OP_BNZ(OP_BNZ),
        .OP_JMP(OP_JMP)
    );

    ROM #(
        .INIT_FILE(INIT_FILE)
    ) rom (
        .i_clk (i_clk),
        .i_addr(w_PC[9:0]),
        .o_data(romData)
    );

    GreyCode greyCodeCounter (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_greyCode(w_greyCode)
    );

endmodule

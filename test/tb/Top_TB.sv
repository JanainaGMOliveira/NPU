`timescale 1ns/1ps

module Top_TB;
    logic clk;
    logic rst;

    integer i;

    task generate_clock(input real period = 20, bit clk_pol = 1, real delay = 0);
        clk = ~clk_pol;
        #(delay);

        forever
		begin
            clk = ~clk;
            #(period/2);
        end

    endtask : generate_clock

    initial
    begin
        generate_clock();
    end

    logic        oBusy;
    logic        oDone;
    logic        oInterrupt;

    logic        iStart;
    logic [31:0] iInstructionBaseAddr;

    logic [31:0] oInstructionMemoryAddr;
    logic        oInstructionMemoryRead;

    logic [31:0] iInstructionRData;
    logic        iInstructionReady;

    logic [31:0] oMemoryAddr;
    logic        oMemoryRead;
    logic        oMemoryWrite;
    logic [31:0] oMemoryWData;

    logic [31:0] iMemoryRData;
    logic        iMemoryReady;

    logic [31:0] instructionMemory [0:255];
    logic [31:0] dataMemory        [0:255];

    Top DUT(
        .oBusy(oBusy),
        .oDone(oDone),
        .oInterrupt(oInterrupt),

        .iStart(iStart),
        .iInstructionBaseAddr(iInstructionBaseAddr),

        .oInstructionMemoryAddr(oInstructionMemoryAddr),
        .oInstructionMemoryRead(oInstructionMemoryRead),

        .iInstructionRData(iInstructionRData),
        .iInstructionReady(iInstructionReady),

        .oMemoryAddr(oMemoryAddr),
        .oMemoryRead(oMemoryRead),
        .oMemoryWrite(oMemoryWrite),
        .oMemoryWData(oMemoryWData),

        .iMemoryRData(iMemoryRData),
        .iMemoryReady(iMemoryReady),

        .clk(clk),
        .rst(rst)
    );

    parameter NPU_RTYPE    = 7'b0001011;
    parameter NPU_LW       = 7'b0101011;
    parameter NPU_SW       = 7'b1011011;
    parameter ECALL        = 7'b1110011;

    parameter FUNCT3_MAC   = 3'b000;
    parameter FUNCT3_ADD   = 3'b001;
    parameter FUNCT3_ACT   = 3'b100;

    parameter FUNCT7_RELU  = 7'b0000000;
    parameter FUNCT7_RAMPA = 7'b0000001;
    parameter FUNCT7_TANH  = 7'b0000010;
    parameter FUNCT7_SIGM  = 7'b0000011;

    function automatic [31:0] Rinstruction(input [6:0] opcode, input [2:0] funct3, input [6:0] funct7, input [4:0] rs1 = 5'b0, input [4:0] rs2 = 5'b0, input [4:0] rd = 5'b0);
    begin
        Rinstruction = {funct7, rs2, rs1, funct3, rd, opcode};
    end
    endfunction

    function automatic [31:0] LWinstruction(input [6:0] opcode, input [2:0] funct3, input [4:0] rd = 5'b0, input [4:0] rs1 = 5'b0, input [11:0] imm = 12'b0);
    begin
        LWinstruction = {imm, rs1, funct3, rd, opcode};
    end
    endfunction

    function automatic [31:0] SWinstruction(input [6:0] opcode, input [2:0] funct3, input [4:0] rs1 = 5'b0, input [4:0] rs2 = 5'b0, input [11:0] imm = 12'b0);
    begin
        SWinstruction = {imm[11:5], rs2, rs1, funct3, imm[4:0], opcode};
    end
    endfunction

    always_comb
    begin
        iInstructionReady = 1'b1;

        if (oInstructionMemoryRead)
            iInstructionRData =
                instructionMemory[oInstructionMemoryAddr[31:2]];
        else
            iInstructionRData = 32'b0;
    end

    always_comb
    begin
        iMemoryReady = 1'b1;
        iMemoryRData = oMemoryRead ? dataMemory[oMemoryAddr[31:2]] : 32'b0;
    end
    always_ff @(posedge clk)
    begin
        if (rst)
        begin
            oMemoryAddr = 0;
            dataMemory[0] <= 2;

            oMemoryAddr = 1;
            dataMemory[1] <= 5;

            oMemoryAddr = 2;
            dataMemory[2] <= 3;

            oMemoryAddr = 3;
            dataMemory[3] <= 6;

            oMemoryAddr = 4;
            dataMemory[4] <= 4;

            oMemoryAddr = 5;
            dataMemory[5] <= 7;
        end
        else if (oMemoryWrite)
        begin
            dataMemory[oMemoryAddr[31:2]] <= oMemoryWData;
        end
    end

    initial
    begin
        rst = 1'b1;
        iStart = 1'b0;

        iInstructionBaseAddr = 32'b0;

        for (i = 0; i < 256; i = i + 1)
        begin
            instructionMemory[i] = 32'b0;
        end

        // LOAD r1, [0]
        instructionMemory[0] = LWinstruction(NPU_LW, 3'b0, 5'd1, 5'd0, 12'd0);
        // LOAD r2, [4]
        instructionMemory[1] = LWinstruction(NPU_LW, 3'b0, 5'd2, 5'd0, 12'd4);

        // MAC r3, r1, r2
        instructionMemory[2] = Rinstruction(NPU_RTYPE, FUNCT3_MAC, 7'b0, 5'd1, 5'd2, 5'd3);

        // LOAD r1, [8]
        instructionMemory[3] = LWinstruction(NPU_LW, 3'b0, 5'd1, 5'd0, 12'd8);

        // LOAD r2, [12]
        instructionMemory[4] = LWinstruction(NPU_LW, 3'b0, 5'd2, 5'd0, 12'd12);

        // MAC r3, r1, r2
        instructionMemory[5] = Rinstruction(NPU_RTYPE, FUNCT3_MAC, 7'b0, 5'd1, 5'd2, 5'd3);

        // LOAD r1, [16]
        instructionMemory[6] = LWinstruction(NPU_LW, 3'b0, 5'd1, 5'd0, 12'd16);

        // LOAD r2, [20]
        instructionMemory[7] = LWinstruction(NPU_LW, 3'b0, 5'd2, 5'd0, 12'd20);

        // MAC r3, r1, r2
        instructionMemory[8] = Rinstruction(NPU_RTYPE, FUNCT3_MAC, 7'b0, 5'd1, 5'd2, 5'd3);

        // RELU r3
        instructionMemory[9] = Rinstruction(NPU_RTYPE, FUNCT3_ACT, FUNCT7_RELU, 5'd3, 5'd0, 5'd3);

        // STORE r3, [24]
        instructionMemory[10] = SWinstruction(NPU_SW, 3'b0, 5'd0, 5'd3, 12'd24);

        // ECALL
        instructionMemory[11] = {25'b0, ECALL};

        #20;
        rst = 1'b0;

        #10;
        iStart = 1'b1;

        #20;
        iStart = 1'b0;

    end
endmodule
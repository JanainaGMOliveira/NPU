module MainDecoder(
    output reg        oIsECALL,
    output reg        oRegWrite,
    output reg        oMemWrite,
    output reg        oMemRead,
    output reg        oUseMac,
    output reg [1:0]  oResultSrc,
    output reg [1:0]  oActFunct,
    output reg        oIsActivation,

    output reg [4:0]  oRs1,
    output reg [4:0]  oRs2,
    output reg [4:0]  oRd,
    output reg [11:0] oImmediate,

    output reg        oHaltRequisition,

    input      [31:0] iInstruction,
    input             iValidInstruction,
    input             rst,
    input             clk
);
    //import npu_pkg::*;
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
    
    wire [6:0] opcode  = iInstruction[6:0];
    wire [2:0] funct3  = iInstruction[14:12];
    wire [6:0] funct7  = iInstruction[31:25];

    assign oRs1  = iInstruction[19:15];
    assign oRs2  = iInstruction[24:20];
    assign oRd   = iInstruction[11:7];

    always @(iInstruction)
    begin
        oIsECALL    = 1'b0;
        oRegWrite   = 1'b0;
        oMemWrite   = 1'b0;
        oMemRead    = 1'b0;
        oUseMac     = 1'b0;
        oResultSrc  = 2'bxx;
        oActFunct   = 2'bxx;
        oIsActivation = 1'b0;

        oImmediate   = 12'bxxxxxxxxxxxx;

        if (iValidInstruction)
            case (opcode)
                NPU_RTYPE:
                begin
                    oRegWrite   = 1'b1;
                    oResultSrc = 2'b00;

                    if (funct3 == FUNCT3_MAC)
                    begin
                        oUseMac    = 1'b1;
                    end
                    else if (funct3 == FUNCT3_ACT)
                    begin
                        oActFunct = funct7[1:0];
                        oIsActivation = 1'b1;
                    end
                    else // não está sendo usado no momento
                    begin
                        oResultSrc = 2'bxx; //ADD
                    end
                end

                NPU_LW:
                begin
                    oRegWrite   = 1'b1;
                    oMemRead    = 1'b1;
                    oResultSrc  = 2'b01;
                    oImmediate   = iInstruction[31:20];
                end

                NPU_SW:
                begin
                    oMemWrite   = 1'b1;
                    oImmediate   = {iInstruction[31:25], iInstruction[11:7]};
                end

                ECALL:
                begin
                    oIsECALL    = 1'b1;
                end

                default: 
                begin
                    oIsECALL    = 1'b0;
                    oRegWrite   = 1'bx;
                    oMemWrite   = 1'bx;
                    oMemRead    = 1'bx;
                    oUseMac     = 1'bx;
                    oResultSrc  = 2'bxx;
                    oActFunct   = 2'bxx;
                end
            endcase
    end

    always @(posedge clk)
    begin
        if (rst)
            oHaltRequisition <= 0;
        else if (oIsECALL && iValidInstruction)
            oHaltRequisition <= 1;
    end
endmodule
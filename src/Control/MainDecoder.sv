module MainDecoder(
    output reg        oImmSrc,
    output reg        oRegWrite,
    output reg        oMemWrite,
    output reg        oUseMac,
    output reg [1:0]  oResultSrc,
    output reg [1:0]  oActFunct,
    input      [31:0] iInstruction
);
    import npu_pkg::*;
    
    wire [6:0] opcode  = iInstruction[6:0];
    wire [2:0] funct3  = iInstruction[14:12];
    wire [6:0] funct7  = iInstruction[31:25];

    always @(iInstruction)
    begin
        case (opcode)
            NPU_RTYPE:
            begin
                oImmSrc     = 1'bx;
                oRegWrite   = 1'b1;
                oMemWrite   = 1'b0;

                if (funct3 == FUNCT3_MAC)
                begin
                    oUseMac    = 1'b1;
                    oResultSrc = 2'b00; // MAC
                    oActFunct = 2'bxx;
                end
                else if (funct3 == FUNCT3_ACT)
                begin
                    oUseMac    = 1'b0;
                    oResultSrc  = 2'b01;
                    oActFunct = funct7[1:0];
                end
                else // não está sendo usado no momento
                begin
                    oUseMac    = 1'b0;
                    oResultSrc = 2'bxx; //ADD
                    oActFunct = 2'bxx;
                end
            end

            NPU_LW:
            begin
                oImmSrc     = 1'b0;
                oRegWrite   = 1'b1;
                oMemWrite   = 1'b0;
                oUseMac     = 1'b0;
                oResultSrc  = 2'b10;
                oActFunct   = 2'bxx;
            end

            NPU_SW:
            begin
                oImmSrc     = 1'b1;
                oRegWrite   = 1'b0;
                oMemWrite   = 1'b1;
                oUseMac     = 1'b0;
                oResultSrc  = 2'bxx;
                oActFunct   = 2'bxx;
            end

            default: 
            begin
                oRegWrite   = 1'bx;
                oImmSrc     = 1'bx;
                oMemWrite   = 1'bx;
                oUseMac     = 1'bx;
                oResultSrc  = 2'bxx;
                oActFunct = 2'bxx;
            end
        endcase
    end
endmodule
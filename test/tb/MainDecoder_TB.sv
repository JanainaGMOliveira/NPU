`timescale 1ns/1ps
module MainDecoder_TB;

    import npu_pkg::*;

    logic        immSrc;
    logic        regWrite;
    logic        memWrite;
    logic        useMac;
    logic [1:0]  resultSrc;
    logic [1:0]  actFunct;
    logic [31:0] instruction;

    bit errorFlag = 0;

    MainDecoder DUT(
                    .oImmSrc(immSrc),
                    .oRegWrite(regWrite),
                    .oMemWrite(memWrite),
                    .oUseMac(useMac),
                    .oResultSrc(resultSrc),
                    .oActFunct(actFunct),
                    .iInstruction(instruction)
    );

    task create_r_instruction(input [6:0] opcode, input [2:0] funct3, input [6:0] funct7);
    begin
        instruction = {funct7, 5'b0, 5'b0, funct3, 5'b0, opcode};
        #1;
    end
    endtask

    task create_lw_instruction(input [6:0] opcode, input [2:0] funct3);
    begin
        instruction = {12'b0, 5'b0, funct3, 5'b0, opcode};
        #1;
    end
    endtask

    task create_sw_instruction(input [6:0] opcode, input [2:0] funct3);
    begin
        instruction = {7'b0, 5'b0, 5'b0, funct3, 5'b0, opcode};
        #1;
    end
    endtask

    task verify_result(input string testName, input expectedImmSrc, input expectedRegWrite, input expectedMemWrite,
        input expectedUseMac, input [1:0] expectedResultSrc, input [1:0] expectedActFunct);
    begin
        assert(($isunknown(expectedImmSrc) && $isunknown(immSrc)) || (immSrc == expectedImmSrc))
        else
        begin
            errorFlag = 1;
            $error("[ERROR] %s: immSrc:    Expected: %b, Got: %b", testName, expectedImmSrc, immSrc);
        end
        
        assert(($isunknown(expectedRegWrite) && $isunknown(regWrite)) || (regWrite == expectedRegWrite))
        else
        begin
            errorFlag = 1;
            $error("[ERROR] %s: regWrite:  Expected: %b, Got: %b", testName, expectedRegWrite, regWrite);
        end

        assert(($isunknown(expectedMemWrite) && $isunknown(memWrite)) || (memWrite == expectedMemWrite))
        else
        begin
            errorFlag = 1;
            $error("[ERROR] %s: memWrite:  Expected: %b, Got: %b", testName, expectedMemWrite, memWrite);
        end

        assert(($isunknown(expectedUseMac) && $isunknown(useMac)) || (useMac == expectedUseMac))
        else
        begin
            errorFlag = 1;
            $error("[ERROR] %s: useMac:    Expected: %b, Got: %b", testName, expectedUseMac, useMac);
        end

        assert(($isunknown(expectedResultSrc) && $isunknown(resultSrc)) || (resultSrc == expectedResultSrc))
        else
        begin
            errorFlag = 1;
            $error("[ERROR] %s: resultSrc: Expected: %b, Got: %b", testName, expectedResultSrc, resultSrc);
        end

        assert(($isunknown(expectedActFunct) && $isunknown(actFunct)) || (actFunct == expectedActFunct))
        else
        begin
            errorFlag = 1;
            $error("[ERROR] %s: actFunct:  Expected: %b, Got: %b", testName, expectedActFunct, actFunct);
        end

        if (!errorFlag)
            $display("[PASS] %s", testName);
    end
    endtask

    initial
    begin
        create_r_instruction(NPU_RTYPE, FUNCT3_MAC, 7'b0);
        verify_result("R-TYPE MAC",         1'bx, 1, 0, 1, 2'b00, 2'bxx);

        create_r_instruction(NPU_RTYPE, FUNCT3_ADD, 7'b0);
        verify_result("R-TYPE ADD",         1'bx, 1, 0, 0, 2'bxx, 2'bxx);

        create_r_instruction(NPU_RTYPE, FUNCT3_ACT, FUNCT7_RELU);
        verify_result("R-TYPE ACT (RELU)",  1'bx, 1, 0, 0, 2'b01, 2'b00);

        create_r_instruction(NPU_RTYPE, FUNCT3_ACT, FUNCT7_RAMPA);
        verify_result("R-TYPE ACT (RAMPA)", 1'bx, 1, 0, 0, 2'b01, 2'b01);

        create_r_instruction(NPU_RTYPE, FUNCT3_ACT, FUNCT7_TANH);
        verify_result("R-TYPE ACT (TANH)",  1'bx, 1, 0, 0, 2'b01, 2'b10);
        
        create_r_instruction(NPU_RTYPE, FUNCT3_ACT, FUNCT7_SIGM);
        verify_result("R-TYPE ACT (SIGM)",  1'bx, 1, 0, 0, 2'b01, 2'b11);

        create_lw_instruction(NPU_LW, 3'b0);
        verify_result("LOAD", 0, 1, 0, 0, 2'b10, 2'bxx);

        create_sw_instruction(NPU_SW, 3'b0);
        verify_result("STORE", 1, 0, 1, 0, 2'bxx, 2'bxx);

        create_r_instruction(7'b1111111, 3'b0, 7'b0);
        verify_result("DEFAULT", 1'bx, 1'bx, 1'bx, 1'bx, 2'bxx, 2'bxx);

        $stop;
    end

endmodule
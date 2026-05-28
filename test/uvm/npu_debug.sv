`ifndef NPU_DEBUG_SV
`define NPU_DEBUG_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "npu_macros.svh"
interface npu_debug(input logic clk);

    logic        validInstructionF, validInstructionD, validInstructionE1, validInstructionE2, validInstructionM, validInstructionWB;
    logic                           regWriteD,         regWriteE1,         regWriteE2,         regWriteM,         regWriteWB, regWriteValid;
    logic                           memReadD,          memReadE1,          memReadE2,          memReadM;
    logic                           memWriteD,         memWriteE1,         memWriteE2,         memWriteM;
    logic [1:0]                     resultSrcD,        resultSrcE1,        resultSrcE2,        resultSrcM,        resultSrcWB;
    logic                           useMacD,           useMacE1,           useMacE2,           useMacM;
    logic [1:0]                     actFunctD,         actFunctE1,         actFunctE2;
    logic                           isActivationD,     isActivationE1,     isActivationE2;
    logic                           isECALLD;
    logic                                                                  useAccBypassOnActE2;

    logic [31:0]                                       mulResultE1,        mulResultE2;
    logic [31:0]                                                           resultE2,           resultM,           resultWB;
    logic [31:0]                    readData1D,        readData1E1;
    logic [31:0]                    readData2D,        readData2E1;
    logic [4:0]                     rs1D,              rs1E1,              rs1E2;
    logic [4:0]                     rs2D,              rs2E1;
    logic [4:0]                     rdD,               rdE1,               rdE2,               rdM,                rdWB;
    logic [31:0]                                                                                                   writeDataReg;
    logic [31:0]                                                           storeDataE2,        storeDataM;
    logic [31:0]                                                                                                   memoryDataWB;
    logic [11:0]                    immD,              immE1,              immE2;
    logic [31:0] operandAForwardedE1, operandAForwardedE2;
    logic [31:0] operandBForwardedE1;
    logic [31:0] dataMem;
    logic [31:0] memoryDataM;

    logic haltRequisition;
    logic stallF,          stallD,         stallE1,          stallE2, stallM;
    logic stallF_HDU,      stallD_HDU;
    logic                  flushD,         flushE1;

endinterface

`endif
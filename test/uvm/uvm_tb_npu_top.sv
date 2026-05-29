`timescale 1ns/10ps
import npu_pkg::*;
`include "npu_pkg.sv"
`include "test/npu_test.sv"
`include "npu_macros.svh"

module uvm_tb_top;
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   import npu_pkg::*;
   
    npu_bfm  bfm();

    NPU DUT(
        .oBusy                 (bfm.oBusy),
        .oDone                 (bfm.oDone),
        .oInterrupt            (bfm.oInterrupt),

        .iStart                (bfm.iStart),
        .iInstructionBaseAddr  (bfm.iInstructionBaseAddr),

        .oInstructionMemoryAddr(bfm.oInstructionMemoryAddr),
        .oInstructionMemoryRead(bfm.oInstructionMemoryRead),

        .iInstructionRData     (bfm.iInstructionRData),
        .iInstructionReady     (bfm.iInstructionReady),

        .oMemoryAddr           (bfm.oMemoryAddr),
        .oMemoryRead           (bfm.oMemoryRead),
        .oMemoryWrite          (bfm.oMemoryWrite),
        .oMemoryWData          (bfm.oMemoryWData),

        .iMemoryRData          (bfm.iMemoryRData),
        .iMemoryReady          (bfm.iMemoryReady),

        .clk                   (bfm.clk),
        .rst                   (bfm.rst)
    );

    npu_debug dbg_if(bfm.clk);

    assign dbg_if.validInstructionF   = DUT.validInstructionF;
    assign dbg_if.validInstructionD   = DUT.validInstructionD;
    assign dbg_if.validInstructionE1  = DUT.validInstructionE1;
    assign dbg_if.validInstructionE2  = DUT.validInstructionE2;
    assign dbg_if.validInstructionM   = DUT.validInstructionM;
    assign dbg_if.validInstructionWB  = DUT.validInstructionWB;

    assign dbg_if.regWriteD     = DUT.regWriteD;
    assign dbg_if.regWriteE1    = DUT.regWriteE1;
    assign dbg_if.regWriteE2    = DUT.regWriteE2;
    assign dbg_if.regWriteM     = DUT.regWriteM;
    assign dbg_if.regWriteWB    = DUT.regWriteWB;
    assign dbg_if.regWriteValid = DUT.regWriteValid;


    assign dbg_if.memReadD  = DUT.memReadD;
    assign dbg_if.memReadE1 = DUT.memReadE1;
    assign dbg_if.memReadE2 = DUT.memReadE2;
    assign dbg_if.memReadM  = DUT.memReadM;

    assign dbg_if.memWriteD  = DUT.memWriteD;
    assign dbg_if.memWriteE1 = DUT.memWriteE1;
    assign dbg_if.memWriteE2 = DUT.memWriteE2;
    assign dbg_if.memWriteM  = DUT.memWriteM;

    assign dbg_if.resultSrcD  = DUT.resultSrcD;
    assign dbg_if.resultSrcE1 = DUT.resultSrcE1;
    assign dbg_if.resultSrcE2 = DUT.resultSrcE2;
    assign dbg_if.resultSrcM  = DUT.resultSrcM;
    assign dbg_if.resultSrcWB = DUT.resultSrcWB;

    assign dbg_if.useMacD  = DUT.useMacD;
    assign dbg_if.useMacE1 = DUT.useMacE1;
    assign dbg_if.useMacE2 = DUT.useMacE2;
    assign dbg_if.useMacM  = DUT.useMacM;

    assign dbg_if.actFunctD  = DUT.actFunctD;
    assign dbg_if.actFunctE1 = DUT.actFunctE1;
    assign dbg_if.actFunctE2 = DUT.actFunctE2;

    assign dbg_if.isActivationD  = DUT.isActivationD;
    assign dbg_if.isActivationE1 = DUT.isActivationE1;
    assign dbg_if.isActivationE2 = DUT.isActivationE2;

    assign dbg_if.isECALLD = DUT.isECALLD;
    
    assign dbg_if.useAccBypassOnActE2 = DUT.useAccBypassOnActE2;

    assign dbg_if.mulResultE1 = DUT.mulResultE1;
    assign dbg_if.mulResultE2 = DUT.mulResultE2;

    assign dbg_if.resultE2 = DUT.resultE2;
    assign dbg_if.resultM  = DUT.resultM;
    assign dbg_if.resultWB = DUT.resultWB;

    assign dbg_if.readData1D  = DUT.readData1D;
    assign dbg_if.readData1E1 = DUT.readData1E1;

    assign dbg_if.readData2D  = DUT.readData2D;
    assign dbg_if.readData2E1 = DUT.readData2E1;

    assign dbg_if.rs1D  = DUT.rs1D;
    assign dbg_if.rs1E1 = DUT.rs1E1;
    assign dbg_if.rs1E2 = DUT.rs1E2;

    assign dbg_if.rs2D  = DUT.rs2D;
    assign dbg_if.rs2E1 = DUT.rs2E1;

    assign dbg_if.rdD  = DUT.rdD;
    assign dbg_if.rdE1 = DUT.rdE1;
    assign dbg_if.rdE2 = DUT.rdE2;
    assign dbg_if.rdM  = DUT.rdM;
    assign dbg_if.rdWB = DUT.rdWB;

    assign dbg_if.writeDataReg = DUT.writeDataReg;

    assign dbg_if.storeDataE2 = DUT.storeDataE2;
    assign dbg_if.storeDataM  = DUT.storeDataM;

    assign dbg_if.memoryDataWB = DUT.memoryDataWB;

    assign dbg_if.immD  = DUT.immD;
    assign dbg_if.immE1 = DUT.immE1;
    assign dbg_if.immE2 = DUT.immE2;

    assign dbg_if.operandAForwardedE1 = DUT.operandAForwardedE1;
    assign dbg_if.operandAForwardedE2 = DUT.operandAForwardedE2;

    assign dbg_if.operandBForwardedE1 = DUT.operandBForwardedE1;

    assign dbg_if.dataMem = DUT.dataMem;

    assign dbg_if.memoryDataM = DUT.memoryDataM;

    assign dbg_if.haltRequisition = DUT.haltRequisition;

    assign dbg_if.stallF  = DUT.stallF;
    assign dbg_if.stallD  = DUT.stallD;
    assign dbg_if.stallE1 = DUT.stallE1;
    assign dbg_if.stallE2 = DUT.stallE2;
    assign dbg_if.stallM  = DUT.stallM;

    assign dbg_if.stallF_HDU = DUT.stallF_HDU;
    assign dbg_if.stallD_HDU = DUT.stallD_HDU;

    assign dbg_if.flushD  = DUT.flushD;
    assign dbg_if.flushE1 = DUT.flushE1;

    initial
    begin
        `uvm_info("TOP", "TOP UVM", UVM_MEDIUM)
        uvm_config_db #(virtual npu_bfm)  ::set(null, "*", "bfm",    bfm);
        uvm_config_db #(virtual npu_debug)::set(null, "*", "dbg_if", dbg_if);

        $dumpfile("uvm_tb_top.vcd");
        $dumpvars(0, uvm_tb_top);

        run_test();
    end

    initial
    begin
        fork
            bfm.generate_clock(CLK_PERIOD);
        join_none
    end
    
endmodule : uvm_tb_top

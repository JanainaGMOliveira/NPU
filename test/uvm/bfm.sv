`ifndef BFM_SV
`define BFM_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "npu_macros.svh"
interface npu_bfm;
    logic clk;
    logic rst;

    logic        iStart;
    logic [31:0] iInstructionBaseAddr;

    logic        oBusy;
    logic        oDone;
    logic        oInterrupt;

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

    task generate_clock(input real period = 20, bit clk_pol = 0, real delay = 0);
        clk = ~clk_pol;
        #(delay);

        forever
		begin
            clk = ~clk;
            #(period/2);
        end

    endtask : generate_clock
endinterface

`endif
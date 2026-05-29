`ifndef PIPELINE_MONITOR_SV
`define PIPELINE_MONITOR_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../npu_macros.svh"
`include "../transaction.sv"

class pipeline_monitor extends uvm_monitor;
    `uvm_component_utils(pipeline_monitor)

    virtual npu_debug dbg_if;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual npu_debug)::get(this, "", "dbg_if", dbg_if))
            `uvm_fatal("NPU MONITOR", "Virtual interface 'dbg_if' not set.")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever
        begin
            @(posedge dbg_if.clk);

                `uvm_info(
                    "PIPELINE",
                    // TODO: format this better and add more signals
                    $sformatf(
                        "\nVALIDS: F=%0d D=%0d E1=%0d E2=%0d MEM=%0d WB=%0d" +
                        "\nSTALLS: stallF=%0d stallD=%0d" +
                        "\nFLUSH: flushD=%0d flushE1=%0d" +
                        "\nRESULT E2=%0d",
                        dbg_if.validInstructionF,
                        dbg_if.validInstructionD,
                        dbg_if.validInstructionE1,
                        dbg_if.validInstructionE2,
                        dbg_if.validInstructionM,
                        dbg_if.validInstructionWB,

                        dbg_if.stallF,
                        dbg_if.stallD,

                        dbg_if.flushD,
                        dbg_if.flushE1,

                        dbg_if.resultE2
                    ),

                    UVM_LOW
                );

        end
    endtask
endclass : pipeline_monitor
`endif 
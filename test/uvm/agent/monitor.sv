`ifndef MONITOR_SV
`define MONITOR_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../npu_macros.svh"
`include "../transaction_npu.sv"

class npu_monitor extends uvm_monitor;
    `uvm_component_utils(npu_monitor)
    
    virtual npu_bfm bfm;
    uvm_analysis_port #(npu_transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);

        ap = new("ap", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual npu_bfm)::get(this, "", "bfm", bfm))
            `uvm_fatal("NPU MONITOR", "Virtual interface 'bfm' not set.")
    endfunction
    
    task run_phase(uvm_phase phase);
        monitor_npu();
    endtask

    task monitor_npu();
        npu_transaction transaction;
        integer i;

        forever
        begin
            @(posedge bfm.clk)
            
            ap.write(transaction);
        end
    endtask
endclass : npu_monitor
`endif 
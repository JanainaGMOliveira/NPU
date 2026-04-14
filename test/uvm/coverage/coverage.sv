`ifndef COVERAGE_SV
`define COVERAGE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../npu_macros.svh"
`include "../transaction_npu.sv"

class npu_coverage extends uvm_subscriber #(npu_transaction);
    `uvm_component_utils(npu_coverage)

    npu_transaction item;

    covergroup npu_cg;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        npu_cg = new();
    endfunction
    
    function void write(npu_transaction t);
        item = t;
        npu_cg.sample();
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("NPU COVERAGE", $sformatf("--- COVERAGE REPORT ---\n Data Coverage: %f%%\n", npu_cg.get_coverage()), UVM_LOW)
    endfunction

endclass : npu_coverage
`endif
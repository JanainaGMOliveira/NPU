`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "../transaction_npu.sv" 
`include "../npu_macros.svh" 

class npu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(npu_scoreboard)
    
    uvm_analysis_imp #(npu_transaction, npu_scoreboard) ap_imp;

    int npu_transaction_count = 0;
    int errors;

    function new(string name, uvm_component parent);
        super.new(name, parent);

        ap_imp    = new("ap_imp", this);
    endfunction : new

    function bit [OUTPUT_DATA_BITS-1:0] calculate_golden_model(npu_transaction item);
        
    endfunction

    function void write(npu_transaction item);
        npu_transaction_count++;
        
        check_values();
    endfunction

    function check_values();
        bit [OUTPUT_DATA_BITS-1:0] expected_output = calculate_golden_model(item);
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info("SCOREBOARD", "===================== Scoreboard Report ====================", UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("NPU criptography:   %0d", npu_cripto_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("NPU decriptography: %0d", npu_decripto_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("NPU operations:     %0d", npu_transaction_count), UVM_LOW)
        `uvm_info("SCOREBOARD", "------------------------------------------------------------", UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Errors:                          %0d              ", errors), UVM_LOW)
        `uvm_info("SCOREBOARD", "============================================================", UVM_LOW)
        
        if(errors > 0)
            `uvm_error("SCOREBOARD", "TEST FAILED: Scoreboard reported mismatches.")
        else
            `uvm_info("SCOREBOARD", "Test completed with NO errors!", UVM_LOW)
    endfunction
endclass
`endif



`ifndef TEST_SV
`define TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "../env/environment.sv"
`include "../sequence/sequence.sv"

class basic_npu_test extends uvm_test;
    `uvm_component_utils(basic_npu_test)
    
    npu_env env;
    
    function new(string name = "npu_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = npu_env::type_id::create("env", this);
        `uvm_info("NPU TEST", "End build_fase", UVM_HIGH);
    endfunction
endclass : npu_test
`endif
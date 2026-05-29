`ifndef TEST_SV
`define TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "../env/environment.sv"
`include "../sequence/sequence.sv"

class basic_npu_test extends uvm_test;
    `uvm_component_utils(basic_npu_test)
    
    npu_env env;
    
    function new(string name = "basic_npu_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = npu_env::type_id::create("env", this);
        `uvm_info("BASIC NPU TEST", "End build_phase", UVM_HIGH);
    endfunction

    task run_phase(uvm_phase phase);
        npu_basic_seq seq;
        
        phase.raise_objection(this);
        
        seq = npu_basic_seq::type_id::create("seq");
        seq.start(env.npu_agt.sequencer);
        
        #1000;
        phase.drop_objection(this);
    endtask
endclass : basic_npu_test
`endif
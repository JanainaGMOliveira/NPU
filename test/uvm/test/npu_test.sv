`ifndef TEST_SV
`define TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "../env/environment.sv"
`include "../sequence/sequence.sv"

class npu_test extends uvm_test;
    `uvm_component_utils(npu_test)
    
    npu_env env;
    
    function new(string name = "npu_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = npu_env::type_id::create("env", this);
        `uvm_info("NPU TEST", "End build_fase", UVM_HIGH);
    endfunction

    task run_phase(uvm_phase phase);
        npu_random_seq seq_random = npu_random_seq::type_id::create("seq_random");
        //npu_corner_seq seq_corner = npu_corner_seq::type_id::create("seq_corner");

        phase.raise_objection(this);
        
        seq_random.start(env.npu_agt.sequencer);
        //seq_corner.start(env.npu_agt.sequencer);

        phase.drop_objection(this);
    endtask
endclass : npu_test
`endif
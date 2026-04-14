`ifndef ENV_SV
`define ENV_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "../agent/agent.sv"
`include "../scoreboard/scoreboard.sv" 
`include "../coverage/coverage.sv"

class npu_env extends uvm_env;
    `uvm_component_utils(npu_env)
    
    npu_agent      npu_agt;
    npu_scoreboard scoreboard;
    npu_coverage   npu_cvg;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        npu_agt = npu_agent::type_id::create("npu_agt", this);
        uvm_config_db#(uvm_active_passive_enum)::set(this, "npu_agt", "is_active", UVM_ACTIVE);

        scoreboard = npu_scoreboard::type_id::create("scoreboard", this);
        npu_cvg = npu_coverage::type_id::create("npu_cvg", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        npu_agt.monitor.ap.connect(scoreboard.ap_imp);
        npu_agt.monitor.ap.connect(npu_cvg.analysis_export);
    endfunction
endclass : npu_env

`endif

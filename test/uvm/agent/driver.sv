`ifndef DRIVER_SV
`define DRIVER_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../npu_macros.svh"
`include "../transaction_npu.sv"

class npu_driver extends uvm_driver #(npu_instruction_transaction);
    `uvm_component_utils(npu_driver)

    virtual npu_bfm bfm;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual npu_bfm)::get(this, "", "bfm", bfm))
        begin
            `uvm_fatal("NPU DRIVER", "Virtual interface 'bfm' not set.")
        end
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        npu_instruction_transaction item;

        forever
        begin
            seq_item_port.get_next_item(item);

            //program_memory.push_back(encode_instruction(item));

            seq_item_port.item_done();
        end
    endtask : run_phase

    task encode_instruction(npu_instruction_transaction item);
        
    endtask
endclass : npu_driver
`endif
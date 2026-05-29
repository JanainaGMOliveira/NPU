`ifndef DRIVER_SV
`define DRIVER_SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../npu_macros.svh"
`include "../transaction.sv"

class npu_driver extends uvm_driver #(npu_instruction_transaction);
    `uvm_component_utils(npu_driver)

    virtual npu_bfm bfm;

    bit [31:0] instructionMemory [0:255];

    int instructionCount;

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
        instructionCount = 0;

        forever
        begin
            seq_item_port.get_next_item(item);

            instructionMemory[instructionCount] = encode_instruction(item);

            `uvm_info("DRIVER", $sformatf("Loaded instruction[%0d] = %h", instructionCount, instructionMemory[instructionCount]), UVM_LOW);

            instructionCount++;

            seq_item_port.item_done();
        end
    endtask : run_phase

    function bit [31:0] encode_instruction(npu_instruction_transaction item);
        case (item.opcode)
            NPU_RTYPE: return {item.funct7, item.rs2, item.rs1, item.funct3, item.rd, item.opcode};
            NPU_LW:    return {item.imm, item.rs1, item.funct3, item.rd, item.opcode};
            NPU_SW:    return {item.imm[11:5], item.rs2, item.rs1, item.funct3, item.imm[4:0], item.opcode};
            ECALL:     return {25'b0, item.opcode};
            default:   return 32'b0;
        endcase
    endfunction
endclass : npu_driver
`endif
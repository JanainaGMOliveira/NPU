`ifndef TRANSACTIONS_SV
`define TRANSACTIONS_SV

import uvm_pkg::*;    
    `include "uvm_macros.svh"

`include "npu_macros.svh"

class npu_instruction_transaction extends uvm_sequence_item;
    rand bit [6:0] opcode;

    rand bit [4:0] rd;
    rand bit [4:0] rs1;
    rand bit [4:0] rs2;

    rand bit [11:0] imm;

    `uvm_object_utils(npu_instr_transaction)

    function new(string name = "npu_instr_transaction");
        super.new(name);
    endfunction
    
    `uvm_object_utils_begin(npu_instruction_transaction)
        `uvm_field_int(opcode, UVM_ALL_ON)
        `uvm_field_int(rd, UVM_ALL_ON)
        `uvm_field_int(rs1, UVM_ALL_ON)
        `uvm_field_int(rs2, UVM_ALL_ON)
        `uvm_field_int(imm, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "npu_instruction_transaction");
        super.new(name);
    endfunction
endclass : npu_instruction_transaction

`endif
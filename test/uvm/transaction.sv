`ifndef TRANSACTIONS_SV
`define TRANSACTIONS_SV

import uvm_pkg::*;    
    `include "uvm_macros.svh"

`include "npu_macros.svh"

class npu_transaction extends uvm_sequence_item;
    rand bit [INPUT_DATA_BITS - 1:0]     ix;
    
    `uvm_object_utils_begin(npu_transaction)
        `uvm_field_int(ix, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "npu_transaction");
        super.new(name);
    endfunction
endclass : npu_transaction

`endif
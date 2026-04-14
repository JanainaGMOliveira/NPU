`ifndef SEQUENCES_SV
`define SEQUENCES_SV

`include "../npu_macros.svh"
`include "../transaction_npu.sv"

class npu_random_seq extends uvm_sequence #(npu_transaction);
    `uvm_object_utils(npu_random_seq)

    int unsigned max_transactions = MAX_TRANSACTIONS;

    function new(string name = "npu_random_seq");
        super.new(name);
    endfunction

    task body();
        npu_transaction item;
        integer i;

        if (starting_phase != null)
        begin
            starting_phase.raise_objection(this);
        end

        `uvm_info("NPU SEQUENCE", $sformatf("Starting %0d random NPU commands", max_transactions), UVM_LOW)

        repeat (max_transactions)
        begin
            item = npu_transaction::type_id::create("item");

            start_item(item);

            assert(item.randomize());

            for (i = 0; i < NPU_MAX_NUMBER; i = i + 1)
            begin
                `uvm_info("NPU SEQUENCE", $sformatf("Sending NPU values: x=0x%h, w=0x%h", item.ix[i], item.iw[i]), UVM_MEDIUM);
            end

            finish_item(item);
        end

        if (starting_phase != null)
        begin
            starting_phase.drop_objection(this);
        end
    endtask

endclass : npu_random_seq

// class npu_corner_seq extends uvm_sequence #(npu_transaction);
//     `uvm_object_utils(npu_corner_seq)

//     int unsigned max_transactions = MAX_TRANSACTIONS;

//     function new(string name = "npu_corner_seq");
//         super.new(name);
//     endfunction

//     task body();
        
//         if (starting_phase != null)
//         begin
//             starting_phase.raise_objection(this);
//         end

//         if (starting_phase != null)
//         begin
//             starting_phase.drop_objection(this);
//         end
//     endtask

//     task send(logic [127:0] w, logic [127:0] k, logic op);
//         npu_transaction item = npu_transaction::type_id::create("item");

//         start_item(item);

//         finish_item(item);
//     endtask
// endclass : npu_corner_seq
`endif
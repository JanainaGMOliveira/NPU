`ifndef SEQUENCES_SV
`define SEQUENCES_SV

`include "../npu_macros.svh"
`include "../transaction.sv"

class npu_basic_seq extends uvm_sequence #(npu_instruction_transaction);
    `uvm_object_utils(npu_basic_seq)

    function new(string name = "npu_basic_seq");
        super.new(name);
    endfunction

    task body();
        npu_instruction_transaction item;
        integer i;

        if (starting_phase != null)
        begin
            starting_phase.raise_objection(this);
        end

        // LOAD r1, [0]
        item = npu_instruction_transaction::type_id::create("item");
        item.opcode = NPU_LW;
        item.rd  = 1;
        item.rs1 = 0;
        item.imm = 0;

        start_item(item);
        finish_item(item);

        // LOAD r2, [4]
        item = npu_instruction_transaction::type_id::create("item");
        item.opcode = NPU_LW;
        item.rd  = 2;
        item.rs1 = 0;
        item.imm = 4;

        start_item(item);
        finish_item(item);

        // MAC r3, r1, r2
        item = npu_instruction_transaction::type_id::create("item");
        item.opcode = NPU_RTYPE;
        item.funct3 = FUNCT3_MAC;
        item.rd  = 3;
        item.rs1 = 1;
        item.rs2 = 2;

        start_item(item);
        finish_item(item);

        // RELU r3
        item = npu_instruction_transaction::type_id::create("item");
        item.opcode = NPU_RTYPE;
        item.funct3 = FUNCT3_ACT;
        item.funct7 = FUNCT7_RELU;
        item.rd  = 3;
        item.rs1 = 3;

        start_item(item);
        finish_item(item);

        // STORE r3, [24]
        item = npu_instruction_transaction::type_id::create("item");
        item.opcode = NPU_SW;
        item.rs1 = 0;
        item.rs2 = 3;

        item.imm = 24;

        start_item(item);
        finish_item(item);

        // ECALL
        item = npu_instruction_transaction::type_id::create("item");
        item.opcode = ECALL;

        start_item(item);
        finish_item(item);

        if (starting_phase != null)
        begin
            starting_phase.drop_objection(this);
        end
    endtask

endclass : npu_basic_seq

// class npu_corner_seq extends uvm_sequence #(npu_instruction_transaction);
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
//         npu_instruction_transaction item = npu_instruction_transaction::type_id::create("item");

//         start_item(item);

//         finish_item(item);
//     endtask
// endclass : npu_corner_seq
`endif
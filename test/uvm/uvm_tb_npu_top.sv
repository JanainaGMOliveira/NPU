`timescale 1ns/10ps
import npu_pkg::*;
`include "npu_pkg.sv"
`include "test/npu_test.sv"
`include "npu_macros.svh"

module uvm_tb_top;
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   import npu_pkg::*;
   
    npu_bfm  bfm();

    npu DUT(
        .clk(bfm.clk)
    );

    initial
    begin
        `uvm_info("TOP", "TOP UVM", UVM_MEDIUM)
        uvm_config_db #(virtual npu_bfm)::set(null, "*", "bfm", bfm);

        $dumpfile("uvm_tb_top.vcd");
        $dumpvars(0, uvm_tb_top);

        run_test();
    end

    initial
    begin
        fork
            bfm.generate_clock(CLK_PERIOD);
        join_none
    end
    
endmodule : uvm_tb_top

`ifndef BFM_SV
`define BFM_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "npu_macros.svh"
interface npu_bfm;
    bit clk;

    // Inputs
    
    // Outputs
    

    // task to generate clock signal
    task generate_clock(input real period = 20, bit clk_pol = 0, real delay = 0);
        clk = ~clk_pol;
        #(delay);

        forever
		begin
            clk = ~clk;
            #(period/2);
        end

    endtask : generate_clock
endinterface

`endif
`ifndef MACROS_SVH
`define MACROS_SVH
    localparam CLK_PERIOD = 20ns; // 50 MHz
    localparam CLK_FREQ   = 50_000_000;

    localparam INPUT_DATA_BITS = 8;
    localparam WEIGHT_DATA_BITS = 16;
    localparam OUTPUT_DATA_BITS = 8;
    localparam INTERNAL_DATA_BITS = 32;

    localparam MAX_TRANSACTIONS = 5;
`endif
`ifndef MACROS_SVH
`define MACROS_SVH
    localparam CLK_PERIOD = 20ns; // 50 MHz
    localparam CLK_FREQ   = 50_000_000;

    localparam INPUT_DATA_BITS = 8;
    localparam WEIGHT_DATA_BITS = 16;
    localparam OUTPUT_DATA_BITS = 8;
    localparam INTERNAL_DATA_BITS = 32;

    localparam MAX_TRANSACTIONS = 5;

    localparam NPU_RTYPE    = 7'b0001011;
    localparam NPU_LW       = 7'b0101011;
    localparam NPU_SW       = 7'b1011011;
    localparam ECALL        = 7'b1110011;

    localparam FUNCT3_MAC   = 3'b000;
    localparam FUNCT3_ADD   = 3'b001;
    localparam FUNCT3_ACT   = 3'b100;

    localparam FUNCT7_RELU  = 7'b0000000;
    localparam FUNCT7_RAMPA = 7'b0000001;
    localparam FUNCT7_TANH  = 7'b0000010;
    localparam FUNCT7_SIGM  = 7'b0000011;
`endif
package npu_pkg;

    parameter NPU_RTYPE    = 7'b0001011;
    parameter NPU_LW       = 7'b0101011;
    parameter NPU_SW       = 7'b1011011;

    parameter FUNCT3_MAC   = 3'b000;
    parameter FUNCT3_ADD   = 3'b001;
    parameter FUNCT3_ACT   = 3'b100;

    parameter FUNCT7_RELU  = 7'b0000000;
    parameter FUNCT7_RAMPA = 7'b0000001;
    parameter FUNCT7_TANH  = 7'b0000010;
    parameter FUNCT7_SIGM  = 7'b0000011;

endpackage
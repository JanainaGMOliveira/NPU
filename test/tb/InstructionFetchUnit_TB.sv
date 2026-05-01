`timescale 1ns/1ps

module InstructionFetchUnit_TB;

    logic clk;
    logic rst;

    logic iEnable;
    logic iStart;
    logic [31:0] iInstructionBaseAddr;

    logic [31:0] oInstructionMemoryAddr;
    logic        oInstructionMemoryRead;
    logic [31:0] iInstructionRData;
    logic        iInstructionReady;

    logic [31:0] oInstruction;
    logic        oValid;

    InstructionFetchUnit DUT(
                             .clk(clk),
                             .rst(rst),
                             .iEnable(iEnable),
                             .iStart(iStart),
                             .iInstructionBaseAddr(iInstructionBaseAddr),
                             .oInstructionMemoryAddr(oInstructionMemoryAddr),
                             .oInstructionMemoryRead(oInstructionMemoryRead),
                             .iInstructionRData(iInstructionRData),
                             .iInstructionReady(iInstructionReady),
                             .oInstruction(oInstruction),
                             .oValid(oValid)
    );

    task generate_clock(input real period = 20, bit clk_pol = 0, real delay = 0);
        clk = ~clk_pol;
        #(delay);

        forever
		begin
            clk = ~clk;
            #(period/2);
        end
    endtask : generate_clock

    initial
    begin
        generate_clock();
    end

    initial
    begin
        rst = 1;
        iEnable = 0;
        iStart = 0;
        iInstructionBaseAddr = 32'h1000;
        iInstructionRData = 32'hDEADBEEF;
        iInstructionReady = 0;

        #10;
        rst = 0;

        iStart = 1; #10;
        iStart = 0;

        iEnable = 1; #30;

        iInstructionReady = 1; #10;
        iInstructionReady = 0;

        #20;
        $stop;
    end

    property p_pcBaseAddr;
        @(posedge clk)
        disable iff (rst)
        iStart |=> oInstructionMemoryAddr == $past(iInstructionBaseAddr);
    endproperty
    assert property (p_pcBaseAddr)
    else $error("PC não carregou base address: atual=%h esperado=%h",
                oInstructionMemoryAddr,
                $past(iInstructionBaseAddr));

    property p_pcIncrement;
        @(posedge clk)
        disable iff (rst)
        iEnable && !iStart |=> oInstructionMemoryAddr == $past(oInstructionMemoryAddr) + 4;
    endproperty
    assert property (p_pcIncrement)
    else $error("PC não incrementou corretamente: atual=%h esperado=%h",
                oInstructionMemoryAddr,
                $past(oInstructionMemoryAddr) + 4);

    property p_pcIncrementDisabled;
        @(posedge clk)
        disable iff (rst)
        !iEnable |=> oInstructionMemoryAddr == $past(oInstructionMemoryAddr);
    endproperty
    assert property (p_pcIncrementDisabled)
    else $error("PC incrementou quand não deveria: atual=%h esperado=%h",
                oInstructionMemoryAddr,
                $past(oInstructionMemoryAddr));

    property p_instructionMemoryRead;
        @(posedge clk)
        oInstructionMemoryRead == iEnable;
    endproperty
    assert property (p_instructionMemoryRead)
    else $error("Read não segue Enable: atual=%h esperado=%h",
                oInstructionMemoryRead,
                iEnable);

    property p_Valid;
        @(posedge clk)
        disable iff (rst)
        iInstructionReady && iEnable |=> oValid == 1;
    endproperty
    assert property (p_Valid)
    else $error("Valid não foi ativado: atual=%h esperado=%h",
                oValid,
                1);

    property p_Invalid;
        @(posedge clk)
        disable iff (rst)
        !(iInstructionReady && iEnable) |=> oValid == 0;
    endproperty
    assert property (p_Invalid)
    else $error("Valid não foi desativado: atual=%h esperado=%h",
                oValid,
                0);

    property p_Instruction;
        @(posedge clk)
        disable iff (rst)
        iInstructionReady && iEnable |=> oInstruction == iInstructionRData;
    endproperty
    assert property (p_Instruction)
    else $error("Instrução incorreta: atual=%h esperado=%h",
                oInstruction,
                iInstructionRData);
endmodule
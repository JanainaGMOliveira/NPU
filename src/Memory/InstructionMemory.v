// vou iniciar só com um arquivo pré determinado. Depois faço o bootloader.
module InstructionMemory #(parameter SIZE = 64, N = 32)(
    output [N-1:0] oReadData,
    input  [N-1:0] iAddress
);
    reg [N-1:0] rom [SIZE - 1:0];
    assign oReadData = rom [iAddress[N-1:2]];

    initial 
    begin
        $readmemh ("program.hex", rom);
    end
endmodule
// vou iniciarsó com um arquivo pré determinado. Depois faço o bootloader.
module InstructionMemory #(parameter SIZE = 64)(
    output [31:0] oReadData,
    input  [31:0] iAddress
);
    reg [31:0] rom [SIZE - 1:0];
    assign oReadData = rom [iAddress[31:2]];

    initial 
    begin
        $readmemh ("program.hex", rom);
    end
endmodule
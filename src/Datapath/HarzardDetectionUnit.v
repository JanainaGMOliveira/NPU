module HazardDetectionUnit(
    output reg   oStallF,
    output reg   oStallD,
    output reg   oFlushE1,

    input  [4:0] iRs1D,
    input  [4:0] iRs2D,
    input  [4:0] iRdE1,
    input  [4:0] iRdE2,

    input        iMemReadE1,
    input        iMemReadE2
);
    wire loadUseHazard1E1;
    wire loadUseHazardE2;

    assign loadUseHazardE1 = iMemReadE1 && ((iRdE1 == iRs1D) || (iRdE1 == iRs2D)) && (iRdE1 != 0);
    assign loadUseHazardE2 = iMemReadE2 && ((iRdE2 == iRs1D) || (iRdE2 == iRs2D)) && (iRdE2 != 0);

    always @(*)
    begin
        oStallF  = 1'b0;
        oStallD  = 1'b0;
        oFlushE1 = 1'b0;

        if (loadUseHazardE1 || loadUseHazardE2)
        begin
            oStallF  = 1'b1;
            oStallD  = 1'b1;
            oFlushE1 = 1'b1;
        end
    end
endmodule
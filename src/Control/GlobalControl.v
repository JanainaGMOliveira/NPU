module GlobalControl(
    output            oBusy,
    output            oDone,
    output            oInterrupt,

    input             iHaltRequisition,
    input             iPipelineEmpty,

    input             iStart,
    input             rst,
    input             clk
);
    reg  busy;
    reg  done;

    assign oBusy = busy;
    always @(posedge clk)
    begin
        if(rst)
            busy <= 0;
        else if (iStart)
            busy <= 1;
        else if (iHaltRequisition && iPipelineEmpty)
            busy <= 0;
    end

    assign oDone = done;
    always @(posedge clk)
    begin
        if (rst)
            done <= 0;
        else if (iHaltRequisition && iPipelineEmpty)
            done <= 1;
        else
            done <= 0;
    end

    assign oInterrupt = oDone;
endmodule
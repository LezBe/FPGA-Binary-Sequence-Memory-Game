module DigitTimer(loadVal, reCfg, brwDn, noBrwUp, brwUp, noBrwDn, curCnt, clk, rst);
    input [3:0] loadVal; // NEW: The custom starting value from GameControl
    input reCfg, brwDn, noBrwUp, clk, rst;
    output brwUp, noBrwDn;
    output [3:0] curCnt;
    reg brwUp, noBrwDn;
    reg [3:0] curCnt;

    always @(posedge clk) begin
        if(rst == 1'b0) begin
            brwUp <= 1'b0;
            noBrwDn <= 1'b0;
            curCnt <= 4'b0000;
        end
        else begin
            brwUp <= 1'b0; 
            if(reCfg == 1'b1) begin
                noBrwDn <= 1'b0;
                curCnt <= loadVal; // UPDATE: Load the dynamic difficulty value here
            end
            else if(brwDn == 1'b1) begin
                if(curCnt > 4'b0000) begin
                    curCnt <= curCnt - 4'b0001;
                    if ((curCnt == 4'b0001) && (noBrwUp == 1'b1)) begin
                        noBrwDn <= 1'b1;
                    end
                end
                else begin
                    if(noBrwUp == 1'b0) begin
                        curCnt <= 4'b1001; // KEEP AS 9: Normal rollovers always go to 9
                        brwUp <= 1'b1; 
                    end
                    else begin
                        curCnt <= 4'b0000;
                        noBrwDn <= 1'b1;
                    end
                end
                
            end
        end
    end
endmodule
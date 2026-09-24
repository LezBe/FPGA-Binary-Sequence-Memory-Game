// ECE 5440/6370
// Author: Mohammed Atif Mohiuddin, 5164
// countTo100
//
// Module for counting to 100.
//
// Last modified 3-28-26

module countTo100(count_in, timeOut, clk, rst);
    input count_in, clk, rst;
    output timeOut;
    reg [6:0] count_out;
    reg timeOut;
    
    always @(posedge clk) begin
        if(rst == 1'b0) begin
            count_out <= 7'b0000000;
            timeOut <= 1'b0;
        end
        else begin
            timeOut <= 1'b0;
	    if(count_in == 1'b1) begin
                if(count_out == 7'b1100011) begin
                    count_out <= 7'b0000000;
                    timeOut <= 1'b1;
                end
                else begin
                    count_out <= count_out + 7'b0000001;
                end
           end
           else begin
                count_out <= 7'd0;
           end
        end
    end
endmodule

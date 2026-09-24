// ECE 5440/6370
// Author: Mohammed Atif Mohiuddin, 5164
// OneMilSec
//
// Counting module to create a timer with
// length of 1-mil sec.
//
// Last modified 3-28-26

module OneMilSec(count_in, timeOut, clk, rst);
    input count_in, clk, rst;
    output timeOut;
    reg [15:0] count_out;
    reg timeOut;
    
    always @(posedge clk) begin
        if(rst == 1'b0) begin
            count_out <= 16'b0000000000000000;
            timeOut <= 1'b0;
        end
        else begin
            timeOut <= 1'b0;
	    if(count_in == 1'b1) begin
                if(count_out == 16'd49999) begin
                    count_out <= 16'b0000000000000000;
                    timeOut <= 1'b1;
                end
                else begin
                    count_out <= count_out + 16'b0000000000000001;
                end
           end
           else begin
                count_out <= 16'd0;
           end
        end
    end
endmodule
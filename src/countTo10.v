// ECE 5440/6370
// Author: Mohammed Atif Mohiuddin, 5164
// countTo10
//
// Module for counting to 10.
//
// Last modified 3-28-26

module countTo10(count_in, timeOut, clk, rst);
    input count_in, clk, rst;
    output timeOut;
    reg [3:0] count_out;
    reg timeOut;
    
    always @(posedge clk) begin
        if(rst == 1'b0) begin
            count_out <= 4'b0000;
            timeOut <= 1'b0;
        end
        else begin
            timeOut <= 1'b0;
            if(count_in == 1'b1) begin
                if(count_out == 4'b1001) begin
                    count_out <= 4'b0000;
                    timeOut <= 1'b1;
                end
                else begin
                    count_out <= count_out + 4'b0001;
                end
           end
           else begin
                count_out <= 4'd0;
           end
        end
    end
endmodule
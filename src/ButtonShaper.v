module ButtonShaper(clk, rst, button_in, button_out);
     input button_in;
     output button_out;
     input clk, rst;
     reg button_out;
     parameter WAIT = 0, PRESSED = 1, HOLD = 2;

     reg [2:0] State, StateNext;
   
     always@(State, button_in) begin
         case(State)
             WAIT: begin
                button_out = 1'b0;
                if (button_in == 1'b0)
                    StateNext = PRESSED;
                else
                    StateNext = WAIT;
             end
             PRESSED: begin
                button_out = 1'b1;
                if (button_in == 1'b0)
                    StateNext = HOLD;
                else
                    StateNext = WAIT;
             end
             HOLD: begin
                button_out = 1'b0;
                if (button_in == 1'b1)
                    StateNext = WAIT;
                else
                    StateNext = HOLD;
             end
    
             default: begin
                button_out = 1'b0;
                StateNext = WAIT;
             end
         endcase
     end


     always@(posedge clk) begin
         if (rst == 1'b0)
            State <= WAIT;
         else
            State <= StateNext;
     end


endmodule




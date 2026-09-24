// ECE 5440
// Author: Claire Lewis 1077
// LoadRegister module
// 4 bit register that holds the previous loaded value stable until the player 
// finishes toggling their number's switches and pressing their specifc LOAD button.

module LoadRegister(D_in, D_out, clk, rst, Load);
    input [3:0] D_in;
    output [3:0] D_out;
    input clk, rst;
    reg [3:0] D_out;
    input Load;

    always@(posedge clk)
       begin
          if (rst == 1'b0)
              begin
                   D_out <= 4'b0000;
              end
           else
              begin
                 if (Load == 1'b1)
                    begin
                        D_out <= D_in;
                    end
              end
        end
endmodule

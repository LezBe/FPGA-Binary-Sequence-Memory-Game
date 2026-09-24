module StackRegister16(Clk, reset, Enable, Data_in, Reg_out);
    input Clk;
    input reset;
    input Enable;
    input [3:0] Data_in;
    output reg [15:0] Reg_out;

	always @(posedge Clk) begin
   		if (reset == 1'b0) begin
        		Reg_out <= 16'h0000;
   		end
   		else if (Enable) begin
        		Reg_out <= {Reg_out[11:0], Data_in};
   		end
	end

endmodule

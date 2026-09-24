module ID_check(Clk, ID_in, Button_Press,reset, LogOut, ROM_data, ROM_Addr, ID_match, Player_ID);
	input Clk, Button_Press, reset, LogOut;
	input [3:0] ID_in;
	input [15:0] ROM_data;
	output ID_match;
	output reg [1:0] Player_ID; //For 4 total ID's
	output reg [4:0] ROM_Addr;

	reg ID_match, Enable;
	reg [1:0] waitCounter, IDCounter;
	reg [3:0] State;
	reg [15:0] StackOut;
	
	wire [15:0] Reg_out;
	
	StackRegister16 IDreg(Clk, reset, Enable, ID_in, Reg_out);

	parameter Init = 0, Digit0 = 1, Digit1 = 2, Digit2 = 3, Digit3 = 4, Fetch = 5, ROM_wait = 6, Compare = 7, StatusCheck = 8;

	always@(posedge Clk) begin
		if(reset == 1'b0)begin
			State <=  Init;
			ROM_Addr <= 5'b00000;
			Player_ID <= 2'b00;
			Enable <= 1'b0;
			ID_match <= 1'b0;
			waitCounter <= 2'b00;
			IDCounter <= 2'b00;
			StackOut <= 16'h0000;
			end
		else begin
			case(State)
				Init: begin
					ROM_Addr <= 5'b00000;
					Player_ID <= 2'b00;
					Enable <= 1'b0;
					ID_match <= 1'b0;
					waitCounter <= 2'b00;
					IDCounter <= 2'b00;
					StackOut <= 16'h0000;
					State <= Digit0;
					end
				Digit0: begin
					State <= Digit0;
					if(Button_Press == 1'b1) begin
						Enable <= 1'b1;
						State <= Digit1;
						end
					end
				Digit1: begin
					State <= Digit1;
					Enable <= 1'b0;
					if(Button_Press == 1'b1) begin
						Enable <= 1'b1;
						State <= Digit2;
						end
					end
				Digit2: begin
					State <= Digit2;
					Enable <= 1'b0;
					if(Button_Press == 1'b1)begin
						Enable <= 1'b1;
						State <= Digit3;
						end
					end
				Digit3: begin
					State <= Digit3;
					Enable <= 1'b0;
					if(Button_Press == 1'b1) begin
						Enable <= 1'b1;
						State <= Fetch;
						end
					end
				Fetch: begin
					Enable <= 1'b0;
					ROM_Addr <= {3'b000,IDCounter};
					State <= ROM_wait;
					end
				ROM_wait: begin
					if(waitCounter == 3'd2)begin
						State <= Compare;
						waitCounter = 3'd0;
						StackOut <= Reg_out;
						end
					else begin
						State <= ROM_wait;
						waitCounter <= waitCounter + 1;
						end
					end
				Compare: begin
					if(StackOut != ROM_data)begin
						IDCounter <= IDCounter + 1;
						State <= StatusCheck;
						end
					else if(StackOut == ROM_data)begin
						ID_match <= 1'b1;
						Player_ID <= IDCounter;
						if(LogOut == 1'b1)
							State <= Init; 
						State <= Compare;
						end    
					end
				StatusCheck: begin
					if(ROM_data == 16'hffff)
						State <= Init;
					else
						State <= Fetch;
					end
				default: State <= Init;
				endcase
			end
		end
endmodule

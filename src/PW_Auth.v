module PW_Auth(Clk, reset, LogOut, IDMatched, Game_Logout, Button_Press,PW_in , PW_ROM_data, PW_ROM_Addr, LoggedIn_LED, LoggedOut_LED, PW_match, Player_ID, Internal_Player_ID);
	input Clk, IDMatched, Game_Logout, Button_Press, reset;
	input [3:0] PW_in;
	input [15:0] PW_ROM_data;
	input [1:0] Player_ID;

	output LoggedIn_LED, LoggedOut_LED, PW_match, LogOut;
	output reg [1:0] Internal_Player_ID;
	output reg [4:0] PW_ROM_Addr;
	reg LoggedIn_LED, LoggedOut_LED, PW_match, Enable, LogOut;
	reg [1:0] waitCounter, PWCounter;
	reg [3:0] State, IDwaitCounter;
	reg [15:0] StackOut;

	wire [15:0] Reg_out;
	
	StackRegister16 PWreg(Clk, reset, Enable, PW_in, Reg_out);
	

	parameter Init = 0, Digit0 = 1, Digit1 = 2, Digit2 = 3, Digit3 = 4, Fetch = 5, ROM_wait = 6, Compare = 7, Out = 8;

	always@(posedge Clk) begin
		if(reset == 1'b0)begin
			Internal_Player_ID <= 2'b00;
			PW_ROM_Addr <= 5'b00000;
			PW_match <= 1'b0;
			LogOut<= 1'b0;
			LoggedIn_LED <= 1'b0;
			LoggedOut_LED <= 1'b1;
			Enable <= 1'b0;
			waitCounter <= 2'b00;
			PWCounter <= 2'b00;
			StackOut <= 16'h0000;
			IDwaitCounter <= 4'h0; 
			end
		else begin
			case(State)
				Init: begin
					Internal_Player_ID <= 2'b00;
					PW_ROM_Addr <= 5'b00000;
					PW_match <= 1'b0;
					LoggedIn_LED <= 1'b0;
					LoggedOut_LED <= 1'b1;
					Enable <= 1'b0;
					waitCounter <= 2'b00;
					PWCounter <= 2'b00;
					StackOut <= 16'h0000;
					IDwaitCounter <= 4'h0; 
					if(IDMatched == 1'b1)begin
						State <= Digit0;
						end
					else begin
						State <= Init;
						end
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
					PW_ROM_Addr <= {3'b000,Player_ID};
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
					if(StackOut != PW_ROM_data && PWCounter < 2)begin
						PWCounter <= PWCounter + 1;
						State <= Digit0;
						end
					else if(PWCounter >= 2) begin
						PWCounter <= 2'b00;
						LogOut <= 1'b1;
						State <= Out;
						end
					else if(Reg_out == PW_ROM_data)begin
						PW_match <= 1'b1;
						Internal_Player_ID <= Player_ID;
						LoggedIn_LED <= 1'b1;
						LoggedOut_LED <= 1'b0;
						if(Game_Logout == 1'b1) begin
							LogOut <= 1'b1;
							State <= Out; 
							end
						State <= Compare;
						end    
					end
				Out: begin
					LogOut <= 1'b0;
					if(IDwaitCounter == 4'hf)begin
						State <= Init;
						IDwaitCounter = 4'h0;
						end
					else begin
						State <= Out;
						IDwaitCounter <= IDwaitCounter + 1;
						end
					end
				default: begin
						State <= Init;
					end
				endcase
			end
		end
endmodule

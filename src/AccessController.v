module AccessController(Clk, Button_Press, reset, Logout_game, Switches, LoggedIn_LED, LoggedOut_LED, Internal_Player_ID, PW_match);
	input Clk, Button_Press, reset, Logout_game;
	input [3:0] Switches;

	output LoggedIn_LED, LoggedOut_LED, PW_match;
	output [2:0] Internal_Player_ID;


	wire IDpass, LogOut;
	wire [15:0]ROM_data, PW_ROM_data;
	wire [4:0]ROM_Addr, PW_ROM_Addr;
	wire [2:0] Player_ID;


	ID_check IDchecker(Clk, Switches, Button_Press,reset, LogOut, ROM_data, ROM_Addr, IDpass, Player_ID);
	
	ID_ROM IDROM(ROM_Addr, Clk, ROM_data);
	PW_ROM PWROM(PW_ROM_Addr,Clk, PW_ROM_data);
	
	PW_Auth PW_Auth1(Clk, reset, LogOut, IDpass, Logout_game, Button_Press, Switches , PW_ROM_data, PW_ROM_Addr, LoggedIn_LED, LoggedOut_LED, PW_match, Player_ID, Internal_Player_ID);
	
endmodule

module FinalProject_FPGABoard(
    input [1:0] Level,           // 2 Switches: Level/Difficulty Select
    input [3:0] Pswd,            // 4 Switches: Password/ID Input
    input [3:0] Plyr1,           // 4 Switches: Player's Game Guess Input
    input PswdEnter_B,           // Button: Submit Password/ID
    input Start_B,               // Button: Start/Restart Game
    input Load_B,                // Button: Load/Submit Guess
    input Logout_B,              // Button: Logout
    input clk,
    input rst,                   // Button/Switch: Global Reset
    
    output [6:0] DecOut_curCnt_Ten, // 7-Seg: Timer 10s Digit
    output [6:0] DecOut_curCnt_One, // 7-Seg: Timer 1s Digit
    output [6:0] DecOut_Level,      // 7-Seg: Current Round/Level
    output [6:0] DecOut_RNG,        // 7-Seg: Random Sequence Display
    output [6:0] DecOut_Plyr1,      // 7-Seg: Player's Current Input Display
    
    output LgdIn,                   // LED: Logged In Status
    output LgdOut,                  // LED: Logged Out Status
    output isPersonalWin,           // LED: Personal Win Status
    output isGlobalWin              // LED: Global Win Status
);

    wire BSOut_PswdEnter, BSOut_Start, BSOut_Load, BSOut_Logout;
    wire Game_Action_Btn; 
    wire [3:0] curCnt_One, curCnt_Ten, Ones, Tens, SequenceOut, RNG_Value;
    wire [7:0] playerScore, RAMD_in, RAMD_out;
    wire [4:0] RAM_Addr;
    wire [2:0] active_Player_ID;
    wire timeOut, timerEn, rcfgTimer, timeOut_OneSec;
    wire isValid, scoreReady, LFSR_Timeout, PW_match;

    ButtonShaper ButtonShaper_PswdEnter(clk, rst, PswdEnter_B, BSOut_PswdEnter);
    ButtonShaper ButtonShaper_Start(clk, rst, Start_B, BSOut_Start);
    ButtonShaper ButtonShaper_Load(clk, rst, Load_B, BSOut_Load);
    ButtonShaper ButtonShaper_Logout(clk, rst, Logout_B, BSOut_Logout);

    assign Game_Action_Btn = BSOut_Start | BSOut_Load;

    LFSR16_8016 LFSR_1(clk, rst, LFSR_Timeout, RNG_Value);
    OneSecTimer OneSecTimer_1(1'b1, timeOut_OneSec, clk, rst);

    AccessController AccessController_1(
        clk, BSOut_PswdEnter, rst, BSOut_Logout, Pswd, 
        LgdIn, LgdOut, active_Player_ID, PW_match
    );

    GameController GameControl_1(
        Game_Action_Btn, Plyr1, timeOut, timeOut_OneSec, PW_match, Level, 
        RNG_Value, isValid, rcfgTimer, timerEn, Ones, Tens, SequenceOut, 
        scoreReady, playerScore, clk, rst
    );
     
    TwoDigitTimer TwoDigitTimer_1(
        timerEn, rcfgTimer, Ones, Tens, timeOut, curCnt_One, curCnt_Ten, clk, rst
    );

    CompleteScoreTracker CompleteScoreTracker_1(active_Player_ID, playerScore, scoreReady, isPersonalWin, isGlobalWin, isValid, clk, rst);

    Decoder_4to7 SevenSegmentDecoder_TimerTen(curCnt_Ten, DecOut_curCnt_Ten);
    Decoder_4to7 SevenSegmentDecoder_TimerOne(curCnt_One, DecOut_curCnt_One);
    Decoder_4to7 SevenSegmentDecoder_Level({2'b00, Level}, DecOut_Level); 
    Decoder_4to7 SevenSegmentDecoder_RNG(SequenceOut, DecOut_RNG);
    Decoder_4to7 SevenSegmentDecoder_Plyr1(Plyr1, DecOut_Plyr1);

endmodule
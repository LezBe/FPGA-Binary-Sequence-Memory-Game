// ECE 5440/6370
// Author: Mohammed Atif Mohiuddin, 5164
// CompleteScoreTracker
//
// 
// 
// 
// 
//
// Last modified 5-11-26

module CompleteScoreTracker(playerID, playerScore, scoreReady, isPersonalWin, isGlobalWin, isValid, clk, rst);
    input [2:0] playerID;
    input [7:0] playerScore;
    input scoreReady, clk, rst;
    output isPersonalWin, isGlobalWin, isValid;
    
    wire [7:0] RAMD_in, RAMD_out;
    wire [4:0] Addr;
    wire RAM_RW;

    ScoreTracker ScoreTracker_1(playerID, playerScore, RAMD_in, scoreReady, Addr, RAMD_out, RAM_RW, isPersonalWin, isGlobalWin, isValid, clk, rst);
    RAM_ScoreTracker RAM_ScoreTracker_1(Addr, clk, RAMD_out, ~RAM_RW, RAMD_in);
endmodule
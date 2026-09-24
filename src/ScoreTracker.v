// ECE 5440/6370
// Author: Mohammed Atif Mohiuddin, 5164
// ScoreTracker
//
// Last modified 5-11-26

module ScoreTracker(playerID, playerScore, RAMD_in, scoreReady, Addr, RAMD_out, RAM_RW, isPersonalWin, isGlobalWin, isValid, clk, rst);
    input [2:0] playerID;
    input [7:0] playerScore, RAMD_in;
    input scoreReady, clk, rst;
    output [4:0] Addr;
    output [7:0] RAMD_out;
    output RAM_RW, isPersonalWin, isGlobalWin, isValid;
    reg [4:0] Addr;
    reg [7:0] RAMD_out; 
    reg RAM_RW, isPersonalWin, isGlobalWin, isValid;

    parameter RAM_INIT = 0, WAIT = 1, FETCH = 2, RAM_C1 = 3, RAM_C2 = 4, CATCH = 5, COMP = 6, WRITE = 7, CHECK_GLOBAL_WIN = 8, DONE = 9;
    reg [3:0] State;
    reg [4:0] init_cnt;

    reg [2:0] reg_playerID, reg_globalWinID;
    reg [7:0] reg_playerScore, reg_RAMScore, reg_globalWinScore;
    
    always @(posedge clk) begin
        if(rst == 1'b0) begin
            RAM_RW <= 1'b1;
            Addr <= 5'b00000;
            RAMD_out <= 8'b00000000;
            isPersonalWin <= 1'b0;
            isGlobalWin <= 1'b0;
            isValid <= 1'b0;
            init_cnt <= 5'b00000;
            reg_globalWinScore <= 8'b00000000;
            State <= RAM_INIT;
        end
        else begin
          case(State)
              RAM_INIT: begin
                RAM_RW <= 1'b0;
                Addr <= init_cnt;
                RAMD_out <= 8'b00000000;
                if(init_cnt == 5'b11111)
                  State <= WAIT;
                else begin
                  init_cnt <= init_cnt + 5'b00001;
                  State <= RAM_INIT;
                end
              end
              WAIT: begin
                RAM_RW <= 1'b1;
                isPersonalWin <= 1'b0;
                isGlobalWin <= 1'b0;
                isValid <= 1'b0;
                if(scoreReady == 1'b0)
                  State <= WAIT;
                else begin
                  reg_playerID <= playerID;
                  reg_playerScore <= playerScore;
                  State <= FETCH;
                end
              end
              FETCH: begin
                RAM_RW <= 1'b1;
                Addr <= {2'b00, reg_playerID};
                State <= RAM_C1;
              end
              RAM_C1: State <= RAM_C2;
              RAM_C2: State <= CATCH;
              CATCH: begin
                reg_RAMScore <= RAMD_in;
                State <= COMP;
              end
              COMP: begin
                if(reg_playerScore > reg_RAMScore) begin
                  isPersonalWin <= 1'b1;
                  State <= WRITE;
                end
                else begin
                  isValid <= 1'b1;
                  State <= DONE;
                end
              end
              WRITE: begin
                RAM_RW <= 1'b0;
                Addr <= {2'b00, reg_playerID};
                RAMD_out <= reg_playerScore;
                State <= CHECK_GLOBAL_WIN;
              end
              CHECK_GLOBAL_WIN: begin
                RAM_RW <= 1'b1;
                if(reg_playerScore > reg_globalWinScore) begin
                  RAM_RW <= 1'b0;
                  Addr <= 5'b01000;
                  RAMD_out <= reg_playerScore;
                  reg_globalWinScore <= reg_playerScore;
                  reg_globalWinID <= reg_playerID;
                  isGlobalWin <= 1'b1;
                end
                isValid <= 1'b1;
                State <= DONE;
              end
              DONE: begin
                isValid <= 1'b1; 
                if(scoreReady == 1'b1)
                  State <= DONE; 
                else begin
                  isValid <= 1'b0;
                  State <= WAIT;
                end
              end
              default: State <= WAIT;
          endcase
        end
    end
endmodule
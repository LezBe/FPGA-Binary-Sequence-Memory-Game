// ECE 5440 Advanced Digital Design
// Luke Jarred Dvorak 8036
// GameCtrler
// module containing the FSM managing the game controller
module GameController(
    input PswdEnter,
    input [3:0] PlayerGuess,
    input timeOut_Game,
    input timeOut_OneSec,
    input AuthSignal,
    input [1:0] Level,
    input [3:0] RNG_In,
    input isValid,
    output reg rcfgTimer,
    output reg timerEn,
    output reg [3:0] Ones,
    output reg [3:0] Tens,
    output reg [3:0] SequenceOut,
    output reg scoreReady,
    output reg [7:0] playerScore,
    input clk,
    input rst
);

    reg [3:0] Sequence [0:7];
    reg [2:0] seq_idx;

    parameter INIT = 0, MEMORIZE = 1, RCFG_TIMER = 2, WAIT_START = 3, START_RELEASE = 4;
    parameter GAMEPLAY = 5, GUESS_RELEASE = 6, SUBMIT_SCORE = 7, GAMEOVER = 8;
    reg [3:0] State;

    always @(posedge clk) begin
        if(rst == 1'b0) begin
            rcfgTimer <= 1'b0; 
            timerEn <= 1'b0;
            scoreReady <= 1'b0;
            playerScore <= 8'd0;
            seq_idx <= 3'd0;
            Ones <= 4'b1001; 
            Tens <= 4'b1001; 
            State <= INIT;
        end
        else begin
            rcfgTimer <= 1'b0;
            scoreReady <= 1'b0;
            case(State)
                INIT: begin
                    scoreReady <= 1'b0;
                    timerEn <= 1'b0;
                    rcfgTimer <= 1'b0;
                    if(AuthSignal == 1'b1) begin
                        seq_idx <= 3'd0;
                        SequenceOut <= RNG_In;
                        State <= MEMORIZE;
                    end
                end
                MEMORIZE: begin
                    if (timeOut_OneSec == 1'b1) begin
                        Sequence[seq_idx] <= RNG_In;
                        SequenceOut <= RNG_In;
                        if (seq_idx == 3'd7)
                            State <= RCFG_TIMER;
                        else
                            seq_idx <= seq_idx + 3'd1;
                    end
                end
                RCFG_TIMER: begin
                    rcfgTimer <= 1'b1;
                    case(Level)
                        2'b00: begin Ones <= 4'b1001; Tens <= 4'b1001; end
                        2'b01: begin Ones <= 4'b0110; Tens <= 4'b0110; end
                        2'b10: begin Ones <= 4'b0011; Tens <= 4'b0011; end
                        2'b11: begin Ones <= 4'b0001; Tens <= 4'b0001; end
                        default: begin Ones <= 4'b1001; Tens <= 4'b1001; end
                    endcase
                    State <= WAIT_START;
                end
                WAIT_START: begin
                    rcfgTimer <= 1'b0;
                    seq_idx <= 3'd0;
                    playerScore <= 8'd0;
                    SequenceOut <= 4'b0000;
                    if(PswdEnter == 1'b1) begin
                        timerEn <= 1'b1;
                        State <= START_RELEASE; 
                    end
                end
                START_RELEASE: begin
                    if(PswdEnter == 1'b0) begin
                        SequenceOut <= 4'b0000;
                        State <= GAMEPLAY;
                    end
                end
                GAMEPLAY: begin
                    timerEn <= 1'b1;
                    if(timeOut_Game == 1'b1) begin
                        timerEn <= 1'b0;
                        State <= SUBMIT_SCORE;
                    end
                    else if(PswdEnter == 1'b1) begin
                        if (PlayerGuess == Sequence[seq_idx])
                            playerScore <= playerScore + 8'd1;
                        if (seq_idx == 3'd7) begin
                            timerEn <= 1'b0;
                            State <= SUBMIT_SCORE;
                        end else begin
                            seq_idx <= seq_idx + 3'd1;
                            State <= GUESS_RELEASE;
                        end
                    end
                end
                GUESS_RELEASE: begin
                    if(timeOut_Game == 1'b1) begin
                        timerEn <= 1'b0;
                        State <= SUBMIT_SCORE;
                    end
                    else if(PswdEnter == 1'b0)
                        State <= GAMEPLAY;
                end
                SUBMIT_SCORE: begin
                    scoreReady <= 1'b1;
                    if(isValid == 1'b1) begin
                        scoreReady <= 1'b0;
                        State <= GAMEOVER;
                    end
                end
                GAMEOVER: begin
                    if(PswdEnter == 1'b1)
                        State <= INIT;
                end
                default: State <= INIT;
            endcase
        end
    end
endmodule

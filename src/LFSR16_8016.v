// ECE 5440 Advanced Digital Design
// Luke Jarred Dvorak 8036
// 1ms_lsfr
// Timer for 1 ms using a LFSR counter
module LFSR16_8016(clk, rst, timeout, Rand);
  input clk, rst;
  output timeout;
  output [3:0] Rand;
  
  reg timeout;
  reg [15:0] LFSR;
  wire feedback = LFSR[15];

  assign Rand = {LFSR[14], LFSR[11], LFSR[7], LFSR[2]}; 

  always @(posedge clk) begin
    if(rst == 1'b0) begin 
        LFSR <= 16'b1111111111111111;
        timeout <= 1'b0;
    end
    else begin
        timeout <= 1'b0;
        if(LFSR == 16'b1101101101101100) begin
            timeout <= 1'b1;
            LFSR <= 16'b1111111111111111;
        end
        else begin
            LFSR[0] <= feedback;
            LFSR[1] <= LFSR[0];
            LFSR[2] <= LFSR[1] ^ feedback;
            LFSR[3] <= LFSR[2] ^ feedback;
            LFSR[4] <= LFSR[3];
            LFSR[5] <= LFSR[4] ^ feedback;
            LFSR[6] <= LFSR[5];
            LFSR[7] <= LFSR[6];
            LFSR[8] <= LFSR[7];
            LFSR[9] <= LFSR[8];
            LFSR[10] <= LFSR[9];
            LFSR[11] <= LFSR[10];
            LFSR[12] <= LFSR[11];
            LFSR[13] <= LFSR[12];
            LFSR[14] <= LFSR[13];
            LFSR[15] <= LFSR[14];
        end
    end
  end
endmodule

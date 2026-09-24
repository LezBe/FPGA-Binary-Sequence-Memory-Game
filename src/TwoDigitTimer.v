// ECE 5440/6370
// Author: Mohammed Atif Mohiuddin, 5164
// TwoDigitTimer
//
// Top-level implementation of digit-timer
// modules and 1-sec timer to create a two-
// digit timer.
//
// Last modified 3-28-26

module TwoDigitTimer(timEn, timReCfg, Ones, Tens, timeOut, curCnt_One, curCnt_Ten, clk, rst);
    input timEn, timReCfg, clk, rst;
    input [3:0] Ones, Tens;
    output timeOut;
    output [3:0] curCnt_One, curCnt_Ten;
    wire timeOut_OneSec;
    wire noBrw_OneTen, brw_OneTen;
    wire brwUp_Ten;
    wire noBrwUp_Ten;
    assign noBrwUp_Ten = 1'b1;

    OneSecTimer OneSecTimer_1(timEn, timeOut_OneSec, clk, rst);
    DigitTimer DigitTimer_1s(Ones, timReCfg, timeOut_OneSec, noBrw_OneTen, brw_OneTen, timeOut, curCnt_One, clk, rst); 
    DigitTimer DigitTimer_10s(Tens, timReCfg, brw_OneTen, noBrwUp_Ten, brwUp_Ten, noBrw_OneTen, curCnt_Ten, clk, rst);
endmodule

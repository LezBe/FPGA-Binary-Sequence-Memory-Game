// ECE 5440/6370
// Author: Mohammed Atif Mohiuddin, 5164
// OneSecTimer
//
// Top-level implementation of 100-mil-sec
// timer and count-to-10 modules to create
// a timer with total length of 1 second.
//
// Last modified 3-28-26

module OneSecTimer(enable_OneHundMilSec, timeOut_OneSec, clk, rst);
    input enable_OneHundMilSec, clk, rst;
    output timeOut_OneSec;
    wire timeOut_OneHundMilSec;
    
    OneHundredMilSecTimer OneHundredMilSecTimer_1(enable_OneHundMilSec, timeOut_OneHundMilSec, clk, rst);
    countTo10 countTo10_1(timeOut_OneHundMilSec, timeOut_OneSec, clk, rst);
    
endmodule
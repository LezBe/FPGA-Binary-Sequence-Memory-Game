// ECE 5440/6370
// Author: Mohammed Atif Mohiuddin, 5164
// OneHundredMilSecTimer
//
// Instantiation module of 1-mil-sec timer
// and count-to-100 modules to create a 
// 100-mil-sec timer.
//
// Last modified 4-10-26

module OneHundredMilSecTimer(enable_OneMilSec, timeOut_OneHundMilSec, clk, rst);
    input enable_OneMilSec, clk, rst;
    output timeOut_OneHundMilSec;
    wire timeOut_OneMilSec;
    
    OneMilSec OneMilSecLFSR_1(enable_OneMilSec, timeOut_OneMilSec, clk, rst);
    countTo100 countTo100_1(timeOut_OneMilSec, timeOut_OneHundMilSec, clk, rst);
    
endmodule

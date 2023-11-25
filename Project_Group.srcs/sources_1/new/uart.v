`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 09:46:52 PM
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart(
        output p1_control,
        output p2_control,
        output active,
        output led,
        input wire bitIn,
        input wire clk,
        input reset
    );
    wire buad;
    wire ready;
    wire [7:0] rxOut;
    wire [1:0] p1_control;
    wire [1:0] p2_control;
    wire active;
    buadGenerator f1(buad,clk);
    uartRx(rxOut,ready,buad,bitIn);
    uartTx(p1_control,p2_control,active,led,reset,ready,buad,rxOut);
    
endmodule

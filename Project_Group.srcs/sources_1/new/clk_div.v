`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2023 12:28:11 PM
// Design Name: 
// Module Name: clk_div
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


module clk_div (
        output clkDiv,
        input clk
        );
        
        reg clkDiv;
        
        initial begin
            clkDiv=0;
        end
        
        always @(posedge clk) begin
            clkDiv=~clkDiv;
        end
        
        
endmodule

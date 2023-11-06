`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2023 11:20:36 AM
// Design Name: 
// Module Name: DFilpFlop
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


module DFilpFlop(
        output q,
        output notq,
        input d,
        input clk
    );
    reg q,notq;
    initial begin
        q = 0;
        notq = 1;
    end
    
    always @(posedge clk)begin
        q = d;
        notq = ~d;
    end
endmodule

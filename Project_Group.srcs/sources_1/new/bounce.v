`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2023 09:27:39 PM
// Design Name: 
// Module Name: bounce
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


module bounce(
        output wire out,
        input d,
        input clk
    );
    
    reg q;
    reg q_prev;
    initial begin
        q <= 0;
        q_prev <=0;
    end
    
    assign out = q && q_prev;
    always @(posedge clk) begin
        q <= d;
        q_prev <= q;
    end
    
endmodule

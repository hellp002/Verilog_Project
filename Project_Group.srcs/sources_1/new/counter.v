`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2023 02:09:57 PM
// Design Name: 
// Module Name: counter
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


module counter(
        output reg [3:0] d1_p1,
        output reg [3:0] d0_p1,
        output reg [3:0] d1_p2,
        output reg [3:0] d0_p2,
        input p1_win,
        input p2_win,
        input clk,
        input reset
    );
    
    
    
    
    
    always@(posedge clk) begin
        if (reset) begin
            d1_p1 = 4'b0000;
            d0_p1 = 4'b0000;
            d1_p2 = 4'b0000;
            d0_p2 = 4'b0000;
        end else begin
            if (p1_win) begin
                if (d0_p1 == 4'b1001) begin
                    d1_p1 = d1_p1 + 1;
                    d0_p1 = 0;
                end else begin
                    d0_p1 = d0_p1 + 1;
                end
            
            end else if (p2_win) begin
                if (d0_p2 == 4'b1001) begin
                    d1_p2 = d1_p2 + 1;
                    d0_p2 = 0;
                end else begin
                    d0_p2 = d0_p2 + 1;
                end
            end
        end
    end
endmodule

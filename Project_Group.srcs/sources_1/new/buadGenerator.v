`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 09:47:10 PM
// Design Name: 
// Module Name: buadGenerator
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


module buadGenerator(
        output reg buad,
        input clk

    );
    
    reg [8:0] counter;
    always@(posedge clk) begin
        // @baud rate 9600 sampling rate 16
        if (counter == 9'd325) begin
            counter <= 0;
            buad = ~buad;
        end 
        else
            counter <= counter + 1;
    
    end
    
endmodule

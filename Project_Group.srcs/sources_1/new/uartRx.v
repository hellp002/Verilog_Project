`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 09:16:16 PM
// Design Name: 
// Module Name: uartRx
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


module uartRx(
        output reg [7:0] dout,
        output reg receive,
        input clk,
        input bitIn
    );
    reg lastbit;
    reg [7:0] counter;
    initial
        lastbit = 1;
    always@(posedge clk) begin
        if (!receive & !bitIn & lastbit) begin
            counter <= 0;
            receive <= 1;
        end
        counter <= (receive) ? counter + 1 : 0;
        lastbit <= bitIn;
        case(counter)
           8'd24 : dout[0] <= bitIn;
           8'd40 : dout[1] <= bitIn;
           8'd56 : dout[2] <= bitIn;
           8'd72 : dout[3] <= bitIn;
           8'd88 : dout[4] <= bitIn;
           8'd104 : dout[5] <= bitIn;
           8'd120 : dout[6] <= bitIn;
           8'd136 : dout[7] <= bitIn;
           8'd150 : begin receive <= 0; counter <= 0; end
        
        endcase
        
    
    end
    
    
    
endmodule

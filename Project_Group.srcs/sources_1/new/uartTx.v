`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 09:31:56 PM
// Design Name: 
// Module Name: uartTx
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


module uartTx(
        output reg [1:0] p1_control,
        output reg [1:0] p2_control,
        output active,
        input reset,
        input busy,
        input clk,
        input [7:0] din
    );
    reg last_status;
    reg read;
    reg [9:0] counter;
    reg [7:0] buffer;
    reg active;
    
    always@(posedge clk or posedge reset) begin
            if (reset) begin
                active = 1'b0;
                p1_control = 2'b00;
                p2_control = 2'b00;
            end else begin
                if (last_status && !busy && (din == 8'd79 || din == 8'd111 || din == 8'd108 || din == 8'd76 || din == 8'd87 || din == 8'd119 || din == 8'd83 || din == 8'd115 ) ) begin
                    case(din) 
                        8'd79: p2_control = 2'b10;
                        8'd111: p2_control = 2'b10;
                        8'd76: p2_control = 2'b01;
                        8'd108: p2_control = 2'b01;
                        8'd87: p1_control = 2'b10;
                        8'd119: p1_control = 2'b10;
                        8'd83: p1_control = 2'b01;
                        8'd115: p1_control = 2'b01;
                    endcase
                    active = 1;
                end else begin
                    active = 0;
                end
                counter <= (read == 1 ) ? counter + 1: 0;
                last_status <= busy;
           end
    end
    
    
    
endmodule

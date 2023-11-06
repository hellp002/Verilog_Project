`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2023 10:34:12 PM
// Design Name: 
// Module Name: spulse
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


module spulse(
        output o,
        input i,
        input clk
    );
    
    reg [1:0] state;
    reg [1:0] n_state;
    reg o;
    initial 
        n_state = 0;
    always @(posedge clk) begin
        state = n_state;
    end
    
    always @(state or i) begin
        case(state) 
            2'b00: begin
                o = 0; 
                if (i == 1) 
                    n_state = 2'b01;
                 else            
                    n_state = 2'b00;
                 
            end    
            2'b01: begin
                o = 1;
                if (i == 1)
                    n_state = 2'b10;
                else
                    n_state = 2'b00;
            end
            2'b10: begin
                o = 0;
                if (i == 1)
                    n_state = 2'b10;
                else
                    n_state = 2'b00;
                end
            default:
                n_state = 2'b00;
        endcase
    end
endmodule

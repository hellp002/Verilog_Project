`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 07:13:22 PM
// Design Name: 
// Module Name: system
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


module display(
        output wire [3:0] choice,
        output wire [6:0] segment,
        output wire dot,
        input [3:0] d3,
        input [3:0] d2,
        input [3:0] d1,
        input [3:0] d0,
        input clk
    );
    reg [1:0] state;
    wire [1:0] n_state;
    reg [3:0] choice_col;
    reg [3:0] choose;
    wire [6:0] buffer;
    assign segment = buffer;
    
    assign n_state = state + 1;
    assign choice = ~choice_col;
    initial
        state = 0;
    always @(posedge clk) begin
        state = n_state;
    end
    always @(state) begin
        case(state)
            2'b00: choice_col = 4'b0001;
            2'b01: choice_col = 4'b0010;
            2'b10: choice_col = 4'b0100;
            2'b11: choice_col = 4'b1000;
        endcase
    end
    always @(state) begin
        case(state)
            2'b00: choose = d0;
            2'b01: choose = d1;
            2'b10: choose = d2;
            2'b11: choose = d3;
        endcase
    end
    
    segment todec(buffer,dot,choose);
    
endmodule

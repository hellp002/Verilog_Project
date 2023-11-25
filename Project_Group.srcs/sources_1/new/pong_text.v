`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Reference book: "FPGA Prototyping by Verilog Examples"
//                      "Xilinx Spartan-3 Version"
// Written by: Dr. Pong P. Chu
// Published by: Wiley, 2008
//
// Adapted for Basys 3 by David J. Marion aka FPGA Dude
//
//////////////////////////////////////////////////////////////////////////////////


module pong_text(
    input clk,
    input [3:0] d1_p1, d0_p1, d1_p2, d0_p2,
    input [9:0] x, y,
    output [1:0] text_on,
    output reg [11:0] text_rgb
    );
    
    // signal declaration
    wire [10:0] rom_addr;
    reg [6:0] char_addr, char_addr_s, char_addr_l, char_addr_r, char_addr_o;
    reg [3:0] row_addr;
    wire [3:0] row_addr_s, row_addr_l, row_addr_r, row_addr_o;
    reg [2:0] bit_addr;
    wire [2:0] bit_addr_s, bit_addr_l, bit_addr_r, bit_addr_o;
    wire [7:0] ascii_word;
    wire ascii_bit, score_on, logo_on, rule_on, over_on;
    wire [7:0] rule_rom_addr;
    
   // instantiate ascii rom
   ascii_rom ascii_unit(.clk(clk), .addr(rom_addr), .data(ascii_word));
   
   // ---------------------------------------------------------------------------
   // score region
   // - display two-digit score and ball # on top left
   // - scale to 16 by 32 text size
   // - line 1, 16 chars: "Score: dd Ball: d"
   // ---------------------------------------------------------------------------
   assign score_on = (y >= 48) && (y < 80) && (x[9:4] < 16);
   //assign score_on = (y[9:5] == 0) && (x[9:4] < 16);
   assign row_addr_s = y[4:1] - 8;
   assign bit_addr_s = x[3:1];
   always @*
    case(x[7:4])
        4'h0 : char_addr_s = 7'h00;     // 
        4'h1 : char_addr_s = 7'h00;     // 
        4'h2 : char_addr_s = 7'h00;     // 
        4'h3 : char_addr_s = 7'h50;    // P
        4'h4 : char_addr_s = 7'b0110001;     // 1
        4'h5 : char_addr_s = 7'h3A;     // :
        4'h6 : char_addr_s = {3'b011, d1_p1};     //
        4'h7 : char_addr_s = {3'b011, d0_p1}; 
        4'h8 : char_addr_s = 7'h00; 
        4'h9 : char_addr_s = 7'h00;     // 
        4'hA : char_addr_s = 7'h00;  
        4'hB : char_addr_s = 7'h50;    // P
        4'hC : char_addr_s = 7'b0110010;     // 2
        4'hD : char_addr_s = 7'h3A;     // :
        4'hE : char_addr_s = {3'b011, d1_p2};  
        4'hF : char_addr_s = {3'b011, d0_p2};
    endcase
    
    // --------------------------------------------------------------------------
    // logo region
    // - display logo "PONG" at top center
    // - used as background
    // - scale to 64 by 128 text size
    // --------------------------------------------------------------------------
    assign logo_on = (y[9:7] == 2) && (3 <= x[9:6]) && (x[9:6] <= 6);
    assign row_addr_l = y[6:3];
    assign bit_addr_l = x[5:3];
    always @*
        case(x[8:6])
            3'o3 :    char_addr_l = 7'h50; // P
            3'o4 :    char_addr_l = 7'h4F; // O
            3'o5 :    char_addr_l = 7'h4E; // N
            default : char_addr_l = 7'h47; // G
        endcase
    
    // mux for ascii ROM addresses and rgb
    always @* begin
        text_rgb = 12'h109;     // aqua background
        
        if(score_on) begin
            char_addr = char_addr_s;
            row_addr = row_addr_s;
            bit_addr = bit_addr_s;
            if(ascii_bit)
                text_rgb = 12'hFFF; // red
        end
        
        else if(logo_on) begin
            char_addr = char_addr_l;
            row_addr = row_addr_l;
            bit_addr = bit_addr_l;
            if(ascii_bit)
                text_rgb = 12'hFF0; // yellow
        end    
    end
    
    assign text_on = {score_on, logo_on};
    
    // ascii ROM interface
    assign rom_addr = {char_addr, row_addr};
    assign ascii_bit = ascii_word[~bit_addr];
      
endmodule

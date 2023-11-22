`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2023 03:17:08 PM
// Design Name: 
// Module Name: game_logic
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


module game_logic(
        output reg [11:0] rgb,
        output wire [3:0] red,
        output p1_win,
        output p2_win,
        input clk,
        input reset,
        input video_on,
        input wire [1:0] p1_control,
        input wire [1:0] p2_control,
        input [9:0] x,
        input [9:0] y
    );
    
    wire refresh_tick;
    reg [9:0] p1x, p1y, p2x, p2y;
    reg [9:0] p1y_next, p2y_next;
    reg [9:0] ballx, bally , ballx_dir_next, bally_dir_next, ballx_dir_reg, bally_dir_reg ;
    wire [9:0] ballx_next, bally_next;
    wire [9:0] p1_top, p1_left, p1_bottom, p1_right;
    wire [9:0] p2_top, p2_left, p2_bottom, p2_right;
    wire [9:0] b_top, b_bot;
    wire [9:0] ball_l,ball_t,ball_r,ball_b;
    
    localparam BALL_SIZE = 7;
    localparam BOARDER_WIDTH = 10-1;
    parameter POS_MOVE = 1;
    parameter NEG_MOVE = -1; 
    localparam HEIGHT = 480-1;
    localparam WIDTH = 640-1;
    localparam PADDLE_L = 50-1;
    localparam PADDLE_W = 5-1;
    localparam MOVEMENT_SPEED = 3;
    localparam B_TOP = 29;
    localparam B_BOT = 469;
    reg [3:0] buffer;
    wire [2:0] rom_addr, rom_col;   // 3-bit rom address and rom column
    reg [7:0] rom_data;

    
    assign red = buffer;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0;
    assign p1_top = p1y;
    assign p1_left = p1x;
    assign p1_bottom = p1y + PADDLE_L;
    assign p1_right = p1x + PADDLE_W;
    
    assign p2_top = p2y;
    assign p2_left = p2x;
    assign p2_bottom = p2y + PADDLE_L;
    assign p2_right = p2x + PADDLE_W;
    
    wire is_out_of_bound_p1,is_out_of_bound_p2;
    
    initial begin
       p1x = 30;
       p1y = 230;
       p2x = 610;
       p2y = 230;
       ballx = 316;
       bally = 236;
       
       ballx_dir_reg <= 10'h002;
       bally_dir_reg <= 10'h002;
    end
    
    // updater
    always@(posedge clk) begin
         if (reset || p1_win || p2_win)begin
            p1y = 230;
            p2y = 230;
            ballx = 316;
            bally = 236;
            bally_dir_reg = POS_MOVE;
            ballx_dir_reg = POS_MOVE;
            buffer = 4'b0000;
         end else begin
            p1y = p1y_next;
            p2y = p2y_next;
                        
            ballx_dir_reg = ballx_dir_next;
            bally_dir_reg = bally_dir_next;
            
            ballx = ballx_next;
            bally = bally_next; 
            if (refresh_tick)
                buffer = 4'b0000;
            if (p1_control != 2'b00)
                buffer = {p1_control, buffer[1:0]};
            if (p2_control != 2'b00)
                buffer = {buffer[3:2], p2_control};
         end
    
    
    end
    
    assign ball_l = ballx;
    assign ball_t = bally;
    assign ball_r = ball_l + BALL_SIZE;
    assign ball_b = ball_t + BALL_SIZE;
    
    wire collide_bot,collide_top;
    wire p1_win,p2_win;
    assign collide_p1 = (p1_left <= ball_l) && (ball_l <= p1_right) && (p1_top <= ball_t) && (ball_t <= p1_bottom);
    assign collide_p2 = (p2_left <= ball_r) && (ball_r <= p2_right) && (p2_top <= ball_b) && (ball_b <= p2_bottom);
    assign collide_bot = (ball_b > (B_BOT - POS_MOVE)) ? 1 : 0;
    assign collide_top = (ball_t < (B_TOP + BOARDER_WIDTH - NEG_MOVE)) ? 1: 0;
    assign p1_win = ball_r > 630;
    assign p2_win = ball_l < 20;
    // ball rom
    always @*
        case(rom_addr)
            3'b000 :    rom_data = 8'b00111100; //   ****  
            3'b001 :    rom_data = 8'b01111110; //  ******
            3'b010 :    rom_data = 8'b11111111; // ********
            3'b011 :    rom_data = 8'b11111111; // ********
            3'b100 :    rom_data = 8'b11111111; // ********
            3'b101 :    rom_data = 8'b11111111; // ********
            3'b110 :    rom_data = 8'b01111110; //  ******
            3'b111 :    rom_data = 8'b00111100; //   ****
        endcase
    
    // ball move
    
    assign ballx_next = (refresh_tick)? ballx + ballx_dir_reg : ballx;  
    assign bally_next = (refresh_tick)? bally + bally_dir_reg : bally;
    always @* begin
        ballx_dir_next = ballx_dir_reg;
        bally_dir_next = bally_dir_reg;
        
        // hit top
        if (collide_top) begin
            bally_dir_next = POS_MOVE;
        end
        else if (collide_bot) begin
            bally_dir_next = NEG_MOVE;
        end   
        else if (collide_p1) begin
            ballx_dir_next = POS_MOVE;
        end
        else if (collide_p2) begin
            ballx_dir_next = NEG_MOVE;
        end
    end 
    
    // paddle move
    always@* begin
      p1y_next = p1y;
      p2y_next = p2y;
      if (refresh_tick) begin
        case(buffer[3:2]) 
            2'b01: p1y_next = (p1_bottom < (HEIGHT - MOVEMENT_SPEED - BOARDER_WIDTH)) ? p1y + MOVEMENT_SPEED : p1y; 
            2'b10: p1y_next = (p1_top > (MOVEMENT_SPEED + B_TOP + BOARDER_WIDTH) ) ? p1y - MOVEMENT_SPEED : p1y; 
        endcase
        case(buffer[1:0]) 
            2'b01: p2y_next = (p2_bottom < (HEIGHT - MOVEMENT_SPEED - BOARDER_WIDTH)) ? p2y + MOVEMENT_SPEED : p2y; 
            2'b10: p2y_next = (p2_top >( MOVEMENT_SPEED + B_TOP + BOARDER_WIDTH)) ? p2y - MOVEMENT_SPEED : p2y; 
        endcase
      end
    end
    
    wire render_p1, render_p2, render_b1, render_b2;
    
    
    
    assign rom_addr = y[2:0] - bally[2:0];   // 3-bit address
    assign rom_col = x[2:0] - ballx[2:0];    // 3-bit column index
    assign rom_bit = rom_data[rom_col];         // 1-bit signal rom data by column
    
    assign render_ball = (ball_l <= x) && (x <= ball_r) && (ball_t <= y) && (y <= ball_b);
    assign render_b1 = (0 <= x) && (x <= WIDTH) && (B_TOP <= y ) && (y <= (B_TOP + BOARDER_WIDTH));
    assign render_b2 = (0 <= x) && (x <= WIDTH) && (B_BOT <= y ) && (y <= (B_BOT + BOARDER_WIDTH));
    assign render_p1 = ((p1_left <= x) && (x <= p1_right)) && ((p1_top <= y) && (y <= p1_bottom));
    assign render_p2 = ((p2_left <= x) && (x <= p2_right)) && ((p2_top <= y) && (y <= p2_bottom));
    
    
    
    
    
    //render logic
    always@* begin
        if (video_on) begin
            if (render_p1) 
                rgb <= 12'hFFF;
            else if(render_p2)
                rgb <= 12'hFFF;
            else if (render_b1 || render_b2)
                rgb <= 12'hFFF;
            else if (render_ball && rom_bit)
                rgb <= 12'hFFF;
            
            else 
                rgb <= 12'h000;
         
        
        end else begin
            rgb <= 12'h000;
        end
    end
    
    
    
    
    
    
    
    
    
    
endmodule

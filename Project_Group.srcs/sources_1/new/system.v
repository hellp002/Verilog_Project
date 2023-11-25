`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 08:18:51 PM
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


module system(
		input wire clk,
		input wire bitIn,
		input wire reset,
		output wire hsync, vsync,
		output rgb,
		output wire txOut,
		output wire [3:0] an,
		output wire dp,
		output wire [6:0] seg,
        output led
	);
	
	// register for Basys 2 8-bit RGB DAC 
	localparam X = 640;
	localparam Y = 480;
	wire [4:0] tmp;
	wire game_on;
	wire [4:0] led;
	wire [11:0] rgb;
	reg [11:0] rgb_reg,rgb_next;
	wire [1:0] text_on;
	wire [11:0] text_rgb;
	wire [3:0] d1_p1;
	wire [3:0] d0_p1;
	wire [3:0] d1_p2;
	wire [3:0] d0_p2;
	wire [11:0] rgb_game;
	wire [23:0] tclk;
	wire [9:0] x,y;
	reg is_h;
	wire p_tick;
	wire [1:0] p1_control;
    wire [1:0] p2_control;
    wire active;
    reg isPlay;
    wire p1_win,p2_win;
	assign led = {p1_control,p2_control};
	assign tclk[0] = clk;
//	assign led = {led[4],p1_control,p2_control};
    genvar i;
	generate for (i = 0; i < 23; i = i + 1) begin
        clk_div f1(tclk[i + 1],tclk[i]);
        end
    endgenerate
	wire RESET;
	debounce r0(RESET,reset,tclk[0],tclk[22]);
	
	
	always@(posedge clk) begin
	   if (reset) begin
	       isPlay = 1'b0; 
	       
	   end
	   else if (!isPlay) begin
	       if (active) begin
	           isPlay = 1'b1;
	       end
	   end else begin
	       if (p1_win) begin
	           isPlay = 1'b0;
	       end
	       else if (p2_win) begin
	           isPlay = 1'b0;
	       end
	   end
	end
	
	always@(posedge clk) begin
	   if (p_tick)
	       rgb_reg = rgb_next;
	end
	
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on;
	counter af(.d1_p1(d1_p1), .d0_p1(d0_p1), .d1_p2(d1_p2), .d0_p2(d0_p2), .p1_win(p1_win), .p2_win(p2_win), .clk(clk), .reset(reset));
	
	display gg(.choice(an), .segment(seg), .dot(dp), .d3(d1_p1), .d2(d0_p1), .d1(d1_p2), .d0(d0_p2), .clk(tclk[18]));
	
    uart f2(p1_control,p2_control,active,led[4],bitIn,clk,reset);
        // instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(1'b0), .hsync(hsync), .vsync(vsync),
                                .video_on(video_on), .p_tick(p_tick), .x(x), .y(y));
   
        // rgb buffer
        
    game_logic g_unit (.rgb(rgb_game), .red(tmp[3:0]) , .game_on(game_on),.p1_win(p1_win), .p2_win(p2_win) , .clk(clk), .reset(!isPlay), .video_on(video_on), .p1_control(p1_control), .p2_control(p2_control), .x(x), .y(y));
        // output
    pong_text pt(.clk(clk), .d1_p1(d1_p1), .d0_p1(d0_p1), .d1_p2(d1_p2), .d0_p2(d0_p2), .x(x), .y(y) , .text_on(text_on),.text_rgb(text_rgb));
        
    always @*
        if(~video_on)
            rgb_next = 12'h000; // blank
        else begin
            if (game_on)
                rgb_next = rgb_game;
            else if (text_on[1] || text_on[0])
                rgb_next = text_rgb;
            else 
                rgb_next = 12'h109;
        end
            
    assign rgb = rgb_reg;      
endmodule

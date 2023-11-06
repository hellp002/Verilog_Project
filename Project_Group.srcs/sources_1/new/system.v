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
		input wire clk, mode,
		input wire [11:0] sw,
		input wire save,
		input wire bitIn,
		output wire hsync, vsync,
		output rgb,
		output wire txOut,
        output led
	);
	
	// register for Basys 2 8-bit RGB DAC 
	localparam X = 640;
	localparam Y = 480;
	
	wire [4:0] led;
	wire [11:0] rgb;
	wire [11:0] rgb_game;
	wire [23:0] tclk;
	wire [9:0] x,y;
	reg is_h;
	wire p_tick;
	wire [1:0] p1_control;
    wire [1:0] p2_control;
	uart f2(p1_control,p2_control,bitIn,clk);
	assign tclk[0] = clk;
//	assign led = {led[4],p1_control,p2_control};
    genvar i;
	generate for (i = 0; i < 23; i = i + 1) begin
        clk_div f1(tclk[i + 1],tclk[i]);
        end
    endgenerate
	wire [11:0] SW;
	wire MODE,SAVE;
    generate for (i = 0; i < 12; i = i + 1) begin
        bounce b0(SW[i],sw[i],tclk[23]);
        end
    endgenerate
	debounce r0(MODE,mode,tclk[0],tclk[22]);
    debounce r1(SAVE,save,tclk[0],tclk[22]);
	
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on;

        // instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(1'b0), .hsync(hsync), .vsync(vsync),
                                .video_on(video_on), .p_tick(p_tick), .x(x), .y(y));
   
        // rgb buffer
        
    game_logic g_unit (.rgb(rgb_game),.led(led[4]), .red(led[3:0]) , .clk(clk), .reset({1'b0}), .video_on(video_on), .p1_control(p1_control), .p2_control(p2_control), .x(x), .y(y));
        // output
    assign rgb = rgb_game;
endmodule

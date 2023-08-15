`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background,
	output reg [11:0] health,
	output reg [15:0] score
   );
	reg [3:0] state; 
	localparam
    	START		    =   4'b0001,
	    GAME	        =   4'b0010,
	    WIN	            =   4'b0100,
	    LOSE 	        =   4'b1000;

	wire block_fill;
	wire pipe_fill;
	wire pipe_fill_long;
	wire pipe_fill_3;
	
	wire coin_fill;
	wire coin2_fill;
	wire coin3_fill;
	wire coin4_fill;
	wire coin5_fill;
	wire coin6_fill;
	wire coin7_fill;
	wire coin8_fill;
	wire coin9_fill;
	wire coin10_fill;
	wire coin11_fill;
	wire coin12_fill;
	wire coin13_fill;
	wire coin14_fill;
	wire coin15_fill;
	wire coin16_fill;
	wire coin17_fill;
	wire coin18_fill;
	wire coin19_fill;
	wire coin20_fill;
	wire coin21_fill;
	wire coin22_fill;
	wire coin23_fill;
	wire coin24_fill;
	wire coin25_fill;
	wire coin26_fill;
	wire coin27_fill;
	wire coin28_fill;
	
	wire ground_fill;
	
	wire floating_block_fill;
	wire cloud_fill2;
	wire cloud_fill3;
	
	wire brick_fill;
	wire brick2_fill;
	wire brick3_fill;
	wire brick4_fill;
	wire brick5_fill;
	wire brick6_fill;

	wire goomba_fill;
	
	wire flag_fill;
	wire goal_fill;
	reg jump_flag;
	reg [9:0] counter;
	reg [9:0] prevcounter;
    reg count;
	reg [6:0] coin_count;
	
	//For each group of coins, we need to set a flag for each
	reg coin_flag;
	reg coin_flag2;
	reg coin_flag3;
	reg coin_flag4;
	reg coin_flag5;
	reg coin_flag6;
	reg coin_flag7;
	reg coin_flag8;
	reg coin_flag9;
	reg coin_flag10;
	
	reg score_flag;
	reg fall_flag;
		
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	
	// Variables for pipe position
    reg [10:0] pipe_xpos, pipe_ypos;
	
	//Variable for cloud position
	reg [9:0] cloud_xpos, cloud_ypos;
	
	//Variable for brick position
	reg [10:0] brick_xpos, brick_ypos;
	
	//Variable for coin position
	reg [10:0] coin_xpos, coin_ypos;

	//Variable for goomba position
	reg [10:0] goomba_xpos, goomba_ypos;
	reg goomba_flag;
	
	//Variable for the goal
	reg [10:0] goal_xpos, goal_ypos; 
	
	//Variable for the flag position
	reg [10:0] flag_xpos, flag_ypos;
   
    // Variables for pipe sprite dimensions
    parameter SPRITE_WIDTH = 50;
    parameter SPRITE_HEIGHT = 100;
	
	//Viarbales for the flag
	parameter FLAG_WIDTH = 5;
	parameter FLAG_HEIGHT = 100;
	
	// Variables for sprite dimensions
    parameter GOAL_WIDTH = 80;
    parameter GOAL_HEIGHT = 60;
	
	//Variables for ground_fill
	parameter GROUND_WIDTH = 800;
	parameter GROUND_HEIGHT = 50;
	
	//Variables for the bricks
	parameter BRICK_WIDTH = 50;
	parameter BRICK_HEIGHT = 20;
	
	//Variables for the coins
	parameter COIN_WIDTH = 6;
	parameter COIN_HEIGHT = 6;
	
	//Variables for goomba(s)
	parameter GOOMBA_WIDTH = 10;
	parameter GOOMBA_HEIGHT = 10;
	
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	parameter WHITE = 12'b1111_1111_1111;
	parameter BROWN = 12'b1100_0010_0000;
	parameter YELLOW = 12'b1111_1111_0000;
	parameter SKYBLUE = 12'b0000_1111_1111;
	//parameter GRAY = 12'b0111_0111_0111;
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if (block_fill) 
			rgb = RED; // Pretend this is Mario
		else if (pipe_fill)
			rgb = 12'b0000_1111_0000; // set to green
		else if (pipe_fill_long)
			rgb = GREEN; // set to green
		else if (pipe_fill_3)
			rgb = GREEN; // set to green
		else if (floating_block_fill)
			rgb = WHITE;
		else if (cloud_fill2)
			rgb = WHITE;
		else if (cloud_fill3)
			rgb = WHITE;
		else if (cloud_fill4)
			rgb = WHITE;
		else if (brick_fill)
			rgb = BROWN;
		else if (brick2_fill)
			rgb = BROWN;
		else if (brick3_fill)
			rgb = BROWN;
		else if (brick4_fill)
			rgb = BROWN;
		else if (brick5_fill)
			rgb = BROWN;
		else if (brick6_fill)
			rgb = BROWN;
		else if (goal_fill)
			rgb = BROWN;
		else if (flag_fill)
			rgb = WHITE; //GRAY
		else if (coin_fill)
			begin
				if(coin_flag == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag == 0)
					rgb = YELLOW;
			end
		else if (coin2_fill) 
			begin
				if(coin_flag == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag == 0)
					rgb = YELLOW;
			end
		else if (coin3_fill) 
			begin
				if(coin_flag == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag == 0)
					rgb = YELLOW;
			end
		else if (coin4_fill) 
			begin
				if(coin_flag2 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag2 == 0)
					rgb = YELLOW;
			end
		else if (coin5_fill) 
			begin
				if(coin_flag2 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag2 == 0)
					rgb = YELLOW;
			end
		else if (coin6_fill) 
			begin
				if(coin_flag2 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag2 == 0)
					rgb = YELLOW;
			end
		else if (coin7_fill) 
			begin
				if(coin_flag3 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag3 == 0)
					rgb = YELLOW;
			end
		else if (coin8_fill) 
			begin
				if(coin_flag3 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag3 == 0)
					rgb = YELLOW;
			end
		else if (coin9_fill) 
			begin
				if(coin_flag3 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag3 == 0)
					rgb = YELLOW;
			end
		else if (coin10_fill) 
			begin
				if(coin_flag4 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag4 == 0)
					rgb = YELLOW;
			end
		else if (coin11_fill) 
			begin
				if(coin_flag4 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag4 == 0)
					rgb = YELLOW;
			end
		else if (coin12_fill) 
			begin
				if(coin_flag4 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag4 == 0)
					rgb = YELLOW;
			end
		else if (coin13_fill) 
			begin
				if(coin_flag5 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag5 == 0)
					rgb = YELLOW;
			end
		else if (coin14_fill) 
			begin
				if(coin_flag5 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag5 == 0)
					rgb = YELLOW;
			end
		else if (coin15_fill) 
			begin
				if(coin_flag5 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag5 == 0)
					rgb = YELLOW;
			end
		else if (coin16_fill) 
			begin
				if(coin_flag6 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag6 == 0)
					rgb = YELLOW;
			end
		else if (coin17_fill) 
			begin
				if(coin_flag6 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag6 == 0)
					rgb = YELLOW;
			end
		else if (coin18_fill) 
			begin
				if(coin_flag6 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag6 == 0)
					rgb = YELLOW;
			end
		else if (coin19_fill) 
			begin
				if(coin_flag7 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag7 == 0)
					rgb = YELLOW;
			end
		else if (coin20_fill) 
			begin
				if(coin_flag7 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag7 == 0)
					rgb = YELLOW;
			end
		else if (coin21_fill) 
			begin
				if(coin_flag8 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag8 == 0)
					rgb = YELLOW;
			end
		else if (coin22_fill) 
			begin
				if(coin_flag8 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag8 == 0)
					rgb = YELLOW;
			end
		else if (coin23_fill) 
			begin
				if(coin_flag9 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag9 == 0)
					rgb = YELLOW;
			end
		else if (coin24_fill) 
			begin
				if(coin_flag9 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag9 == 0)
					rgb = YELLOW;
			end
		else if (coin25_fill) 
			begin
				if(coin_flag9 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag9 == 0)
					rgb = YELLOW;
			end
		else if (coin26_fill) 
			begin
				if(coin_flag10 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag10 == 0)
					rgb = YELLOW;
			end
		else if (coin27_fill) 
			begin
				if(coin_flag10 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag10 == 0)
					rgb = YELLOW;
			end
		else if (coin28_fill) 
			begin
				if(coin_flag10 == 1)
					rgb = 12'b0000_1111_1111;
				else if(coin_flag10 == 0)
					rgb = YELLOW;
			end
		else if (goomba_fill)
			rgb = BROWN;
		else if (vCount >= 450)
			rgb = BROWN;
		else	
			rgb=background;
	end
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	assign block_fill = vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	
	// The position and dimensions of the coins
	assign coin_fill  = (vCount >= (coin_ypos + 60)) && (vCount <= (coin_ypos + 60) + COIN_HEIGHT) && (hCount >= (515 - coin_xpos)) && (hCount <= ((515 - coin_xpos) + COIN_WIDTH));
	assign coin2_fill = (vCount >= (coin_ypos + 60)) && (vCount <= ((coin_ypos + 60) + COIN_HEIGHT)) && (hCount >= (525 - coin_xpos)) && (hCount <= (525 - coin_xpos) + COIN_WIDTH);
	assign coin3_fill = (vCount >= (coin_ypos + 60)) && (vCount <= ((coin_ypos + 60) + COIN_HEIGHT)) && (hCount >= (535 - coin_xpos)) && (hCount <= (535 - coin_xpos) + COIN_WIDTH);
	assign coin4_fill = (vCount >= (coin_ypos + 50)) && (vCount <= ((coin_ypos + 50) + COIN_HEIGHT)) && (hCount >= (625 - coin_xpos)) && (hCount <= ((625 - coin_xpos) + COIN_WIDTH));
	assign coin5_fill = (vCount >= (coin_ypos + 50)) && (vCount <= ((coin_ypos + 50) + COIN_HEIGHT)) && (hCount >= (635 - coin_xpos)) && (hCount <= ((635 - coin_xpos) + COIN_WIDTH));
	assign coin6_fill = (vCount >= (coin_ypos + 50)) && (vCount <= ((coin_ypos + 50) + COIN_HEIGHT)) && (hCount >= (645 - coin_xpos)) && (hCount <= ((645 - coin_xpos) + COIN_WIDTH));
	assign coin7_fill = (vCount >= (coin_ypos + 130)) && (vCount <= ((coin_ypos + 130) + COIN_HEIGHT)) && (hCount >= (695 - coin_xpos)) && (hCount <= ((695 - coin_xpos) + COIN_WIDTH));
	assign coin8_fill = (vCount >= (coin_ypos + 130)) && (vCount <= ((coin_ypos + 130) + COIN_HEIGHT)) && (hCount >= (705 - coin_xpos)) && (hCount <= ((705 - coin_xpos) + COIN_WIDTH));
	assign coin9_fill = (vCount >= (coin_ypos + 130)) && (vCount <= ((coin_ypos + 130) + COIN_HEIGHT)) && (hCount >= (715 - coin_xpos)) && (hCount <= ((715 - coin_xpos) + COIN_WIDTH));
	assign coin10_fill = (vCount >= (coin_ypos + 50)) && (vCount <= ((coin_ypos + 50) + COIN_HEIGHT)) && (hCount >= (775 - coin_xpos)) && (hCount <= ((775 - coin_xpos) + COIN_WIDTH));
	assign coin11_fill = (vCount >= (coin_ypos + 50)) && (vCount <= ((coin_ypos + 50) + COIN_HEIGHT)) && (hCount >= (785 - coin_xpos)) && (hCount <= ((785 - coin_xpos) + COIN_WIDTH));
	assign coin12_fill = (vCount >= (coin_ypos + 50)) && (vCount <= ((coin_ypos + 50) + COIN_HEIGHT)) && (hCount >= (795 - coin_xpos)) && (hCount <= ((795 - coin_xpos) + COIN_WIDTH));
	assign coin13_fill = (vCount >= (coin_ypos - 50)) && (vCount <= ((coin_ypos - 50) + COIN_HEIGHT)) && (hCount >= (875 - coin_xpos)) && (hCount <= ((875 - coin_xpos) + COIN_WIDTH));
	assign coin14_fill = (vCount >= (coin_ypos - 50)) && (vCount <= ((coin_ypos - 50) + COIN_HEIGHT)) && (hCount >= (885 - coin_xpos)) && (hCount <= ((885 - coin_xpos) + COIN_WIDTH));
	assign coin15_fill = (vCount >= (coin_ypos - 50)) && (vCount <= ((coin_ypos - 50) + COIN_HEIGHT)) && (hCount >= (895 - coin_xpos)) && (hCount <= ((895 - coin_xpos) + COIN_WIDTH));
	assign coin16_fill = (vCount >= (coin_ypos + 110)) && (vCount <= ((coin_ypos + 110) + COIN_HEIGHT)) && (hCount >= (865 - coin_xpos)) && (hCount <= ((865 - coin_xpos) + COIN_WIDTH));
	assign coin17_fill = (vCount >= (coin_ypos + 110)) && (vCount <= ((coin_ypos + 110) + COIN_HEIGHT)) && (hCount >= (885 - coin_xpos)) && (hCount <= ((885 - coin_xpos) + COIN_WIDTH));
	assign coin18_fill = (vCount >= (coin_ypos + 110)) && (vCount <= ((coin_ypos + 110) + COIN_HEIGHT)) && (hCount >= (905 - coin_xpos)) && (hCount <= ((905 - coin_xpos) + COIN_WIDTH));
	assign coin19_fill = (vCount >= (coin_ypos - 10)) && (vCount <= ((coin_ypos - 10) + COIN_HEIGHT)) && (hCount >= (965 - coin_xpos)) && (hCount <= ((965 - coin_xpos) + COIN_WIDTH));
	assign coin20_fill = (vCount >= (coin_ypos - 10)) && (vCount <= ((coin_ypos - 10) + COIN_HEIGHT)) && (hCount >= (975 - coin_xpos)) && (hCount <= ((975 - coin_xpos) + COIN_WIDTH));
	assign coin21_fill = (vCount >= (coin_ypos - 60)) && (vCount <= ((coin_ypos - 60) + COIN_HEIGHT)) && (hCount >= (1035 - coin_xpos)) && (hCount <= ((1035 - coin_xpos) + COIN_WIDTH));
	assign coin22_fill = (vCount >= (coin_ypos - 60)) && (vCount <= ((coin_ypos - 60) + COIN_HEIGHT)) && (hCount >= (1045 - coin_xpos)) && (hCount <= ((1045 - coin_xpos) + COIN_WIDTH));
	assign coin23_fill = (vCount >= (coin_ypos - 10)) && (vCount <= ((coin_ypos - 10) + COIN_HEIGHT)) && (hCount >= (715 - coin_xpos)) && (hCount <= ((715 - coin_xpos) + COIN_WIDTH));
	assign coin24_fill = (vCount >= (coin_ypos - 10)) && (vCount <= ((coin_ypos - 10) + COIN_HEIGHT)) && (hCount >= (725 - coin_xpos)) && (hCount <= ((725 - coin_xpos) + COIN_WIDTH));
	assign coin25_fill = (vCount >= (coin_ypos - 10)) && (vCount <= ((coin_ypos - 10) + COIN_HEIGHT)) && (hCount >= (735 - coin_xpos)) && (hCount <= ((735 - coin_xpos) + COIN_WIDTH));
	
	assign coin26_fill = (vCount >= (coin_ypos + 40)) && (vCount <= ((coin_ypos + 40) + COIN_HEIGHT)) && (hCount >= (365 - coin_xpos)) && (hCount <= ((365 - coin_xpos) + COIN_WIDTH));
	assign coin27_fill = (vCount >= (coin_ypos + 40)) && (vCount <= ((coin_ypos + 40) + COIN_HEIGHT)) && (hCount >= (375 - coin_xpos)) && (hCount <= ((375 - coin_xpos) + COIN_WIDTH));
	assign coin28_fill = (vCount >= (coin_ypos + 40)) && (vCount <= ((coin_ypos + 40) + COIN_HEIGHT)) && (hCount >= (385 - coin_xpos)) && (hCount <= ((385 - coin_xpos) + COIN_WIDTH));
	
	// The position and dimensions of the pipes
	assign pipe_fill = (vCount >= pipe_ypos) && (vCount <= (pipe_ypos + SPRITE_HEIGHT)) && (hCount >= (610 - pipe_xpos)) && (hCount <= ((610 - pipe_xpos) + SPRITE_WIDTH));
	assign pipe_fill_long = (vCount >= pipe_ypos) && (vCount <= (pipe_ypos + SPRITE_HEIGHT)) && (hCount >= (760 - pipe_xpos)) && (hCount <= ((760 - pipe_xpos) + SPRITE_WIDTH));
	assign pipe_fill_3 = (vCount >= pipe_ypos) && (vCount <= (pipe_ypos + SPRITE_HEIGHT)) && (hCount >= (960 - pipe_xpos)) && (hCount <= ((960 - pipe_xpos) + SPRITE_WIDTH));
	
	assign floating_block_fill = (vCount >= cloud_ypos-5) && (vCount <= cloud_ypos+5) && (hCount >= cloud_xpos - 20) && (hCount <= cloud_xpos + 20);
	assign cloud_fill2 = (vCount >= (cloud_ypos - 80)) && (vCount <= (cloud_ypos - 80) + 10) && (hCount >= (cloud_xpos + 120) - 25) && (hCount <= (cloud_xpos + 120) + 25);
	assign cloud_fill3 = (vCount >= (cloud_ypos - 5)) && (vCount <= (cloud_ypos - 5) + 10) && (hCount >= (cloud_xpos + 200) - 15) && (hCount <= (cloud_xpos + 200) + 15);
	assign cloud_fill4 = (vCount >= (cloud_ypos + 40)) && (vCount <= (cloud_ypos + 40) + 10) && (hCount >= (cloud_xpos + 100) - 15) && (hCount <= (cloud_xpos + 100) + 15);
	
	// The position and dimension of the bricks
	assign brick_fill  = (vCount >= (brick_ypos + 60)) && (vCount <= ((brick_ypos + 60) + BRICK_HEIGHT)) && (hCount >= (500 - brick_xpos)) && (hCount <= ((500 - brick_xpos) + BRICK_WIDTH));
	assign brick2_fill = (vCount >= (brick_ypos - 10)) && (vCount <= ((brick_ypos - 10) + BRICK_HEIGHT)) && (hCount >= (700 - brick_xpos)) && (hCount <= ((700 - brick_xpos) + BRICK_WIDTH));
	assign brick3_fill = (vCount >= (brick_ypos - 40)) && (vCount <= ((brick_ypos - 40) + BRICK_HEIGHT)) && (hCount >= (820 - brick_xpos)) && (hCount <= ((820 - brick_xpos) + (BRICK_WIDTH + 80)));
	assign brick4_fill = (vCount >= brick_ypos) && (vCount <= (brick_ypos + BRICK_HEIGHT)) && (hCount >= (950 - brick_xpos)) && (hCount <= ((950 - brick_xpos) + BRICK_WIDTH));
	assign brick5_fill = (vCount >= (brick_ypos - 50)) && (vCount <= ((brick_ypos - 50) + BRICK_HEIGHT)) && (hCount >= (1050 - brick_xpos)) && (hCount <= ((1050 - brick_xpos) + (BRICK_WIDTH - 20)));
	assign brick6_fill  = (vCount >= (brick_ypos + 40)) && (vCount <= ((brick_ypos + 40) + BRICK_HEIGHT)) && (hCount >= (350 - brick_xpos)) && (hCount <= ((350 - brick_xpos) + (BRICK_WIDTH + 60)));
	
	//assign goomba_fill= (vCount >= goomba_ypos) && (vCount <= (goomba_ypos + GOOMBA_HEIGHT)) && (hCount >= goomba_xpos) && (hCount <= (goomba_xpos + GOOMBA_WIDTH));
	assign goomba_fill = (vCount >= (goomba_ypos-10)) && (vCount <= (goomba_ypos + 10)) && (hCount >= (780 - goomba_xpos) - 10) && (hCount <= ((780 - goomba_xpos) + 10));
	
	assign goal_fill = (vCount >= goal_ypos) && (vCount <= (goal_ypos + GOAL_HEIGHT)) && (hCount >= (1250 - goal_xpos)) && (hCount <= ((1250 - goal_xpos) + GOAL_WIDTH));
	assign flag_fill = (vCount >= flag_ypos) && (vCount <= (flag_ypos + FLAG_HEIGHT)) && (hCount >= (1290 - flag_xpos)) && (hCount <= ((1290 - flag_xpos) + FLAG_WIDTH));
	
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//Reinitialize to START state
			state <= START;
		end
		else if (clk) begin
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/
			case (state)
				START:
					begin
						state <= GAME;

						//Initial placement of player
						xpos <= 400; //450
						ypos <= 450; //250
						
						//Initial placement of cloud
						cloud_xpos <= 450;
						cloud_ypos <= 150;
						
						//Placement of floating blocks
						brick_xpos <= 0;
						brick_ypos <= 300;
						
						//Set initial pipe position 
						pipe_xpos <= 0;
						pipe_ypos <= 350; 
						
						//Setting the position of the coin
						coin_xpos <= 0;
						coin_ypos <= 290; 
						
						//Initialize the coin flags
						coin_flag <= 0;
						coin_flag2 <= 0;
						coin_flag3 <= 0;
						coin_flag4 <= 0;
						coin_flag5 <= 0;
						coin_flag6 <= 0;
						coin_flag7 <= 0;
						coin_flag8 <= 0;
						coin_flag9 <= 0;
						coin_flag10 <= 0;
						score <= 0;

						//Set initial values for goomba
						goomba_xpos <= 820;
						goomba_ypos <= 440;
						goomba_flag <= 0;
						health <= 4'b0001;
						
						//Set initial values for goal
						goal_xpos <= 0;
						goal_ypos <= 390;
						
						//Set initial values for flag
						flag_xpos <= 0;
						flag_ypos <= 290;
						
						counter <= 0;
						jump_flag <= 0;
						prevcounter <= 0;
						
						score_flag <= 0;
						coin_count <= 0;
						//count <= 0;
					end
				GAME:
					begin
						if(health == 0)
							state <= LOSE;
						if(xpos == (1290 - flag_xpos))
							state <= WIN;
						//RTL
						cloud_xpos <= cloud_xpos - 1;
						
						if(right) begin
							pipe_xpos <= pipe_xpos + 2;
							brick_xpos <= brick_xpos + 2; 
							coin_xpos <= coin_xpos + 2;
							goal_xpos <= goal_xpos + 2;
							flag_xpos <= flag_xpos + 2;
							goomba_xpos <= goomba_xpos + 2;
							
							//Check for collision
							if((xpos == (610 - pipe_xpos)) && (ypos > pipe_ypos)) //add to left state
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == (760 - pipe_xpos)) && (ypos > pipe_ypos))
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == (960 - pipe_xpos)) && (ypos > pipe_ypos))
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == (1250 - goal_xpos)) && (ypos > goal_ypos))
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == (350 - brick_xpos)) && ((ypos >= (brick_ypos + 40)) && (ypos <= ((brick_ypos + 40) + BRICK_HEIGHT)))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end
							if((xpos == (500 - brick_xpos)) && ((ypos >= (brick_ypos + 60)) && (ypos <= ((brick_ypos + 60) + BRICK_HEIGHT)))) //goal_ypos //(brick_ypos + 60) + BRICK_HEIGHT)
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == (700 - brick_xpos)) && ((ypos >= (brick_ypos - 10)) && (ypos <= ((brick_ypos - 10) + BRICK_HEIGHT)))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end
							if((xpos == (820 - brick_xpos)) && ((ypos >= (brick_ypos - 40)) && (ypos <= ((brick_ypos - 40) + BRICK_HEIGHT)))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == (950 - brick_xpos)) && ((ypos >= (brick_ypos)) && (ypos <= ((brick_ypos) + BRICK_HEIGHT)))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == (1050 - brick_xpos)) && ((ypos >= (brick_ypos - 50)) && (ypos <= ((brick_ypos - 50) + BRICK_HEIGHT)))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end				
						end
						else if(left) begin
						    if (pipe_xpos >= 2)
							    pipe_xpos <= pipe_xpos - 2;
							if (brick_xpos >= 2)
    							brick_xpos <= brick_xpos - 2; 
    						if (coin_xpos >= 2)
						        coin_xpos <= coin_xpos - 2;
							if (goal_xpos >= 2)
						        goal_xpos <= goal_xpos - 2;
							if (flag_xpos >= 2)
						        flag_xpos <= flag_xpos - 2;
							if(goomba_xpos >= 2)
								goomba_xpos <= goomba_xpos - 2;
							
							//Check for collision
							if((xpos == ((610 - pipe_xpos) + SPRITE_WIDTH)) && (ypos > pipe_ypos))
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == ((760 - pipe_xpos) + SPRITE_WIDTH)) && (ypos > pipe_ypos))
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == ((960 - pipe_xpos) + SPRITE_WIDTH)) && (ypos > pipe_ypos))
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == ((1250 - goal_xpos) + GOAL_WIDTH)) && (ypos > goal_ypos))
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == ((350 - brick_xpos)  + BRICK_WIDTH)) && ((ypos >= (brick_ypos + 40)) && (ypos <= ((brick_ypos + 40) + BRICK_HEIGHT)))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end
							if((xpos == ((500 - brick_xpos) + BRICK_WIDTH)) && ((ypos >= (brick_ypos + 60)) && (ypos <= ((brick_ypos + 60) + BRICK_HEIGHT)))) //goal_ypos //(brick_ypos + 60) + BRICK_HEIGHT)
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == ((700 - brick_xpos) + BRICK_WIDTH)) && ((ypos >= (brick_ypos - 10)) && (ypos <= ((brick_ypos - 10) + BRICK_HEIGHT)))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end
							if((xpos == ((820 - brick_xpos) + BRICK_WIDTH)) && ((ypos >= (brick_ypos - 40)) && (ypos <= ((brick_ypos - 40) + BRICK_HEIGHT)))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == ((950 - brick_xpos) + BRICK_WIDTH)) && ((ypos >= (brick_ypos)) && (ypos <= ((brick_ypos) + BRICK_HEIGHT)))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end 
							if((xpos == ((1050 - brick_xpos) + BRICK_WIDTH)) && ((ypos >= (brick_ypos - 50)) && (ypos <= ((brick_ypos - 50) + (BRICK_HEIGHT - 20))))) //see brick_ypos
								begin
									pipe_xpos <= pipe_xpos;
									brick_xpos <= brick_xpos;
									coin_xpos <= coin_xpos;
									goal_xpos <= goal_xpos;
									flag_xpos <= flag_xpos;
								end
						end
						else if(up) begin
							jump_flag = 1;

							if(ypos==34)
								ypos<=514;	
						end
						else if(down) begin
							ypos <= ypos + 2;
							jump_flag = 0;
							
							//Checking for collision
							if(((xpos > (610 - pipe_xpos)) && (xpos < ((610 - pipe_xpos) + SPRITE_WIDTH))) && (ypos == pipe_ypos))
								ypos <= ypos;
							if(((xpos > (760 - pipe_xpos)) && (xpos < ((760 - pipe_xpos) + SPRITE_WIDTH))) && (ypos == pipe_ypos))
								ypos <= ypos;
							if(((xpos > (960 - pipe_xpos)) && (xpos < ((960 - pipe_xpos) + SPRITE_WIDTH))) && (ypos == pipe_ypos))
								ypos <= ypos;
							if(((xpos > (1250 - goal_xpos)) && (xpos < ((1250 - goal_xpos) + GOAL_WIDTH))) && (ypos == goal_ypos))
								ypos <= ypos;
							
							if(((xpos > (350 - brick_xpos)) && (xpos < ((350 - brick_xpos)  + (BRICK_WIDTH + 60)))) && (ypos == (brick_ypos + 40)))
								ypos <= ypos;
							if(((xpos > (500 - brick_xpos)) && (xpos < ((500 - brick_xpos) + BRICK_WIDTH))) && (ypos == (brick_ypos + 60)))
								ypos <= ypos;
							if(((xpos > (700 - brick_xpos)) && (xpos < ((700 - brick_xpos) + BRICK_WIDTH))) && (ypos == (brick_ypos - 10)))
								ypos <= ypos;
							if(((xpos > (820 - brick_xpos)) && (xpos < ((820 - brick_xpos)  + (BRICK_WIDTH + 80)))) && (ypos == (brick_ypos - 40)))
								ypos <= ypos;
							if(((xpos > (950 - brick_xpos)) && (xpos < ((950 - brick_xpos)  + BRICK_WIDTH))) && (ypos == brick_ypos))
								ypos <= ypos;
							if(((xpos > (1050 - brick_xpos)) && (xpos < ((1050 - brick_xpos) + BRICK_WIDTH))) && (ypos == (brick_ypos - 50)))
								ypos <= ypos;
								
							if(ypos > 450)
								ypos <= ypos;
								
							if(ypos==514)
								ypos<=34;		
						end
						
			if (jump_flag == 1 && counter < prevcounter + 128)
                begin 
                    ypos <= ypos - 1;
                    counter = counter + 1;
					if(((xpos > (350 - brick_xpos))  && (xpos < ((350 - brick_xpos)  + (BRICK_WIDTH + 60)))) && (ypos == ((brick_ypos + 40) + BRICK_HEIGHT)))
								ypos <= ypos;
                    if(((xpos > (500 - brick_xpos))  && (xpos < ((500 - brick_xpos)  + BRICK_WIDTH))) && (ypos == ((brick_ypos + 60) + BRICK_HEIGHT)))
								ypos <= ypos;
					if(((xpos > (700 - brick_xpos))  && (xpos < ((700 - brick_xpos)  + BRICK_WIDTH))) && (ypos == ((brick_ypos - 10) + BRICK_HEIGHT)))
								ypos <= ypos;
					if(((xpos > (820 - brick_xpos))  && (xpos < ((820 - brick_xpos)  + (BRICK_WIDTH + 80)))) && (ypos == ((brick_ypos - 40) + BRICK_HEIGHT)))
								ypos <= ypos;
					if(((xpos > (950 - brick_xpos))  && (xpos < ((950 - brick_xpos)  + BRICK_WIDTH))) && (ypos == (brick_ypos + BRICK_HEIGHT)))
								ypos <= ypos;
					if(((xpos > (1050 - brick_xpos)) && (xpos < ((1050 - brick_xpos) + BRICK_WIDTH))) && (ypos == ((brick_ypos - 50) + BRICK_HEIGHT)))
								ypos <= ypos;
                end
            if (counter == prevcounter + 127)
                begin 
                    jump_flag <= 0;
                end
            if (jump_flag == 0 && counter >= 1)
                begin 
                    ypos <= ypos + 1;
                    //counter = counter - 1;
                    if(((xpos > (610 - pipe_xpos)) && (xpos < ((610 - pipe_xpos) + SPRITE_WIDTH))) && (ypos == pipe_ypos))
								begin
									ypos <= ypos;
									prevcounter<= counter;
								end
					else if(((xpos > (760 - pipe_xpos)) && (xpos < ((760 - pipe_xpos) + SPRITE_WIDTH))) && (ypos == pipe_ypos))
								begin
									ypos <= ypos;
									prevcounter<= counter;
								end
					else if(((xpos > (960 - pipe_xpos)) && (xpos < ((960 - pipe_xpos) + SPRITE_WIDTH))) && (ypos == pipe_ypos))
								begin
									ypos <= ypos;
									prevcounter<= counter;
								end
					else if(((xpos > (1250 - goal_xpos)) && (xpos < ((1250 - goal_xpos) + GOAL_WIDTH))) && (ypos <= (goal_ypos + GOAL_HEIGHT)))
								begin
									ypos <= ypos;
									prevcounter<= counter;
								end
								
					else if(((xpos > (350 - brick_xpos)) && (xpos < ((350 - brick_xpos)  + (BRICK_WIDTH + 60)))) && (ypos == (brick_ypos + 40)))
								begin
									ypos <= ypos;
									prevcounter<= counter;
								end		
					else if(((xpos > (500 - brick_xpos)) && (xpos < ((500 - brick_xpos) + BRICK_WIDTH))) && (ypos == (brick_ypos + 60)))
								begin
									ypos <= ypos;
									prevcounter<= counter;
								end
					else if(((xpos > (700 - brick_xpos)) && (xpos < ((700 - brick_xpos) + BRICK_WIDTH))) && (ypos == (brick_ypos - 10)))
								begin
									ypos <= ypos;
									prevcounter<= counter;
								end
					else if(((xpos > (820 - brick_xpos)) && (xpos < ((820 - brick_xpos)  + (BRICK_WIDTH + 80)))) && (ypos == (brick_ypos - 40)))
								begin
									ypos <= ypos;
									prevcounter<= counter;
								end
					else if(((xpos > (950 - brick_xpos))  && (xpos < ((950 - brick_xpos)  + BRICK_WIDTH))) && (ypos == brick_ypos))
								begin
									ypos <= ypos;
									prevcounter<= counter;
								end
					else if(((xpos > (1050 - brick_xpos)) && (xpos < ((1050 - brick_xpos) + BRICK_WIDTH))) && (ypos == (brick_ypos - 50)))
								begin
									ypos <= ypos;
									prevcounter <= counter;
								end
					else 
						counter = counter - 1;
						prevcounter <= counter;
		
					if(ypos > 450)
					begin 
						ypos <= ypos;
						prevcounter <= 0;
					end 
					
                end
					
						//To deal with the movement of goomba
						if(goomba_xpos == (960 - pipe_xpos))
							goomba_flag <= 1;
						if((xpos == goomba_xpos) && (ypos > goomba_ypos))
								health <= health - 1;
							
						if(goomba_flag == 0)
							goomba_xpos <= goomba_xpos + 1;
						else begin
							goomba_xpos <= goomba_xpos - 1;
							if(goomba_xpos == ((760 - pipe_xpos) + SPRITE_WIDTH))
								goomba_flag <= 0;
						end
						
						if(((xpos > (350 - brick_xpos)) && (xpos < ((350 - brick_xpos)  + (BRICK_WIDTH + 60)))) && (ypos == (brick_ypos + 40)))
							begin
								coin_flag10 <= 1;
								score_flag <= 1;
							end
						if(((xpos > (500 - brick_xpos)) && (xpos < ((500 - brick_xpos) + BRICK_WIDTH))) && (ypos == (brick_ypos + 60)))
							begin
								coin_flag <= 1;
								score_flag <= 1;
							end
						if(((xpos > (610 - pipe_xpos)) && (xpos < ((610 - pipe_xpos) + SPRITE_WIDTH))) && (ypos == pipe_ypos))
							begin
								coin_flag2 <= 1;
								score_flag <= 1;
							end
						if((xpos == (760 - pipe_xpos)) && (ypos > pipe_ypos))
							begin
								coin_flag3 <= 1;
								score_flag <= 1;
							end
						if(((xpos > (760 - pipe_xpos)) && (xpos < ((760 - pipe_xpos) + SPRITE_WIDTH))) && (ypos == pipe_ypos))
							begin
								coin_flag4 <= 1;
								//score <= score + 3;
								score_flag <= 1;
							end
						if(((xpos > (820 - brick_xpos)) && (xpos < ((820 - brick_xpos)  + (BRICK_WIDTH + 80)))) && (ypos == (brick_ypos - 40)))
							begin
								coin_flag5 <= 1;
								//score <= score + 3;
								score_flag <= 1;
							end
						if((xpos == (960 - pipe_xpos)) && (ypos > pipe_ypos))
							begin
								coin_flag6 <= 1;
								//score <= score + 3;
								score_flag <= 1;
							end
						if(((xpos > (950 - brick_xpos))  && (xpos < ((950 - brick_xpos)  + BRICK_WIDTH))) && (ypos == brick_ypos))
							begin
								coin_flag7 <= 1;
								//score <= score + 3;
								score_flag <= 1;
							end
						if(((xpos > (1050 - brick_xpos)) && (xpos < ((1050 - brick_xpos) + BRICK_WIDTH))) && (ypos == (brick_ypos - 50)))
							begin
								coin_flag8 <= 1;
								//score <= score + 3;
								score_flag <= 1;
							end
						if(((xpos > (700 - brick_xpos)) && (xpos < ((700 - brick_xpos) + BRICK_WIDTH))) && (ypos == (brick_ypos - 10)))
							begin
								coin_flag9 <= 1;
								//score <= score + 3;
								score_flag <= 1;
							end
							
						if(score_flag == 1)
							begin
								coin_count <= coin_count + 1;
								if(coin_count == 15)
									begin
										score <= score + 10;
										score_flag <= 0;
										coin_count <= 0;
									end
							end
					end
				LOSE:
					begin 
						state <= START;
					end
				WIN:
					begin 
						state <= START;
					end
			endcase
		end
	end
	
	/*always@(posedge clk)
        begin
            if (jump_flag == 1)
                begin 
                    ypos <= ypos - 1;
                    counter <= counter + 1;
                end
            if (counter == 9)
                begin 
                    jump_flag <= 0;
                end
            if (jump_flag == 0 && counter >= 1)
                begin 
                    ypos <= ypos + 1;
                    counter <= counter - 1;
                end
        end*/ 
	
	//the background color reflects the most recent button press
	always@(posedge clk, posedge rst) begin
		if(rst)
			background <= 12'b0000_1111_1111;
		else 
			if(right)
				background <= 12'b0000_1111_1111;
			else if(left)
				background <= 12'b0000_1111_1111;
			else if(down)
				background <= 12'b0000_1111_1111;
			else if(up)
				background <= 12'b0000_1111_1111;
	end

	
	
endmodule
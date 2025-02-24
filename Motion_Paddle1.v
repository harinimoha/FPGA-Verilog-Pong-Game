// The Verilog code for paddle 1 and 2 motion control 

module Motion_Paddle1 (
    input clock,
    input reset,
    input paddle1_up,
    input paddle1_down,
    output reg [15:0] paddle1_Y
);

    // Parameters for paddle dimensions and screen resolution
    parameter SCREEN_HEIGHT = 480;
    parameter PADDLE_HEIGHT = 80;

    always @(posedge clock or posedge reset) 
    begin
        if (reset) 
		begin
            	// Initialize paddle1_Y to the middle of the screen edge to the far left
            	paddle1_Y <= SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2;
        	end 

        else 
        	begin
            	// Update paddle1_Y based on the external input received from player 1 
            	if (paddle1_up && (paddle1_Y < SCREEN_HEIGHT - PADDLE_HEIGHT)) 
		         begin
                	paddle1_Y <= paddle1_Y + 2;  // Following a paddle_up by some number of pixels (eg. 2)
            	end
					
					
            	if (paddle1_down && (paddle1_Y > 0)) 
		         begin
                	paddle1_Y <= paddle1_Y - 2;  // Following a paddle_down input from the user, move the paddle down by some number of pixels (eg. 2)
            	end
        end
    end

endmodule
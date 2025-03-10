module Motion_Paddle2 (
    input clock,
    input reset,
    input paddle2_up,
    input paddle2_down,
    output reg [15:0] paddle2_Y
);

    // Paddle dimensions and screen resolution
    parameter SCREEN_HEIGHT = 480;
    parameter PADDLE_HEIGHT = 80;

    always @(posedge clock or posedge reset)
	 
	 begin
        if (reset) 
	         begin
            // Initialize paddle2_Y to the middle of the screen edge to the far right
            paddle2_Y <= SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2;
            end 
        else 
		  
	         begin
            // Update paddle2_Y based on user input

                 if (paddle2_up && (paddle2_Y < SCREEN_HEIGHT - PADDLE_HEIGHT)) 
				
				     begin
                 paddle2_Y <= paddle2_Y + 2;  // Following a paddle_up by some number of pixels (eg. 2)
                 end

					  
                 if (paddle2_down && (paddle2_Y > 0)) 
					  
	              begin
                 paddle2_Y <= paddle2_Y - 2;  // Following a paddle_down by some number of pixels (eg. 2)
                 end
             end
		  
    end

endmodule
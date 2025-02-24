module CollisionDectection_Paddle1Loss (
    input [15:0] Ball_X,
    input [15:0] Ball_Y,
    input [15:0] Paddle1_Y,
    input wire paddle1_collision, // Signal indicating ball collision with Paddle 1
    output reg [15:0] paddle2_score // Register to store Paddle 2 score
);

    // Parameters for screen resolution
    parameter SCREEN_HEIGHT = 480;

    // Parameters for paddle dimensions
    parameter PADDLE_HEIGHT = 80; 
    parameter MAX_SCORE = 9; // Maximum score

    always @(*) 
	 begin
        // Check if ball collision with Paddle 1 has failed
        if ((Ball_X >= 0) && (Ball_X < 20) &&((Ball_Y < Paddle1_Y) || (Ball_Y >= (Paddle1_Y + PADDLE_HEIGHT)))) 
            begin
            // Update Paddle 2 score, ensuring it does not exceed the maximum score
            if (paddle2_score < MAX_SCORE) 
				begin
                paddle2_score = paddle2_score + 1;
            end
        end
     end

endmodule
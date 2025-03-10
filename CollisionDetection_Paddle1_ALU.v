module CollisionDetection_Paddle1_ALU (
    input [15:0] Ball_X,
    input [15:0] Ball_Y,
    input [15:0] Ball_Vx,
    input [15:0] Ball_Vy,
    input 15:0] Paddle1_Y,
    output reg [15:0] Updated_Ball_Vx,
    output reg [15:0] Updated_Ball_Vy
);

    // Parameters for screen resolution
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;

    // Parameters for paddle and ball dimensions
    parameter PADDLE_WIDTH = 20; // May change, I am not sure. 
    parameter PADDLE_HEIGHT = 80; // May change, I am not sure
    parameter BALL_SIZE = 10; // May change, I am not sure

    always @(*) 
    	begin

        // Initialize updated velocities
        Updated_Ball_Vx = Ball_Vx;
        Updated_Ball_Vy = Ball_Vy;

        // Check for collision with Paddle 1
        if ((Ball_X >= 0) && (Ball_X < PADDLE_WIDTH) && (Ball_Y >= Paddle1_Y) && (Ball_Y < (Paddle1_Y + PADDLE_HEIGHT))) 
            begin
	    // Determining  the subsection of the paddle that was hit
            integer BallSubsection;

            if (Ball_Y < (Paddle1_Y + PADDLE_HEIGHT/3))
                assign BallSubsection = 1;

            else if (Ball_Y < (Paddle1_Y + 2*PADDLE_HEIGHT/3))
                assign BallSubsection = 2;

            else
                assign BallSubsection = 3;

            // Now, let us vary the velocity of the ball based on the section of the paddle that was hit. 

            case(BallSubsection)
                1: 
		          begin
                    // Move diagonally upward with inverted velocity
                    Updated_Ball_Vx = -Ball_Vx;
                    Updated_Ball_Vy = -Ball_Vy;
                end

                2: 
		          begin
                    // Reflect backward in a linear fashion
                    Updated_Ball_Vx = -Ball_Vx;
                    Updated_Ball_Vy = Ball_Vy;
                end
                3: 
		          begin
                    // Move diagonally downward with inverted velocity
                    Updated_Ball_Vx = -Ball_Vx;
                    Updated_Ball_Vy = -Ball_Vy;
                end

                default: 
		          begin
                    Updated_Ball_Vx = 0;
                    Updated_Ball_Vy = 0;
                end

            endcase
        end
    end

endmodule
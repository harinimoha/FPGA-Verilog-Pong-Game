module CollisionDetection_Paddle2_ALU (
    input [15:0] Ball_X,
    input [15:0] Ball_Y,
    input [15:0] Ball_Vx,
    input [15:0] Ball_Vy,
    input [15:0] Paddle2_Y,
    output reg [15:0] Updated_Ball_Vx,
    output reg [15:0] Updated_Ball_Vy
);

    // Parameters for screen resolution
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;

    // Parameters for paddle and ball dimensions
    parameter PADDLE_WIDTH = 20; 
    parameter PADDLE_HEIGHT = 80; 
    parameter BALL_SIZE = 10; 

    always @(*) 
	 begin
	 
        // Initialize updated velocities
        Updated_Ball_Vx = Ball_Vx;
        Updated_Ball_Vy = Ball_Vy;

        // Check for collision with Paddle 2
        if ((Ball_X >= (SCREEN_WIDTH - PADDLE_WIDTH - 2)) && (Ball_X < SCREEN_WIDTH) &&(Ball_Y >= Paddle2_Y) && (Ball_Y < (Paddle2_Y + PADDLE_HEIGHT))) 
            begin
            // Determine the subsection of the paddle that was hit
            integer BallSubsection;

            if (Ball_Y < (Paddle2_Y + PADDLE_HEIGHT/3))
                assign BallSubsection = 1;
					 
            else if (Ball_Y < (Paddle2_Y + 2*PADDLE_HEIGHT/3))
                assign BallSubsection = 2;
					 
            else
                assign BallSubsection = 3;

            // Perform collision response based on the subsection
            case(BallSubsection)
                1: 
                begin
                    // Move diagonally upward towards the top edge of the screen
                    Updated_Ball_Vx = Ball_Vx;
                    Updated_Ball_Vy = -Ball_Vy;
                end
                2: 
                begin
                    // Move diagonally downward towards the bottom edge of the screen
                    Updated_Ball_Vx = Ball_Vx;
                    Updated_Ball_Vy = -Ball_Vy;
                end
                3: 
                begin
                    // Move diagonally linearly opposite towards Paddle 1
                    Updated_Ball_Vx = -Ball_Vx;
                    Updated_Ball_Vy = Ball_Vy;
                end
                default: begin
                    Updated_Ball_Vx = 0;
                    Updated_Ball_Vy = 0;
                end
            endcase
        end
    end

endmodule
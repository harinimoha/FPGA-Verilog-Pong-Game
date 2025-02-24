module Collision_Detection_WallUp_ALU (
    input [15:0] Ball_X,
    input [15:0] Ball_Y,
    input [15:0] Ball_Vx,
    input [15:0] Ball_Vy,
    output reg [15:0] Updated_Ball_Vx,
    output reg [15:0] Updated_Ball_Vy
);

    // Parameters for screen resolution
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;

    // Parameters for ball dimensions
    parameter BALL_SIZE = 10; 

    always @(*)
        begin

        // Initialize updated velocities
        Updated_Ball_Vx = Ball_Vx;
        Updated_Ball_Vy = Ball_Vy;

        // Check for collision with the top wall
        if ((Ball_Y >= SCREEN_HEIGHT - BALL_SIZE) && (Ball_X >= 0) && (Ball_X < SCREEN_WIDTH)) begin

            // Determine the subsection of the ball that hit the top wall
            integer BallSubsection;

            if (Ball_Y < (SCREEN_HEIGHT - BALL_SIZE/2))
                assign BallSubsection = 1;
            else
                assign BallSubsection = 2;

            // Perform collision response based on the subsection of the ball 
            case(BallSubsection)
                1: 
		          begin
                    // Move diagonally downward towards the bottom edge of the screen
                    Updated_Ball_Vx = Ball_Vx;
                    Updated_Ball_Vy = -Ball_Vy;
                end

                2: 
		          begin
                    // Move diagonally upward towards the top edge of the screen
                    Updated_Ball_Vx = Ball_Vx;
                    Updated_Ball_Vy = -Ball_Vy;
                end

                default: begin
                    Updated_Ball_Vx = 0;
                    Updated_Ball_Vy = 0;
                end
            endcase
        end
    end

endmodule
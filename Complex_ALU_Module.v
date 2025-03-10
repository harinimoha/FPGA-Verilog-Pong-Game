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

module Motion_Paddle2 (
    input clock,
    input reset,
    input paddle2_up,
    input paddle2_down,
    output reg [15:0] paddle2_Y
);

    // Parameters for paddle dimensions and screen resolution
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

            if (paddle2_up && (paddle2_Y < SCREEN_HEIGHT - PADDLE_HEIGHT)) begin
                paddle2_Y <= paddle2_Y + 2;  // Following a paddle_up by some number of pixels (eg. 2)

            end

            if (paddle2_down && (paddle2_Y > 0)) 
	begin
                paddle2_Y <= paddle2_Y - 2;  // Following a paddle_down by some number of pixels (eg. 2)
            end
        end
    end

endmodule



module Motion_Ball (
    input clock,
    input reset,
    input start_game,
    input [15:0] paddle1_Y,
    input [15:0] paddle2_Y,
    output reg [15:0] Ball_X,
    output reg [15:0] Ball_Y,
    output reg [15:0] Vx,
    output reg [15:0] Vy
);

    // Parameters for screen resolution, ball size, and initial velocities
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter BALL_SIZE = 10;
    parameter INITIAL_VX = 0;
    parameter INITIAL_VY = 0;

    // These are the states in which the ball directions could be in (six possible directions)
    localparam UP = 3'b000;
    localparam DOWN = 3'b001;
    localparam LEFT_UP = 3'b010;
    localparam LEFT_DOWN = 3'b011;
    localparam RIGHT_UP = 3'b100;
    localparam RIGHT_DOWN = 3'b101;

    // These would temporarily hold updated values for use by the game to ensure that the motion of the ball is continuous. 
    reg [2:0] direction;
    reg [15:0] next_Ball_X;
    reg [15:0] next_Ball_Y;
    reg [15:0] next_Vx;
    reg [15:0] next_Vy;

    always @(posedge clock or posedge reset) 
    begin
        if (reset) 
            begin
            // Initialize ball position and velocities
            Ball_X <= SCREEN_WIDTH / 2 - BALL_SIZE / 2;
            Ball_Y <= SCREEN_HEIGHT / 2 - BALL_SIZE / 2;

            Vx <= INITIAL_VX;
            Vy <= INITIAL_VY;

            direction <= UP;
            end
 
            else if (start_game) 
            begin
            // Updating ball position based on current velocities
            next_Ball_X = Ball_X + Vx;
            next_Ball_Y = Ball_Y + Vy;

            // Checking for collision with paddles and updating velocities

            case (direction)
                UP: begin

                    // Check if the ball collided with the top wall
                    if (next_Ball_Y <= 0) 
                        begin
                        direction <= DOWN; // Collide with upper wall and move downwards
                        end

                    // Check if the ball collided with paddle 1
                    else if ((next_Ball_X <= 20) && (next_Ball_Y >= paddle1_Y) && (next_Ball_Y < paddle1_Y + 80)) 
			begin
                        direction <= RIGHT_DOWN;        // Move diagonally downward towards Paddle 2
                    	end

                    // Check if the ball collided with paddle 2
                    else if ((next_Ball_X >= SCREEN_WIDTH - 20 - BALL_SIZE) && (next_Ball_Y >= paddle2_Y) && (next_Ball_Y < paddle2_Y + 80)) 
			begin
                        direction <= LEFT_DOWN;        // Move diagonally downward towards Paddle 1
                    	end

                     end

                DOWN: 
		    begin
                    // Check if the ball collided with the bottom wall and move upward if it does. 
                    if (next_Ball_Y >= SCREEN_HEIGHT - BALL_SIZE) 
                        begin
                        direction <= UP; // Reflect upward
                        end

                    // Check if the ball collided with paddle 1 
                    else if ((next_Ball_X <= 20) && (next_Ball_Y >= paddle1_Y) && (next_Ball_Y < paddle1_Y + 80)) 
			begin
                        direction <= RIGHT_UP; // Move diagonally upward towards Paddle 2
                        end

                    // Check if the ball collided with paddle 2
                    else if ((next_Ball_X >= SCREEN_WIDTH - 20 - BALL_SIZE) && (next_Ball_Y >= paddle2_Y) && (next_Ball_Y < paddle2_Y + 80))
		        begin
                        direction <= LEFT_UP; // Move diagonally upward towards Paddle 1
                        end
                    end

                LEFT_UP: 
                    begin

                    // Check if the ball collided with Paddle 1
                    if ((next_Ball_X <= 20) && (next_Ball_Y >= paddle1_Y) && (next_Ball_Y < paddle1_Y + 80)) 
                    	begin
                        direction <= RIGHT_UP; // Reflect upward
                    	end

                    // Check if the ball  collided with Paddle 2
                    else if ((next_Ball_X >= SCREEN_WIDTH - 20 - BALL_SIZE) && (next_Ball_Y >= paddle2_Y) && (next_Ball_Y < paddle2_Y + 80)) 
                    	begin
                        direction <= LEFT_UP; // Reflect upward
                    	end

                    // Check if the ball collided with the top wall
                    else if (next_Ball_Y <= 0) 
			begin
                        direction <= LEFT_DOWN; // Move diagonally downward towards Paddle 1
                    	end

                    end

                LEFT_DOWN: 
	            begin
                    // Check if the ball coincided with Paddle 1
                    if ((next_Ball_X <= 20) && (next_Ball_Y >= paddle1_Y) && (next_Ball_Y < paddle1_Y + 80)) begin
                        direction <= RIGHT_DOWN;       // Reflect downward
                    end

                    // Check if paddle coincided with Paddle 2
                    else if ((next_Ball_X >= SCREEN_WIDTH - 20 - BALL_SIZE) && (next_Ball_Y >= paddle2_Y) && (next_Ball_Y < paddle2_Y + 80)) begin
                        direction <= LEFT_DOWN;        // Reflect downward
                    end

                    // Check if paddle coincided with bottom wall
                    else if (next_Ball_Y >= SCREEN_HEIGHT - BALL_SIZE) begin
                        direction <= LEFT_UP;          // Move diagonally upward towards Paddle 1
                    end

                end

                RIGHT_UP: 
                    begin
                    // Check if the ball collided with Paddle 1
                    if ((next_Ball_X <= 20) && (next_Ball_Y >= paddle1_Y) && (next_Ball_Y < paddle1_Y + 80)) begin
                        direction <= RIGHT_UP; // Reflect upward
                    end

                    // Check if the ball collided with Paddle 2
                    else if ((next_Ball_X >= SCREEN_WIDTH - 20 - BALL_SIZE) && (next_Ball_Y >= paddle2_Y) && (next_Ball_Y < paddle2_Y + 80)) begin
                        direction <= LEFT_UP; // Reflect upward
                    end

                    // Check if the ball collided with top wall
                    else if (next_Ball_Y <= 0) begin
                        direction <= RIGHT_DOWN; // Move diagonally downward towards Paddle 2
                    end
                end
                RIGHT_DOWN: begin
                    // Check for collision with Paddle 1
                    if ((next_Ball_X <= 20) && (next_Ball_Y >= paddle1_Y) && (next_Ball_Y < paddle1_Y + 80)) 
		    begin
                        direction <= RIGHT_DOWN; // Reflect downward
                    end

                    // Check for collision with Paddle 2
                    else if ((next_Ball_X >= SCREEN_WIDTH - 20 - BALL_SIZE) && (next_Ball_Y >= paddle2_Y) && (next_Ball_Y < paddle2_Y + 80)) 
                    begin
                        direction <= LEFT_DOWN; // Reflect downward
                    end

                    // Check for collision with bottom wall
                    else if (next_Ball_Y >= SCREEN_HEIGHT - BALL_SIZE) 
		    begin
                        direction <= RIGHT_UP; // Move diagonally upward towards Paddle 2
                    end
                end

                default: 
                    begin
                    	Ball_X <= SCREEN_WIDTH / 2 - BALL_SIZE / 2;
            		Ball_Y <= SCREEN_HEIGHT / 2 - BALL_SIZE / 2;
                    end
            endcase

            // Updated velocities based on new locations 
            case (direction)
                UP: 
                begin
                    next_Vx = 0;
                    next_Vy = -2;
                end

                DOWN: 
                begin
                    next_Vx = 0;
                    next_Vy = 2;
                end

                LEFT_UP: 
                begin
                    next_Vx = -2;
                    next_Vy = -2;
                end

                LEFT_DOWN: 
                begin
                    next_Vx = -2;
                    next_Vy = 2;
                end

                RIGHT_UP: 
                begin
                    next_Vx = 1;
                    next_Vy = -1;
                end

                RIGHT_DOWN: 
		begin
                    next_Vx = 1;
                    next_Vy = 1;
                end

                default: 
                begin
		    next_Vx = 0;
                    next_Vy = 0;   
                end

            endcase

        end

        // Now, the state variable will be updated accordingly as the game runs. 

        Ball_X <= next_Ball_X;
        Ball_Y <= next_Ball_Y;
        Vx <= next_Vx;
        Vy <= next_Vy;

    end

endmodule



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




module Collision_Detection_WallDown_ALU (
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
    parameter BALL_SIZE = 10; // Adjust as needed

    always @(*) 
        begin
        // Initialize updated velocities
        Updated_Ball_Vx = Ball_Vx;
        Updated_Ball_Vy = Ball_Vy;

        // Check for collision with the bottom wall
        if ((Ball_Y <= BALL_SIZE) && (Ball_X >= 0) && (Ball_X < SCREEN_WIDTH)) 
            begin
            // Determine the subsection of the ball that hit the bottom wall
            integer BallSubsection;

            if (Ball_Y > BALL_SIZE/2)
               assign BallSubsection = 1;
            else
               assign BallSubsection = 2;

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

                default: 
                begin
                    Updated_Ball_Vx = 0;
                    Updated_Ball_Vy = 0;
                end
            endcase
        end
    end

endmodule


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

    always @* begin
        // Check if ball collision with Paddle 1 has failed
        if ((Ball_X >= 0) && (Ball_X < 20) &&((Ball_Y < Paddle1_Y) || (Ball_Y >= (Paddle1_Y + PADDLE_HEIGHT)))) 
            begin

            // Update Paddle 2 score, ensuring it does not exceed the maximum score
            if (paddle2_score < MAX_SCORE) begin
                paddle2_score = paddle2_score + 1;
            end
        end
    end

endmodule

module CollisionDectection_Paddle2Loss (
    input [15:0] Ball_X,
    input [15:0] Ball_Y,
    input [15:0] Paddle1_Y,
    input [15:0] Paddle2_Y,
    input wire paddle2_collision, // Signal indicating ball collision with Paddle 2
    output reg [15:0] paddle1_score // Register to store Paddle 1 score
);

    // Parameters for screen resolution
    parameter SCREEN_HEIGHT = 480;

    // Parameters for paddle dimensions
    parameter PADDLE_HEIGHT = 80; // Adjust as needed
    parameter MAX_SCORE = 9; // Maximum score

    always @(*)
        begin

        // Check if ball collision with Paddle 2 has failed
        if ((Ball_X >= SCREEN_WIDTH - 20) && (Ball_X < SCREEN_WIDTH) && ((Ball_Y < Paddle2_Y) || (Ball_Y >= (Paddle2_Y + PADDLE_HEIGHT)))) 
            begin
            // Update Paddle 1 score, ensuring it does not exceed the maximum score

            if (paddle1_score < MAX_SCORE) 
               begin
               paddle1_score = paddle1_score + 1;
            end
        end
    end

endmodule


		
			
	





	

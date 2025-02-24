module CollisionDectection_Paddle2Loss (
    input [15:0] Ball_X,
    input [15:0] Ball_Y,
    input [15:0] Paddle1_Y,
    input [15:0] Paddle2_Y,
    input wire paddle2_collision, // Signal indicating ball collision with Paddle 2. Is it even needed?
    output reg [15:0] paddle1_score // Register to store Paddle 1 score
);

    // Parameters for screen resolution
    parameter SCREEN_HEIGHT = 480;

    // Parameters for paddle dimensions
    parameter PADDLE_HEIGHT = 80; 
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
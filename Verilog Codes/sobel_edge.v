`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

module sobel_core (
    input clk,
    input rst,
    input [7:0] pixel_in,
    input valid_in,
    output reg [7:0] pixel_out,
    output reg valid_out
);

    parameter WIDTH = 512;

    // Line buffers (previous rows)
    reg [7:0] r1 [0:WIDTH-1];
    reg [7:0] r2 [0:WIDTH-1];
    reg [7:0] r3 [0:WIDTH-1];

    // Row / Column counters
    reg [31:0] col;
    reg [31:0] row;

    // Sobel variables
    reg signed [10:0] Gx, Gy;
    reg [10:0] abs_Gx, abs_Gy;
    reg [11:0] G;

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            col <= 0;
            row <= 0;
            pixel_out <= 0;
            valid_out <= 0;

            // Optional buffer reset (
            for (i = 0; i < WIDTH; i = i + 1) begin
                r1[i] <= 0;
                r2[i] <= 0;
                r3[i] <= 0;
            end
        end 
        else if (valid_in) begin

            // Shift rows
            r3[col] <= r2[col];
            r2[col] <= r1[col];
            r1[col] <= pixel_in;

            // Valid Sobel region 
            if (row > 1 && col > 1 && col < WIDTH-1) begin

                // Sobel Gx
                Gx <=  r3[col] - r3[col-2]
                     + ((r2[col] << 1) - (r2[col-2] << 1))
                     +  r1[col] - r1[col-2];

                // Sobel Gy
                Gy <=  r3[col] + (r3[col-1] << 1) + r3[col-2]
                     - r1[col] - (r1[col-1] << 1) - r1[col-2];

                // Absolute values
                abs_Gx <= (Gx < 0) ? -Gx : Gx;
                abs_Gy <= (Gy < 0) ? -Gy : Gy;

                // Magnitude approximation
                G <= abs_Gx + abs_Gy;

                // Clamp output
                if (G > 255)
                    pixel_out <= 8'd255;
                else
                    pixel_out <= G[7:0];

                valid_out <= 1;
            end
            else begin
                pixel_out <= 0;
                valid_out <= 0;
            end

            // Column increment
            if (col == WIDTH-1) begin
                col <= 0;
                row <= row + 1;
            end
            else begin
                col <= col + 1;
            end
        end
        else begin
            valid_out <= 0;
        end
    end

endmodule

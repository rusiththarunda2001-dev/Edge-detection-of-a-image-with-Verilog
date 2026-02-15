`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module sobel_tb;

    parameter WIDTH  = 512;
    parameter HEIGHT = 512;

    reg clk;
    reg rst;
    reg [7:0] pixel_in;
    reg valid_in;

    wire [7:0] pixel_out;
    wire valid_out;

    integer infile, outfile;
    integer scan;
    integer pixel_count;

    // Instantiate DUT
    sobel_core #(.WIDTH(WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .pixel_in(pixel_in),
        .valid_in(valid_in),
        .pixel_out(pixel_out),
        .valid_out(valid_out)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Main stimulus
    initial begin
        pixel_in     = 0;
        valid_in     = 0;
        rst          = 1;
        pixel_count  = 0;

        // Open files
        infile  = $fopen("nature_decimal.txt", "r");
        outfile = $fopen("edge_output.txt", "w");

        if (infile == 0) begin
            $display("? ERROR: Cannot open input file.");
            $finish;
        end

        if (outfile == 0) begin
            $display("? ERROR: Cannot open output file.");
            $finish;
        end

        // Apply reset
        #20;
        rst = 0;

        // Feed pixels
        while (!$feof(infile)) begin
            @(posedge clk);
            scan = $fscanf(infile, "%d\n", pixel_in);
            valid_in = 1;
            pixel_count = pixel_count + 1;
        end

        // Stop input
        @(posedge clk);
        valid_in = 0;

        // Allow pipeline flush
        #2000;

        $display("? Simulation Completed.");
        $display("Total pixels processed = %0d", pixel_count);

        $fclose(infile);
        $fclose(outfile);

        $finish;
    end

    reg valid_d;

    always @(posedge clk) begin
        valid_d <= valid_in;
    end
    
    always @(posedge clk) begin
        if(valid_d) begin
            if(valid_out)
                $fwrite(outfile, "%d\n", pixel_out);
            else
                $fwrite(outfile, "0\n");
        end
    end

endmodule


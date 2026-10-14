`timescale 1ns / 1ps

module tb_sync_fifo;

    // Parameters matching the UUT
    localparam DATA_WIDTH = 8;
    localparam DEPTH_ADDR = 3; // Depth = 8 words for a shorter simulation

    // Inputs
    reg clk;
    reg rst_n;
    reg wr_en;
    reg [DATA_WIDTH-1:0] wr_data;
    reg rd_en;

    // Outputs
    wire full;
    wire [DATA_WIDTH-1:0] rd_data;
    wire empty;

    // Instantiate the Unit Under Test (UUT)
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH_ADDR(DEPTH_ADDR)
    ) uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .wr_en(wr_en), 
        .wr_data(wr_data), 
        .full(full), 
        .rd_en(rd_en), 
        .rd_data(rd_data), 
        .empty(empty)
    );

    // Clock Generation (100MHz)
    always #5 clk = ~clk;

    // Simulation Flow
    initial begin
        // 1. Initialize Inputs
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        wr_data = 0;
        rd_en = 0;

        // 2. Apply Reset
        #20;
        rst_n = 1;
        $display("--- System Reset Released ---");

        // 3. Write Data until Full
        @(posedge clk);
        while (!full) begin
            wr_en = 1;
            wr_data = wr_data + 8'h11; // Increment data pattern
            @(posedge clk);
            $display("Time: %0t | WRITE: Data=%h, Full=%b", $time, wr_data, full);
        end
        wr_en = 0;
        $display("--- FIFO is now FULL ---");

        // 4. Idle for a few clocks
        #30;

        // 5. Read Data until Empty
        @(posedge clk);
        while (!empty) begin
            rd_en = 1;
            @(posedge clk);
            #1; // Slight delay to capture output properly
            $display("Time: %0t | READ : Data=%h, Empty=%b", $time, rd_data, empty);
        end
        rd_en = 0;
        $display("--- FIFO is now EMPTY ---");

        // 6. End Simulation
        #50;
        $finish;
    end

endmodule

`timescale 1ns / 1ps

module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH_ADDR = 4 // Depth = 2^DEPTH_ADDR (16 words)
)(
    input wire clk,
    input wire rst_n,
    
    // Write Interface
    input wire wr_en,
    input wire [DATA_WIDTH-1:0] wr_data,
    output wire full,
    
    // Read Interface
    input wire rd_en,
    output reg [DATA_WIDTH-1:0] rd_data,
    output wire empty
);

    // Memory array
    localparam DEPTH = 1 << DEPTH_ADDR;
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    
    // Pointers and count
    reg [DEPTH_ADDR-1:0] wr_ptr;
    reg [DEPTH_ADDR-1:0] rd_ptr;
    reg [DEPTH_ADDR:0]   count; // Extra bit to represent "full" state properly

    // Status flags
    assign empty = (count == 0);
    assign full  = (count == DEPTH);

    // Sequential Logic: Pointers and Memory operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr  <= 0;
            rd_ptr  <= 0;
            count   <= 0;
            rd_data <= 0;
        end else begin
            // Handling simultaneous Read and Write
            case ({wr_en && !full, rd_en && !empty})
                2'b10: begin // Write only
                    mem[wr_ptr] <= wr_data;
                    wr_ptr      <= wr_ptr + 1;
                    count       <= count + 1;
                end
                2'b01: begin // Read only
                    rd_data <= mem[rd_ptr];
                    rd_ptr  <= rd_ptr + 1;
                    count   <= count - 1;
                end
                2'b11: begin // Write and Read simultaneously
                    mem[wr_ptr] <= wr_data;
                    wr_ptr      <= wr_ptr + 1;
                    rd_data     <= mem[rd_ptr];
                    rd_ptr      <= rd_ptr + 1;
                    // count remains unchanged
                end
                default: ; // Do nothing
            endcase
        end
    end

endmodule

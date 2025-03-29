`timescale 1ns / 1ps

module row_shift(
    input [127:0] state_in,   // Column-major: [Col0, Col1, Col2, Col3]
    output [127:0] state_out  // Shifted rows (still column-major)
);

    // Extract each column (32 bits each)
    wire [31:0] col0, col1, col2, col3;
    assign col0 = state_in[127:96];  // Column 0: [Row0, Row1, Row2, Row3]
    assign col1 = state_in[95:64];   // Column 1: [Row0, Row1, Row2, Row3]
    assign col2 = state_in[63:32];   // Column 2: [Row0, Row1, Row2, Row3]
    assign col3 = state_in[31:0];    // Column 3: [Row0, Row1, Row2, Row3]

    // Reconstruct rows from columns (since we need to shift rows)
    wire [31:0] row0, row1, row2, row3;
    assign row0 = {col0[31:24], col1[31:24], col2[31:24], col3[31:24]};  // Row 0
    assign row1 = {col0[23:16], col1[23:16], col2[23:16], col3[23:16]};  // Row 1
    assign row2 = {col0[15:8],  col1[15:8],  col2[15:8],  col3[15:8]};   // Row 2
    assign row3 = {col0[7:0],   col1[7:0],   col2[7:0],   col3[7:0]};    // Row 3

    // Apply row shifts (now working on actual rows)
    wire [31:0] shifted_row0, shifted_row1, shifted_row2, shifted_row3;
    assign shifted_row0 = row0;                                  // Row 0: No shift
    assign shifted_row1 = {row1[23:0], row1[31:24]};             // Row 1: Left-rotate 1 byte
    assign shifted_row2 = {row2[15:0], row2[31:16]};             // Row 2: Left-rotate 2 bytes
    assign shifted_row3 = {row3[7:0],  row3[31:8]};              // Row 3: Left-rotate 3 bytes

    // Reconstruct columns from shifted rows (back to column-major)
    assign state_out[127:96] = {shifted_row0[31:24], shifted_row1[31:24], shifted_row2[31:24], shifted_row3[31:24]};  // Col0
    assign state_out[95:64]  = {shifted_row0[23:16], shifted_row1[23:16], shifted_row2[23:16], shifted_row3[23:16]};  // Col1
    assign state_out[63:32]  = {shifted_row0[15:8],  shifted_row1[15:8],  shifted_row2[15:8],  shifted_row3[15:8]};   // Col2
    assign state_out[31:0]   = {shifted_row0[7:0],   shifted_row1[7:0],   shifted_row2[7:0],   shifted_row3[7:0]};    // Col3

endmodule

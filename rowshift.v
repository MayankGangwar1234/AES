`timescale 1ns / 1ps

module row_shift(
    input [127:0] state_in,   
    output [127:0] state_out  
);

    wire [31:0] row_0, row_1, row_2, row_3;
    
    assign row_0 = state_in[127:96];  
    assign row_1 = state_in[95:64];  
    assign row_2 = state_in[63:32];   
    assign row_3 = state_in[31:0];    

    assign state_out[127:96]   = row_0;                  
    assign state_out[95:64]    = {row_1[23:0], row_1[31:24]}; 
    assign state_out[63:32]    = {row_2[15:0], row_2[31:16]}; 
    assign state_out[31:0]     = {row_3[7:0], row_3[31:8]};   

endmodule

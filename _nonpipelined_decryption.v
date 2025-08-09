// Code your design here
`timescale 1ns / 1ps
module inv_shift_rows(
    input [127:0] state_in,
    output [127:0] state_out
);
    // Extract columns
    wire [31:0] col0, col1, col2, col3;
    assign col0 = state_in[127:96];
    assign col1 = state_in[95:64];
    assign col2 = state_in[63:32];
    assign col3 = state_in[31:0];

    // Reconstruct rows
    wire [31:0] row0, row1, row2, row3;
    assign row0 = {col0[31:24], col1[31:24], col2[31:24], col3[31:24]};
    assign row1 = {col0[23:16], col1[23:16], col2[23:16], col3[23:16]};
    assign row2 = {col0[15:8],  col1[15:8],  col2[15:8],  col3[15:8]};
    assign row3 = {col0[7:0],   col1[7:0],   col2[7:0],   col3[7:0]};

    // Apply inverse shifts (right rotations)
    wire [31:0] inv_shifted_row0, inv_shifted_row1, inv_shifted_row2, inv_shifted_row3;
    assign inv_shifted_row0 = row0;                                  // No shift
    assign inv_shifted_row1 = {row1[7:0], row1[31:8]};               // Right-rotate 1 byte
    assign inv_shifted_row2 = {row2[15:0], row2[31:16]};             // Right-rotate 2 bytes
    assign inv_shifted_row3 = {row3[23:0], row3[31:24]};             // Right-rotate 3 bytes

    // Reconstruct columns
    assign state_out[127:96] = {inv_shifted_row0[31:24], inv_shifted_row1[31:24], inv_shifted_row2[31:24], inv_shifted_row3[31:24]};
    assign state_out[95:64]  = {inv_shifted_row0[23:16], inv_shifted_row1[23:16], inv_shifted_row2[23:16], inv_shifted_row3[23:16]};
    assign state_out[63:32]  = {inv_shifted_row0[15:8],  inv_shifted_row1[15:8],  inv_shifted_row2[15:8],  inv_shifted_row3[15:8]};
    assign state_out[31:0]   = {inv_shifted_row0[7:0],   inv_shifted_row1[7:0],   inv_shifted_row2[7:0],   inv_shifted_row3[7:0]};
endmodule

module inv_sub_bytes(
    input  [127:0] state_in,
    output [127:0] state_out
);
    // Complete Inverse S-Box
    reg [7:0] inv_sbox [0:255];
    
    initial begin
        inv_sbox[8'h00] = 8'h52; inv_sbox[8'h01] = 8'h09; inv_sbox[8'h02] = 8'h6a; inv_sbox[8'h03] = 8'hd5;
        inv_sbox[8'h04] = 8'h30; inv_sbox[8'h05] = 8'h36; inv_sbox[8'h06] = 8'ha5; inv_sbox[8'h07] = 8'h38;
        inv_sbox[8'h08] = 8'hbf; inv_sbox[8'h09] = 8'h40; inv_sbox[8'h0a] = 8'ha3; inv_sbox[8'h0b] = 8'h9e;
        inv_sbox[8'h0c] = 8'h81; inv_sbox[8'h0d] = 8'hf3; inv_sbox[8'h0e] = 8'hd7; inv_sbox[8'h0f] = 8'hfb;
        
        inv_sbox[8'h10] = 8'h7c; inv_sbox[8'h11] = 8'he3; inv_sbox[8'h12] = 8'h39; inv_sbox[8'h13] = 8'h82;
        inv_sbox[8'h14] = 8'h9b; inv_sbox[8'h15] = 8'h2f; inv_sbox[8'h16] = 8'hff; inv_sbox[8'h17] = 8'h87;
        inv_sbox[8'h18] = 8'h34; inv_sbox[8'h19] = 8'h8e; inv_sbox[8'h1a] = 8'h43; inv_sbox[8'h1b] = 8'h44;
        inv_sbox[8'h1c] = 8'hc4; inv_sbox[8'h1d] = 8'hde; inv_sbox[8'h1e] = 8'he9; inv_sbox[8'h1f] = 8'hcb;
        
        inv_sbox[8'h20] = 8'h54; inv_sbox[8'h21] = 8'h7b; inv_sbox[8'h22] = 8'h94; inv_sbox[8'h23] = 8'h32;
        inv_sbox[8'h24] = 8'ha6; inv_sbox[8'h25] = 8'hc2; inv_sbox[8'h26] = 8'h23; inv_sbox[8'h27] = 8'h3d;
        inv_sbox[8'h28] = 8'hee; inv_sbox[8'h29] = 8'h4c; inv_sbox[8'h2a] = 8'h95; inv_sbox[8'h2b] = 8'h0b;
        inv_sbox[8'h2c] = 8'h42; inv_sbox[8'h2d] = 8'hfa; inv_sbox[8'h2e] = 8'hc3; inv_sbox[8'h2f] = 8'h4e;
        
        inv_sbox[8'h30] = 8'h08; inv_sbox[8'h31] = 8'h2e; inv_sbox[8'h32] = 8'ha1; inv_sbox[8'h33] = 8'h66;
        inv_sbox[8'h34] = 8'h28; inv_sbox[8'h35] = 8'hd9; inv_sbox[8'h36] = 8'h24; inv_sbox[8'h37] = 8'hb2;
        inv_sbox[8'h38] = 8'h76; inv_sbox[8'h39] = 8'h5b; inv_sbox[8'h3a] = 8'ha2; inv_sbox[8'h3b] = 8'h49;
        inv_sbox[8'h3c] = 8'h6d; inv_sbox[8'h3d] = 8'h8b; inv_sbox[8'h3e] = 8'hd1; inv_sbox[8'h3f] = 8'h25;
        
        inv_sbox[8'h40] = 8'h72; inv_sbox[8'h41] = 8'hf8; inv_sbox[8'h42] = 8'hf6; inv_sbox[8'h43] = 8'h64;
        inv_sbox[8'h44] = 8'h86; inv_sbox[8'h45] = 8'h68; inv_sbox[8'h46] = 8'h98; inv_sbox[8'h47] = 8'h16;
        inv_sbox[8'h48] = 8'hd4; inv_sbox[8'h49] = 8'ha4; inv_sbox[8'h4a] = 8'h5c; inv_sbox[8'h4b] = 8'hcc;
        inv_sbox[8'h4c] = 8'h5d; inv_sbox[8'h4d] = 8'h65; inv_sbox[8'h4e] = 8'hb6; inv_sbox[8'h4f] = 8'h92;
        
        inv_sbox[8'h50] = 8'h6c; inv_sbox[8'h51] = 8'h70; inv_sbox[8'h52] = 8'h48; inv_sbox[8'h53] = 8'h50;
        inv_sbox[8'h54] = 8'hfd; inv_sbox[8'h55] = 8'hed; inv_sbox[8'h56] = 8'hb9; inv_sbox[8'h57] = 8'hda;
        inv_sbox[8'h58] = 8'h5e; inv_sbox[8'h59] = 8'h15; inv_sbox[8'h5a] = 8'h46; inv_sbox[8'h5b] = 8'h57;
        inv_sbox[8'h5c] = 8'ha7; inv_sbox[8'h5d] = 8'h8d; inv_sbox[8'h5e] = 8'h9d; inv_sbox[8'h5f] = 8'h84;
        
        inv_sbox[8'h60] = 8'h90; inv_sbox[8'h61] = 8'hd8; inv_sbox[8'h62] = 8'hab; inv_sbox[8'h63] = 8'h00;
        inv_sbox[8'h64] = 8'h8c; inv_sbox[8'h65] = 8'hbc; inv_sbox[8'h66] = 8'hd3; inv_sbox[8'h67] = 8'h0a;
        inv_sbox[8'h68] = 8'hf7; inv_sbox[8'h69] = 8'he4; inv_sbox[8'h6a] = 8'h58; inv_sbox[8'h6b] = 8'h05;
        inv_sbox[8'h6c] = 8'hb8; inv_sbox[8'h6d] = 8'hb3; inv_sbox[8'h6e] = 8'h45; inv_sbox[8'h6f] = 8'h06;
        
        inv_sbox[8'h70] = 8'hd0; inv_sbox[8'h71] = 8'h2c; inv_sbox[8'h72] = 8'h1e; inv_sbox[8'h73] = 8'h8f;
        inv_sbox[8'h74] = 8'hca; inv_sbox[8'h75] = 8'h3f; inv_sbox[8'h76] = 8'h0f; inv_sbox[8'h77] = 8'h02;
        inv_sbox[8'h78] = 8'hc1; inv_sbox[8'h79] = 8'haf; inv_sbox[8'h7a] = 8'hbd; inv_sbox[8'h7b] = 8'h03;
        inv_sbox[8'h7c] = 8'h01; inv_sbox[8'h7d] = 8'h13; inv_sbox[8'h7e] = 8'h8a; inv_sbox[8'h7f] = 8'h6b;
        
        inv_sbox[8'h80] = 8'h3a; inv_sbox[8'h81] = 8'h91; inv_sbox[8'h82] = 8'h11; inv_sbox[8'h83] = 8'h41;
        inv_sbox[8'h84] = 8'h4f; inv_sbox[8'h85] = 8'h67; inv_sbox[8'h86] = 8'hdc; inv_sbox[8'h87] = 8'hea;
        inv_sbox[8'h88] = 8'h97; inv_sbox[8'h89] = 8'hf2; inv_sbox[8'h8a] = 8'hcf; inv_sbox[8'h8b] = 8'hce;
        inv_sbox[8'h8c] = 8'hf0; inv_sbox[8'h8d] = 8'hb4; inv_sbox[8'h8e] = 8'he6; inv_sbox[8'h8f] = 8'h73;
        
        inv_sbox[8'h90] = 8'h96; inv_sbox[8'h91] = 8'hac; inv_sbox[8'h92] = 8'h74; inv_sbox[8'h93] = 8'h22;
        inv_sbox[8'h94] = 8'he7; inv_sbox[8'h95] = 8'had; inv_sbox[8'h96] = 8'h35; inv_sbox[8'h97] = 8'h85;
        inv_sbox[8'h98] = 8'he2; inv_sbox[8'h99] = 8'hf9; inv_sbox[8'h9a] = 8'h37; inv_sbox[8'h9b] = 8'he8;
        inv_sbox[8'h9c] = 8'h1c; inv_sbox[8'h9d] = 8'h75; inv_sbox[8'h9e] = 8'hdf; inv_sbox[8'h9f] = 8'h6e;
        
        inv_sbox[8'ha0] = 8'h47; inv_sbox[8'ha1] = 8'hf1; inv_sbox[8'ha2] = 8'h1a; inv_sbox[8'ha3] = 8'h71;
        inv_sbox[8'ha4] = 8'h1d; inv_sbox[8'ha5] = 8'h29; inv_sbox[8'ha6] = 8'hc5; inv_sbox[8'ha7] = 8'h89;
        inv_sbox[8'ha8] = 8'h6f; inv_sbox[8'ha9] = 8'hb7; inv_sbox[8'haa] = 8'h62; inv_sbox[8'hab] = 8'h0e;
        inv_sbox[8'hac] = 8'haa; inv_sbox[8'had] = 8'h18; inv_sbox[8'hae] = 8'hbe; inv_sbox[8'haf] = 8'h1b;
        
        inv_sbox[8'hb0] = 8'hfc; inv_sbox[8'hb1] = 8'h56; inv_sbox[8'hb2] = 8'h3e; inv_sbox[8'hb3] = 8'h4b;
        inv_sbox[8'hb4] = 8'hc6; inv_sbox[8'hb5] = 8'hd2; inv_sbox[8'hb6] = 8'h79; inv_sbox[8'hb7] = 8'h20;
        inv_sbox[8'hb8] = 8'h9a; inv_sbox[8'hb9] = 8'hdb; inv_sbox[8'hba] = 8'hc0; inv_sbox[8'hbb] = 8'hfe;
        inv_sbox[8'hbc] = 8'h78; inv_sbox[8'hbd] = 8'hcd; inv_sbox[8'hbe] = 8'h5a; inv_sbox[8'hbf] = 8'hf4;
        
        inv_sbox[8'hc0] = 8'h1f; inv_sbox[8'hc1] = 8'hdd; inv_sbox[8'hc2] = 8'ha8; inv_sbox[8'hc3] = 8'h33;
        inv_sbox[8'hc4] = 8'h88; inv_sbox[8'hc5] = 8'h07; inv_sbox[8'hc6] = 8'hc7; inv_sbox[8'hc7] = 8'h31;
        inv_sbox[8'hc8] = 8'hb1; inv_sbox[8'hc9] = 8'h12; inv_sbox[8'hca] = 8'h10; inv_sbox[8'hcb] = 8'h59;
        inv_sbox[8'hcc] = 8'h27; inv_sbox[8'hcd] = 8'h80; inv_sbox[8'hce] = 8'hec; inv_sbox[8'hcf] = 8'h5f;
        
        inv_sbox[8'hd0] = 8'h60; inv_sbox[8'hd1] = 8'h51; inv_sbox[8'hd2] = 8'h7f; inv_sbox[8'hd3] = 8'ha9;
        inv_sbox[8'hd4] = 8'h19; inv_sbox[8'hd5] = 8'hb5; inv_sbox[8'hd6] = 8'h4a; inv_sbox[8'hd7] = 8'h0d;
        inv_sbox[8'hd8] = 8'h2d; inv_sbox[8'hd9] = 8'he5; inv_sbox[8'hda] = 8'h7a; inv_sbox[8'hdb] = 8'h9f;
        inv_sbox[8'hdc] = 8'h93; inv_sbox[8'hdd] = 8'hc9; inv_sbox[8'hde] = 8'h9c; inv_sbox[8'hdf] = 8'hef;
        
        inv_sbox[8'he0] = 8'ha0; inv_sbox[8'he1] = 8'he0; inv_sbox[8'he2] = 8'h3b; inv_sbox[8'he3] = 8'h4d;
        inv_sbox[8'he4] = 8'hae; inv_sbox[8'he5] = 8'h2a; inv_sbox[8'he6] = 8'hf5; inv_sbox[8'he7] = 8'hb0;
        inv_sbox[8'he8] = 8'hc8; inv_sbox[8'he9] = 8'heb; inv_sbox[8'hea] = 8'hbb; inv_sbox[8'heb] = 8'h3c;
        inv_sbox[8'hec] = 8'h83; inv_sbox[8'hed] = 8'h53; inv_sbox[8'hee] = 8'h99; inv_sbox[8'hef] = 8'h61;
        
        inv_sbox[8'hf0] = 8'h17; inv_sbox[8'hf1] = 8'h2b; inv_sbox[8'hf2] = 8'h04; inv_sbox[8'hf3] = 8'h7e;
        inv_sbox[8'hf4] = 8'hba; inv_sbox[8'hf5] = 8'h77; inv_sbox[8'hf6] = 8'hd6; inv_sbox[8'hf7] = 8'h26;
        inv_sbox[8'hf8] = 8'he1; inv_sbox[8'hf9] = 8'h69; inv_sbox[8'hfa] = 8'h14; inv_sbox[8'hfb] = 8'h63;
        inv_sbox[8'hfc] = 8'h55; inv_sbox[8'hfd] = 8'h21; inv_sbox[8'hfe] = 8'h0c; inv_sbox[8'hff] = 8'h7d;
    end
    
    // Perform inverse substitution on each byte
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : inv_sub_bytes_loop
            assign state_out[(i*8) +: 8] = inv_sbox[state_in[(i*8) +: 8]];
        end
    endgenerate
endmodule

module aes_sbox (
    input wire [7:0] data_in,      // 8-bit input (16x16 = 256 possible values)
    output reg [7:0] data_out      // 8-bit substituted output
);
    // S-Box substitution values (from AES standard)
    // Stored as a 1D array of 256 8-bit values
    reg [7:0] sbox [0:255];

    // Initialize the S-Box with substitution values
    initial begin
        sbox[8'h00] = 8'h63; sbox[8'h01] = 8'h7c; sbox[8'h02] = 8'h77; sbox[8'h03] = 8'h7b;
        sbox[8'h04] = 8'hf2; sbox[8'h05] = 8'h6b; sbox[8'h06] = 8'h6f; sbox[8'h07] = 8'hc5;
        sbox[8'h08] = 8'h30; sbox[8'h09] = 8'h01; sbox[8'h0a] = 8'h67; sbox[8'h0b] = 8'h2b;
        sbox[8'h0c] = 8'hfe; sbox[8'h0d] = 8'hd7; sbox[8'h0e] = 8'hab; sbox[8'h0f] = 8'h76;
        
        sbox[8'h10] = 8'hca; sbox[8'h11] = 8'h82; sbox[8'h12] = 8'hc9; sbox[8'h13] = 8'h7d;
        sbox[8'h14] = 8'hfa; sbox[8'h15] = 8'h59; sbox[8'h16] = 8'h47; sbox[8'h17] = 8'hf0;
        sbox[8'h18] = 8'had; sbox[8'h19] = 8'hd4; sbox[8'h1a] = 8'ha2; sbox[8'h1b] = 8'haf;
        sbox[8'h1c] = 8'h9c; sbox[8'h1d] = 8'ha4; sbox[8'h1e] = 8'h72; sbox[8'h1f] = 8'hc0;
        
        sbox[8'h20] = 8'hb7; sbox[8'h21] = 8'hfd; sbox[8'h22] = 8'h93; sbox[8'h23] = 8'h26;
        sbox[8'h24] = 8'h36; sbox[8'h25] = 8'h3f; sbox[8'h26] = 8'hf7; sbox[8'h27] = 8'hcc;
        sbox[8'h28] = 8'h34; sbox[8'h29] = 8'ha5; sbox[8'h2a] = 8'he5; sbox[8'h2b] = 8'hf1;
        sbox[8'h2c] = 8'h71; sbox[8'h2d] = 8'hd8; sbox[8'h2e] = 8'h31; sbox[8'h2f] = 8'h15;
        
        sbox[8'h30] = 8'h04; sbox[8'h31] = 8'hc7; sbox[8'h32] = 8'h23; sbox[8'h33] = 8'hc3;
        sbox[8'h34] = 8'h18; sbox[8'h35] = 8'h96; sbox[8'h36] = 8'h05; sbox[8'h37] = 8'h9a;
        sbox[8'h38] = 8'h07; sbox[8'h39] = 8'h12; sbox[8'h3a] = 8'h80; sbox[8'h3b] = 8'he2;
        sbox[8'h3c] = 8'heb; sbox[8'h3d] = 8'h27; sbox[8'h3e] = 8'hb2; sbox[8'h3f] = 8'h75;
        
        sbox[8'h40] = 8'h09; sbox[8'h41] = 8'h83; sbox[8'h42] = 8'h2c; sbox[8'h43] = 8'h1a;
        sbox[8'h44] = 8'h1b; sbox[8'h45] = 8'h6e; sbox[8'h46] = 8'h5a; sbox[8'h47] = 8'ha0;
        sbox[8'h48] = 8'h52; sbox[8'h49] = 8'h3b; sbox[8'h4a] = 8'hd6; sbox[8'h4b] = 8'hb3;
        sbox[8'h4c] = 8'h29; sbox[8'h4d] = 8'he3; sbox[8'h4e] = 8'h2f; sbox[8'h4f] = 8'h84;
        
        sbox[8'h50] = 8'h53; sbox[8'h51] = 8'hd1; sbox[8'h52] = 8'h00; sbox[8'h53] = 8'hed;
        sbox[8'h54] = 8'h20; sbox[8'h55] = 8'hfc; sbox[8'h56] = 8'hb1; sbox[8'h57] = 8'h5b;
        sbox[8'h58] = 8'h6a; sbox[8'h59] = 8'hcb; sbox[8'h5a] = 8'hbe; sbox[8'h5b] = 8'h39;
        sbox[8'h5c] = 8'h4a; sbox[8'h5d] = 8'h4c; sbox[8'h5e] = 8'h58; sbox[8'h5f] = 8'hcf;
        
        sbox[8'h60] = 8'hd0; sbox[8'h61] = 8'hef; sbox[8'h62] = 8'haa; sbox[8'h63] = 8'hfb;
        sbox[8'h64] = 8'h43; sbox[8'h65] = 8'h4d; sbox[8'h66] = 8'h33; sbox[8'h67] = 8'h85;
        sbox[8'h68] = 8'h45; sbox[8'h69] = 8'hf9; sbox[8'h6a] = 8'h02; sbox[8'h6b] = 8'h7f;
        sbox[8'h6c] = 8'h50; sbox[8'h6d] = 8'h3c; sbox[8'h6e] = 8'h9f; sbox[8'h6f] = 8'ha8;
        
        sbox[8'h70] = 8'h51; sbox[8'h71] = 8'ha3; sbox[8'h72] = 8'h40; sbox[8'h73] = 8'h8f;
        sbox[8'h74] = 8'h92; sbox[8'h75] = 8'h9d; sbox[8'h76] = 8'h38; sbox[8'h77] = 8'hf5;
        sbox[8'h78] = 8'hbc; sbox[8'h79] = 8'hb6; sbox[8'h7a] = 8'hda; sbox[8'h7b] = 8'h21;
        sbox[8'h7c] = 8'h10; sbox[8'h7d] = 8'hff; sbox[8'h7e] = 8'hf3; sbox[8'h7f] = 8'hd2;
        
        sbox[8'h80] = 8'hcd; sbox[8'h81] = 8'h0c; sbox[8'h82] = 8'h13; sbox[8'h83] = 8'hec;
        sbox[8'h84] = 8'h5f; sbox[8'h85] = 8'h97; sbox[8'h86] = 8'h44; sbox[8'h87] = 8'h17;
        sbox[8'h88] = 8'hc4; sbox[8'h89] = 8'ha7; sbox[8'h8a] = 8'h7e; sbox[8'h8b] = 8'h3d;
        sbox[8'h8c] = 8'h64; sbox[8'h8d] = 8'h5d; sbox[8'h8e] = 8'h19; sbox[8'h8f] = 8'h73;
        
        sbox[8'h90] = 8'h60; sbox[8'h91] = 8'h81; sbox[8'h92] = 8'h4f; sbox[8'h93] = 8'hdc;
        sbox[8'h94] = 8'h22; sbox[8'h95] = 8'h2a; sbox[8'h96] = 8'h90; sbox[8'h97] = 8'h88;
        sbox[8'h98] = 8'h46; sbox[8'h99] = 8'hee; sbox[8'h9a] = 8'hb8; sbox[8'h9b] = 8'h14;
        sbox[8'h9c] = 8'hde; sbox[8'h9d] = 8'h5e; sbox[8'h9e] = 8'h0b; sbox[8'h9f] = 8'hdb;
        
        sbox[8'ha0] = 8'he0; sbox[8'ha1] = 8'h32; sbox[8'ha2] = 8'h3a; sbox[8'ha3] = 8'h0a;
        sbox[8'ha4] = 8'h49; sbox[8'ha5] = 8'h06; sbox[8'ha6] = 8'h24; sbox[8'ha7] = 8'h5c;
        sbox[8'ha8] = 8'hc2; sbox[8'ha9] = 8'hd3; sbox[8'haa] = 8'hac; sbox[8'hab] = 8'h62;
        sbox[8'hac] = 8'h91; sbox[8'had] = 8'h95; sbox[8'hae] = 8'he4; sbox[8'haf] = 8'h79;
        
        sbox[8'hb0] = 8'he7; sbox[8'hb1] = 8'hc8; sbox[8'hb2] = 8'h37; sbox[8'hb3] = 8'h6d;
        sbox[8'hb4] = 8'h8d; sbox[8'hb5] = 8'hd5; sbox[8'hb6] = 8'h4e; sbox[8'hb7] = 8'ha9;
        sbox[8'hb8] = 8'h6c; sbox[8'hb9] = 8'h56; sbox[8'hba] = 8'hf4; sbox[8'hbb] = 8'hea;
        sbox[8'hbc] = 8'h65; sbox[8'hbd] = 8'h7a; sbox[8'hbe] = 8'hae; sbox[8'hbf] = 8'h08;
        
        sbox[8'hc0] = 8'hba; sbox[8'hc1] = 8'h78; sbox[8'hc2] = 8'h25; sbox[8'hc3] = 8'h2e;
        sbox[8'hc4] = 8'h1c; sbox[8'hc5] = 8'ha6; sbox[8'hc6] = 8'hb4; sbox[8'hc7] = 8'hc6;
        sbox[8'hc8] = 8'he8; sbox[8'hc9] = 8'hdd; sbox[8'hca] = 8'h74; sbox[8'hcb] = 8'h1f;
        sbox[8'hcc] = 8'h4b; sbox[8'hcd] = 8'hbd; sbox[8'hce] = 8'h8b; sbox[8'hcf] = 8'h8a;
        
        sbox[8'hd0] = 8'h70; sbox[8'hd1] = 8'h3e; sbox[8'hd2] = 8'hb5; sbox[8'hd3] = 8'h66;
        sbox[8'hd4] = 8'h48; sbox[8'hd5] = 8'h03; sbox[8'hd6] = 8'hf6; sbox[8'hd7] = 8'h0e;
        sbox[8'hd8] = 8'h61; sbox[8'hd9] = 8'h35; sbox[8'hda] = 8'h57; sbox[8'hdb] = 8'hb9;
        sbox[8'hdc] = 8'h86; sbox[8'hdd] = 8'hc1; sbox[8'hde] = 8'h1d; sbox[8'hdf] = 8'h9e;
        
        sbox[8'he0] = 8'he1; sbox[8'he1] = 8'hf8; sbox[8'he2] = 8'h98; sbox[8'he3] = 8'h11;
        sbox[8'he4] = 8'h69; sbox[8'he5] = 8'hd9; sbox[8'he6] = 8'h8e; sbox[8'he7] = 8'h94;
        sbox[8'he8] = 8'h9b; sbox[8'he9] = 8'h1e; sbox[8'hea] = 8'h87; sbox[8'heb] = 8'he9;
        sbox[8'hec] = 8'hce; sbox[8'hed] = 8'h55; sbox[8'hee] = 8'h28; sbox[8'hef] = 8'hdf;
        
        sbox[8'hf0] = 8'h8c; sbox[8'hf1] = 8'ha1; sbox[8'hf2] = 8'h89; sbox[8'hf3] = 8'h0d;
        sbox[8'hf4] = 8'hbf; sbox[8'hf5] = 8'he6; sbox[8'hf6] = 8'h42; sbox[8'hf7] = 8'h68;
        sbox[8'hf8] = 8'h41; sbox[8'hf9] = 8'h99; sbox[8'hfa] = 8'h2d; sbox[8'hfb] = 8'h0f;
        sbox[8'hfc] = 8'hb0; sbox[8'hfd] = 8'h54; sbox[8'hfe] = 8'hbb; sbox[8'hff] = 8'h16;
    end

    // Perform the substitution
    always @(*) begin
        data_out = sbox[data_in];
    end

endmodule


module inv_mix_columns (
    input [127:0] state_in,  
    output [127:0] state_out
);
    // First define the basic multiply by 2 (xtime) function
    function [7:0] gf_mul2;
        input [7:0] b;
        begin
            gf_mul2 = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
        end
    endfunction

    // Then build the other multiplications using gf_mul2
    function [7:0] gf_mul9;  // Multiply by 0x09 (x^3 + 1)
        input [7:0] b;
        reg [7:0] temp;
        begin
            temp = gf_mul2(gf_mul2(gf_mul2(b)));  // Multiply by 8 (three xtimes)
            gf_mul9 = temp ^ b;                    // Then add original (8+1=9)
        end
    endfunction

    function [7:0] gf_mulb;  // Multiply by 0x0B (x^3 + x + 1)
        input [7:0] b;
        reg [7:0] temp1, temp2;
        begin
            temp1 = gf_mul2(gf_mul2(gf_mul2(b)));  // Multiply by 8
            temp2 = gf_mul2(b);                    // Multiply by 2
            gf_mulb = temp1 ^ temp2 ^ b;            // 8 + 2 + 1 = 11 (0x0B)
        end
    endfunction

    function [7:0] gf_muld;  // Multiply by 0x0D (x^3 + x^2 + 1)
        input [7:0] b;
        reg [7:0] temp1, temp2;
        begin
            temp1 = gf_mul2(gf_mul2(gf_mul2(b)));  // Multiply by 8
            temp2 = gf_mul2(gf_mul2(b));           // Multiply by 4
            gf_muld = temp1 ^ temp2 ^ b;           // 8 + 4 + 1 = 13 (0x0D)
        end
    endfunction

    function [7:0] gf_mule;  // Multiply by 0x0E (x^3 + x^2 + x)
        input [7:0] b;
        reg [7:0] temp1, temp2, temp3;
        begin
            temp1 = gf_mul2(gf_mul2(gf_mul2(b)));  // Multiply by 8
            temp2 = gf_mul2(gf_mul2(b));           // Multiply by 4
            temp3 = gf_mul2(b);                    // Multiply by 2
            gf_mule = temp1 ^ temp2 ^ temp3;       // 8 + 4 + 2 = 14 (0x0E)
        end
    endfunction

    // Process each column (same as before)
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : inv_mix_column
            wire [7:0] b0 = state_in[127-32*i -: 8];  
            wire [7:0] b1 = state_in[127-32*i-8 -: 8]; 
            wire [7:0] b2 = state_in[127-32*i-16 -: 8]; 
            wire [7:0] b3 = state_in[127-32*i-24 -: 8]; 
            
            wire [7:0] new_b0 = gf_mule(b0) ^ gf_mulb(b1) ^ gf_muld(b2) ^ gf_mul9(b3);
            wire [7:0] new_b1 = gf_mul9(b0) ^ gf_mule(b1) ^ gf_mulb(b2) ^ gf_muld(b3);
            wire [7:0] new_b2 = gf_muld(b0) ^ gf_mul9(b1) ^ gf_mule(b2) ^ gf_mulb(b3);
            wire [7:0] new_b3 = gf_mulb(b0) ^ gf_muld(b1) ^ gf_mul9(b2) ^ gf_mule(b3);
            
            assign state_out[127-32*i -: 8] = new_b0;
            assign state_out[127-32*i-8 -: 8] = new_b1;
            assign state_out[127-32*i-16 -: 8] = new_b2;
            assign state_out[127-32*i-24 -: 8] = new_b3;
        end
    endgenerate
endmodule


module g(input [31:0] w, input [3:0] round, output [31:0] g_op);
  wire [31:0] RC[0:10];
  wire [7:0] sb0, sb1, sb2, sb3;  // Fixed: was sbo
  
  assign RC[4'h0] = 32'h00000000; 
  assign RC[4'h1] = 32'h01000000; assign RC[4'h2] = 32'h02000000;
  assign RC[4'h3] = 32'h04000000; assign RC[4'h4] = 32'h08000000;
  assign RC[4'h5] = 32'h10000000; assign RC[4'h6] = 32'h20000000;
  assign RC[4'h7] = 32'h40000000; assign RC[4'h8] = 32'h80000000;
  assign RC[4'h9] = 32'h1B000000; assign RC[4'ha] = 32'h36000000;
  
  aes_sbox aa(.data_in(w[23:16]), .data_out(sb0));
  aes_sbox bb(.data_in(w[15:8]), .data_out(sb1));
  aes_sbox cc(.data_in(w[7:0]), .data_out(sb2));
  aes_sbox dc(.data_in(w[31:24]), .data_out(sb3));
  
  assign g_op = {sb0, sb1, sb2, sb3} ^ RC[round];
endmodule


module key_expansion(input[127:0] key, output reg [127:0] op_key0,output reg [127:0] op_key1,output reg [127:0] op_key2,output reg [127:0] op_key3,output reg [127:0] op_key4,output reg [127:0] op_key5,output reg [127:0] op_key6,output reg [127:0] op_key7,output reg [127:0] op_key8,output reg [127:0] op_key9,output reg [127:0] op_key10);
  wire [31:0] w0,w1,w2,w3;
  assign {w0,w1,w2,w3} = key;
  
  // Round 1
  wire [31:0] g_1;
  g a(.w(w3), .round(4'd1), .g_op(g_1));
  wire [31:0] w4,w5,w6,w7;
  assign w4 = w0 ^ g_1;
  assign w5 = w4 ^ w1;
  assign w6 = w5 ^ w2;
  assign w7 = w6 ^ w3;
  
  // Round 2
  wire [31:0] g_2;
  g b(.w(w7), .round(4'd2), .g_op(g_2));
  wire [31:0] w8,w9,w10,w11;
  assign w8 = w4 ^ g_2;
  assign w9 = w8 ^ w5;
  assign w10 = w9 ^ w6;
  assign w11 = w10 ^ w7;
  
  // Round 3
  wire [31:0] g_3;
  g c(.w(w11), .round(4'd3), .g_op(g_3));
  wire [31:0] w12,w13,w14,w15;
  assign w12 = w8 ^ g_3;
  assign w13 = w12 ^ w9;
  assign w14 = w13 ^ w10;
  assign w15 = w14 ^ w11;
  
  // Round 4
  wire [31:0] g_4;
  g d(.w(w15), .round(4'd4), .g_op(g_4));
  wire [31:0] w16,w17,w18,w19;
  assign w16 = w12 ^ g_4;
  assign w17 = w16 ^ w13;
  assign w18 = w17 ^ w14;
  assign w19 = w18 ^ w15;
  
  // Round 5
  wire [31:0] g_5;
  g e(.w(w19), .round(4'd5), .g_op(g_5));
  wire [31:0] w20,w21,w22,w23;
  assign w20 = w16 ^ g_5;
  assign w21 = w20 ^ w17;
  assign w22 = w21 ^ w18;
  assign w23 = w22 ^ w19;
  
  // Round 6
  wire [31:0] g_6;
  g f(.w(w23), .round(4'd6), .g_op(g_6));
  wire [31:0] w24,w25,w26,w27;
  assign w24 = w20 ^ g_6;
  assign w25 = w24 ^ w21;
  assign w26 = w25 ^ w22;
  assign w27 = w26 ^ w23;
  
  // Round 7
  wire [31:0] g_7;
  g h(.w(w27), .round(4'd7), .g_op(g_7));
  wire [31:0] w28,w29,w30,w31;
  assign w28 = w24 ^ g_7;
  assign w29 = w28 ^ w25;
  assign w30 = w29 ^ w26;
  assign w31 = w30 ^ w27;
  
  // Round 8
  wire [31:0] g_8;
  g i(.w(w31), .round(4'd8), .g_op(g_8));
  wire [31:0] w32,w33,w34,w35;
  assign w32 = w28 ^ g_8;
  assign w33 = w32 ^ w29;
  assign w34 = w33 ^ w30;  // Fixed: was w17^w30
  assign w35 = w34 ^ w31;  // Fixed: was w18^w31
  
  // Round 9
  wire [31:0] g_9;
  g j(.w(w35), .round(4'd9), .g_op(g_9));
  wire [31:0] w36,w37,w38,w39;
  assign w36 = w32 ^ g_9;
  assign w37 = w36 ^ w33;
  assign w38 = w37 ^ w34;
  assign w39 = w38 ^ w35;
  
  // Round 10
  wire [31:0] g_10;
  g k(.w(w39), .round(4'd10), .g_op(g_10));
  wire [31:0] w40,w41,w42,w43;
  assign w40 = w36 ^ g_10;  // Fixed: was g_8
  assign w41 = w40 ^ w37;
  assign w42 = w41 ^ w38;
  assign w43 = w42 ^ w39;
  
  always @(*) begin
    
      op_key0 = {w0,w1,w2,w3};
      op_key1 = {w4,w5,w6,w7};
      op_key2 = {w8,w9,w10,w11};
      op_key3 = {w12,w13,w14,w15};
      op_key4 = {w16,w17,w18,w19};
      op_key5 = {w20,w21,w22,w23};
      op_key6 = {w24,w25,w26,w27};
      op_key7 = {w28,w29,w30,w31};
      op_key8 = {w32,w33,w34,w35};
      op_key9 = {w36,w37,w38,w39};
      op_key10 = {w40,w41,w42,w43};
      
    
  end
endmodule

module add_round_key(input[127:0] state_in,input[127:0] key,output [127:0] state_out);
  
  
  //xor of expanded key with input state
  assign state_out=state_in^key;
endmodule

module main_module_decrypt(
    input [127:0] ciphertext,
    input [127:0] key,
    output [127:0] plaintext
);
    // Internal signals for round processing
    wire [127:0] round_keys [0:10];
    wire [127:0] state [0:10];
   
    // Generate all round keys
  key_expansion ky(.key(key), .op_key0(round_keys[0]), .op_key1(round_keys[1]), .op_key2(round_keys[2]), .op_key3(round_keys[3]), .op_key4(round_keys[4]), .op_key5(round_keys[5]), .op_key6(round_keys[6]), .op_key7(round_keys[7]), .op_key8(round_keys[8]), .op_key9(round_keys[9]), .op_key10(round_keys[10]));
  
    
    // Initial round (Round 10)
    
  add_round_key ark0(
    .state_in(ciphertext),
    .key(round_keys[10]),
        .state_out(state[0])
    );
    genvar i;
    // 9 main rounds (Round 9 to 1)
    generate
        for (i = 1; i <= 9; i = i + 1) begin : MAIN_ROUNDS
            wire [127:0] inv_shifted, inv_subbed, mixed;
            
            // Inverse ShiftRows
            inv_shift_rows isr(
                .state_in(state[i-1]),
                .state_out(inv_shifted)
            );
            
            // Inverse SubBytes
            inv_sub_bytes isb(
                .state_in(inv_shifted),
                .state_out(inv_subbed)
            );
            
            // AddRoundKey
            
          add_round_key ark2(
            .state_in(inv_subbed),
            .key(round_keys[10-i]),
            .state_out(mixed)
    );
            
            // Inverse MixColumns
            inv_mix_columns imc(
                .state_in(mixed),
                .state_out(state[i])
            );
        end
    endgenerate
    
    // Final round (Round 0)
    wire [127:0] final_inv_shifted, final_inv_subbed;
    
    // Inverse ShiftRows
    inv_shift_rows isr_final(
        .state_in(state[9]),
        .state_out(final_inv_shifted)
    );
    
    // Inverse SubBytes
    inv_sub_bytes isb_final(
        .state_in(final_inv_shifted),
        .state_out(final_inv_subbed)
    );
    
    // AddRoundKey
    
  add_round_key ark2(
    .state_in(final_inv_subbed),
      .key(round_keys[0]),
    .state_out(plaintext)
    );
endmodule



module aes_inv_sbox (
    input wire [7:0] data_in,      // 8-bit input
    output reg [7:0] data_out      // 8-bit substituted output
);
    // Inverse S-Box substitution values (from AES standard)
    reg [7:0] inv_sbox [0:255];

    // Initialize the Inverse S-Box with substitution values
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

    // Perform the inverse substitution
    always @(*) begin
        data_out = inv_sbox[data_in];
    end

endmodule

module invsb(
    input  [127:0] state_in,
    output [127:0] state_out
);
    
    wire [7:0] sbox_inv_out[15:0];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : sub_bytes_loop
          aes_inv_sbox sbox_inv_inst (
                .data_in(state_in[(i*8) +: 8]),
                .data_out(sbox_inv_out[i])
            );
            assign state_out[(i*8) +: 8] = sbox_inv_out[i];
        end
    endgenerate

endmodule

module inv_shift_rows(
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
    assign shifted_row1 = {row1[7:0], row1[31:8]};             // Row 1: Left-rotate 1 byte
    assign shifted_row2 = {row2[15:0], row2[31:16]};             // Row 2: Left-rotate 2 bytes
    assign shifted_row3 = {row3[23:0],  row3[31:24]};              // Row 3: Left-rotate 3 bytes

    // Reconstruct columns from shifted rows (back to column-major)
    assign state_out[127:96] = {shifted_row0[31:24], shifted_row1[31:24], shifted_row2[31:24], shifted_row3[31:24]};  // Col0
    assign state_out[95:64]  = {shifted_row0[23:16], shifted_row1[23:16], shifted_row2[23:16], shifted_row3[23:16]};  // Col1
    assign state_out[63:32]  = {shifted_row0[15:8],  shifted_row1[15:8],  shifted_row2[15:8],  shifted_row3[15:8]};   // Col2
    assign state_out[31:0]   = {shifted_row0[7:0],   shifted_row1[7:0],   shifted_row2[7:0],   shifted_row3[7:0]};    // Col3

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

module add_round_key(input[127:0] state_in,input[127:0] main_key,input [3:0] round,output [127:0] state_out);

  //generation of expanded key for perticular round
  wire [127:0] round_key;
  key_expansion a(.key(main_key),.round(round),.op_key(round_key));
  
  //xor of expanded key with input state
  assign state_out=state_in^round_key;
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
  
  aes_inv_sbox aa(.data_in(w[23:16]), .data_out(sb0));
  aes_inv_sbox bb(.data_in(w[15:8]), .data_out(sb1));
  aes_inv_sbox cc(.data_in(w[7:0]), .data_out(sb2));
  aes_inv_sbox dc(.data_in(w[31:24]), .data_out(sb3));
  
  assign g_op = {sb0, sb1, sb2, sb3} ^ RC[round];
endmodule


module key_expansion(input[127:0] key, input [3:0] round, output reg [127:0] op_key);
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
    case (round)
      4'd0 : op_key = {w0,w1,w2,w3};
      4'd1 : op_key = {w4,w5,w6,w7};
      4'd2 : op_key = {w8,w9,w10,w11};
      4'd3 : op_key = {w12,w13,w14,w15};
      4'd4 : op_key = {w16,w17,w18,w19};
      4'd5 : op_key = {w20,w21,w22,w23};
      4'd6 : op_key = {w24,w25,w26,w27};
      4'd7 : op_key = {w28,w29,w30,w31};
      4'd8 : op_key = {w32,w33,w34,w35};
      4'd9 : op_key = {w36,w37,w38,w39};
      4'd10: op_key = {w40,w41,w42,w43};
      default: op_key = 128'b0;
    endcase
  end
endmodule

module inverse_cipher(
    input [127:0] ciphertext,
    input [127:0] key,
    output [127:0] plaintext
);
    // Internal signals for round processing
    wire [127:0] round_keys [0:10];
    wire [127:0] state [0:10];
    
    // Generate all round keys
    genvar i;
    generate
        for (i = 0; i <= 10; i = i + 1) begin : KEY_EXPANSION
            key_expansion ke(.key(key), .round(i), .op_key(round_keys[i]));
        end
    endgenerate
    
    // Initial round (Round 10)
    add_round_key ark0(
        .state_in(ciphertext),
        .main_key(key),
        .round(4'd10),
        .state_out(state[0])
    );
    
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
            invsb isb(
                .state_in(inv_shifted),
                .state_out(inv_subbed)
            );
            
            // AddRoundKey
            add_round_key ark(
                .state_in(inv_subbed),
                .main_key(key),
                .round(10-i),
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
    invsb isb_final(
        .state_in(final_inv_shifted),
        .state_out(final_inv_subbed)
    );
    
    // AddRoundKey
    add_round_key ark_final(
        .state_in(final_inv_subbed),
        .main_key(key),
        .round(4'd0),
        .state_out(plaintext)
    );
endmodule

// Inverse SubBytes module with complete S-Box

    // Perform inverse substitution on each byte
   


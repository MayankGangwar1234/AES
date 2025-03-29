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


module key_expansion(input[127:0] key, input [3:0] round, output reg [127:0] op_key);
  wire [31:0] w0,w1,w2,w3;
  assign {w0,w1,w2,w3} = key;
  
  // Round 1
  wire [31:0] g_1;
  g a(.w(w3), .round(4'd1), .g_op(g_1));
  reg [31:0] w4,w5,w6,w7;
  assign w4 = w0 ^ g_1;
  assign w5 = w4 ^ w1;
  assign w6 = w5 ^ w2;
  assign w7 = w6 ^ w3;
  
  // Round 2
  wire [31:0] g_2;
  g b(.w(w7), .round(4'd2), .g_op(g_2));
  reg [31:0] w8,w9,w10,w11;
  assign w8 = w4 ^ g_2;
  assign w9 = w8 ^ w5;
  assign w10 = w9 ^ w6;
  assign w11 = w10 ^ w7;
  
  // Round 3
  wire [31:0] g_3;
  g c(.w(w11), .round(4'd3), .g_op(g_3));
  reg [31:0] w12,w13,w14,w15;
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

module mixcolumns (
    input [127:0] state_in,  
    output [127:0] state_out
);
    // GF multiplication functions 
    function [7:0] gf_mul2;
        input [7:0] b;
        begin
            gf_mul2 = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});  //exor with 0x1b to handle overflow
        end
    endfunction

    function [7:0] gf_mul3;
        input [7:0] b;
        begin
            gf_mul3 = gf_mul2(b) ^ b;
        end
    endfunction

    // Process each column
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : mix_column
            // Extract column i 
            wire [7:0] b0 = state_in[(127-32*i) : (127-32*i)-7];  
            wire [7:0] b1 = state_in[(127-32*i)-8 : (127-32*i)-15];  
            wire [7:0] b2 = state_in[(127-32*i)-16 : (127-32*i)-23];  
            wire [7:0] b3 = state_in[(127-32*i)-24 : (127-32*i)-31]; 
            
            // MixColumns transformation
            wire [7:0] new_b0 = gf_mul2(b0) ^ gf_mul3(b1) ^ b2 ^ b3;
            wire [7:0] new_b1 = b0 ^ gf_mul2(b1) ^ gf_mul3(b2) ^ b3;
            wire [7:0] new_b2 = b0 ^ b1 ^ gf_mul2(b2) ^ gf_mul3(b3);
            wire [7:0] new_b3 = gf_mul3(b0) ^ b1 ^ b2 ^ gf_mul2(b3);
            
            // Assign output (column-major order)
            assign state_out[(127-32*i) : (127-32*i)-7] = new_b0;
            assign state_out[(127-32*i)-8 : (127-32*i)-15] = new_b1;
            assign state_out[(127-32*i)-16 : (127-32*i)-23] = new_b2;
            assign state_out[(127-32*i)-24 : (127-32*i)-31] = new_b3;
        end
    endgenerate
endmodule

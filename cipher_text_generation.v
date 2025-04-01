 module cipher_text_generation(
    input [127:0] plaintext,
    input [127:0] key,
    output [127:0] ciphertext
);
    // Internal signals for round processing
    wire [127:0] round_keys [0:10];
    wire [127:0] state [0:10];
    
    // Generate all round keys
  key_expansion ky(.key(key), .op_key0(round_keys[0]), .op_key1(round_keys[1]), .op_key2(round_keys[2]), .op_key3(round_keys[3]), .op_key4(round_keys[4]), .op_key5(round_keys[5]), .op_key6(round_keys[6]), .op_key7(round_keys[7]), .op_key8(round_keys[8]), .op_key9(round_keys[9]), .op_key10(round_keys[10]));
    
    // Initial round (Round 0) - just AddRoundKey
    add_round_key ark0(
        .state_in(plaintext),
      .key(round_keys[0]),
        .state_out(state[0])
    );
    genvar i;
    // 9 main rounds (Round 1 to 9)
    generate
        for (i = 1; i <= 9; i = i + 1) begin : MAIN_ROUNDS
            wire [127:0] subbed, shifted, mixed;
            
            // SubBytes
            aes_sub_bytes sb(
                .state_in(state[i-1]),
                .state_out(subbed)
            );
            
            // ShiftRows
            row_shift sr(
                .state_in(subbed),
                .state_out(shifted)
            );
            
            // MixColumns
            mixcolumns mc(
                .state_in(shifted),
                .state_out(mixed)
            );
            
            // AddRoundKey
            add_round_key ark(
                .state_in(mixed),
              .key(round_keys[i]),
                .state_out(state[i])
            );
        end
    endgenerate
    
    // Final round (Round 10) - no MixColumns
    wire [127:0] final_subbed, final_shifted;
    
    // SubBytes
    aes_sub_bytes sb_final(
        .state_in(state[9]),
        .state_out(final_subbed)
    );
    
    // ShiftRows
    row_shift sr_final(
        .state_in(final_subbed),
        .state_out(final_shifted)
    );
    
    // AddRoundKey
    add_round_key ark_final(
        .state_in(final_shifted),
      .key(round_keys[10]),
        .state_out(ciphertext)
    );
    
endmodule

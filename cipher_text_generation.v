module cipher_text_generation(
    input [127:0] plaintext,
    input [127:0] key,
    output [127:0] ciphertext
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
    
    // Initial round (Round 0) - just AddRoundKey
    add_round_key ark0(
        .state_in(plaintext),
        .main_key(key),
        .round(4'd0),
        .state_out(state[0])
    );
    
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
                .main_key(key),
                .round(i),
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
        .main_key(key),
        .round(4'd10),
        .state_out(ciphertext)
    );
    
endmodule

module aes_sub_bytes(
    input  [127:0] state_in,
    output [127:0] state_out
);
    
    wire [7:0] sbox_out[15:0];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : sub_bytes_loop
          aes_sbox sbox_inst (
                .data_in(state_in[(i*8) +: 8]),
                .data_out(sbox_out[i])
            );
            assign state_out[(i*8) +: 8] = sbox_out[i];
        end
    endgenerate

endmodule

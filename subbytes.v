module aes_sub_bytes(
    input  [127:0] state_in,
    output [127:0] state_out
);
    
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : sub_bytes_loop
          aes_sbox sbox_inst (
              .data_in(state_in[(8*i)+7: 8*i]),
              .data_out(state_out[(8*i)+7: 8*i])
            );
        end
    endgenerate

endmodule

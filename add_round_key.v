module add_round_key(input[127:0] state_in,input[127:0] key,output [127:0] state_out);
  
  //xor of expanded key with input state
  assign state_out=state_in^key;
endmodule

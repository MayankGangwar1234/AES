module add_round_key(input[127:0] state_in,input[127:0] main_key,input [3:0] round,output [127:0] state_out);
  
  reg [127:0] round_key;
  key_expansion a(.key(main_key),.round(round),.op_key(round_key));
  
  assign state_out=state_in^round_key;
endmodule

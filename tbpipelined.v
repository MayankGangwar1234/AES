`timescale 1ns / 1ns

module aes_cipher_tb();

    // Inputs
    reg [127:0] plaintext;
    reg [127:0] key;
    reg clk;
    reg reset;
    reg valid_in;
    
    // Output
    wire valid_output;
    wire [127:0] ciphertext;
    
    // Instantiate the Unit Under Test (UUT)
    cipher_text_generation uut (
        .plaintext(plaintext),
        .key(key),
        .clk(clk),
        .valid_in(valid_in),
        .reset(reset),
        .valid_output(valid_output),
        .ciphertext(ciphertext)
    );
    
    // Clock generation (100MHz)
    always begin
        #10 clk = ~clk;
    end
    
    // Test cases
    initial begin
        // Initialize Inputs
        clk = 0;
        plaintext = 0;
        key = 0;
        reset = 0;
        valid_in = 1;
        
        // Wait for global reset
       
        
        //------------------------------------------------------------------
        // Test Case 1: NIST FIPS-197 Example (Appendix B)
        //------------------------------------------------------------------
        $display("\n[%0t] Test Case 1: NIST FIPS-197 Appendix B Example", $time);
        plaintext = 128'h3243f6a8885a308d313198a2e0370734;
        key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        
     
        
        $display("Plaintext: %h", plaintext);
        $display("Key:       %h", key);
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   3925841d02dc09fbdc118597196a0b32");
        $display("Result:    %s", (ciphertext === 128'h3925841d02dc09fbdc118597196a0b32) ? "PASS" : "FAIL");
        
        //------------------------------------------------------------------
        // Test Case 2: All Zeros
        //------------------------------------------------------------------
        #15;
        $display("\n[%0t] Test Case 2: All Zeros Input", $time);
        plaintext = 128'h00000000000000000000000000000000;
        key = 128'h00000000000000000000000000000000;
        
       
        
        $display("Plaintext: %h", plaintext);
        $display("Key:       %h", key);
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   66e94bd4ef8a2c3b884cfa59ca342b2e");
        $display("Result:    %s", (ciphertext === 128'h66e94bd4ef8a2c3b884cfa59ca342b2e) ? "PASS" : "FAIL");
        
        //------------------------------------------------------------------
        // Test Case 3: All Ones
        //------------------------------------------------------------------
        #17;
        $display("\n[%0t] Test Case 3: All Ones Input", $time);
        plaintext = 128'hffffffffffffffffffffffffffffffff;
        key = 128'hffffffffffffffffffffffffffffffff;
        
       
        
        $display("Plaintext: %h", plaintext);
        $display("Key:       %h", key);
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   d6ef5264e78ae67a5f1eab29f1e078c0");
        $display("Result:    %s", (ciphertext === 128'hd6ef5264e78ae67a5f1eab29f1e078c0) ? "PASS" : "FAIL");
        
        //------------------------------------------------------------------
        // Test Case 4: Random Test Vector
        //------------------------------------------------------------------
        #42
        $display("\n[%0t] Test Case 4: Random Test Vector", $time);
        plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;
        key = 128'h603deb1015ca71be2b73aef0857d7781;
        
        
        
        $display("Plaintext: %h", plaintext);
        $display("Key:       %h", key);
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   f3eed1bdb5d2a03c064b5a7e3db181f8");
        $display("Result:    %s", (ciphertext === 128'hf3eed1bdb5d2a03c064b5a7e3db181f8) ? "PASS" : "FAIL");
        
        
        
        // End simulation
        #100;
        reset = 1;
         $display("Ciphertext: %h", ciphertext);
        #25
        reset = 0;
        $display("\n[%0t] Test Case 5: Random Test Vector", $time);
        plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;
        key = 128'h603deb1015ca71be2b73aef0857d7781;
        
        
        
        $display("Plaintext: %h", plaintext);
        $display("Key:       %h", key);
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   f3eed1bdb5d2a03c064b5a7e3db181f8");
        $display("\n[%0t] Simulation Complete", $time);
        
        #33
        valid_in=1'b0;
        #33;
        valid_in=1'b1;
        
        #200
        $finish;
    end
    
 
    
endmodule

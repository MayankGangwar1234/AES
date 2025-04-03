`timescale 1ns / 1ps

module tb_aes_decrypt();

    reg clk;
    reg reset;
    reg valid_in;
    reg [127:0] ciphertext;
    reg [127:0] key;
    wire valid_output;
    wire [127:0] plaintext;
    
    // Instantiate the DUT
    main_module_decrypt dut (
        .ciphertext(ciphertext),
        .key(key),
        .reset(reset),
        .clk(clk),
        .valid_in(valid_in),
        .valid_output(valid_output),
        .plaintext(plaintext)
    );
    
    // Clock generation
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        valid_in = 0;
        ciphertext = 128'h0;
        key = 128'h0;
        
        // Apply reset
        #10;
        reset = 0;
        
        // Set test values
        #10;
        ciphertext = 128'hc7d12419489e3b6233a2c5a7f4563172; // Ciphertext
        key = 128'h0; // All zeros key
        valid_in = 1;
        
        // Wait for processing
        #200;
        
        // Display results
        $display("Ciphertext: %h", ciphertext);
        $display("Key: %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Valid output: %b", valid_output);
        
        // Expected plaintext (from your comment)
        if (plaintext === 128'h00000101030307070f0f1f1f3f3f7f7f) begin
            $display("Test PASSED - Plaintext matches expected value");
        end else begin
            $display("Test FAILED - Plaintext does not match expected value");
            $display("Expected: 00000101030307070f0f1f1f3f3f7f7f");
        end
        
        $finish;
    end
    
endmodule

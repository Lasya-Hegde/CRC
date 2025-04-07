`timescale 1ns / 1ps

module crc_tb;

    // Parameters
    parameter m = 5; // Length of G (10011 has 5 bits)
    parameter n = 14; // Length of D (longest D is 14 bits)

    // Inputs
    reg clk;
    reg reset;
    reg start;
    reg [n-1:0] data_in;
    reg [m-1:0] G;

    // Outputs
    wire error;
    wire done;
    wire [1:0] new;
    
    // Instantiate the Unit Under Test (UUT)
    crc #(m, n) uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .G(G),
        .error(error),
        .done(done),
        .new(new)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 ns clock period

    // Test cases
    reg [n-1:0] test_data[0:2];  // Array to store D inputs
    reg [m-1:0] test_gen;        // Generator polynomial G
    integer i;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        start = 0;

        // Define test cases
        test_data[0] = 14'b10010101010100; // i) First D value
        test_data[1] = 14'b01011010101111; // ii) Second D value
        test_data[2] = 14'b10101010100100; // iii) Third D value
        test_gen = 5'b10011;              // G = 10011

        // Apply reset
       

        // Run all test cases
        for (i = 0; i < 3; i = i + 1) begin
            // Set inputs
            data_in = test_data[i];
            G = test_gen;
 #10;
        reset = 1;
        #10;
        reset = 0;
            // Start CRC operation
            start = 1;
            #10;
            start = 0;

            // Wait for the operation to complete
            wait(done);

            // Display the results
            $display("Test Case %0d:", i + 1);
            $display("D = %b, G = %b", test_data[i], test_gen);
            $display("Actual Error = %b", error);

            // Apply a reset between test cases
            #10;
            reset = 1;
            #10;
            reset = 0;
        end

        // End simulation
        $stop;
    end

endmodule

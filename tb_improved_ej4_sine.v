`timescale 1ns / 1ps

module tb_improved_ej4_sine();

    // Parameters
    `define NBinput     32
    `define NBoutput    64
    
    // Instantiate DUT
    ej4 #(
        .NBinput    (`NBinput),
        .NBoutput   (`NBoutput),
        .b0         (1),
        .b1         (-1),
        .b2         (1),
        .b3         (1),
        .a0         (1)
    ) DUT (
        .X          (X),
        .clk        (clk),
        .rst_n      (rst_n),
        .Y          (Y)
    );

    // Clock generator
    reg clk;
    always #5 clk = ~clk;
    
    // Reset generator
    reg rst_n;
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end
    
    // Input signal generator
    reg signed [`NBinput-1:0] X;
    integer i;
    real amplitude = 10;
    real freq = 100;
    real t;
    initial begin
        X = 0;
        for(i = 0; i < 500; i = i + 1) begin
            t = i * 1.0 / freq;
            X = amplitude * sin(2.0 * $pi * freq * t);
            #1;
        end
    end
    
    // Output monitor
    wire signed [`NBoutput-1:0] Y;
    reg signed [`NBoutput-1:0] Y_buf [0:499];
    integer j;
    initial begin
        #550;
        $display("Simulation complete. Displaying output.");
        for(j = 0; j < 500; j = j + 1) begin
            Y_buf[j] = Y;
            #1;
        end
        $dumpfile("tb_ej4.vcd");
        $dumpvars(0, tb_ej4);
        $display("Output data dumped to tb_ej4.vcd");
        $finish;
    end

endmodule

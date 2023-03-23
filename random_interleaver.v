module random_interleaver(
    input        [N - 1 : 0]    data_in,
    input                       clock,
    output reg   [N - 1 : 0]    data_out,
    output reg                  done
    );

    parameter                        NB = 1024;          // Data size
    reg         [31             : 0] seed = 123456789;   // Random number generator seed
    reg         [$clog2(NB) - 1 : 0] index;
    reg                              interleaver_done;   // flag
    reg         [N - 1          : 0] counter = 0;        // data_in index
    reg         [N - 1          : 0] used_index;         // boolean vector for non-repeated index checking

initial begin
    used_index = {N{1'b0}};                     // begin with all 0s
end

always @(posedge clock) begin

    if (!interleaver_done) begin
        index = $random(seed) % N;              // Generate random index
        if (used_index[index]) begin            // check if index was already used
            index = $random % N;                // if it was already used generate new index
        end
        used_index[index] = 1'b1;               // mark index as already used
        data_out[index]   <= data_in[counter];  // Move input data bit to random output position
        counter           <= counter + 1'b0;   
    end
end
  
always @(posedge clock) begin
    if (!interleaver_done) begin
        if (counter == N-1) begin
            interleaver_done <= 1'b1;   // Finalizar cuando se han procesado todos los bits de entrada
            done <= 1'b1;
        end
    end
end
  
endmodule

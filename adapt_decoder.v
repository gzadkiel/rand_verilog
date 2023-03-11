module turbo_decoder (
    input clk,
    input reset,
    input [2*N-1:0] r, // received signal
    output [N-1:0] d // decoded output
);

parameter N = 256; // block size
parameter I = 6; // number of iterations
parameter M = 8; // number of states

reg [M-1:0] state1 [0:I-1]; // state memories for encoder 1
reg [M-1:0] state2 [0:I-1]; // state memories for encoder 2
reg [N-1:0] LLR [0:I-1][1:2]; // log-likelihood ratio memories for iterations and encoders

reg [M-1:0] path_metric [0:I-1][0:M-1]; // path metric memories for iterations and states

// Encoder 1
module encoder1 (
    input [N-1:0] d,
    output [N-1:0] c
);

reg [M-1:0] state = 0; // initialize state

// Generator polynomial coefficients
parameter g1 = 7'b1011011;
parameter g2 = 7'b1111001;

// Encoder operation
always @ (d or state) begin
    c = d ^ ((state[M-1] & g1) ^ (state[0] & g2));
    state = {state[M-2:0], c[N-1]};
end

endmodule

// Encoder 2
module encoder2 (
    input [N-1:0] d,
    output [N-1:0] c
);

reg [M-1:0] state = 0; // initialize state

// Generator polynomial coefficients
parameter g1 = 7'b1011101;
parameter g2 = 7'b1101011;

// Encoder operation
always @ (d or state) begin
    c = d ^ ((state[M-1] & g1) ^ (state[0] & g2));
    state = {state[M-2:0], c[N-1]};
end

endmodule

// Soft decision decoder
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset state and memory values
        state1 <= '{M{1'b0}};
        state2 <= '{M{1'b0}};
        LLR <= '{0, 0};
        path_metric <= '{0};
    end else begin
        // Log-likelihood ratio calculation
        for (i = 0; i < N; i++) begin
            LLR[0][1][i] = r[2*i] - r[2*i+1];
            LLR[0][2][i] = r[2*i+1];
        end
        
        // Iterative decoding
        for (j = 1; j < I; j++) begin
            // Encoder 1 decoding
            for (i = 0; i < N; i++) begin
                path_metric[j][0] = path_metric[j-1][0] + LLR[j][1][i];
                path_metric[j][1] = path_metric[j-1][1] + LLR[j][1][i];
                path_metric[j][2] = path_metric[j-1][2] + LLR[j][2][i];
                path_metric[j][3] = path_metric[j-1][3] + LLR[j][1][i];
                state1[j][i] = (path_metric[j][0] - path_metric[j-1][1]) < (path_metric[j][3] - path_metric[j-1][2]);
                LLR[j+1][1][i] = LLR[j][1][i] + ((-1)^(state1[j][i])) * path_metric[j][1];
            end
        // Encoder 2 decoding
        for (i = 0; i < N; i++) begin
            path_metric[j][4] = path_metric[j-1][4] + LLR[j][1][i];
            path_metric[j][5] = path_metric[j-1][5] + LLR[j][2][i];
            path_metric[j][6] = path_metric[j-1][6] + LLR[j][2][i];
            path_metric[j][7] = path_metric[j-1][7] + LLR[j][1][i];
            state2[j][i] = (path_metric[j][4] - path_metric[j-1][5]) < (path_metric[j][6] - path_metric[j-1][7]);
            LLR[j+1][2][i] = LLR[j][2][i] + ((-1)^(state2[j][i])) * path_metric[j][5];
        end
        end

    // Final decoding
    for (i = 0; i < N; i++) begin
        d[i] = (LLR[I][1][i] + LLR[I][2][i]) < 0;
    end
end

endmodule
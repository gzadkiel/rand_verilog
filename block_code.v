module block_code(
   input clk,
   input [7:0] in_data,
   output [15:0] encoded_data,
   input [15:0] received_data,
   output [7:0] decoded_data
);

// Encoder module
module encoder(
   input [7:0] data_in,
   output [15:0] data_out
);

// Decoder module
module decoder(
   input [15:0] data_in,
   output [7:0] data_out
);

// Main module
reg [7:0] data_in;
wire [15:0] encoded_data;
wire [7:0] decoded_data;

encoder u_encoder (
   .data_in(data_in),
   .data_out(encoded_data)
);

decoder u_decoder (
   .data_in(received_data),
   .data_out(decoded_data)
);

always @(posedge clk) begin
   data_in <= in_data;
end

assign encoded_data = u_encoder.data_out;
assign decoded_data = u_decoder.data_out;

endmodule

// Encoder implementation
module encoder(
   input [7:0] data_in,
   output [15:0] data_out
);

assign data_out[15:8] = data_in;
assign data_out[7:0] = ~data_in;

endmodule

// Decoder implementation
module decoder(
   input [15:0] data_in,
   output [7:0] data_out
);

assign data_out = data_in[15:8];

endmodule

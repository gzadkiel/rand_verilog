module adaptive_filter (
  input clk,
  input rst,
  input signed [15:0] x_in,
  input signed [15:0] d_in,
  output signed [15:0] y_out
);

  // Define filter coefficients as signed registers
  reg signed [15:0] w0;
  reg signed [15:0] w1;

  // Define internal signals for the filter
  wire signed [31:0] acc;
  wire signed [15:0] error;
  wire signed [15:0] x0;
  wire signed [15:0] x1;

  // Internal signals for the adaptive update
  wire signed [15:0] update;
  reg signed [15:0] update_reg;

  // Input registers for x and d
  reg signed [15:0] x_in_reg;
  reg signed [15:0] d_in_reg;

  // Delay elements for x and d
  reg signed [15:0] x0_reg;
  reg signed [15:0] x1_reg;

  // Set initial values for filter coefficients
  initial begin
    w0 = 0;
    w1 = 0;
  end

  // Delay x and d inputs
  always @(posedge clk) begin
    x_in_reg <= x_in;
    d_in_reg <= d_in;
  end

  // Delay x samples
  always @(posedge clk) begin
    x0_reg <= x_in_reg;
    x1_reg <= x0_reg;
  end

  // Calculate filter output and error
  assign x0 = x0_reg;
  assign x1 = x1_reg;
  assign acc = w0*x0 + w1*x1;
  assign y_out = acc[15:0];
  assign error = d_in_reg - y_out;

  // Update coefficients using LMS algorithm
  always @(posedge clk) begin
    // Calculate update signal
    update <= (error * x0_reg) >> 10; // scale factor of 1/1024

    // Update filter coefficients
    w0 <= w0 + update_reg;
    w1 <= w1 + update;

    // Delay update signal
    update_reg <= update;
  end

  // Reset filter coefficients and delay elements
  always @(posedge clk) begin
    if (rst) begin
      w0 <= 0;
      w1 <= 0;
      x0_reg <= 0;
      x1_reg <= 0;
      update_reg <= 0;
    end
  end

endmodule

/*
In this code, we have a module called fir_filter that takes in a clock signal (clk), an 8-bit input data signal (in_data), and outputs an 
8-bit filtered data signal (out_data). The filter coefficients are stored in a parameter array called coef. The delay line is implemented 
as an array of four 8-bit registers called delay. The accumulator is implemented as a 16-bit register called acc.

In the first always block, we shift the delay line by one position and store the new input data in the first delay register.

In the second always block, we compute the filtered output using the delay line and the filter coefficients. We multiply each delay element 
by its corresponding coefficient and sum up the results in the accumulator. We then output the top 8 bits of the accumulator as the filtered output.

This code implements a basic 4-tap FIR filter. You can modify the coefficients to implement different types of filters 
with different requency responses.
*/

module test_FIR(
  input           clk,
  input     [7:0] in_data,
  output    [7:0] out_data
);

// Filter coefficients
// Each coefficient has an 8 bit lenght, and the depth of the array indicates the amount
parameter   [7:0] coef [0:3] = {8'h20, 8'h40, 8'h60, 8'h40};

// Delay line
// Register chain, again with 8 bit word length and indicated depth
reg [7:0] delay [0:3];

// Accumulator
reg [15:0] acc;

// Shift the delay line and store new input
always @(posedge clk) begin
  delay[3] <= delay[2];
  delay[2] <= delay[1];
  delay[1] <= delay[0];
  delay[0] <= in_data;
end

// Compute output
always @(posedge clk) begin
  acc       <= {acc[13:0], 4'd0} + delay[0] * coef[0] + delay[1] * coef[1] + delay[2] * coef[2] + delay[3] * coef[3];
  out_data  <= acc[15:8];
end

endmodule



/*
assign acc = {acc[13:0], in_data} * {coeff[3], coeff[2], coeff[1], coeff[0], 2'd0};

We concatenate the lower 14 bits of the acc variable with the input data in_data to create a 16-bit operand. This operand 
is then multiplied by the filter coefficients, which are concatenated with 2'd0 to create a 20-bit coefficient vector. The
resulting 20-bit product is then truncated to 16 bits and stored in the acc variable.

In Verilog, when we use the {a,b} syntax, we are concatenating the bits of a and b to create a larger value. 
In this case, we are concatenating the 14 LSBs of the acc variable with the input data in_data to create a 16-bit operand. 
We are also concatenating the filter coefficients with 2'd0 to create a 20-bit coefficient vector. The 2'd0 part adds two 
zero bits to the end of the coefficient vector.

When we multiply these two operands together, we get a 20-bit product. However, we only need to store the lower 
16 bits of the product in the acc variable. Therefore, we truncate the upper 4 bits of the product by only storing the lower 16 bits.

As for why we use 2'd0 instead of 4'd0 in the concatenation, it is because we want the size of the coefficient vector 
to be a multiple of 4 bits. This is because many hardware multipliers operate on operands that are multiples of 4 bits. 
While it is true that using 4'd0 instead of 2'd0 would not have caused any issues in this specific example, using 2'd0 is a common 
practice in Verilog to ensure that operands are multiples of 4 bits.

I hope this explanation helps clarify things. Please let me know if you have any further questions.
*/
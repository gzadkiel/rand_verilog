/*
In this code, we have a module called float_multiplier that takes in two signed 13-bit floating-point 
numbers (a and b) and outputs their product (result).

The input values are separated into sign, mantissa, and exponent using the assign statements. The mantissas are multiplied 
using a 16-bit signed register called mant_prod. The sum of the exponents is computed using a 7-bit signed register called exp_sum. 
The exp_sum value is adjusted by subtracting 7'b0111100 (which corresponds to a bias of 7) to account for the implicit leading 1 in the mantissa.

The result is computed by shifting the mantissa by the adjusted exponent value and then combining it with a 
zero sign bit. The sign of the result is determined by checking whether the signs of the input values match, and then negating the 
result if they do not.

Note that this code does not implement any rounding or overflow/underflow handling. If you need those features, you will need to 
modify the code accordingly.
*/

module float_mult(
  input signed [12:0] a,
  input signed [12:0] b,
  output reg signed [12:0] result
);

// Separate input values into sign, mantissa, and exponent
reg sign_a, sign_b;
reg [7:0] mant_a, mant_b;
reg [3:0] exp_a, exp_b;

assign sign_a = a[12];
assign sign_b = b[12];
assign mant_a = a[7:0];
assign mant_b = b[7:0];
assign exp_a = a[11:8];
assign exp_b = b[11:8];

// Compute the product of the mantissas
reg signed [15:0] mant_prod;
assign mant_prod = mant_a * mant_b;

// Compute the sum of the exponents
reg signed [6:0] exp_sum;
assign exp_sum = exp_a + exp_b - 7'b0111100;

// Determine the sign of the result
reg signed [12:0] signed_result;
assign signed_result = {1'b0, mant_prod[15:8]} << exp_sum;
if (sign_a == sign_b)
  assign result = signed_result;
else
  assign result = -signed_result;

endmodule

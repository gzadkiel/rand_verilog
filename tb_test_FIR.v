/*
In this code, we have a testbench module called fir_filter_tb. We instantiate the fir_filter module (dut) and 
connect its input and output ports to signals in the testbench.

In the initial block, we initialize the clock and input data signals, and then run a loop to generate 20 random 
input data values with a 5 ns delay between each value.

In the always block, we toggle the clock signal every 5 ns.

To run the simulation, you can use a Verilog simulator such as ModelSim or Icarus Verilog. Once you compile both the fir_filter module 
and the fir_filter_tb module, you can run the simulation and view the waveform to see the filtered output signal.
*/


`timescale 1ns / 1ns

module tb_test_FIR();

reg clk;
reg [7:0] in_data;
wire [7:0] out_data;

fir_filter dut(
  .clk(clk),
  .in_data(in_data),
  .out_data(out_data)
);

initial begin
  clk = 0;
  in_data = 0;
  #10;
  for (int i = 0; i < 20; i++) begin
    in_data = $random;
    #5;
  end
  #100;
  $finish;
end

always #5 clk = ~clk;

endmodule
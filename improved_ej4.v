// General parameters
`define NBinput     8
`define NBoutput    8
`define NTAPS       4

// Coefficients
`define b0      1
`define b1      -1
`define b2      1
`define a0      1
`define b3      1

module improved_ej4
    #(
    // Parameters
    parameter NBinput   = `NBinput,
    parameter NBoutput  = `NBoutput,
    parameter NTAPS     = `NTAPS,
    parameter b0        = `b0,
    parameter b1        = `b1,
    parameter b2        = `b2,
    parameter b3        = `b3,
    parameter a0        = `a0
    )
    (
    // Ports
    input   [NBinput  - 1 : 0] X,
    input                      clk,
    input                      rst_n,
    output  [NBoutput - 1 : 0] Y
    );

// Product wires
wire signed [NBoutput - 1 : 0] cable_b [NTAPS     : 0];
wire signed [NBoutput - 1 : 0] cable_a [NTAPS - 1 : 0];

// Registers
reg signed [NBoutput - 1 : 0] z [NTAPS * 2 : 0];

// Circular buffer 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        z [NBoutput - 1 : 0] [NTAPS * 2 : 0]<= {NBoutput{1'b0}};
    end
    else begin
        // Pipeline X registers
        z[0:NBoutput-1] <= {z[NBoutput*1:NBoutput], X};
        // Pipeline Y registers
        z[NBOUTPUT*NTAPS:NBOUTPUT*(NTAPS-1)] <= {z[NBOUTPUT*(NTAPS-1)-1:0], Y};    
    end
end

// Input product wires
assign cable_b[0] = X*b0;
assign cable_b[1] = z[NBOUTPUT*1-1:0]*b1;
assign cable_b[2] = z[NBOUTPUT*2-1:NBOUTPUT+1]*b2;
assign cable_b[3] = z[NBOUTPUT*3-1:NBOUTPUT*2+3]*b3;
// Output product wires
assign cable_a[0] = z[NBOUTPUT*1-1:NBOUTPUT+3] >>> 2;
assign cable_a[1] = z[NBOUTPUT*2-1:NBOUTPUT*1+7] >>> 4;

assign Y = {cable_b, cable_a};

endmodule
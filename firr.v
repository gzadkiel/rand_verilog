module radar_processing(
    input clk,
    input rst,
    input [7:0] input_signal,
    output reg [7:0] output_signal
);

//Definición de los coeficientes del filtro FIR
parameter COEFFS [4:0] = {5'b00100, 5'b00100, 5'b00100, 5'b00100, 5'b00100};

//Definición de la memoria FIFO de entrada y salida
reg [7:0] input_fifo [4:0];
reg [7:0] output_fifo [4:0];

//Definición de los punteros de memoria FIFO de entrada y salida
reg [2:0] input_ptr = 0;
reg [2:0] output_ptr = 0;

//Proceso para el filtro FIR
always @(posedge clk) begin
    //Desplazamiento de las muestras en la memoria FIFO de entrada
    input_fifo[0] <= input_signal;
    input_fifo[1] <= input_fifo[0];
    input_fifo[2] <= input_fifo[1];
    input_fifo[3] <= input_fifo[2];
    input_fifo[4] <= input_fifo[3];

    //Cálculo del producto de los coeficientes con las muestras
    wire [7:0] prod1 = input_fifo[0] * COEFFS[0];
    wire [7:0] prod2 = input_fifo[1] * COEFFS[1];
    wire [7:0] prod3 = input_fifo[2] * COEFFS[2];
    wire [7:0] prod4 = input_fifo[3] * COEFFS[3];
    wire [7:0] prod5 = input_fifo[4] * COEFFS[4];

    //Suma de los productos para generar la salida del filtro FIR
    wire [7:0] output = prod1 + prod2 + prod3 + prod4 + prod5;

    //Desplazamiento de las muestras en la memoria FIFO de salida
    output_fifo[0] <= output;
    output_fifo[1] <= output_fifo[0];
    output_fifo[2] <= output_fifo[1];
    output_fifo[3] <= output_fifo[2];
    output_fifo[4] <= output_fifo[3];

    //Asignación de la salida del filtro FIR
    output_signal <= output_fifo[4];
end

endmodule
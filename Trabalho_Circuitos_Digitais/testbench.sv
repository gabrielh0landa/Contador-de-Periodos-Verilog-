`timescale 1ms/1ns
module temporizador_tb;

    reg sinal_tb;
    reg clock_tb;
    reg reset_tb;
    wire [11:0] quant_clocks_tb;
 	wire [11:0] tempocontado_tb;

    contadordetempodosinal uut (
    .sinal(sinal_tb),
    .clock(clock_tb),
    .reset(reset_tb),
    .quant_clocks(quant_clocks_tb),
    .tempocontado(tempocontado_tb)
    );

    initial begin
        clock_tb = 1;
        reset_tb = 1;
        sinal_tb = 0;

        #10 
        reset_tb = 0;

        #20
        sinal_tb = 1;

        #30
        sinal_tb = 0;

        #40
        sinal_tb = 1;

        #50
        sinal_tb = 0; 

        #60
        sinal_tb = 1; 

        #70
        sinal_tb = 0;

        #80
        sinal_tb = 1;
        $stop;
    end

    always #5 clock_tb = ~clock_tb;

    initial begin
        $monitor("Time = %0t | sinal = %b | reset = %b | quant_clocks = %d | tempocontado = %d", 
                 $time, sinal_tb, reset_tb, quant_clocks_tb, tempocontado_tb);
    end


endmodule



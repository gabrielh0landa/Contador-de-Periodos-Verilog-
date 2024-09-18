module contadordetempodosinal(
    input logic sinal,
    input logic clock,
    input logic reset,
    output logic [11:0] quant_clocks,
    output logic [11:0] tempocontado
);

    
    reg [1:0] estado, prox_estado;

   
    parameter esperando = 2'b00;
    parameter contando = 2'b01;
    parameter sinaldesligou = 2'b10;
    parameter sinalligou = 2'b11;

    parameter logic [31:0] milissegundos_por_cloks = 10;

   
    initial begin
        estado = esperando;
        quant_clocks = 12'b000000000000;
        tempocontado = 12'b000000000000;
    end

   
    always @(*) begin
        case (estado)
            esperando: begin
                if (sinal)
                    prox_estado = contando;
                else
                    prox_estado = esperando;
            end
            contando: begin
                if (!sinal) 
                    prox_estado = sinaldesligou;
                else
                    prox_estado = contando;
            end
            sinaldesligou: begin
                if (sinal)
                    prox_estado = sinalligou;
                else
                    prox_estado = sinaldesligou;
            end
            sinalligou: begin
                if (!sinal)
                    prox_estado = esperando;
                else
                    prox_estado = sinalligou;
            end
            default: prox_estado = esperando;
        endcase
    end

    
    always @(posedge clock or posedge reset) begin
        if (reset)
            estado <= esperando;
        else
            estado <= prox_estado;  
    end

   
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            quant_clocks <= 12'b000000000000;
            tempocontado <= 12'b000000000000;
        end else begin
            
            if (estado == contando) begin
                quant_clocks <= quant_clocks + 1;
                tempocontado <= (quant_clocks + 1)*milissegundos_por_cloks;

            end else if (estado == sinaldesligou) begin
                quant_clocks <= quant_clocks + 1; 
                tempocontado <= (quant_clocks + 1)*milissegundos_por_cloks;   
                 
            end else if (estado == sinalligou) begin
                quant_clocks <= 12'b000000000000; 
                tempocontado <= tempocontado;

            end else if (estado == esperando) begin
                quant_clocks <= quant_clocks;
                tempocontado <= 12'b000000000000;  
                
            end
        end
    end

endmodule

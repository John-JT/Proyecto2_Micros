`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/01/2017 08:23:29 AM
// Module Name: MEM_WB
//////////////////////////////////////////////////////////////////////////////////


module MEM_WB(
    input reloj,
    input resetMEM,
    input [1:0] ctrl_WB_mem1, ctrl_WB_mem2,
    input [31:0] DO1, DO2,                    //Salida Memoria de Datos
    input [31:0] DIR1, DIR2,                  //Entrada Direccion Memoria de Datos
    input [4:0] Y_MUX_mem1, Y_MUX_mem2,

    output DIR_WB1, DIR_WB2,
    output REG_WR1, REG_WR2,
    output [31:0] DO_wb1, DO_wb2,             //Salida de Memoria de Datos a Multiplexor Selector
    output [31:0] DIR_wb1, DIR_wb2,           // Salida "directa" de la ALU
    output [4:0] Y_MUX_wb1, Y_MUX_wb2         //Salida para WB
    );


    reg [70:0] MEM_WB1;
    reg [70:0] MEM_WB2;


    always @(posedge reloj)
    begin

       if (resetMEM)
       begin
          MEM_WB1 <= 71'b0;
       end

       else
       begin
          MEM_WB1 <= {ctrl_WB_mem1, DO1, DIR1, Y_MUX_mem1};
       end
    end

    always @(posedge reloj)
    begin

       if (resetMEM)
       begin
          MEM_WB2 <= 71'b0;
       end

       else
       begin
          MEM_WB2 <= {ctrl_WB_mem2, DO2, DIR2, Y_MUX_mem2};
       end
    end


    assign DIR_WB1 = MEM_WB1[70];
    assign REG_WR1 = MEM_WB1[69];         //Salida para WB
    assign DO_wb1 = MEM_WB1[68:37];
    assign DIR_wb1 = MEM_WB1[36:5];
    assign Y_MUX_wb1 = MEM_WB1[4:0];

    assign DIR_WB2 = MEM_WB2[70];
    assign REG_WR2 = MEM_WB2[69];         //Salida para WB
    assign DO_wb2 = MEM_WB2[68:37];
    assign DIR_wb2 = MEM_WB2[36:5];
    assign Y_MUX_wb2 = MEM_WB2[4:0];

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/01/2017 08:23:29 AM
// Module Name: EX_MEM
//////////////////////////////////////////////////////////////////////////////////


module EX_MEM(
    input reloj,
    input resetEX,
    input [2:0] ctrl_MEM_exe1, ctrl_MEM_exe2,
    input [1:0] ctrl_WB_exe1, ctrl_WB_exe2,
    input [31:0] Y_ALU1, Y_ALU2,                    //Salida de
    input [31:0] DOB_exe1, DOB_exe2,                //salida DOB en la etapa EXE
    input [4:0] Y_MUX1, Y_MUX2,                     //Salida MUX que elige entre rd y rt para Write Back

    output MEM_RD1, MEM_RD2,
    output MEM_WR1, MEM_WR2,
    output w_h1, w_h2,
    output [1:0] ctrl_WB_mem1, ctrl_WB_mem2,
    output [31:0] DIR1, DIR2,
    output [31:0] DI1, DI2,
    output [4:0] Y_MUX_mem1, Y_MUX_mem2
    );


    reg [73:0] EX_MEM1;
    reg [73:0] EX_MEM2;


    always @(posedge reloj)
    begin
       if (resetEX)
       begin
          EX_MEM1 <= 74'b0;
       end

       else
       begin
          EX_MEM1 <= {ctrl_MEM_exe1, ctrl_WB_exe1, Y_ALU1, DOB_exe1, Y_MUX1};
       end
    end

    always @(posedge reloj)
    begin
       if (resetEX)
       begin
          EX_MEM2 <= 74'b0;
       end

       else
       begin
          EX_MEM2 <= {ctrl_MEM_exe2, ctrl_WB_exe2, Y_ALU2, DOB_exe2, Y_MUX2};
       end
    end


    assign MEM_RD1 = EX_MEM1[73];
    assign MEM_WR1 = EX_MEM1[72];
    assign w_h1 = EX_MEM1[71];
    assign ctrl_WB_mem1 = EX_MEM1[70:69];
    assign DIR1 = EX_MEM1[68:37];
    assign DI1 = EX_MEM1[36:5];
    assign Y_MUX_mem1 = EX_MEM1[4:0];

    assign MEM_RD2 = EX_MEM2[73];
    assign MEM_WR2 = EX_MEM2[72];
    assign w_h2 = EX_MEM2[71];
    assign ctrl_WB_mem2 = EX_MEM2[70:69];
    assign DIR2 = EX_MEM2[68:37];
    assign DI2 = EX_MEM2[36:5];
    assign Y_MUX_mem2 = EX_MEM2[4:0];


endmodule

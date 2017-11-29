`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10/02/2017 06:59:43 PM
// Module Name: Micro_TB
//////////////////////////////////////////////////////////////////////////////////


module Micro_TB(
    );

    reg reloj;
    reg resetM;
    wire [71:0] aux;
    wire [31:0] P_C, addr2;
    wire [31:0] DI_banco1, DI_banco2;
    wire [4:0] DIR_WRA1, DIR_WRA2;
    wire REG_WR1, REG_WR2;
    wire [31:0] DO_D1, DO_D2;

    reg [31:0] arreglo1 [0:31];
    reg [31:0] mem1 [0:31];
    reg [31:0] arreglo2 [0:31];
    reg [31:0] mem2 [0:31];

    integer i = 0;
    integer j = 0;

    Micro_MIPS micro(
          .reloj(reloj),
          .resetM(resetM),

          .aux(aux),
          .P_C(P_C), .addr2(addr2),
          .DI_banco1(DI_banco1), .DI_banco2(DI_banco2),
          .DIR_WRA1(DIR_WRA1), .DIR_WRA2(DIR_WRA2),
          .REG_WR1(REG_WR1), .REG_WR2(REG_WR2),
          .DO_D1(DO_D1), .DO_D2(DO_D2)
    );


    always
    begin
    #5 reloj = ~reloj;
    end


    initial

    begin

    for (i = 0; i < 32; i = i + 1)    ////// inicialiazar arreglo en 0
        begin
        arreglo1[i] = {31'b0};
        mem1[i] = {31'b0};
        end

    for (j = 0; j < 32; j = j + 1)    ////// inicialiazar arreglo en 0
        begin
        arreglo2[j] = {31'b0};
        mem2[j] = {31'b0};
        end

    reloj = 0;
    resetM = 1;

    #30;
    resetM = 0;

    end


    always
    begin
      @(posedge reloj);
      if (P_C >= 12 && REG_WR1 == 0)
      begin
        arreglo1[DIR_WRA1] = {DI_banco1}|{DO_D1};
        $display("%d: %h", DIR_WRA1, arreglo1[DIR_WRA1]);
      end
    end
/*
    always
    begin
      @(posedge reloj);
      if (P_C >= 12 && REG_WR2 == 0)
      begin
        arreglo2[DIR_WRA2] = {DI_banco2}|{DO_D2};
        $display("%d: %h", "2", DIR_WRA2, arreglo2[DIR_WRA2]);
      end
      end
*/


endmodule

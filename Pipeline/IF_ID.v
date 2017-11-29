`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/01/2017 08:23:29 AM
// Module Name: IF_ID
//////////////////////////////////////////////////////////////////////////////////


module IF_ID(
    input reloj,
    input resetIF,
    input [31:0] DO1, DO2,      //Salida de Memoria de Instrucciones
    input [3:0] PC_4, PC_8,

    output [5:0] opcode1, opcode2,
    output [5:0] funct1, funct2,
    output [25:0] JUMP_ADDR1, JUMP_ADDR2,
    output [4:0] rs1, rs2,
    output [4:0] rt1, rt2,
    output [4:0] rd1, rd2,
    output [15:0] imm1, imm2,
    output [71:0] aux,
    output [3:0] pc_4, pc_8
    );


    reg [35:0] IF_ID1;
    reg [35:0] IF_ID2;


    always @(posedge reloj)

    begin
        if (resetIF)
        begin
            IF_ID1 <= 36'b0;
        end

        else
        begin
            IF_ID1 <= {PC_4, DO1};
        end
    end

    always @(posedge reloj)

    begin
        if (resetIF)
        begin
            IF_ID2 <= 36'b0;
        end

        else
        begin
            IF_ID2 <= {PC_8, DO2};
        end
    end

      assign opcode1 = IF_ID1[31:26];
      assign funct1 = IF_ID1[5:0];
      assign JUMP_ADDR1 = IF_ID1[25:0];
      assign rs1 = IF_ID1[25:21];
      assign rt1 = IF_ID1[20:16];
      assign rd1 = IF_ID1[15:11];
      assign imm1 = IF_ID1[15:0];
      assign pc_4 = IF_ID1[35:32];

      assign opcode2 = IF_ID2[31:26];
      assign funct2 = IF_ID2[5:0];
      assign JUMP_ADDR2 = IF_ID2[25:0];
      assign rs2 = IF_ID2[25:21];
      assign rt2 = IF_ID2[20:16];
      assign rd2 = IF_ID2[15:11];
      assign imm2 = IF_ID2[15:0];
      assign pc_8 = IF_ID2[35:32];

      assign aux = {IF_ID1, IF_ID2};
endmodule

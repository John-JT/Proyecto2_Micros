`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/01/2017 08:23:29 AM
// Module Name: ID_EX
//////////////////////////////////////////////////////////////////////////////////


module ID_EX(
    input reloj,
    input resetID,
    input [4:0] ctrl_EXE1, ctrl_EXE2,
    input [2:0] ctrl_MEM1, ctrl_MEM2,
    input [1:0] ctrl_WB1, ctrl_WB2,
    input [31:0] DOA1, DOA2,             //Salida A de Banco de Registros
    input [31:0] DOB1, DOB2,             //Salida B de Banco de Registros
    input [31:0] imm_ext1, imm_ext2,
    input [4:0] rt1, rt2,
    input [4:0] rd1, rd2,

    output [2:0] ALU_FUN1, ALU_FUN2,
    output SEL_ALU1, SEL_ALU2,
    output SEL_REG1, SEL_REG2,
    output [2:0] ctrl_MEM_exe1, ctrl_MEM_exe2,
    output [1:0] ctrl_WB_exe1, ctrl_WB_exe2,
    output [31:0] A1, A2,
    output [31:0] DOB_exe1, DOB_exe2,
    output [31:0] imm_ext_exe1, imm_ext_exe2,
    output [4:0] rt_exe1, rt_exe2,
    output [4:0] rd_exe1, rd_exe2
    );


    reg [115:0] ID_EX1;
    reg [115:0] ID_EX2;


    always @(posedge reloj)
    begin

       if (resetID)
       begin
          ID_EX1  <= 116'b0;
       end

       else
       begin
          ID_EX1 <= {ctrl_EXE1, ctrl_MEM1, ctrl_WB1, DOA1, DOB1, imm_ext1, rt1, rd1};
       end
    end

    always @(posedge reloj)
    begin

       if (resetID)
       begin
          ID_EX2  <= 116'b0;
       end

       else
       begin
          ID_EX2 <= {ctrl_EXE2, ctrl_MEM2, ctrl_WB2, DOA2, DOB2, imm_ext2, rt2, rd2};
       end
    end


    assign ALU_FUN1 = ID_EX1[115:113];
    assign SEL_ALU1 = ID_EX1[112];
    assign SEL_REG1 = ID_EX1[111];
    assign ctrl_MEM_exe1 = ID_EX1[110:108];
    assign ctrl_WB_exe1 = ID_EX1[107:106];
    assign A1 = ID_EX1[105:74];
    assign DOB_exe1 = ID_EX1[73:42];
    assign imm_ext_exe1 = ID_EX1[41:10];
    assign rt_exe1 = ID_EX1[9:5];
    assign rd_exe1 = ID_EX1[4:0];

    assign ALU_FUN2 = ID_EX2[115:113];
    assign SEL_ALU2 = ID_EX2[112];
    assign SEL_REG2 = ID_EX2[111];
    assign ctrl_MEM_exe2 = ID_EX2[110:108];
    assign ctrl_WB_exe2 = ID_EX2[107:106];
    assign A2 = ID_EX2[105:74];
    assign DOB_exe2 = ID_EX2[73:42];
    assign imm_ext_exe2 = ID_EX2[41:10];
    assign rt_exe2 = ID_EX2[9:5];
    assign rd_exe2 = ID_EX2[4:0];


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Grupo DDJ
// Engineer: DDJ
// Create Date: 09/28/2017 10:02:33 PM
// Module Name: Micro_MIPS
//////////////////////////////////////////////////////////////////////////////////



module Micro_MIPS(
    input wire reloj,
    input wire resetM,
    output wire [71:0] aux,
    output wire [31:0] P_C, addr2,
    output wire [31:0] DI_banco1, DI_banco2,
    output wire [4:0] DIR_WRA1, DIR_WRA2,
    output wire REG_WR1, REG_WR2,
    output wire [31:0] DO_D1, DO_D2);



    //---Wires de Interconexión Intermodular---
    //fetch
    wire [31:0] jump_dec1, jump_dec2;
    wire [1:0] SEL_DIR;
    wire SEL_JA;
    wire [31:0] DO_I1, DO_I2;
    //wire [31:0] addr2, P_C;
    wire [3:0] PC_4,pc_4;
    wire [3:0] addr2_4,pc_8;

    //IF_ID
    wire resetIF_aux;
    wire resetIF = (resetIF_aux & resetM);
    wire [5:0] opcode1, opcode2;
    wire [5:0] funct1, funct2;
    wire [25:0] JUMP_ADDR1, JUMP_ADDR2;
    wire [4:0] rs1, rs2;
    wire [4:0] rt1, rt2;
    wire [4:0] rd1, rd2;
    wire [15:0] imm1, imm2;

    //ruta control
    wire REG_RD1, REG_RD2;
    wire SEL_IM1, SEL_IM2;
    wire [4:0] ctrl_EXE1, ctrl_EXE2;
    wire [2:0] ctrl_MEM1, ctrl_MEM2;
    wire [1:0] ctrl_WB1, ctrl_WB2;

    //decode
    wire [31:0] DOA1, DOA2;
    wire [31:0] DOB1, DOB2;
    wire [31:0] imm_ext1, imm_ext2;
    //wire [4:0] DIR_WRA1, DIR_WRA2;
    //wire [31:0] DI_banco1, DI_banco2;

    //ID_EX
    wire [2:0] ALU_FUN1, ALU_FUN2;
    wire SEL_ALU1, SEL_ALU2;
    wire SEL_REG1, SEL_REG2;
    wire [2:0] ctrl_MEM_exe1, ctrl_MEM_exe2;
    wire [1:0] ctrl_WB_exe1, ctrl_WB_exe2;
    wire [31:0] A1, A2;
    wire [31:0] DOB_exe1, DOB_exe2;
    wire [31:0] imm_ext_exe1, imm_ext_exe2;
    wire [4:0] rt_exe1, rt_exe2;
    wire [4:0] rd_exe1, rd_exe2;

    //execute
    wire [31:0] Y_ALU1, Y_ALU2;
    wire [31:0] DOB_exeinpipe1, DOB_exeinpipe2;
    wire [4:0] Y_MUX1, Y_MUX2;

    //EX_MEM
    wire MEM_RD1, MEM_RD2;
    wire MEM_WR1, MEM_WR2;
    wire w_h1, w_h2;
    wire [1:0] ctrl_WB_mem1, ctrl_WB_mem2;
    wire [31:0] DIR_D1, DIR_D2;
    wire [31:0] DI_D1, DI_D2;
    wire [4:0] Y_MUX_mem1, Y_MUX_mem2;

    //MEM
    //wire [31:0] DO_D1, DO_D2;

    //MEM_WB
    wire DIR_WB1, DIR_WB2;
    wire [31:0] DO_D_wb1, DO_D_wb2;
    wire [31:0] DIR_D_wb1, DIR_D_wb2;



    //---Instanciaciones---
    fetch inst_fetch(
          .DOA_exe1(DOA1), .DOA_exe2(DOA2),
          .jump_exe1(jump_dec1), .jump_exe2(jump_dec2),
          .reloj(reloj),
          .reset(resetM),
          .SEL_JA(SEL_JA),
          .SEL_DIR(SEL_DIR),
          .P_C(P_C), .addr2(addr2),
          .PC_4(PC_4), .addr2_4(addr2_4));

     //////// memoria de instrucciones
     instruction_mem im(
          .addr1(P_C),
          .addr2(addr2),
          .data1(DO_I1),
          .data2(DO_I2));


    IF_ID inst_IF_ID(
          .reloj(reloj),
          .resetIF(resetIF),
          .DO1(DO_I1),.DO2(DO_I2),
          .PC_4(PC_4),.PC_8(addr2_4),
          .opcode1(opcode1),.opcode2(opcode2),
          .funct1(funct1),.funct2(funct2),
          .JUMP_ADDR1(JUMP_ADDR1),.JUMP_ADDR2(JUMP_ADDR2),
          .rs1(rs1),.rs2(rs2),
          .rt1(rt1),.rt2(rt2),
          .rd1(rd1),.rd2(rd2),
          .imm1(imm1),.imm2(imm2),
          .pc_4(pc_4),.pc_8(pc_8),
          .aux(aux));

    ruta_ctrl inst_ruta_ctrl(
          .opcode1(opcode1),.opcode2(opcode2),
          .funct1(funct1),.funct2(funct2),
          .SEL_DIR(SEL_DIR),
          .SEL_JA(SEL_JA),
          .resetIF(resetIF_aux),
          .REG_RD1(REG_RD1),.REG_RD2(REG_RD2),
          .SEL_IM1(SEL_IM1),.SEL_IM2(SEL_IM2),
          .ctrl_EXE1(ctrl_EXE1),.ctrl_EXE2(ctrl_EXE2),
          .ctrl_MEM1(ctrl_MEM1),  .ctrl_MEM2(ctrl_MEM2),
          .ctrl_WB1(ctrl_WB1), .ctrl_WB2(ctrl_WB2));

    decode inst_decode(
          .reloj(reloj),
          .DIR_A1(rs1),  .DIR_A2(rs2),
          .DIR_B1(rt1),  .DIR_B2(rt2),
          .DIR_WRA1(DIR_WRA1),.DIR_WRA2(DIR_WRA2),
          .DI1(DI_banco1),.DI2(DI_banco2),
          .REG_RD1(REG_RD1),.REG_RD2(REG_RD2),
          .REG_WR1(REG_WR1),  .REG_WR2(REG_WR2),
          .SEL_I1(SEL_IM1),.SEL_I2(SEL_IM2),
          .IMD1(imm1),.IMD2(imm2),
          .address1(JUMP_ADDR1),.address2(JUMP_ADDR2),
          .pc_4(pc_4),.pc_8(pc_8),
          .DOA1(DOA1),.DOA2(DOA2),
          .DOB1(DOB1),.DOB2(DOB2),
          .out_mux_sz1(imm_ext1),.out_mux_sz2(imm_ext2),
          .out_addr1(jump_dec1),.out_addr2(jump_dec2));

    ID_EX inst_ID_EX(
          .reloj(reloj),
          .resetID(resetM),
          .ctrl_EXE1(ctrl_EXE1),.ctrl_EXE2(ctrl_EXE2),
          .ctrl_MEM1(ctrl_MEM1),.ctrl_MEM2(ctrl_MEM2),
          .ctrl_WB1(ctrl_WB1),.ctrl_WB2(ctrl_WB2),
          .DOA1(DOA1),  .DOA2(DOA2),
          .DOB1(DOB1),.DOB2(DOB2),
          .imm_ext1(imm_ext1),.imm_ext2(imm_ext2),
          .rt1(rt1),  .rt2(rt2),
          .rd1(rd1),.rd2(rd2),
          .ALU_FUN1(ALU_FUN1),.ALU_FUN2(ALU_FUN2),
          .SEL_ALU1(SEL_ALU1),.SEL_ALU2(SEL_ALU2),
          .SEL_REG1(SEL_REG1),.SEL_REG2(SEL_REG2),
          .ctrl_MEM_exe1(ctrl_MEM_exe1),.ctrl_MEM_exe2(ctrl_MEM_exe2),
          .ctrl_WB_exe1(ctrl_WB_exe1),  .ctrl_WB_exe2(ctrl_WB_exe2),
          .A1(A1),  .A2(A2),
          .DOB_exe1(DOB_exe1),.DOB_exe2(DOB_exe2),
          .imm_ext_exe1(imm_ext_exe1),.imm_ext_exe2(imm_ext_exe2),
          .rt_exe1(rt_exe1),.rt_exe2(rt_exe2),
          .rd_exe1(rd_exe1), .rd_exe2(rd_exe2));

    execute inst_execute(
          .ALU_FUN1(ALU_FUN1),.ALU_FUN2(ALU_FUN2),
          .input_A1(A1),.input_A2(A2),
          .input_sz1(imm_ext_exe1),.input_sz2(imm_ext_exe2),
          .input_register1(DOB_exe1),.input_register2(DOB_exe2),
          .rt1(rt_exe1),.rt2(rt_exe2),
          .rd1(rd_exe1),.rd2(rd_exe2),
          .SEL_ALU1(SEL_ALU1),.SEL_ALU2(SEL_ALU2),
          .SEL_REG1(SEL_REG1),.SEL_REG2(SEL_REG2),
          .out_ALU1(Y_ALU1),.out_ALU2(Y_ALU2),
          .out_dato_registro1(DOB_exeinpipe1),  .out_dato_registro2(DOB_exeinpipe2),
          .out_mux_sel_reg1(Y_MUX1),   .out_mux_sel_reg2(Y_MUX2));

    EX_MEM inst_EX_MEM(
          .reloj(reloj),
          .resetEX(resetM),
          .ctrl_MEM_exe1(ctrl_MEM_exe1),  .ctrl_MEM_exe2(ctrl_MEM_exe2),
          .ctrl_WB_exe1(ctrl_WB_exe1),    .ctrl_WB_exe2(ctrl_WB_exe2),
          .Y_ALU1(Y_ALU1),                .Y_ALU2(Y_ALU2),
          .DOB_exe1(DOB_exeinpipe1),      .DOB_exe2(DOB_exeinpipe2),
          .Y_MUX1(Y_MUX1),                .Y_MUX2(Y_MUX2),
          .MEM_RD1(MEM_RD1),              .MEM_RD2(MEM_RD2),
          .MEM_WR1(MEM_WR1),              .MEM_WR2(MEM_WR2),
          .w_h1(w_h1),                    .w_h2(w_h2),
          .ctrl_WB_mem1(ctrl_WB_mem1),    .ctrl_WB_mem2(ctrl_WB_mem2),
          .DIR1(DIR_D1),                  .DIR2(DIR_D2),
          .DI1(DI_D1),                    .DI2(DI_D2),
          .Y_MUX_mem1(Y_MUX_mem1),   .Y_MUX_mem2(Y_MUX_mem2));

    mem inst_mem(
          .reloj(reloj),
          .DI_MEM1(DI_D1),           .DI_MEM2(DI_D2),
          .DIR_MEM1(DIR_D1[6:0]),    .DIR_MEM2(DIR_D2[6:0]),
          .MEM_RD1(MEM_RD1),         .MEM_RD2(MEM_RD2),
          .MEM_WR1(MEM_WR1),         .MEM_WR2(MEM_WR2),
          .w_h1(w_h1),               .w_h2(w_h2),
          .DO_MEMo1(DO_D1), .DO_MEMo2(DO_D2));

    MEM_WB inst_MEM_WB(
          .reloj(reloj),
          .resetMEM(resetM),
          .ctrl_WB_mem1(ctrl_WB_mem1), .ctrl_WB_mem2(ctrl_WB_mem2),
          .DO1(DO_D1),                 .DO2(DO_D2),
          .DIR1(DIR_D1),               .DIR2(DIR_D2),
          .Y_MUX_mem1(Y_MUX_mem1),     .Y_MUX_mem2(Y_MUX_mem2),
          .DIR_WB1(DIR_WB1),           .DIR_WB2(DIR_WB2),
          .REG_WR1(REG_WR1),           .REG_WR2(REG_WR2),
          .DO_wb1(DO_D_wb1),           .DO_wb2(DO_D_wb2),
          .DIR_wb1(DIR_D_wb1),         .DIR_wb2(DIR_D_wb2),
          .Y_MUX_wb1(DIR_WRA1),       .Y_MUX_wb2(DIR_WRA2));

    wb inst_wb(
          .DIR_WB1(DIR_WB1),          .DIR_WB2(DIR_WB2),
          .DO1(DO_D_wb1),             .DO2(DO_D_wb2),
          .DIR1(DIR_D_wb1),           .DIR2(DIR_D_wb2),
          .out_mux_wb1(DI_banco1),   .out_mux_wb2(DI_banco2));



    //assign que evite warning:
    //[Synth 8-3332] Sequential element (inst_IF_ID/IF_ID_reg[30]) is unused...
    //...and will be removed from module Micro_MIPS. ****[y otros parecidos]****
    //assign aux2 = {ALU_FUN, SEL_ALU, SEL_REG, ctrl_MEM_exe, ctrl_WB_exe, A, DOB_exe, imm_ext_exe, rt_exe, rd_exe};
endmodule

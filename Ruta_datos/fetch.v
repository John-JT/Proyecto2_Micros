`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
// Create Date: 30.08.2017 23:22:33
// Design Name:
// Module Name: fetch
//////////////////////////////////////////////////////////////////////////////////


module fetch(
  input [31:0] DOA_exe1, DOA_exe2,
  input reloj,reset,
  input SEL_JA,
  input [1:0] SEL_DIR,
  input [31:0] jump_exe1, jump_exe2,
  output [31:0] P_C, addr2,
  output [3:0] PC_4, addr2_4
  );


  reg [31:0] PC = 32'd0;
  wire [31:0] DOA_exe, jump_exe;


  //Mux de los diferentes JA y JR
  assign jump_exe = SEL_JA ? jump_exe2 : jump_exe1;
  assign DOA_exe = SEL_JA ? DOA_exe2 : DOA_exe1;
  /*case (SEL_JA)
    0:
      begin
      jump_exe = jump_exe1;
      DOA_exe = DOA_exe1;
      end
    1:
      begin
      jump_exe = jump_exe2;
      DOA_exe = DOA_exe2;
      end
  endcase*/


  ////// mux SEL_DIR
  always @(posedge reloj)
  if (reset)
    begin
        PC <= 32'd0;
    end
  else
    begin
        case (SEL_DIR)
         2'b00: PC <= PC + 32'd4;
         2'b01: PC <= jump_exe;
         2'b10: PC <= DOA_exe;
         2'b11: PC <= 32'd0;
        endcase
    end


    assign P_C = PC;
    assign PC_4 = P_C[31:28];

    //Logica de segunda direccion
    assign addr2 = (P_C + 32'd4);
    assign addr2_4 = addr2[31:28];


endmodule

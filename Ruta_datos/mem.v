`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 28/09/2017 08:12:00 AM
// Module Name: mem
//////////////////////////////////////////////////////////////////////////////////

module mem (
  input reloj,
  input [31:0] DI_MEM1, DI_MEM2,
  input [6:0] DIR_MEM1, DIR_MEM2,
  input MEM_RD1, MEM_RD2,
  input MEM_WR1, MEM_WR2,
  input w_h1, w_h2,
  output [31:0] DO_MEMo1, DO_MEMo2
  );
  //w_h = 0 Mitad ; w_h = 1 Completa

  reg [31:0] mem [0:127];           //Memoria de 32bits con 128 entradas
  reg [31:0] DO_MEMor1 = 32'b0;
  reg [31:0] DO_MEMor2 = 32'b0;
  wire LE1 = ((~MEM_RD1)+(MEM_WR1));
  wire LE2 = ((~MEM_RD2)+(MEM_WR2));

  always @ (posedge reloj)
  begin
      if (LE1)
        begin
          DO_MEMor1 <= mem[DIR_MEM1];
        end
      else
        begin
          if(w_h1)  mem[DIR_MEM1] <= DI_MEM1;
          else      mem[DIR_MEM1] <= {16'b0,DI_MEM1[15:0]};
        end
  end

  always @ (posedge reloj)
  begin
      if (LE2)
        begin
          DO_MEMor2 <= mem[DIR_MEM2];
        end
      else
        begin
          if(w_h2)   mem[DIR_MEM2] <= DI_MEM2;
          else      mem[DIR_MEM2] <= {16'b0,DI_MEM2[15:0]};
        end
  end


    assign DO_MEMo1 = DO_MEMor1;
    assign DO_MEMo2 = DO_MEMor2;


endmodule //mem

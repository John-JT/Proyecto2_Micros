`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
// Create Date: 11.09.2017 22:01:26
// Design Name:
// Module Name: decode
//////////////////////////////////////////////////////////////////////////////////


module decode(
    input reloj,
    input [4:0] DIR_A1, DIR_B1, DIR_WRA1, DIR_A2, DIR_B2, DIR_WRA2,
    input [31:0] DI1, DI2,
    input REG_RD1, REG_WR1, SEL_I1, REG_RD2, REG_WR2, SEL_I2,
    input [15:0] IMD1, IMD2,
    input [25:0] address1, address2,
    input [3:0] pc_4, pc_8,

    output [31:0] DOA1, DOB1, out_mux_sz1, DOA2, DOB2, out_mux_sz2,
    output [31:0] out_addr1, out_addr2);


    reg [31:0] registro [0:31];

    reg [31:0] routA1, routB1 = 32'b0;
    reg [31:0] routA2, routB2 = 32'b0;
    reg [31:0] out_sign1, out_zero1 = 0;
    reg [31:0] out_sign2, out_zero2 = 0;

    wire [1:0] regRD = {REG_RD1, REG_RD2};
    wire [1:0] regWR = {REG_WR1, REG_WR2};

   ////////// banco de registros
   /*always @ (*)
    begin
    if (REG_RD1 == 1'b0)
    begin
        routA1 = registro [DIR_A1];
        routB1 = registro [DIR_B1];
    end
    else
    begin
        routA1 = 32'b0;
        routB1 = 32'b0;
    end
    end

    always @ (*)
     begin
     if (REG_RD2 == 1'b0)
     begin
         routA2 = registro [DIR_A2];
         routB2 = registro [DIR_B2];
     end
     else
     begin
         routA2 = 32'b0;
         routB2 = 32'b0;
     end
     end*/





    always @ (regRD, DIR_A1, DIR_B1, DIR_A2, DIR_B2)
    begin
      case (regRD)
        2'b00:
          begin
          routA1 = registro [DIR_A1];
          routB1 = registro [DIR_B1];
          routA2 = registro [DIR_A2];
          routB2 = registro [DIR_B2];
          end
        2'b01:
          begin
          routA1 = registro [DIR_A1];
          routB1 = registro [DIR_B1];
          routA2 = 32'b0;
          routB2 = 32'b0;
          end
        2'b10:
          begin
          routA1 = 32'b0;
          routB1 = 32'b0;
          routA2 = registro [DIR_A2];
          routB2 = registro [DIR_B2];
          end
        2'b11:
          begin
          routA1 = 32'b0;
          routB1 = 32'b0;
          routA2 = 32'b0;
          routB2 = 32'b0;
          end
      endcase
    end

/*
    always @ (posedge reloj)
    begin
    if (REG_WR1 == 0) registro[DIR_WRA1] <= DI1;
    else registro[DIR_WRA1] <= registro[DIR_WRA1];
    end

    always @ (posedge reloj)
    begin
    if (REG_WR2 == 0) registro[DIR_WRA2] <= DI2;
    else registro[DIR_WRA2] <= registro[DIR_WRA2];
    end
*/

    always @ (posedge reloj)
    begin
      case (regWR)
        2'b00:
        begin
          registro[DIR_WRA1] <= DI1;
          registro[DIR_WRA2] <= DI2;
        end
        2'b01:
        begin
          registro[DIR_WRA1] <= DI1;
          registro[DIR_WRA2] <= registro[DIR_WRA2];
        end
        2'b10:
        begin
          registro[DIR_WRA1] <= registro[DIR_WRA1];
          registro[DIR_WRA2] <= DI2;
        end
        2'b11:
        begin
          registro[DIR_WRA1] <= registro[DIR_WRA1];
          registro[DIR_WRA2] <= registro[DIR_WRA2];
        end
      endcase
    end

    assign DOA1 = routA1;
    assign DOB1 = routB1;

    assign DOA2 = routA2;
    assign DOB2 = routB2;


    ///////////sign extension
    always @(IMD1)
    begin

    if(IMD1[15]==1'b1) out_sign1 = {16'b1111111111111111,IMD1};

    else out_sign1 = {16'b0000000000000000,IMD1};

    end


    always @(IMD2)
    begin

    if(IMD2[15]==1'b1) out_sign2 = {16'b1111111111111111,IMD2};

    else out_sign2 = {16'b0000000000000000,IMD2};

    end


   /////// zero extension
    always @(IMD1)
    begin
    out_zero1 <= {16'b0000000000000000,IMD1};
    end


    always @(IMD2)
    begin
    out_zero2 <= {16'b0000000000000000,IMD2};
    end


    ////////// mux sign and zero
    assign out_mux_sz1 = SEL_I1 ? out_sign1 : out_zero1;
    assign out_mux_sz2 = SEL_I2 ? out_sign2 : out_zero2;


    /////// calculo para jump addr
    assign out_addr1 = {pc_4,address1,2'b00};
    assign out_addr2 = {pc_8,address2,2'b00};


endmodule

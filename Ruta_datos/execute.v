`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
// Create Date: 26.09.2017 23:40:10
// Design Name:
// Module Name: execute
//////////////////////////////////////////////////////////////////////////////////


module execute(
    input [2:0] ALU_FUN1, ALU_FUN2,
    input [31:0] input_A1, input_sz1, input_register1, input_A2, input_sz2, input_register2,
    input [4:0] rt1, rd1, rt2, rd2,
    input SEL_ALU1 ,SEL_REG1, SEL_ALU2, SEL_REG2,


    output [31:0] out_ALU1, out_dato_registro1, out_ALU2, out_dato_registro2,
    output [4:0] out_mux_sel_reg1, out_mux_sel_reg2
    );


    reg [31:0] out_alu1;
    wire [31:0] input_B1;

    reg [31:0] out_alu2;
    wire [31:0] input_B2;


    ///////////// mux alu
     assign input_B1 = SEL_ALU1 ? input_sz1 : input_register1;
     assign input_B2 = SEL_ALU2 ? input_sz2 : input_register2;


    ////////// ALU
    always @(ALU_FUN1, input_A1, input_B1)
    begin
    case (ALU_FUN1)
        3'b001:
            out_alu1 = input_A1 + input_B1;
        3'b010:
            out_alu1 = input_A1 - input_B1;
        3'b011:
            out_alu1 = input_A1 & input_B1;
        3'b100:
            out_alu1 = input_A1 | input_B1;
        3'b101:
            out_alu1 = ~(input_A1 | input_B1);
        3'b110:
            if (input_A1 < input_B1)
                out_alu1 = 1;
            else
                out_alu1 = 0;
        default:
            out_alu1 = 32'b0;
    endcase
    end

    always @(ALU_FUN2, input_A2, input_B2)
    begin
    case (ALU_FUN2)
        3'b001:
            out_alu2 = input_A2 + input_B2;
        3'b010:
            out_alu2 = input_A2 - input_B2;
        3'b011:
            out_alu2 = input_A2 & input_B2;
        3'b100:
            out_alu2 = input_A2 | input_B2;
        3'b101:
            out_alu2 = ~(input_A2 | input_B2);
        3'b110:
            if (input_A2 < input_B2)
                out_alu2 = 1;
            else
                out_alu2 = 0;
        default:
            out_alu2 = 32'b0;
    endcase
    end


  /////////// mux sel_reg
  assign out_mux_sel_reg1 = SEL_REG1 ? rd1 : rt1;
  assign out_mux_sel_reg2 = SEL_REG2 ? rd2 : rt2;


  //////// asignar salidas
  assign out_ALU1 = out_alu1;
  assign out_dato_registro1 = input_register1;

  assign out_ALU2 = out_alu2;
  assign out_dato_registro2 = input_register2;


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 27.09.2017 18:18:00
// Design Name:
// Module Name: wb
//////////////////////////////////////////////////////////////////////////////////


module wb(
  input DIR_WB1, DIR_WB2,
  input [31:0] DO1, DIR1, DO2, DIR2,
  output [31:0] out_mux_wb1, out_mux_wb2);


  assign out_mux_wb1 = DIR_WB1 ? DIR1 : DO1;
  assign out_mux_wb2 = DIR_WB2 ? DIR2 : DO2;


endmodule

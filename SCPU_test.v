`timescale 1ns / 1ps

module Pipeline_CPU_test (
    input rst,
    input clk
);

  wire [31:0] Data_in;
  wire [31:0] inst_in;
  wire [31:0] Addr_out;
  wire [31:0] Data_out;
  wire MemRW_Mem;
  wire MemRW_EX;
  wire [31:0] inst_ID;
  wire [31:0] PC_out_IF;
  wire [31:0] PC_out_ID;
  wire [31:0] PC_out_EX;
  wire [31:0] Data_out_WB;

  RAM_B RAM (
      .clka (~clk),
      .wea  (MemRW_Mem),
      .addra(Addr_out[11:2]),
      .dina (Data_out),
      .douta(Data_in)
  );

  ROM_D ROM (
      .a  (PC_out_IF[11:2]),
      .spo(inst_in)
  );

  Pipeline_CPU Pipeline_CPU_inst (
      .clk(clk),
      .rst(rst),
      .inst_IF(inst_in),
      .Data_in(Data_in),
      
      .Addr_out(Addr_out),
      .Data_out(Data_out),
      .Data_out_WB(Data_out_WB),
      .PC_out_IF(PC_out_IF),
      .PC_out_ID(PC_out_ID),
      .PC_out_EX(PC_out_EX),
      .inst_ID(inst_ID),
      .MemRW_Mem(MemRW_Mem),
      .MemRW_EX(MemRW_EX)
  );

endmodule

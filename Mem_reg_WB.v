module Mem_reg_WB (
    input         clk_MemWB,
    input         rst_MemWB,
    input         en_MemWB,
    input  [31:0] PC4_in_MemWB,
    input  [31:0] PC_in_MemWB,
    input  [31:0] Inst_in_MemWB,
    input         valid_in_MemWB,
    input  [ 4:0] Rd_addr_MemWB,
    input  [31:0] ALU_in_MemWB,
    input  [31:0] DMem_data_MemWB,
    input  [ 1:0] MemtoReg_in_MemWB,
    input         RegWrite_in_MemWB,
    output [31:0] PC4_out_MemWB,
    output [31:0] PC_out_MemWB,
    output [31:0] Inst_out_MemWB,
    output        valid_out_MemWB,
    output [ 4:0] Rd_addr_out_MemWB,
    output [31:0] ALU_out_MemWB,
    output [31:0] DMem_data_out_MemWB,
    output [ 1:0] MemtoReg_out_MemWB,
    output        RegWrite_out_MemWB
);

  reg [31:0] PC4_reg;
  reg [31:0] PC_reg;
  reg [31:0] Inst_reg;
  reg valid_reg;
  reg [4:0] Rd_addr_reg;
  reg [31:0] ALU_reg;
  reg [31:0] DMem_data_reg;
  reg [1:0] MemtoReg_reg;
  reg RegWrite_reg;

  always @(posedge clk_MemWB or posedge rst_MemWB) begin
    if (rst_MemWB) begin
      PC4_reg <= 32'b0;
      PC_reg <= 32'b0;
      Inst_reg <= 32'b0;
      valid_reg <= 1'b0;
      Rd_addr_reg <= 5'b0;
      ALU_reg <= 32'b0;
      DMem_data_reg <= 32'b0;
      MemtoReg_reg <= 2'b0;
      RegWrite_reg <= 1'b0;
    end else if (en_MemWB) begin
      PC4_reg <= PC4_in_MemWB;
      PC_reg <= PC_in_MemWB;
      Inst_reg <= Inst_in_MemWB;
      valid_reg <= valid_in_MemWB;
      Rd_addr_reg <= Rd_addr_MemWB;
      ALU_reg <= ALU_in_MemWB;
      DMem_data_reg <= DMem_data_MemWB;
      MemtoReg_reg <= MemtoReg_in_MemWB;
      RegWrite_reg <= RegWrite_in_MemWB;
    end
  end

  assign PC4_out_MemWB = PC4_reg;
  assign PC_out_MemWB = PC_reg;
  assign Inst_out_MemWB = Inst_reg;
  assign valid_out_MemWB = valid_reg;
  assign Rd_addr_out_MemWB = Rd_addr_reg;
  assign ALU_out_MemWB = ALU_reg;
  assign DMem_data_out_MemWB = DMem_data_reg;
  assign MemtoReg_out_MemWB = MemtoReg_reg;
  assign RegWrite_out_MemWB = RegWrite_reg;

endmodule

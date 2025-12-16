module Ex_reg_Mem (
    input         clk_EXMem,
    input         rst_EXMem,
    input         en_EXMem,
    input  [31:0] PC_imm_EXMem,
    input  [31:0] PC4_in_EXMem,
    input  [31:0] PC_in_EXMem,
    input         valid_in_EXMem,
    input  [31:0] Inst_in_EXMem,
    input  [ 4:0] Rd_addr_EXMem,
    input         zero_in_EXMem,
    input  [31:0] ALU_in_EXMem,
    input  [31:0] Rs2_in_EXMem,
    input         Branch_in_EXMem,
    input         BranchN_in_EXMem,
    input         MemRW_in_EXMem,
    input         Junp_in_EXMem,
    input  [ 1:0] MemtoReg_in_EXMem,
    input         RegWrite_in_EXMem,
    output [31:0] C_out_EXMem,
    output [31:0] PC4_out_EXMem,
    output [31:0] PC_imm_out_EXMem,
    output [31:0] valid_out_EXMem,
    output [31:0] Inst_out_EXMem,
    output [ 4:0] Rd_addr_out_EXMem,
    output        zero_out_EXMem,
    output [31:0] ALU_out_EXMem,
    output [31:0] Rs2_out_EXMem,
    output        Branch_out_EXMem,
    output        BranchN_out_EXMem,
    output        MemRW_out_EXMem,
    output        Jump_out_EXMem,
    output [ 1:0] MemtoReg_out_EXMem,
    output        RegWrite_out_EXMem
);

  reg [31:0] PC_imm_reg;
  reg [31:0] PC4_reg;
  reg [31:0] PC_reg;
  reg [31:0] valid_reg;
  reg [31:0] Inst_reg;
  reg [4:0] Rd_addr_reg;
  reg zero_reg;
  reg [31:0] ALU_reg;
  reg [31:0] Rs2_reg;
  reg Branch_reg;
  reg BranchN_reg;
  reg MemRW_reg;
  reg Jump_reg;
  reg [1:0] MemtoReg_reg;
  reg RegWrite_reg;

  always @(posedge clk_EXMem) begin
    if (rst_EXMem) begin
      PC_imm_reg <= 32'b0;
      PC4_reg <= 32'b0;
      PC_reg <= 32'b0;
      valid_reg <= 32'b0;
      Inst_reg <= 32'b0;
      Rd_addr_reg <= 5'b0;
      zero_reg <= 1'b0;
      ALU_reg <= 32'b0;
      Rs2_reg <= 32'b0;
      Branch_reg <= 1'b0;
      BranchN_reg <= 1'b0;
      MemRW_reg <= 1'b0;
      Jump_reg <= 1'b0;
      MemtoReg_reg <= 2'b0;
      RegWrite_reg <= 1'b0;
    end else if (en_EXMem) begin
      PC_imm_reg <= PC_imm_EXMem;
      PC4_reg <= PC4_in_EXMem;
      PC_reg <= PC_in_EXMem;
      valid_reg <= valid_in_EXMem;
      Inst_reg <= Inst_in_EXMem;
      Rd_addr_reg <= Rd_addr_EXMem;
      zero_reg <= zero_in_EXMem;
      ALU_reg <= ALU_in_EXMem;
      Rs2_reg <= Rs2_in_EXMem;
      Branch_reg <= Branch_in_EXMem;
      BranchN_reg <= BranchN_in_EXMem;
      MemRW_reg <= MemRW_in_EXMem;
      Jump_reg <= Junp_in_EXMem;
      MemtoReg_reg <= MemtoReg_in_EXMem;
      RegWrite_reg <= RegWrite_in_EXMem;
    end
  end

  assign PC_imm_out_EXMem = PC_imm_reg;
  assign PC4_out_EXMem = PC4_reg;
  assign C_out_EXMem = PC_reg;
  assign valid_out_EXMem = valid_reg;
  assign Inst_out_EXMem = Inst_reg;
  assign Rd_addr_out_EXMem = Rd_addr_reg;
  assign zero_out_EXMem = zero_reg;
  assign ALU_out_EXMem = ALU_reg;
  assign Rs2_out_EXMem = Rs2_reg;
  assign Branch_out_EXMem = Branch_reg;
  assign BranchN_out_EXMem = BranchN_reg;
  assign MemRW_out_EXMem = MemRW_reg;
  assign Jump_out_EXMem = Jump_reg;
  assign MemtoReg_out_EXMem = MemtoReg_reg;
  assign RegWrite_out_EXMem = RegWrite_reg;

endmodule

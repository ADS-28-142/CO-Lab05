module ID_reg_Ex (
    input clk_IDEX,
    input rst_IDEX,
    input en_IDEX,
    input NOP_IDEX,
    input valid_in_IDEX,
    input [31:0] PC_in_IDEX,
    input [31:0] Inst_in_IDEX,
    input [4:0] Rd_addr_IDEX,
    input [31:0] Rs1_in_IDEx,
    input [31:0] Rs2_in_IDEX,
    input [31:0] Imm_in_IDEX,
    input ALUSrc_B_in_IDEX,
    input [2:0] ALU_control_in_IDEX,
    input Branch_in_IDEX,
    input BranchN_in_IDEX,
    input MemRW_in_IDEX,
    input Jump_in_IDEX,
    input [1:0] MemtoReg_in_IDEX,
    input RegWrite_in_IDEX,
    output [31:0] PC_out_IDEX,
    output [31:0] Inst_out_IDEX,
    output [4:0] Rd_addr_out_IDEX,
    output [31:0] Rs1_out_IDEX,
    output [31:0] Rs2_out_IDEX,
    output [31:0] Imm_out_IDEX,
    output ALUSrc_B_out_IDEX,
    output [2:0] ALU_control_out_IDEX,
    output Branch_out_IDEX,
    output BranchN_out_IDEX,
    output MemRW_out_IDEX,
    output Jump_out_IDEX,
    output MemtoReg_out_IDEX,
    output RegWrite_out_IDEX,
    output valid_out_IDEX
);

  reg [31:0] PC_reg;
  reg [31:0] Inst_reg;
  reg [4:0] Rd_addr_reg;
  reg [31:0] Rs1_reg;
  reg [31:0] Rs2_reg;
  reg [31:0] Imm_reg;
  reg ALUSrc_B_reg;
  reg [2:0] ALU_control_reg;
  reg Branch_reg;
  reg BranchN_reg;
  reg MemRW_reg;
  reg Jump_reg;
  reg [1:0] MemtoReg_reg;
  reg RegWrite_reg;
  reg valid_reg;

  always @(posedge clk_IDEX) begin
    if (rst_IDEX) begin
      PC_reg <= 32'b0;
      Inst_reg <= 32'b0;
      Rd_addr_reg <= 5'b0;
      Rs1_reg <= 32'b0;
      Rs2_reg <= 32'b0;
      Imm_reg <= 32'b0;
      ALUSrc_B_reg <= 1'b0;
      ALU_control_reg <= 3'b0;
      Branch_reg <= 1'b0;
      BranchN_reg <= 1'b0;
      MemRW_reg <= 1'b0;
      Jump_reg <= 1'b0;
      MemtoReg_reg <= 2'b0;
      RegWrite_reg <= 1'b0;
      valid_reg <= 1'b0;
    end else if (en_IDEX) begin
      if (NOP_IDEX) begin
        valid_reg <= 1'b0;
      end else begin
        PC_reg <= PC_in_IDEX;
        Inst_reg <= Inst_in_IDEX;
        Rd_addr_reg <= Rd_addr_IDEX;
        Rs1_reg <= Rs1_in_IDEx;
        Rs2_reg <= Rs2_in_IDEX;
        Imm_reg <= Imm_in_IDEX;
        ALUSrc_B_reg <= ALUSrc_B_in_IDEX;
        ALU_control_reg <= ALU_control_in_IDEX;
        Branch_reg <= Branch_in_IDEX;
        BranchN_reg <= BranchN_in_IDEX;
        MemRW_reg <= MemRW_in_IDEX;
        Jump_reg <= Jump_in_IDEX;
        MemtoReg_reg <= MemtoReg_in_IDEX;
        RegWrite_reg <= RegWrite_in_IDEX;
        valid_reg <= valid_in_IDEX;
      end
    end
  end

  assign PC_out_IDEX = PC_reg;
  assign Inst_out_IDEX = Inst_reg;
  assign Rd_addr_out_IDEX = Rd_addr_reg;
  assign Rs1_out_IDEX = Rs1_reg;
  assign Rs2_out_IDEX = Rs2_reg;
  assign Imm_out_IDEX = Imm_reg;
  assign ALUSrc_B_out_IDEX = ALUSrc_B_reg;
  assign ALU_control_out_IDEX = ALU_control_reg;
  assign Branch_out_IDEX = Branch_reg;
  assign BranchN_out_IDEX = BranchN_reg;
  assign MemRW_out_IDEX = MemRW_reg;
  assign Jump_out_IDEX = Jump_reg;
  assign MemtoReg_out_IDEX = MemtoReg_reg;
  assign RegWrite_out_IDEX = RegWrite_reg;
  assign valid_out_IDEX = valid_reg;

endmodule

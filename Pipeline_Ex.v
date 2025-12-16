module Pipeline_Ex (
    input [31:0] PC_in_EX,
    input [31:0] Imm_in_EX,
    input [31:0] Rs1_in_EX,
    input [2:0] ALU_control_in_EX,
    input [31:0] Rs2_in_EX,
    input ALUSrc_B_in_EX,
    output [31:0] PC4_out_EX,
    output [31:0] PC_out_EX,
    output [31:0] ALU_out_EX,
    output zero_out_EX,
    output [31:0] Rs2_out_EX
);

  assign PC4_out_EX = PC_in_EX + 32'd4;
  assign PC_out_EX  = PC_in_EX + Imm_in_EX;

  wire [31:0] MUX2T1_32_0_out;

  MUX2T1_32 MUX2T1_32_0 (
      .I0(Rs2_in_EX),
      .I1(Imm_in_EX),
      .s (ALUSrc_B_in_EX),
      .o (MUX2T1_32_0_out)
  );

  ALU ALU (
      .A(Rs1_in_EX),
      .ALU_operation(ALU_control_in_EX),
      .B(MUX2T1_32_0_out),
      .res(ALU_out_EX),
      .zero(zero_out_EX)
  );

  assign Rs2_out_EX = Rs2_in_EX;

endmodule

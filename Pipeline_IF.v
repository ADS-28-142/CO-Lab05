module Pipeline_IF (
    input clk_IF,
    input rst_IF,
    input en_IF,
    input [31:0] PC_in_IF,
    input PCSrc,
    output [31:0] PC_out_IF
);

  wire [31:0] MUX2T1_32_out;
  wire [31:0] PC_out;

  MUX2T1_32 MUX2T1_32 (
      .I0(PC_out + 32'd4),
      .I1(PC_in_IF),
      .s (PCSrc),
      .o (MUX2T1_32_out)
  );

  REG32 PC (
      .clk(clk_IF),
      .rst(rst_IF),
      .CE (en_IF),
      .D  (MUX2T1_32_out),
      .Q  (PC_out)
  );

  assign PC_out_IF = PC_out;

endmodule

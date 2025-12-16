module IF_reg_ID (
    input clk_IFID,
    input rst_IFID,
    input en_IFID,
    input [31:0] PC_in_IFID,
    input [31:0] inst_in_IFID,
    input NOP_IFID,
    output [31:0] PC_out_IFID,
    output [31:0] inst_out_IFID,
    output valid_IFID
);

  reg [31:0] PC_reg;
  reg [31:0] inst_reg;
  reg valid_reg;

  always @(posedge clk_IFID or posedge rst_IFID) begin
    if (rst_IFID) begin
      PC_reg <= 32'b0;
      inst_reg <= 32'b0;
      valid_reg <= 1'b0;
    end else if (en_IFID) begin
      PC_reg <= PC_in_IFID;
      inst_reg <= NOP_IFID ? 32'b0 : inst_in_IFID;
      valid_reg <= ~NOP_IFID;
    end
  end

  assign PC_out_IFID = PC_reg;
  assign inst_out_IFID = inst_reg;
  assign valid_IFID = valid_reg;

endmodule

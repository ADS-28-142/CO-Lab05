module REG32 (
    input clk,
    input rst,
    input CE,
    input [31:0] D,
    output [31:0] Q
);

  reg [31:0] pc;

  always @(posedge clk or posedge rst) begin
    if (rst) pc <= 32'h00000000;
    else if (CE) pc <= D;
  end

  assign Q = pc;

endmodule

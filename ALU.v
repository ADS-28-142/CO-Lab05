module ALU (
    input [31:0] A,
    input [2:0] ALU_operation,
    input [31:0] B,
    output [31:0] res,
    output zero
);

  reg [31:0] result;

  assign res  = result;
  assign zero = (result == 32'b0);

  always @(*) begin
    case (ALU_operation)
      3'b000:  result = A & B;  // AND
      3'b001:  result = A | B;  // OR
      3'b010:  result = A + B;  // ADD
      3'b110:  result = A - B;  // SUB
      3'b111:  result = (A < B) ? 32'b1 : 32'b0;  // SLT
      3'b100:  result = ~(A | B);  // NOR
      3'b101:  result = A >> B[4:0];  // SRL (logical right by shamt)
      3'b011:  result = A ^ B;  // XOR
      default: result = 32'b0;
    endcase
  end

endmodule

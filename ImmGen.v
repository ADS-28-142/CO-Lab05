module ImmGen (
    input  wire [ 1:0] ImmSel,      // 00:I  01:S  10:B  11:J
    input  wire [31:0] inst_field,  // instruction word
    output reg  [31:0] Imm_out
);

  always @* begin
    case (ImmSel)
      2'b00: begin  // I-type (addi, lw, etc.)
        Imm_out = {{20{inst_field[31]}}, inst_field[31:20]};
      end
      2'b01: begin  // S-type (sw)
        Imm_out = {{20{inst_field[31]}}, inst_field[31:25], inst_field[11:7]};
      end
      2'b10: begin  // B-type (beq, etc.)
        // imm[12|10:5|4:1|0] = inst[31|30:25|11:8|7], LSB = 0
        Imm_out = {
          {19{inst_field[31]}},
          inst_field[31],
          inst_field[7],
          inst_field[30:25],
          inst_field[11:8],
          1'b0
        };
      end
      2'b11: begin  // J-type (jal)
        // imm[20|10:1|11|19:12|0] = inst[31|30:21|20|19:12|0], LSB = 0
        Imm_out = {
          {11{inst_field[31]}},
          inst_field[31],
          inst_field[19:12],
          inst_field[20],
          inst_field[30:21],
          1'b0
        };
      end
      default: Imm_out = 32'b0;
    endcase
  end

endmodule

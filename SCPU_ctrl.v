module SCPU_ctrl (
    input [4:0] OPcode,
    input [2:0] Fun3,
    input Fun7,
    input MIO_ready,
    output reg [1:0] ImmSel,
    output reg ALUSrc_B,
    output reg [1:0] MemtoReg,
    output reg Jump,
    output reg Branch,
    output reg BranchN,
    output reg RegWrite,
    output reg MemRW,
    output reg [2:0] ALU_Control,
    output reg CPU_MIO
);

  // control logic
  always @(*) begin
    // defaults
    ImmSel      = 2'b00;
    ALUSrc_B    = 1'b0;
    MemtoReg    = 2'b00;
    Jump        = 1'b0;
    Branch      = 1'b0;
    BranchN     = 1'b0;
    RegWrite    = 1'b0;
    MemRW       = 1'b0;
    ALU_Control = 3'b000;
    CPU_MIO     = 1'b0;

    case (OPcode)
      5'b01100: begin  // R-type
        RegWrite = 1'b1;
        ALUSrc_B = 1'b0;
        MemRW    = 1'b0;
        MemtoReg = 2'b00;
        case (Fun3)
          3'b000: ALU_Control = (Fun7 == 1'b1) ? 3'b110 : 3'b010;  // SUB/ADD
          3'b010: ALU_Control = 3'b111;  // SLT
          3'b100: ALU_Control = 3'b011;  // XOR
          3'b101: ALU_Control = 3'b101;  // SLR
          3'b110: ALU_Control = 3'b001;  // OR
          3'b111: ALU_Control = 3'b000;  // AND
        endcase
      end

      5'b00100: begin  // I-type
        RegWrite = 1'b1;
        ALUSrc_B = 1'b1;
        MemRW    = 1'b0;
        MemtoReg = 2'b00;
        ImmSel   = 2'b00; // I-type imm
        case (Fun3)
          3'b000: ALU_Control = 3'b010;  // ADDI
          3'b010: ALU_Control = 3'b111;  // SLTI
          3'b100: ALU_Control = 3'b011;  // XORI
          3'b101: ALU_Control = 3'b101;  // SLRI
          3'b110: ALU_Control = 3'b001;  // ORI
          3'b111: ALU_Control = 3'b000;  // ANDI
        endcase
      end

      5'b00000: begin  // LOAD
        RegWrite = 1'b1;
        ALUSrc_B = 1'b1;
        MemRW    = 1'b0;
        MemtoReg = 2'b01;
        ImmSel   = 2'b00; // I-type imm (load)
        ALU_Control = 3'b010; // ALU ADD
      end

      5'b01000: begin  // STORE
        RegWrite = 1'b0;
        ALUSrc_B = 1'b1;
        MemRW    = 1'b1;
        ImmSel   = 2'b01; // S-type imm
        ALU_Control = 3'b010; // ALU ADD
      end

      5'b11000: begin  // BRANCH
        RegWrite = 1'b0;
        ALUSrc_B = 1'b0;
        MemRW = 1'b0;
        Branch = (Fun3 == 3'b000) ? 1'b1 : 1'b0;
        BranchN = (Fun3 == 3'b001) ? 1'b1 : 1'b0;
        ImmSel = 2'b10;  // B-type imm
        ALU_Control = 3'b110;  // ALU SUB
      end

      5'b11011: begin  // JAL
        RegWrite = 1'b1;
        ALUSrc_B = 1'b0;
        MemRW    = 1'b0;
        MemtoReg = 2'b10;  // PC + 4
        Jump     = 1'b1;
        ImmSel   = 2'b11;  // J-type imm
      end

      default: begin
        // keep defaults for unsupported opcodes
      end
    endcase
  end

endmodule
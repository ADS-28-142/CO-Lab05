module Pipeline_ID(
    input clk_ID,
    input rst_ID,
    // 写回接口
    input [4:0] Rd_addr_ID,
    input [31:0] Wt_data_ID,
    input RegWrite_in_ID,
    // 来自IF/ID寄存器
    input [31:0] Inst_in_ID,
    // 寄存器输出
    output [31:0] Rs1_out_ID,
    output [31:0] Rs2_out_ID,
    // 立即数输出
    output [31:0] Imm_out_ID,
    // ALU控制信号
    output ALUSrc_B_ID,
    output [2:0] ALU_control_ID,
    // 分支/跳转控制
    output Branch_ID,
    output BranchN_ID,
    output Jump_ID,
    // 访存控制
    output MemRW_ID,
    // 写回控制
    output [1:0] MemtoReg_ID,
    output RegWrite_out_ID,
    // 目的寄存器地址
    output [4:0] Rd_addr_out_ID,
    // 冒险检测需要的信息
    output [4:0] Rs1_addr_ID,
    output [4:0] Rs2_addr_ID,
    output Rs1_used,
    output Rs2_used
);
    
    wire [1:0] ImmSel;
    
    // 寄存器堆（双读端口，单写端口）
    Regs Regs_0(
        .clk(~clk_ID),  //取反，下降沿read
        .rst(rst_ID),
        .Rs1_addr(Inst_in_ID[19:15]),
        .Rs2_addr(Inst_in_ID[24:20]),
        .Wt_addr(Rd_addr_ID),
        .Wt_data(Wt_data_ID),
        .RegWrite(RegWrite_in_ID),
        .Rs1_data(Rs1_out_ID),
        .Rs2_data(Rs2_out_ID)
    );
    
    // 控制器
    SCPU_ctrl SCPU_ctrl_0(
        .OPcode(Inst_in_ID[6:2]),
        .Fun3(Inst_in_ID[14:12]),
        .Fun7(Inst_in_ID[30]),
        .ImmSel(ImmSel),
        .ALUSrc_B(ALUSrc_B_ID),
        .MemtoReg(MemtoReg_ID),
        .Jump(Jump_ID),
        .Branch(Branch_ID),
        .BranchN(BranchN_ID),
        .RegWrite(RegWrite_out_ID),
        .MemRW(MemRW_ID),
        .ALU_Control(ALU_control_ID)
    );
    
    // 立即数生成单元
    ImmGen ImmGen_0(
        .ImmSel(ImmSel),
        .inst_field(Inst_in_ID),
        .Imm_out(Imm_out_ID)
    );
    
    // 目的寄存器地址
    assign Rd_addr_out_ID = Inst_in_ID[11:7];
    
    // 源寄存器地址（直接来自指令字段）
    assign Rs1_addr_ID = Inst_in_ID[19:15];
    assign Rs2_addr_ID = Inst_in_ID[24:20];
    
    // 判断源寄存器是否被使用
    reg Rs1_used_reg, Rs2_used_reg;
    
    always @(*) begin
        case (Inst_in_ID[6:2])  // opcode
            // R-type指令：需要Rs1和Rs2
            5'b01100: begin
                Rs1_used_reg = 1'b1;
                Rs2_used_reg = 1'b1;
            end
            // I-type算术指令：需要Rs1
            5'b00100: begin
                Rs1_used_reg = 1'b1;
                Rs2_used_reg = 1'b0;
            end
            // Load指令：需要Rs1
            5'b00000: begin
                Rs1_used_reg = 1'b1;
                Rs2_used_reg = 1'b0;
            end
            // Store指令：需要Rs1和Rs2
            5'b01000: begin
                Rs1_used_reg = 1'b1;
                Rs2_used_reg = 1'b1;
            end
            // Branch指令：需要Rs1和Rs2
            5'b11000: begin
                Rs1_used_reg = 1'b1;
                Rs2_used_reg = 1'b1;
            end
            // JALR指令：需要Rs1
            5'b11001: begin
                Rs1_used_reg = 1'b1;
                Rs2_used_reg = 1'b0;
            end
            // JAL指令：不需要寄存器
            5'b11011: begin
                Rs1_used_reg = 1'b0;
                Rs2_used_reg = 1'b0;
            end
            // LUI/AUIPC指令：不需要寄存器
            5'b01101, 5'b00101: begin
                Rs1_used_reg = 1'b0;
                Rs2_used_reg = 1'b0;
            end
            default: begin
                Rs1_used_reg = 1'b0;
                Rs2_used_reg = 1'b0;
            end
        endcase
    end
    
    assign Rs1_used = Rs1_used_reg;
    assign Rs2_used = Rs2_used_reg;
    
endmodule
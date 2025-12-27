module Pipeline_Ex(
    input [31:0] PC_in_EX,          // 来自ID/EX寄存器的PC值
    input [31:0] Imm_in_EX,         // 来自ID/EX寄存器的立即数
    input [31:0] Rs1_in_EX,         // 来自ID/EX寄存器的Rs1值
    input [2:0] ALU_control_in_EX,  // ALU控制信号
    input [31:0] Rs2_in_EX,         // 来自ID/EX寄存器的Rs2值
    input ALUSrc_B_in_EX,           // ALU B端选择信号
    // 输出信号
    output [31:0] PC4_out_EX,       // PC + 4
    output [31:0] PC_out_EX,    // PC + Imm（分支目标）
    output [31:0] ALU_out_EX,       // ALU计算结果
    output zero_out_EX,             // ALU零标志
    output [31:0] Rs2_out_EX        // Rs2值（用于Store指令）
);
    
    wire [31:0] MUX2T1_32_0_out;    // ALU B端输入
    
    // 计算PC + 4 和 PC + Imm
    assign PC4_out_EX = PC_in_EX + 32'd4;
    assign PC_out_EX = PC_in_EX + Imm_in_EX;
    
    // ALU B端输入选择器
    MUX2T1_32 MUX2T1_32_0(
        .I0(Rs2_in_EX),             // 寄存器值
        .I1(Imm_in_EX),             // 立即数
        .s(ALUSrc_B_in_EX),         // 选择信号
        .o(MUX2T1_32_0_out)
    );
    
    // ALU单元
    ALU ALU_0(
        .A(Rs1_in_EX),              // A端输入
        .ALU_operation(ALU_control_in_EX), // ALU操作码
        .B(MUX2T1_32_0_out),        // B端输入
        .res(ALU_out_EX),           // 计算结果
        .zero(zero_out_EX)          // 零标志
    );
    
    // 传递Rs2值（用于Store指令）
    assign Rs2_out_EX = Rs2_in_EX;
    
endmodule
module Pipeline_IF(
    input clk_IF,
    input rst_IF,
    input en_IF,                // stall模块控制
    input [31:0] PC_in_IF,      // 来自MEM阶段的分支目标
    input PCSrc,                // 分支控制信号
    output [31:0] PC_out_IF    // 当前PC值
);
    
    wire [31:0] MUX2T1_32_out;
    wire [31:0] PC_out;
    
    
    // PC选择器：PC+4 或 分支目标
    MUX2T1_32 MUX2T1_32_0(
        .I0(PC_out + 32'd4),    // 顺序执行
        .I1(PC_in_IF),          // 分支/跳转目标
        .s(PCSrc),              // 选择信号
        .o(MUX2T1_32_out)
    );
    
    // PC寄存器
    REG32 PC(
        .clk(clk_IF),
        .rst(rst_IF),
        .CE(en_IF),             // 由stall模块控制
        .D(MUX2T1_32_out),
        .Q(PC_out)
    );
    
    assign PC_out_IF = PC_out;
    
endmodule
module Pipeline_WB(
    input [1:0] MemtoReg_in_WB,
    input [31:0] ALU_in_WB,
    input [31:0] DMem_data_WB,
    input [31:0] PC4_in_WB,
    output [31:0] Data_out_WB
);
    
    MUX4T1_32 MUX4T1_32_0(
        .s(MemtoReg_in_WB),     // 选择信号
        .I0(ALU_in_WB),         // 选择0：ALU结果
        .I1(DMem_data_WB),      // 选择1：内存数据
        .I2(PC4_in_WB),         // 选择2：PC+4（用于JAL）
        .I3(32'b0),             // 选择3：保留
        .o(Data_out_WB)         // 输出数据
    );
    
endmodule
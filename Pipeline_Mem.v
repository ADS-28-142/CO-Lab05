module Pipeline_Mem(
    // 控制信号输入
    input Branch_in_Mem,
    input zero_in_Mem,
    input BranchN_in_Mem,
    input Jump_in_Mem,
    // 输出信号
    output PCSrc                   // PC选择信号
);
    
    // 分支判断逻辑
    assign PCSrc = Jump_in_Mem | ((zero_in_Mem & Branch_in_Mem) | (~zero_in_Mem & BranchN_in_Mem));
    
endmodule

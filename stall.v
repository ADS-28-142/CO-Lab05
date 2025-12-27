module stall(
    input rst_stall,
    // 来自ID阶段
    input [4:0] Rs1_addr_ID,
    input [4:0] Rs2_addr_ID,
    input Rs1_used,
    input Rs2_used,
    input Branch_ID,
    input BranchN_ID,
    input Jump_ID,
    // 来自ID/EX寄存器
    input RegWrite_out_IDEX,
    input [4:0] Rd_addr_out_IDEX,
    input Branch_out_IDEX,
    input BranchN_out_IDEX,
    input Jump_out_IDEX,
    // 来自EX/MEM寄存器
    input RegWrite_out_EXMem,
    input [4:0] Rd_addr_out_EXMem,
    input Branch_out_EXMem,
    input BranchN_out_EXMem,
    input Jump_out_EXMem,
    // 控制信号输出
    output reg en_IF,        // IF阶段使能
    output reg en_IFID,      // IF/ID寄存器使能
    output reg NOP_IFID,     // 在IF/ID插入NOP
    output reg NOP_IDEX      // 在ID/EX插入NOP
);

    // 数据冒险检测
    wire data_hazard_EX, data_hazard_MEM;
    
    // EX阶段数据冒险（ID/EX.RegWrite与ID阶段源寄存器相关）
    assign data_hazard_EX = RegWrite_out_IDEX && (
        (Rs1_used && (Rs1_addr_ID != 5'b0) && (Rd_addr_out_IDEX == Rs1_addr_ID)) ||
        (Rs2_used && (Rs2_addr_ID != 5'b0) && (Rd_addr_out_IDEX == Rs2_addr_ID))
    );
    
    // MEM阶段数据冒险（EX/MEM.RegWrite与ID阶段源寄存器相关）
    assign data_hazard_MEM = RegWrite_out_EXMem && (
        (Rs1_used && (Rs1_addr_ID != 5'b0) && (Rd_addr_out_EXMem == Rs1_addr_ID)) ||
        (Rs2_used && (Rs2_addr_ID != 5'b0) && (Rd_addr_out_EXMem == Rs2_addr_ID))
    );
    
    // 控制冒险检测
    wire control_hazard;
    assign control_hazard = Branch_ID || BranchN_ID || Jump_ID || 
                           Branch_out_IDEX || BranchN_out_IDEX || Jump_out_IDEX ||
                           Branch_out_EXMem || BranchN_out_EXMem || Jump_out_EXMem;
    
    // 冒险处理逻辑
    always @(*) begin
        if (rst_stall) begin
            en_IF = 1'b1;
            en_IFID = 1'b1;
            NOP_IFID = 1'b0;
            NOP_IDEX = 1'b0;
        end
        else begin
            if (data_hazard_EX || data_hazard_MEM) begin
                // 数据冒险：在ID/EX插入NOP，暂停IF和IF/ID
                en_IF = 1'b0;      // 暂停取指
                en_IFID = 1'b0;    // 暂停IF/ID寄存器
                NOP_IFID = 1'b0;   // IF/ID不插入NOP
                NOP_IDEX = 1'b1;   // 在ID/EX插入NOP
            end
            else if (control_hazard) begin
                // 控制冒险：在IF/ID插入NOP
                en_IF = 1'b1;      // 继续取指
                en_IFID = 1'b1;    // 使能IF/ID寄存器
                NOP_IFID = 1'b1;   // 在IF/ID插入NOP
                NOP_IDEX = 1'b0;   // ID/EX不插入NOP
            end
            else begin
                // 无冒险：正常流水线执行
                en_IF = 1'b1;
                en_IFID = 1'b1;
                NOP_IFID = 1'b0;
                NOP_IDEX = 1'b0;
            end
        end
    end

endmodule
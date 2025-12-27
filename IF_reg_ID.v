module IF_reg_ID(
    input clk_IFID,
    input rst_IFID,
    input en_IFID,              // stall模块控制
    input [31:0] PC_in_IFID,
    input [31:0] inst_in_IFID,
    input NOP_IFID,             // stall模块控制：插入NOP
    output reg [31:0] PC_out_IFID,
    output reg [31:0] inst_out_IFID,
    output reg valid_IFID
);
    
    always @(posedge clk_IFID or posedge rst_IFID) begin
        if (rst_IFID) begin
            PC_out_IFID <= 32'h00000000;
            inst_out_IFID <= 32'h00000000;
            valid_IFID <= 1'b0;
        end
        else if (en_IFID) begin
            if (NOP_IFID) begin
                // 插入NOP指令：addi x0, x0, 0 (0x00000013)
                PC_out_IFID <= 32'h00000000;
                inst_out_IFID <= 32'h00000013;
                valid_IFID <= 1'b0;      // 标记为无效指令
            end
            else begin
                PC_out_IFID <= PC_in_IFID;
                inst_out_IFID <= inst_in_IFID;
                valid_IFID <= 1'b1;      // 标记为有效指令
            end
        end
    end
    
endmodule
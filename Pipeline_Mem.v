module Pipeline_Mem (
    input  Branch_in_Mem,
    input  zero_in_Mem,
    input  BranchN_in_Mem,
    input  Jump_in_Mem,
    output PCSrc
);

  assign PCSrc = Jump_in_Mem | ((zero_in_Mem & Branch_in_Mem) | (~zero_in_Mem & BranchN_in_Mem));

endmodule

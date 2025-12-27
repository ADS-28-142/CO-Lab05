`timescale 1ns / 1ps

module Pipeline_CPU_tb ();

  reg rst;
  reg clk;

  Pipeline_CPU_test inst (
      .rst(rst),
      .clk(clk)
  );

  initial begin
    clk = 1'b0;
    rst = 1'b1;
    #20;
    rst = 1'b0;
    #2000;
  end

  always #10 clk = ~clk;

endmodule

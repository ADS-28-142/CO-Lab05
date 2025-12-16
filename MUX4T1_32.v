module MUX4T1_32 (
    input  [31:0] I0,
    input  [31:0] I1,
    input  [31:0] I2,
    input  [31:0] I3,
    input  [ 1:0] s,
    output [31:0] o
);

  assign o = (s == 2'b00) ? I0 : (s == 2'b01) ? I1 : (s == 2'b10) ? I2 : (s == 2'b11) ? I3 : 32'b0;

endmodule

module CSSTE (
    input clk_100mhz,
    input RSTN,
    input [3:0] BTN_y,
    input [15:0] SW,
    output [3:0] Blue,
    output [3:0] Green,
    output [3:0] Red,
    output HSYNC,
    output VSYNC,
    output [15:0] LED_out,
    output [7:0] AN,
    output [7:0] segment
);

  // U1
  wire MemRW_Men;
  wire MemRW_Ex;
  wire [31:0] Addr_out;
  wire [31:0] Data_out;
  wire [31:0] PC;
  wire [31:0] PC_out_ID;
  wire [31:0] PC_out_Ex;
  wire [31:0] inst_ID;
  wire [31:0] Data_out_WB;
  // U2
  wire [31:0] inst;
  // U3
  wire [31:0] ram_data_out;
  // U4
  wire [31:0] Data_in;
  wire [31:0] ram_data_in;
  wire [9:0] ram_addr;
  wire data_ram_we;
  wire SPIO_we;
  wire Multi_8CH32_we;
  wire counter_we;
  wire [31:0] Peripheral_in;
  // U5
  wire [7:0] point;
  wire [7:0] les;
  wire [31:0] disp_num;
  // U7
  wire [1:0] counter_set;
  // U8
  wire [31:0] clkdiv;
  wire Clk_CPU;
  // U9
  wire [3:0] BTN_OK;
  wire [15:0] SW_OK;
  wire rst;
  // U10
  wire counter0_out;
  wire counter1_out;
  wire counter2_out;
  wire [31:0] counter_out;

  Pipeline_CPU U1 (
      .clk(Clk_CPU),
      .rst(rst),
      .Data_in(Data_in),
      .inst_IF(inst),
      .MemRW_Men(MemRW_Men),
      .MemRW_Ex(MemRW_Ex),
      .Addr_out(Addr_out),
      .Data_out(Data_out),
      .PC_out_IF(PC),
      .PC_out_ID(PC_out_ID),
      .PC_out_Ex(PC_out_Ex),
      .inst_ID(inst_ID),
      .Data_out_WB(Data_out_WB)
  );

  ROM_D U2 (
      .a  (PC[11:2]),
      .spo(inst)
  );

  RAM_B U3 (
      .clka (~clk_100mhz),
      .wea  (data_ram_we),
      .addra(ram_addr),
      .dina (ram_data_in),
      .douta(ram_data_out)
  );

  MIO_BUS U4 (
      .clk(clk_100mhz),
      .rst(rst),
      .BTN(BTN_OK),
      .SW(SW_OK),
      .mem_w(MemRW_Men),
      .Cpu_data2bus(Data_out),
      .addr_bus(Addr_out),
      .ram_data_out(ram_data_out),
      .led_out(LED_out),
      .counter_out(counter_out),
      .counter0_out(counter0_out),
      .counter1_out(counter1_out),
      .counter2_out(counter2_out),
      .Cpu_data4bus(Data_in),
      .ram_data_in(ram_data_in),
      .ram_addr(ram_addr),
      .data_ram_we(data_ram_we),
      .GPIOf0000000_we(SPIO_we),
      .GPIOe0000000_we(Multi_8CH32_we),
      .counter_we(counter_we),
      .Peripheral_in(Peripheral_in)
  );

  Multi_8CH32 U5 (
      .clk(~Clk_CPU),
      .rst(rst),
      .EN(Multi_8CH32_we),
      .Test(SW_OK[7:5]),
      .point_in({clkdiv_debug[31:0], clkdiv_debug[31:0]}),
      .LES(64'b0),
      .Data0(Peripheral_in),
      .data1({2'b0, PC[31:2]}),
      .data2(inst),
      .data3(counter_out),
      .data4(Addr_out),
      .data5(Data_out),
      .data6(Data_in),
      .data7(PC),
      .point_out(point),
      .LE_out(les),
      .Disp_num(disp_num)
  );

  Seg7_Dev_0 U6 (
      .disp_num(disp_num),
      .point(point),
      .les(les),
      .scan({clkdiv[18], clkdiv[17], clkdiv[16]}),
      .AN(AN),
      .segment(segment)
  );

  SPIO U7 (
      .clk(~Clk_CPU),
      .rst(rst),
      .Start(clkdiv[20]),
      .EN(SPIO_we),
      .P_Data(Peripheral_in),
      .counter_set(counter_set),
      .LED_out(LED_out)
  );

  clk_div U8 (
      .clk(clk_100mhz),
      .rst(rst),
      .SW2(SW_OK[2]),
      .SW8(SW_OK[8]),
      .STEP(SW_OK[10]),
      .clkdiv(clkdiv),
      .Clk_CPU(Clk_CPU)
  );

  wire [31:0] clkdiv_debug;

  clk_div U8_debug (
      .clk(clk_100mhz),
      .rst(rst),
      .SW2(SW_OK[2]),
      .SW8(SW_OK[8]),
      .STEP(SW_OK[10]),
      .clkdiv(clkdiv_debug)
  );

  SAnti_jitter U9 (
      .clk(clk_100mhz),
      .RSTN(RSTN),
      .Key_y(BTN_y),
      .SW(SW),
      .BTN_OK(BTN_OK),
      .SW_OK(SW_OK),
      .rst(rst)
  );

  Counter_x U10 (
      .clk(~Clk_CPU),
      .rst(rst),
      .clk0(clkdiv[6]),
      .clk1(clkdiv[9]),
      .clk2(clkdiv[11]),
      .counter_we(counter_we),
      .counter_val(Peripheral_in),
      .counter_ch(counter_set),
      .counter0_OUT(counter0_out),
      .counter1_OUT(counter1_out),
      .counter2_OUT(counter2_out),
      .counter_out(counter_out)
  );

  VGA U11 (
      .clk_25m(clkdiv[1]),
      .clk_100m(clk_100mhz),
      .rst(rst),
      .PC_IF(PC),
      .inst_IF(inst),
      .PC_ID(PC_out_ID),
      .inst_ID(inst_ID),
      .PC_Ex(PC_out_Ex),
      .MemRW_Ex(MemRW_Ex),
      .MemRW_Men(MemRW_Men),
      .Data_out(Data_out),
      .Addr_out(Addr_out),
      .Data_out_WB(Data_out_WB),
      .hs(HSYNC),
      .vs(VSYNC),
      .vga_r(Red),
      .vga_g(Green),
      .vga_b(Blue)
  );

endmodule

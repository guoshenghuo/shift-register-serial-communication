`timescale 1ns / 1ps
`include "modules/uart_rx.v"
`include "modules/uart_tx.v"
`include "modules/rlshift.v"
module tb;
    reg clk=0;
	 reg [7:0] tx_data1;
	 wire [7:0] rx_data;
	 wire done;
	 wire ready;
	 wire rx_pin;
	 wire shift_en;
	 wire [7:0] tx_data;
    always #20 clk=~clk;
	 reg start_clr;
	 reg start_lod;
	 reg rst=1;//接收端标志位驱动初始化开始计数
    // 发送端测试
    initial begin
        #100;
        start_clr = 1;
		  rst = 0;
		  #10;
		  rst = 1;
		  #20;
		  start_clr = 0;
		  start_lod = 1;
		  tx_data1 = 8'hA5;
		  #40;
		  start_lod = 0; 
        #900;
		  #100;
        start_clr = 1;
		  rst = 0;
		  #10;
		  rst = 1;
		  #20;
		  start_clr = 0;
		  start_lod = 1;
		  tx_data1 = 8'h88;
		  #40;
		  start_lod = 0; 
        #900;$finish;
    end
	uart_rx	uut1(
		  .rx_pin(rx_pin),    // 串行输入引脚
		  .clk(clk),          // 主时钟
		  .rst(rst),
		  .ready(ready),
		  .rx_data(rx_data),  // 接收完成数据
		  .done(done)         // 接收完成标志
	);
	
	uart_tx  uut2(
		  .tx_data(tx_data1),    // 待发送并行数据
		  .clk(clk),              // 主时钟（需分频为波特率）
		  .start_clr(start_clr),
		  .start_lod(start_lod),            // 发送启动信号
		  .tx_pin(rx_pin),       // 串行输出引脚
		  .ready(ready),			//告诉接收端，此时d数据已经导入到q中
		  .shift_en(shift_en),
		  .q(tx_data)
	);
  
endmodule


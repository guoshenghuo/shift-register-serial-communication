`timescale 1ns / 1ps
module Top (clk,rst,start_clr,start_lod,tx_data1,rx_data,done);
    input clk;
	 input rst;//接收端标志位驱动初始化开始计数
	 input start_clr;
	 input start_lod;
	 input wire [7:0] tx_data1;
	 output wire [7:0] rx_data;
	 output wire done;
	 wire ready;
	 wire rx_pin;
	 wire shift_en;
	uart_rx	uut1(
		  .rx_pin(rx_pin),    // 串行输入引脚
		  .clk(clk),          // 主时钟
		  .rst(rst),
		  .ready(ready),
		  .start_clr(start_clr),
		  .rx_data(rx_data),  // 接收完成数据
		  .done(done)         // 接收完成标志
	);
	
	uart_tx   uut2(
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


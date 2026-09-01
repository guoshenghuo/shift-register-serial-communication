`timescale 1ns / 1ps
module uart_rx(
    input rx_pin,           // 串行输入引脚
    input clk,              // 主时钟
	 input rst,					//初始化信号
	 input wire ready,		//表示当前发送方已经将数据d传入q，此时rx_pin是有效的数据位
	 input wire start_clr,  //下降沿的时候使bit_cnt初始化
    output wire [7:0] rx_data,  // 接收完成数据
    output reg done         // 接收完成标志
);

// 实例化移位寄存器
rlshift rx_shift(
    .q(rx_data),
    .d(),           // 并行加载未使用
    .clk(clk), // 波特率采样时钟
    .clr(),     // 不清零
    .lod(1'b0),     // 不加载并行数据
    .s(1'b1),       // 持续移位
    .dir(rx_pin),   // 右移时输入串行数据；因为发送端是右移所以接收端必须右移
    .dil()          // 左移未使用
);


reg [3:0] bit_cnt;// 作用是完成传输的标志生成，要在q已经被赋值=d以后才开始
always @(posedge ready or negedge rst) 
begin
	 if (rst==0)//初始化bit_cnt操作不然永远bit_cnt都是不定值，这样就不能实现8个周期进行一次
	 begin
		  done <= 1'b0;
		  bit_cnt <= 4'd0;
	 end
    else if (ready) begin
		  if (bit_cnt < 4'd8) begin
				done <= 1'b0;//接收信号不到8次
				bit_cnt <= bit_cnt + 1;
		  end
	     else begin
				done <= 1'b1;//接收信号8次完成done1
				bit_cnt <= 4'd0;
		  end
	 end
	 else 
        done <= 1'b0;

end


endmodule
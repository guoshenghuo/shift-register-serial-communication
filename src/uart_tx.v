`timescale 1ns / 1ps
module uart_tx(
    input [7:0] tx_data,    // 待发送并行数据
    input clk,              // 主时钟（需分频为波特率）
    input start_clr,
	 input start_lod,            // 发送启动信号
    output reg tx_pin,       // 串行输出引脚
	 output reg ready,			//告诉接收端，此时d数据已经导入到q中
	 output wire shift_en,
	 output wire [7:0] q
); 
// 实例化移位寄存器
rlshift tx_shift(
    .q(q),           // 发送以后内部寄存器状态
    .d(tx_data),    // 加载发送数据
    .clk(clk),
    .clr(~start_clr),   // 启动时清零旧数据
    .lod(start_lod),    // 启动时加载新数据
    .s(shift_en),   // 移位使能（由计数器控制）
    .dir(1'b0),     // 右移时补充0到q最高位
    .dil()          // 左移未使用
);

// 波特率分频与移位控制
reg [3:0] bit_cnt;

always @(posedge clk) 
begin
    if (start_clr)//当还没有将d值赋值给q的时候就把bit_cnt激活，等到下一次就可以移位了
	 begin
        bit_cnt <= 4'd0;
		  ready<=0;
    end 
	 else if (bit_cnt <= 4'd8) 
	 begin
		  ready<=1;
		  #5;//只能用于仿真//延时5ns，为了保证该次移位已经完成，再进行下一次移位
        bit_cnt <= bit_cnt + 1;
		  ready<=0;
    end
	 else
	 begin
		  ready<=0;
		  bit_cnt=bit_cnt;
	 end
end

assign shift_en = (bit_cnt >= 1) && (bit_cnt <= 8); // 第1-8周期移位

// 输出数据选择（右移时取最低位）
always @(*) 
begin
    tx_pin = tx_shift.q[0]; //串行输出当前q[0]的值，右移时候取q最低位
end

endmodule

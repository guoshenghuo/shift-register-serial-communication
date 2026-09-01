`timescale 1ns / 1ps
module uart_rx_tb();
// 定义测试信号
reg clk;
reg rst;
reg rx_pin;
reg ready;
reg start_clr;
wire [7:0] rx_data;
wire done;

// 实例化被测模块
uart_rx uut (
    .rx_pin(rx_pin),
    .clk(clk),
    .rst(rst),
    .ready(ready),
    .start_clr(start_clr),
    .rx_data(rx_data),
    .done(done)
);

// 生成50MHz时钟 (周期20ns)
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// 定义发送字节的任务
task send_byte;
    input [7:0] data;
    integer i;
    begin
        // UART协议：发送从低位到高位，因为是右移
        for (i = 0; i < 8; i = i + 1) 
		  begin
            @(negedge clk);     // 在时钟下降沿设置信号
            rx_pin = data[i];   // 按LSB-first顺序发送
            ready = 1;          // 激活ready信号，因为初始化的时候就为低电平，所以这里就是上升沿
            @(posedge clk);     // 等待时钟上升沿
            #2 ready = 0;       // 短暂保持后撤销ready，以便传送下一位的时候还是能够bit_cnt加1
        end
        
        // 发送完成后保持空闲状态
        @(negedge clk);
        rx_pin = 1;  // 空闲状态为高电平
        ready = 1;   //以便传送下一位的时候还是能够bit_cnt加1
		  // 验证0xAA接收结果
		  if (rx_data != data) 
			   $display("ERROR at %t: 接收数据错误! 预期:%h,实际:%h", $time, data ,rx_data);
		  else
			   $display("SUCCESS: %h接收正确",data);
		  @(posedge clk);
		  ready = 0;	  
	 end
endtask

// 主测试流程
initial begin
    // 初始化信号
    rst = 0;
    rx_pin = 1;      // 空闲状态为高电平[7](@ref)
    ready = 0;
    start_clr = 1;	//接收端默认q不清零

    
    // 复位操作 (低电平有效)[4](@ref)
    #20 rst = 1;
    #20 rst = 0;//下降沿就使bit_cnt赋值为0
    #20 rst = 1;
    
    // 测试案例1：发送0x55 (01010101),并且验证0x55接收的结果
    send_byte(8'h55);  // 交替比特模式，易检测错误
    #50;
    // 测试案例2：发送0xAA (10101010)，并且验证0xAA接收的结果
    send_byte(8'hAA);
    #50;
    // 测试案例3：边界值测试(0xFF)
    send_byte(8'hFF);
    #100 $finish;
end
endmodule
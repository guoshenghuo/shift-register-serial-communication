`timescale 1ns / 1ps
module uart_tx_tb;

// 输入信号声明
reg clk;
reg [7:0] tx_data;
reg start_clr;//初始化
reg start_lod;//装载

// 输出信号声明
wire tx_pin;//输出当前被移位移除的数据
wire ready;
wire shift_en;//移位使能
wire [7:0] q;

// 实例化被测模块
uart_tx uut (
    .tx_data(tx_data),
    .clk(clk),
    .start_clr(start_clr),
    .start_lod(start_lod),
    .tx_pin(tx_pin),
    .ready(ready),
    .shift_en(shift_en),
    .q(q)
); 

// 时钟生成（50MHz） 
initial begin
	 clk=0;
	 #5;clk=1;
    forever #10 clk = ~clk; // 20ns周期对应50MHz
end

// 测试向量生成
initial begin
    // 初始化信号
    tx_data = 8'h00;
    start_clr = 1;//高电平有效,初始化
    start_lod = 0;

    // 测试案例1：发送0x55（含起始位和停止位）
    #20;//此时q已经进行初始化了，所以最低的最低起始标志位应该是0
    start_clr = 0;//低电平无效
    tx_data = 8'h55;      // 二进制 01010101
    start_lod = 1;        // 高电平有效，加载数据
    #20;
    start_lod = 0;		  // 低电平无效，因为start_clr也无效，开始数据移位
    
    // 等待第一个字节发送完成（9位：1起始+8数据）
    #160;                 // 9位*20ns=180ns，照理说传输的数据是tx_data =8'h55；
	 //重新执行一遍初始化信号
	 tx_data = 8'h00;
    start_clr = 1;//高电平有效,初始化
    start_lod = 0;
    // 测试案例2：发送0xAA（验证连续发送）
	 #20;
	 start_clr = 0;//低电平无效
    tx_data = 8'hAA;      // 二进制 10101010
    start_lod = 1;
    #20;
    start_lod = 0;
    
    // 结束仿真
    #140;					
    $finish;
end

// 波形监控与断言，传出信号为0x55，加上起始位0
initial begin
    $dumpfile("uart_tx.vcd");
    $dumpvars(0, uart_tx_tb);
    
    
    #20; 
    // 检查起始位（低电平）
    if(tx_pin !== 1'b0) $display("ERROR at time %t: 起始位错误", $time);
    
    // 逐位检查0x55（LSB优先）
	 //时钟上升沿前就赋值数据，但是要等到上升沿以后才能读取正确数据，否则读取数据还是全0
	 #10; if(tx_pin !== 1'b1) $display("ERROR at time %t: bit0错误", $time); // 0x55的LSB是1
    #20; if(tx_pin !== 1'b0) $display("ERROR at time %t: bit1错误", $time);
    #20; if(tx_pin !== 1'b1) $display("ERROR at time %t: bit2错误", $time);
    #20; if(tx_pin !== 1'b0) $display("ERROR at time %t: bit3错误", $time);
    #20; if(tx_pin !== 1'b1) $display("ERROR at time %t: bit4错误", $time);
    #20; if(tx_pin !== 1'b0) $display("ERROR at time %t: bit5错误", $time);
    #20; if(tx_pin !== 1'b1) $display("ERROR at time %t: bit6错误", $time);
    #20; if(tx_pin !== 1'b0) $display("ERROR at time %t: bit7错误", $time);

end

endmodule


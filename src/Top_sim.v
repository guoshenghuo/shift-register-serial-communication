`timescale 1ns / 1ps
module Top_sim;
    reg clk=0;
	 reg [7:0] tx_data1;
    
	 reg start_clr;
	 reg start_lod;
	 reg rst=1;//接收端标志位驱动初始化开始计数
	 wire done;
	 wire [7:0] rx_data;
    always #20 clk=~clk;
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
    Top	my_top(
	.clk(clk),
	.rst(rst),
	.start_clr(start_clr),
	.start_lod(start_lod),
	.tx_data1(tx_data1),
	.rx_data(rx_data),
	.done(done)
    );
	 
endmodule
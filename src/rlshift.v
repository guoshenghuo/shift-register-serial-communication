`timescale 1ns / 1ps
module rlshift(q,d,clk,clr,lod,s,dir,dil);
input[7:0] d;
input	clk,clr,lod,s,dir,dil;	
output [7:0] q;
reg [7:0]	q;	
always @ (posedge clk)
begin
	if (!clr)
		q=8'b00000000; //低电平有效，同步复位
	else if (lod) //同步预置，d的数据进入，lod高电平有效q赋值为d
		q=d; 
	else if (s) //右移信号s变为1
	begin
		q=q>>1;
		q[7]=dir;
	end 
	else 
	begin 
		q=q<<1;
		q[0]=dil; 
	end 
end
endmodule
